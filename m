Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A568C53CF42
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 19:55:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345757AbiFCRya (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 13:54:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347263AbiFCRwK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 13:52:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AD6AE53;
        Fri,  3 Jun 2022 10:51:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AC64B60F7F;
        Fri,  3 Jun 2022 17:51:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A28FAC385A9;
        Fri,  3 Jun 2022 17:51:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654278707;
        bh=0K5voZzLyc+xuScdTQ/pYb/ZRAHzPncbwaYY8Xc9DiI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KYyrxSjC3lqspTKNZXq5mraVMaRLO4ZTf57TQUfdaojcrr53n38IgJTVdm3wczcMo
         r2jAb2Knzi+JjLyIqF6OliGH7YYpd9A18JvFDNgudnpCGcCSx1nRhJMWSFkkFfVHX2
         JlyF5XoFxmY/YvyHYNPyUXDFCU7GvB2wh00cpNzA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hao Luo <haoluo@google.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 5.15 66/66] bpf: Check PTR_TO_MEM | MEM_RDONLY in check_helper_mem_access
Date:   Fri,  3 Jun 2022 19:43:46 +0200
Message-Id: <20220603173822.559821958@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220603173820.663747061@linuxfoundation.org>
References: <20220603173820.663747061@linuxfoundation.org>
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

commit 97e6d7dab1ca4648821c790a2b7913d6d5d549db upstream.

The commit being fixed was aiming to disallow users from incorrectly
obtaining writable pointer to memory that is only meant to be read. This
is enforced now using a MEM_RDONLY flag.

For instance, in case of global percpu variables, when the BTF type is
not struct (e.g. bpf_prog_active), the verifier marks register type as
PTR_TO_MEM | MEM_RDONLY from bpf_this_cpu_ptr or bpf_per_cpu_ptr
helpers. However, when passing such pointer to kfunc, global funcs, or
BPF helpers, in check_helper_mem_access, there is no expectation
MEM_RDONLY flag will be set, hence it is checked as pointer to writable
memory. Later, verifier sets up argument type of global func as
PTR_TO_MEM | PTR_MAYBE_NULL, so user can use a global func to get around
the limitations imposed by this flag.

This check will also cover global non-percpu variables that may be
introduced in kernel BTF in future.

Also, we update the log message for PTR_TO_BUF case to be similar to
PTR_TO_MEM case, so that the reason for error is clear to user.

Fixes: 34d3a78c681e ("bpf: Make per_cpu_ptr return rdonly PTR_TO_MEM.")
Reviewed-by: Hao Luo <haoluo@google.com>
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Link: https://lore.kernel.org/r/20220319080827.73251-3-memxor@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/verifier.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -4602,13 +4602,23 @@ static int check_helper_mem_access(struc
 		return check_map_access(env, regno, reg->off, access_size,
 					zero_size_allowed);
 	case PTR_TO_MEM:
+		if (type_is_rdonly_mem(reg->type)) {
+			if (meta && meta->raw_mode) {
+				verbose(env, "R%d cannot write into %s\n", regno,
+					reg_type_str(env, reg->type));
+				return -EACCES;
+			}
+		}
 		return check_mem_region_access(env, regno, reg->off,
 					       access_size, reg->mem_size,
 					       zero_size_allowed);
 	case PTR_TO_BUF:
 		if (type_is_rdonly_mem(reg->type)) {
-			if (meta && meta->raw_mode)
+			if (meta && meta->raw_mode) {
+				verbose(env, "R%d cannot write into %s\n", regno,
+					reg_type_str(env, reg->type));
 				return -EACCES;
+			}
 
 			buf_info = "rdonly";
 			max_access = &env->prog->aux->max_rdonly_access;


