Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3F61505082
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:23:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238726AbiDRM0T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:26:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238736AbiDRMZk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:25:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7E4620F4E;
        Mon, 18 Apr 2022 05:19:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 81C0960EF4;
        Mon, 18 Apr 2022 12:19:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76031C385B5;
        Mon, 18 Apr 2022 12:19:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284380;
        bh=agCDIBbbtk1c65NvNmNwBPTDas9g5rHHdEy1c5V0PVQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SIhXbkjolvcgYRMATDHJVqp/VYcJlxjyIn85WHuWpUoHoffftFMYKhFW7weBP8trp
         tIW/F2PW3De7KpTjfn6RGRovA6MZjFy+NPHvKXh9EUHLHCexrv1lVeRk/tsPnvg063
         9lU8OmkBjJwpY3Og8Xdk9NBS8IIDQm8S0pR/SzI8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Garry <john.garry@huawei.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        Ajish Koshy <Ajish.Koshy@microchip.com>,
        Viswas G <Viswas.G@microchip.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 096/219] scsi: pm80xx: Mask and unmask upper interrupt vectors 32-63
Date:   Mon, 18 Apr 2022 14:11:05 +0200
Message-Id: <20220418121209.440553367@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121203.462784814@linuxfoundation.org>
References: <20220418121203.462784814@linuxfoundation.org>
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

From: Ajish Koshy <Ajish.Koshy@microchip.com>

[ Upstream commit 294080eacf92a0781e6d43663448a55001ec8c64 ]

When upper inbound and outbound queues 32-63 are enabled, we see upper
vectors 32-63 in interrupt service routine. We need corresponding registers
to handle masking and unmasking of these upper interrupts.

To achieve this, we use registers MSGU_ODMR_U(0x34) to mask and
MSGU_ODMR_CLR_U(0x3C) to unmask the interrupts. In these registers bit 0-31
represents interrupt vectors 32-63.

Link: https://lore.kernel.org/r/20220411064603.668448-2-Ajish.Koshy@microchip.com
Fixes: 05c6c029a44d ("scsi: pm80xx: Increase number of supported queues")
Reviewed-by: John Garry <john.garry@huawei.com>
Acked-by: Jack Wang <jinpu.wang@ionos.com>
Signed-off-by: Ajish Koshy <Ajish.Koshy@microchip.com>
Signed-off-by: Viswas G <Viswas.G@microchip.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/pm8001/pm80xx_hwi.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index 55163469030d..2dea48933ef9 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -1734,10 +1734,11 @@ static void
 pm80xx_chip_interrupt_enable(struct pm8001_hba_info *pm8001_ha, u8 vec)
 {
 #ifdef PM8001_USE_MSIX
-	u32 mask;
-	mask = (u32)(1 << vec);
-
-	pm8001_cw32(pm8001_ha, 0, MSGU_ODMR_CLR, (u32)(mask & 0xFFFFFFFF));
+	if (vec < 32)
+		pm8001_cw32(pm8001_ha, 0, MSGU_ODMR_CLR, 1U << vec);
+	else
+		pm8001_cw32(pm8001_ha, 0, MSGU_ODMR_CLR_U,
+			    1U << (vec - 32));
 	return;
 #endif
 	pm80xx_chip_intx_interrupt_enable(pm8001_ha);
@@ -1753,12 +1754,15 @@ static void
 pm80xx_chip_interrupt_disable(struct pm8001_hba_info *pm8001_ha, u8 vec)
 {
 #ifdef PM8001_USE_MSIX
-	u32 mask;
-	if (vec == 0xFF)
-		mask = 0xFFFFFFFF;
+	if (vec == 0xFF) {
+		/* disable all vectors 0-31, 32-63 */
+		pm8001_cw32(pm8001_ha, 0, MSGU_ODMR, 0xFFFFFFFF);
+		pm8001_cw32(pm8001_ha, 0, MSGU_ODMR_U, 0xFFFFFFFF);
+	} else if (vec < 32)
+		pm8001_cw32(pm8001_ha, 0, MSGU_ODMR, 1U << vec);
 	else
-		mask = (u32)(1 << vec);
-	pm8001_cw32(pm8001_ha, 0, MSGU_ODMR, (u32)(mask & 0xFFFFFFFF));
+		pm8001_cw32(pm8001_ha, 0, MSGU_ODMR_U,
+			    1U << (vec - 32));
 	return;
 #endif
 	pm80xx_chip_intx_interrupt_disable(pm8001_ha);
-- 
2.35.1



