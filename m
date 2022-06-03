Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D82F53D0CC
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 20:12:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346651AbiFCSIb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 14:08:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347834AbiFCSGT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 14:06:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 281595D677;
        Fri,  3 Jun 2022 10:59:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 19AEBB82438;
        Fri,  3 Jun 2022 17:59:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86795C3411C;
        Fri,  3 Jun 2022 17:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654279148;
        bh=nPcxQpf1ssmDisQFOLeXmXkRO9v1ounJGsftVl69TWI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KZcKconOqpCxwv8w1gmarcjo4bt1MEmAaIT5AleTVroMLC78ByapCu1ItJwJVfKiX
         u1hLVQj01SE1RwoAyr/hMymUQeNwkB7vIeRtZOITp+FN+wOxDBoiMewJ9qRa11PcMT
         5e/ulgasDr8BxIUu2iPehiBRUULAXSGnw2+bSuGg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 5.18 67/67] bpf: Do write access check for kfunc and global func
Date:   Fri,  3 Jun 2022 19:44:08 +0200
Message-Id: <20220603173822.641516438@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220603173820.731531504@linuxfoundation.org>
References: <20220603173820.731531504@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kumar Kartikeya Dwivedi <memxor@gmail.com>

commit be77354a3d7ebd4897ee18eca26dca6df9224c76 upstream.

When passing pointer to some map value to kfunc or global func, in
verifier we are passing meta as NULL to various functions, which uses
meta->raw_mode to check whether memory is being written to. Since some
kfunc or global funcs may also write to memory pointers they receive as
arguments, we must check for write access to memory. E.g. in some case
map may be read only and this will be missed by current checks.

However meta->raw_mode allows for uninitialized memory (e.g. on stack),
since there is not enough info available through BTF, we must perform
one call for read access (raw_mode = false), and one for write access
(raw_mode = true).

Fixes: e5069b9c23b3 ("bpf: Support pointers in global func args")
Fixes: d583691c47dc ("bpf: Introduce mem, size argument pair support for kfunc")
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Link: https://lore.kernel.org/r/20220319080827.73251-2-memxor@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/verifier.c |   44 +++++++++++++++++++++++++++++---------------
 1 file changed, 29 insertions(+), 15 deletions(-)

--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -4934,8 +4934,7 @@ static int check_mem_size_reg(struct bpf
 	 * out. Only upper bounds can be learned because retval is an
 	 * int type and negative retvals are allowed.
 	 */
-	if (meta)
-		meta->msize_max_value = reg->umax_value;
+	meta->msize_max_value = reg->umax_value;
 
 	/* The register is SCALAR_VALUE; the access check
 	 * happens using its boundaries.
@@ -4978,24 +4977,33 @@ static int check_mem_size_reg(struct bpf
 int check_mem_reg(struct bpf_verifier_env *env, struct bpf_reg_state *reg,
 		   u32 regno, u32 mem_size)
 {
+	bool may_be_null = type_may_be_null(reg->type);
+	struct bpf_reg_state saved_reg;
+	struct bpf_call_arg_meta meta;
+	int err;
+
 	if (register_is_null(reg))
 		return 0;
 
-	if (type_may_be_null(reg->type)) {
-		/* Assuming that the register contains a value check if the memory
-		 * access is safe. Temporarily save and restore the register's state as
-		 * the conversion shouldn't be visible to a caller.
-		 */
-		const struct bpf_reg_state saved_reg = *reg;
-		int rv;
-
+	memset(&meta, 0, sizeof(meta));
+	/* Assuming that the register contains a value check if the memory
+	 * access is safe. Temporarily save and restore the register's state as
+	 * the conversion shouldn't be visible to a caller.
+	 */
+	if (may_be_null) {
+		saved_reg = *reg;
 		mark_ptr_not_null_reg(reg);
-		rv = check_helper_mem_access(env, regno, mem_size, true, NULL);
-		*reg = saved_reg;
-		return rv;
 	}
 
-	return check_helper_mem_access(env, regno, mem_size, true, NULL);
+	err = check_helper_mem_access(env, regno, mem_size, true, &meta);
+	/* Check access for BPF_WRITE */
+	meta.raw_mode = true;
+	err = err ?: check_helper_mem_access(env, regno, mem_size, true, &meta);
+
+	if (may_be_null)
+		*reg = saved_reg;
+
+	return err;
 }
 
 int check_kfunc_mem_size_reg(struct bpf_verifier_env *env, struct bpf_reg_state *reg,
@@ -5004,16 +5012,22 @@ int check_kfunc_mem_size_reg(struct bpf_
 	struct bpf_reg_state *mem_reg = &cur_regs(env)[regno - 1];
 	bool may_be_null = type_may_be_null(mem_reg->type);
 	struct bpf_reg_state saved_reg;
+	struct bpf_call_arg_meta meta;
 	int err;
 
 	WARN_ON_ONCE(regno < BPF_REG_2 || regno > BPF_REG_5);
 
+	memset(&meta, 0, sizeof(meta));
+
 	if (may_be_null) {
 		saved_reg = *mem_reg;
 		mark_ptr_not_null_reg(mem_reg);
 	}
 
-	err = check_mem_size_reg(env, reg, regno, true, NULL);
+	err = check_mem_size_reg(env, reg, regno, true, &meta);
+	/* Check access for BPF_WRITE */
+	meta.raw_mode = true;
+	err = err ?: check_mem_size_reg(env, reg, regno, true, &meta);
 
 	if (may_be_null)
 		*mem_reg = saved_reg;


