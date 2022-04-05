Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9BC64F2D17
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:35:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239180AbiDEJxI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:53:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243543AbiDEJJE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:09:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52B89B91B0;
        Tue,  5 Apr 2022 01:58:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A7D4761572;
        Tue,  5 Apr 2022 08:58:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9145C385A0;
        Tue,  5 Apr 2022 08:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649149092;
        bh=kYZhOnBQIEQ5uNY6XMoHEpNf48Uv3rRYsl8kLmBQSDs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k+YlihSIqIl71Y23T4AE9EOpDNFn1/ldemvHNusYvAhideNyRKi6voZQ8DMucEbkF
         ROfn2TJQdcYUiPJaYZ2oQ2Xop3eaVP/S7H+PvnxZ8ZqiigL7jwnvtKQHd31G9hxnZK
         tceIsxDCcqdcRSdCH8q0oRdKQ7ZR6vDbj80ChdK0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hou Tao <houtao1@huawei.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0553/1017] bpf, arm64: Call build_prologue() first in first JIT pass
Date:   Tue,  5 Apr 2022 09:24:26 +0200
Message-Id: <20220405070410.698756494@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Hou Tao <houtao1@huawei.com>

[ Upstream commit 68e4f238b0e9d3670a1612ad900a6e98b2b3f7dd ]

BPF line info needs ctx->offset to be the instruction offset in the whole JITed
image instead of the body itself, so also call build_prologue() first in first
JIT pass.

Fixes: 37ab566c178d ("bpf: arm64: Enable arm64 jit to provide bpf_line_info")
Signed-off-by: Hou Tao <houtao1@huawei.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20220226121906.5709-2-houtao1@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/net/bpf_jit_comp.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/net/bpf_jit_comp.c b/arch/arm64/net/bpf_jit_comp.c
index 71ef9dcd9b57..3c6d0d60820f 100644
--- a/arch/arm64/net/bpf_jit_comp.c
+++ b/arch/arm64/net/bpf_jit_comp.c
@@ -1049,15 +1049,18 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 		goto out_off;
 	}
 
-	/* 1. Initial fake pass to compute ctx->idx. */
-
-	/* Fake pass to fill in ctx->offset. */
-	if (build_body(&ctx, extra_pass)) {
+	/*
+	 * 1. Initial fake pass to compute ctx->idx and ctx->offset.
+	 *
+	 * BPF line info needs ctx->offset[i] to be the offset of
+	 * instruction[i] in jited image, so build prologue first.
+	 */
+	if (build_prologue(&ctx, was_classic)) {
 		prog = orig_prog;
 		goto out_off;
 	}
 
-	if (build_prologue(&ctx, was_classic)) {
+	if (build_body(&ctx, extra_pass)) {
 		prog = orig_prog;
 		goto out_off;
 	}
-- 
2.34.1



