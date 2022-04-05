Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DEC94F37D6
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:25:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359576AbiDELUH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:20:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349229AbiDEJt2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:49:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3F8722BD6;
        Tue,  5 Apr 2022 02:42:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5127961576;
        Tue,  5 Apr 2022 09:42:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62D30C385A1;
        Tue,  5 Apr 2022 09:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649151777;
        bh=cQGKMLWxdF5P/yDNlUth6Ig7C50k5+SASMNoZMLOBF8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vi8gsU3Ek0XLTw5EQSeCSr+KD6n4J8FpdvNPOpUA0vdMLX4hD+8DO3VgE69Mz+n2e
         1iWKwaThaS15RLNytYmaUrcbAy2IKKfm1vBY/OCd945TYohOGYaQPWlCLt8GBG00Rt
         1WjNOj2EGQnXTjW7LvhzUu/m4XmN3Ar36DxSlYJY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hou Tao <houtao1@huawei.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 499/913] bpf, arm64: Call build_prologue() first in first JIT pass
Date:   Tue,  5 Apr 2022 09:26:01 +0200
Message-Id: <20220405070354.812793604@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
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
index 465c44d0c72f..d13d9e5085a7 100644
--- a/arch/arm64/net/bpf_jit_comp.c
+++ b/arch/arm64/net/bpf_jit_comp.c
@@ -1042,15 +1042,18 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
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



