Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 746BC59224B
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 17:47:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241462AbiHNPrO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 11:47:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241452AbiHNPoj (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 11:44:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51AE6273E;
        Sun, 14 Aug 2022 08:34:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 06954B80B56;
        Sun, 14 Aug 2022 15:34:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07BC6C43470;
        Sun, 14 Aug 2022 15:33:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660491239;
        bh=mTC0kP17e1XCi3YiZ/Si/p45n4hJH4RH53+7e7trTvM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hsTEGvF1i0CUC88DYSMlRfZNW3XJBhPm5tRLPLiRxGIk60Fv53E/u3qe/IjCwXUBz
         qajPfMnONpRxWUxncqRSJonKtpQlnlxQJjrtKukMXh3eMcANelKyLFroGOovnbbEIE
         /q0wBGqG4tibggBnAMs/AQ4228z1JLbTvKRPqKskixrMPmAHSbXtff/FgH2kXE0Cn5
         dJtblt0vXgl5G1dsyyDVKYgcCMbMaQM7D5CvYoxlFRGmEi+kPBv37miApT2deh0HsT
         A6ZSo6ae9xNRBeK82cL7qxQx00FguaexNuvRUlTeY3Dwnk/UYliDsc8yxlGpFmbcy+
         DG2x3KldLeSsQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ben Dooks <ben.dooks@sifive.com>, Vinod Koul <vkoul@kernel.org>,
        Sasha Levin <sashal@kernel.org>, Eugeniy.Paltsev@synopsys.com,
        dmaengine@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 32/46] dmaengine: dw-axi-dmac: do not print NULL LLI during error
Date:   Sun, 14 Aug 2022 11:32:33 -0400
Message-Id: <20220814153247.2378312-32-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220814153247.2378312-1-sashal@kernel.org>
References: <20220814153247.2378312-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ben Dooks <ben.dooks@sifive.com>

[ Upstream commit 86cb0defe0e275453bc39e856bb523eb425a6537 ]

During debugging we have seen an issue where axi_chan_dump_lli()
is passed a NULL LLI pointer which ends up causing an OOPS due
to trying to get fields from it. Simply print NULL LLI and exit
to avoid this.

Signed-off-by: Ben Dooks <ben.dooks@sifive.com>
Link: https://lore.kernel.org/r/20220708170153.269991-3-ben.dooks@sifive.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c b/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c
index 35993ab92154..8f765e2d7c72 100644
--- a/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c
+++ b/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c
@@ -944,6 +944,11 @@ static int dw_axi_dma_chan_slave_config(struct dma_chan *dchan,
 static void axi_chan_dump_lli(struct axi_dma_chan *chan,
 			      struct axi_dma_hw_desc *desc)
 {
+	if (!desc->lli) {
+		dev_err(dchan2dev(&chan->vc.chan), "NULL LLI\n");
+		return;
+	}
+
 	dev_err(dchan2dev(&chan->vc.chan),
 		"SAR: 0x%llx DAR: 0x%llx LLP: 0x%llx BTS 0x%x CTL: 0x%x:%08x",
 		le64_to_cpu(desc->lli->sar),
-- 
2.35.1

