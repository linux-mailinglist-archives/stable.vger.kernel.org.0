Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 040D04FC0EB
	for <lists+stable@lfdr.de>; Mon, 11 Apr 2022 17:35:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348021AbiDKPiD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 11:38:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348025AbiDKPiC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 11:38:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CD1D387A8
        for <stable@vger.kernel.org>; Mon, 11 Apr 2022 08:35:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 960E761546
        for <stable@vger.kernel.org>; Mon, 11 Apr 2022 15:35:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA5F2C385A4;
        Mon, 11 Apr 2022 15:35:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649691344;
        bh=4NJRvNF6N9PxB/NhV5pAJWaBfOsE1f9ExAtz88auQ4k=;
        h=Subject:To:Cc:From:Date:From;
        b=YF7kWPi2EDbb0C4XmE7dPVHXZpE5gQ4gJTErH6zZ7EOlT9tOCialXJb4OqJTmiWBu
         ZC5ZynizaXh1SiwoPJWPbzr7NKE/9JM4/UPdnNNq1tSeFcYwP8rLNuzHUUXvNkAuw/
         NWsbsMgS+DWLkpqn0eu6+2RswNSOA1xVcBGTiIxM=
Subject: FAILED: patch "[PATCH] bpf: Resolve to prog->aux->dst_prog->type only for" failed to apply to 5.15-stable tree
To:     kafai@fb.com, ast@kernel.org, yhs@fb.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 11 Apr 2022 17:35:34 +0200
Message-ID: <164969133445185@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 4a9c7bbe2ed4d2b240674b1fb606c41d3940c412 Mon Sep 17 00:00:00 2001
From: Martin KaFai Lau <kafai@fb.com>
Date: Tue, 29 Mar 2022 18:14:56 -0700
Subject: [PATCH] bpf: Resolve to prog->aux->dst_prog->type only for
 BPF_PROG_TYPE_EXT

The commit 7e40781cc8b7 ("bpf: verifier: Use target program's type for access verifications")
fixes the verifier checking for BPF_PROG_TYPE_EXT (extension)
prog such that the verifier looks for things based
on the target prog type that it is extending instead of
the BPF_PROG_TYPE_EXT itself.

The current resolve_prog_type() returns the target prog type.
It checks for nullness on prog->aux->dst_prog.  However,
when loading a BPF_PROG_TYPE_TRACING prog and it is tracing another
bpf prog instead of a kernel function, prog->aux->dst_prog is not
NULL also.  In this case, the verifier should still verify as the
BPF_PROG_TYPE_TRACING type instead of the traced prog type in
prog->aux->dst_prog->type.

An oops has been reported when tracing a struct_ops prog.  A NULL
dereference happened in check_return_code() when accessing the
prog->aux->attach_func_proto->type and prog->aux->attach_func_proto
is NULL here because the traced struct_ops prog has the "unreliable" set.

This patch is to change the resolve_prog_type() to only
return the target prog type if the prog being verified is
BPF_PROG_TYPE_EXT.

Fixes: 7e40781cc8b7 ("bpf: verifier: Use target program's type for access verifications")
Signed-off-by: Martin KaFai Lau <kafai@fb.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Yonghong Song <yhs@fb.com>
Link: https://lore.kernel.org/bpf/20220330011456.2984509-1-kafai@fb.com

diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
index c1fc4af47f69..3a9d2d7cc6b7 100644
--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -570,9 +570,11 @@ static inline u32 type_flag(u32 type)
 	return type & ~BPF_BASE_TYPE_MASK;
 }
 
+/* only use after check_attach_btf_id() */
 static inline enum bpf_prog_type resolve_prog_type(struct bpf_prog *prog)
 {
-	return prog->aux->dst_prog ? prog->aux->dst_prog->type : prog->type;
+	return prog->type == BPF_PROG_TYPE_EXT ?
+		prog->aux->dst_prog->type : prog->type;
 }
 
 #endif /* _LINUX_BPF_VERIFIER_H */

