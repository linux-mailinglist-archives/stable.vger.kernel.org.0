Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEA825051DA
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:42:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231514AbiDRMlo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:41:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240711AbiDRMjd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:39:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB9E613CDC;
        Mon, 18 Apr 2022 05:30:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 84C6AB80EC0;
        Mon, 18 Apr 2022 12:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5AE6C385A1;
        Mon, 18 Apr 2022 12:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650285014;
        bh=kN7kp0z6+3glEndQphRk/Wj1ypFcaAiDQfd9EyAmZxE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rKqURGodkNCWcZWDEiEp3Rrv/fFvWbSPXg9wAxfMqlWBFFlsvIT3F1R2Xp4JXiBjj
         makgUEme4dDI2pFV+QcwOuYkZf7VARj3z4/+Lp4gCNp6WQqO6j1Se7z3ocZLHHa1dE
         P4nVMC3RZF/3BPW/ovaqj+97r+7aEt32GVnyN9ZY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Garry <john.garry@huawei.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        Ajish Koshy <Ajish.Koshy@microchip.com>,
        Viswas G <Viswas.G@microchip.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 079/189] scsi: pm80xx: Mask and unmask upper interrupt vectors 32-63
Date:   Mon, 18 Apr 2022 14:11:39 +0200
Message-Id: <20220418121202.751044975@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121200.312988959@linuxfoundation.org>
References: <20220418121200.312988959@linuxfoundation.org>
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
index 5561057109de..aa6f114be064 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -1733,10 +1733,11 @@ static void
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
@@ -1752,12 +1753,15 @@ static void
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



