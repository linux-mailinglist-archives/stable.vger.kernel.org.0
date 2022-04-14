Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 092C7501188
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 16:59:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345393AbiDNNuL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:50:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344445AbiDNNla (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:41:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B306120;
        Thu, 14 Apr 2022 06:39:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C254FB82968;
        Thu, 14 Apr 2022 13:39:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27129C385A1;
        Thu, 14 Apr 2022 13:39:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649943543;
        bh=sr2o8NaAsktY5c/m0j0EJ2yevGTkuAdbJcQwzADN4bo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CGB5mkqAroxhF9ruC0utbJyyennkneewlBSOyD0Ee70/CrhHdswaY76+SObCe4hai
         PkevGQTRiscBS3zbbX8XfWPzcdMH5/0rJM4cjjTOSdDZAFeLcjiXucj7IF+IIlS5xv
         LWgPAbBAySZEyni7w/YOJ/uFeFtt3m1v4/1LnVd8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hou Tao <houtao1@huawei.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 194/475] bpf, arm64: Call build_prologue() first in first JIT pass
Date:   Thu, 14 Apr 2022 15:09:39 +0200
Message-Id: <20220414110900.559199914@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110855.141582785@linuxfoundation.org>
References: <20220414110855.141582785@linuxfoundation.org>
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
index a343677837c7..6332288dfb44 100644
--- a/arch/arm64/net/bpf_jit_comp.c
+++ b/arch/arm64/net/bpf_jit_comp.c
@@ -909,15 +909,18 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
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



