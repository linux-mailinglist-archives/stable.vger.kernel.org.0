Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED6A7594163
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:50:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243583AbiHOVKj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:10:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348143AbiHOVIN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:08:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1543152FC2;
        Mon, 15 Aug 2022 12:18:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AC47EB81106;
        Mon, 15 Aug 2022 19:18:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16EE4C433D6;
        Mon, 15 Aug 2022 19:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591108;
        bh=J5MIm3UtF/W+1yWUXo2HL/p6MBZovK8cm6sauq+Outg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yl+neMqc7i8YAUwRKy3OT7j0P1sVVkJZ9r8qST/BPcdYuQKMLGlfv98Ozr3eYCE1d
         EaNkz4yIvo5ztpTjB2hTm6VCz+LuoLniknpOo89phieMUB9xz3N7oyIOt6Vs2RV/AT
         UStfruWhsr9o6Bd9jvKQk0iQHDoHVW5jZcEp0ajY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Joanne Koong <joannelkoong@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0475/1095] bpf: Move check_ptr_off_reg before check_map_access
Date:   Mon, 15 Aug 2022 19:57:54 +0200
Message-Id: <20220815180449.237811027@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kumar Kartikeya Dwivedi <memxor@gmail.com>

[ Upstream commit e9147b4422e1f35b9c229c980c596ccf03d61562 ]

Some functions in next patch want to use this function, and those
functions will be called by check_map_access, hence move it before
check_map_access.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Joanne Koong <joannelkoong@gmail.com>
Link: https://lore.kernel.org/bpf/20220415160354.1050687-3-memxor@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 76 +++++++++++++++++++++----------------------
 1 file changed, 38 insertions(+), 38 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index f29aa357826c..afa05e6cd78f 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -3468,6 +3468,44 @@ static int check_mem_region_access(struct bpf_verifier_env *env, u32 regno,
 	return 0;
 }
 
+static int __check_ptr_off_reg(struct bpf_verifier_env *env,
+			       const struct bpf_reg_state *reg, int regno,
+			       bool fixed_off_ok)
+{
+	/* Access to this pointer-typed register or passing it to a helper
+	 * is only allowed in its original, unmodified form.
+	 */
+
+	if (reg->off < 0) {
+		verbose(env, "negative offset %s ptr R%d off=%d disallowed\n",
+			reg_type_str(env, reg->type), regno, reg->off);
+		return -EACCES;
+	}
+
+	if (!fixed_off_ok && reg->off) {
+		verbose(env, "dereference of modified %s ptr R%d off=%d disallowed\n",
+			reg_type_str(env, reg->type), regno, reg->off);
+		return -EACCES;
+	}
+
+	if (!tnum_is_const(reg->var_off) || reg->var_off.value) {
+		char tn_buf[48];
+
+		tnum_strn(tn_buf, sizeof(tn_buf), reg->var_off);
+		verbose(env, "variable %s access var_off=%s disallowed\n",
+			reg_type_str(env, reg->type), tn_buf);
+		return -EACCES;
+	}
+
+	return 0;
+}
+
+int check_ptr_off_reg(struct bpf_verifier_env *env,
+		      const struct bpf_reg_state *reg, int regno)
+{
+	return __check_ptr_off_reg(env, reg, regno, false);
+}
+
 /* check read/write into a map element with possible variable offset */
 static int check_map_access(struct bpf_verifier_env *env, u32 regno,
 			    int off, int size, bool zero_size_allowed)
@@ -3979,44 +4017,6 @@ static int get_callee_stack_depth(struct bpf_verifier_env *env,
 }
 #endif
 
-static int __check_ptr_off_reg(struct bpf_verifier_env *env,
-			       const struct bpf_reg_state *reg, int regno,
-			       bool fixed_off_ok)
-{
-	/* Access to this pointer-typed register or passing it to a helper
-	 * is only allowed in its original, unmodified form.
-	 */
-
-	if (reg->off < 0) {
-		verbose(env, "negative offset %s ptr R%d off=%d disallowed\n",
-			reg_type_str(env, reg->type), regno, reg->off);
-		return -EACCES;
-	}
-
-	if (!fixed_off_ok && reg->off) {
-		verbose(env, "dereference of modified %s ptr R%d off=%d disallowed\n",
-			reg_type_str(env, reg->type), regno, reg->off);
-		return -EACCES;
-	}
-
-	if (!tnum_is_const(reg->var_off) || reg->var_off.value) {
-		char tn_buf[48];
-
-		tnum_strn(tn_buf, sizeof(tn_buf), reg->var_off);
-		verbose(env, "variable %s access var_off=%s disallowed\n",
-			reg_type_str(env, reg->type), tn_buf);
-		return -EACCES;
-	}
-
-	return 0;
-}
-
-int check_ptr_off_reg(struct bpf_verifier_env *env,
-		      const struct bpf_reg_state *reg, int regno)
-{
-	return __check_ptr_off_reg(env, reg, regno, false);
-}
-
 static int __check_buffer_access(struct bpf_verifier_env *env,
 				 const char *buf_info,
 				 const struct bpf_reg_state *reg,
-- 
2.35.1



