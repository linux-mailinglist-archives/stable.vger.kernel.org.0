Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF950541318
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 21:56:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357908AbiFGTz5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 15:55:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358703AbiFGTxF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 15:53:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDFED26554;
        Tue,  7 Jun 2022 11:22:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CE72A60DDF;
        Tue,  7 Jun 2022 18:22:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBA59C385A2;
        Tue,  7 Jun 2022 18:22:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626129;
        bh=7QQ5grX8R7fbK834V+H9zWsoK0HdlbCrvTqdcW37FDI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NCNYoc1A6dH/JTx8AS0Y4W+qLj5XGMrFzV0csTqRTQKA936HFpD+Vyd5QX0ptSsb6
         1qyXbiXigVegEM3p6f4Z8vAPBuNLBq9kY1fkV7xAHi3VGPNUPNI+mNYX+mwDPE9Wag
         3tJtzc8bioYoDMkxf11+bwsniy9vFft6h/0uZgkY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sinan Kaya <okaya@kernel.org>,
        Tyler Hicks <tyhicks@linux.microsoft.com>,
        Borislav Petkov <bp@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 269/772] EDAC/dmc520: Dont print an error for each unconfigured interrupt line
Date:   Tue,  7 Jun 2022 18:57:41 +0200
Message-Id: <20220607164956.951769630@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tyler Hicks <tyhicks@linux.microsoft.com>

[ Upstream commit ad2df24732e8956a45a00894d2163c4ee8fb0e1f ]

The dmc520 driver requires that at least one interrupt line, out of the
ten possible, is configured. The driver prints an error and returns
-EINVAL from its .probe function if there are no interrupt lines
configured.

Don't print a KERN_ERR level message for each interrupt line that's
unconfigured as that can confuse users into thinking that there is an
error condition.

Before this change, the following KERN_ERR level messages would be
reported if only dram_ecc_errc and dram_ecc_errd were configured in the
device tree:

  dmc520 68000000.dmc: IRQ ram_ecc_errc not found
  dmc520 68000000.dmc: IRQ ram_ecc_errd not found
  dmc520 68000000.dmc: IRQ failed_access not found
  dmc520 68000000.dmc: IRQ failed_prog not found
  dmc520 68000000.dmc: IRQ link_err not
  dmc520 68000000.dmc: IRQ temperature_event not found
  dmc520 68000000.dmc: IRQ arch_fsm not found
  dmc520 68000000.dmc: IRQ phy_request not found

Fixes: 1088750d7839 ("EDAC: Add EDAC driver for DMC520")
Reported-by: Sinan Kaya <okaya@kernel.org>
Signed-off-by: Tyler Hicks <tyhicks@linux.microsoft.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lore.kernel.org/r/20220111163800.22362-1-tyhicks@linux.microsoft.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/dmc520_edac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/edac/dmc520_edac.c b/drivers/edac/dmc520_edac.c
index b8a7d9594afd..1fa5ca57e9ec 100644
--- a/drivers/edac/dmc520_edac.c
+++ b/drivers/edac/dmc520_edac.c
@@ -489,7 +489,7 @@ static int dmc520_edac_probe(struct platform_device *pdev)
 	dev = &pdev->dev;
 
 	for (idx = 0; idx < NUMBER_OF_IRQS; idx++) {
-		irq = platform_get_irq_byname(pdev, dmc520_irq_configs[idx].name);
+		irq = platform_get_irq_byname_optional(pdev, dmc520_irq_configs[idx].name);
 		irqs[idx] = irq;
 		masks[idx] = dmc520_irq_configs[idx].mask;
 		if (irq >= 0) {
-- 
2.35.1



