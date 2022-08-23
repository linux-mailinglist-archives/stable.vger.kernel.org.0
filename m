Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E86F059D8BE
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:04:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348949AbiHWJRT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:17:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349985AbiHWJQ2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:16:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70B69883E0;
        Tue, 23 Aug 2022 01:32:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 42BE6B81C35;
        Tue, 23 Aug 2022 08:32:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 899D1C433C1;
        Tue, 23 Aug 2022 08:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661243563;
        bh=Wk2EN4oWzCNZy1fjsGB+gIos7yTqSgZhVXSohy2ODQE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BxJNnbXxmUMmdTXGLj0GbU5dEFut44r0cpvrifZTHr/5E1+yHi0jtLMKY0EajY9ZP
         1gKUPmCpAMXVSP3iedreJo1zX4jixlJ2zApr+GPnpieEJdmL3ApZQudypXMUCjUheI
         lSEUqavKRRlfYGQvy8hRzFKhvEkySsI8RVIdqeQk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Dooks <ben.dooks@sifive.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 299/365] dmaengine: dw-axi-dmac: do not print NULL LLI during error
Date:   Tue, 23 Aug 2022 10:03:20 +0200
Message-Id: <20220823080130.678002903@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
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
index c741da02b67e..41583f01a360 100644
--- a/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c
+++ b/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c
@@ -982,6 +982,11 @@ static int dw_axi_dma_chan_slave_config(struct dma_chan *dchan,
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



