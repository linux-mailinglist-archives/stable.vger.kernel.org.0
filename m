Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E30A6AF3BB
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:08:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233664AbjCGTIr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:08:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233694AbjCGTIW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:08:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 163379547A
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:53:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D149F61531
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:53:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E06A1C433D2;
        Tue,  7 Mar 2023 18:53:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678215199;
        bh=KUdxQlmNmo+5hThEmUOW/bmyIPVhpRue6udZs1OevTI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F7wR1yj8CcmYFID/LsPt0I9S4l7UTH/MgjYCPU5eLwu6pUV0dpQaw7mF4Zg9BlXfj
         uCXeyqa8TLP0Zwfkel9JZ3ZW6yHt0s/C5NLLSJVGRNkgRrPv07VbYQmAdCmz/+kCcs
         K7m5FPWhBjOWTlibNDx4y/lfsNGLegzEe8/X20tc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Stanislav Fomichev <sdf@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 156/567] bpf: Fix global subprog context argument resolution logic
Date:   Tue,  7 Mar 2023 17:58:12 +0100
Message-Id: <20230307165912.708019076@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrii Nakryiko <andrii@kernel.org>

[ Upstream commit d384dce281ed1b504fae2e279507827638d56fa3 ]

KPROBE program's user-facing context type is defined as typedef
bpf_user_pt_regs_t. This leads to a problem when trying to passing
kprobe/uprobe/usdt context argument into global subprog, as kernel
always strip away mods and typedefs of user-supplied type, but takes
expected type from bpf_ctx_convert as is, which causes mismatch.

Current way to work around this is to define a fake struct with the same
name as expected typedef:

  struct bpf_user_pt_regs_t {};

  __noinline my_global_subprog(struct bpf_user_pt_regs_t *ctx) { ... }

This patch fixes the issue by resolving expected type, if it's not
a struct. It still leaves the above work-around working for backwards
compatibility.

Fixes: 91cc1a99740e ("bpf: Annotate context types")
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Stanislav Fomichev <sdf@google.com>
Link: https://lore.kernel.org/bpf/20230216045954.3002473-2-andrii@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/btf.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 0c2fa93bd8d27..1f9369b677fe2 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -4468,6 +4468,7 @@ btf_get_prog_ctx_type(struct bpf_verifier_log *log, const struct btf *btf,
 	if (!ctx_struct)
 		/* should not happen */
 		return NULL;
+again:
 	ctx_tname = btf_name_by_offset(btf_vmlinux, ctx_struct->name_off);
 	if (!ctx_tname) {
 		/* should not happen */
@@ -4481,8 +4482,16 @@ btf_get_prog_ctx_type(struct bpf_verifier_log *log, const struct btf *btf,
 	 * int socket_filter_bpf_prog(struct __sk_buff *skb)
 	 * { // no fields of skb are ever used }
 	 */
-	if (strcmp(ctx_tname, tname))
-		return NULL;
+	if (strcmp(ctx_tname, tname)) {
+		/* bpf_user_pt_regs_t is a typedef, so resolve it to
+		 * underlying struct and check name again
+		 */
+		if (!btf_type_is_modifier(ctx_struct))
+			return NULL;
+		while (btf_type_is_modifier(ctx_struct))
+			ctx_struct = btf_type_by_id(btf_vmlinux, ctx_struct->type);
+		goto again;
+	}
 	return ctx_type;
 }
 
-- 
2.39.2



