Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0444D30EE83
	for <lists+stable@lfdr.de>; Thu,  4 Feb 2021 09:35:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234624AbhBDIcZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Feb 2021 03:32:25 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:57839 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234957AbhBDIcY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Feb 2021 03:32:24 -0500
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 1148VMtA4009881, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexmbs01.realtek.com.tw[172.21.6.94])
        by rtits2.realtek.com.tw (8.15.2/2.70/5.88) with ESMTPS id 1148VMtA4009881
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 4 Feb 2021 16:31:22 +0800
Received: from localhost (172.22.88.222) by RTEXMBS01.realtek.com.tw
 (172.21.6.94) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2; Thu, 4 Feb 2021
 16:31:21 +0800
From:   <ricky_wu@realtek.com>
To:     <arnd@arndb.de>, <gregkh@linuxfoundation.org>,
        <ricky_wu@realtek.com>, <yuehaibing@huawei.com>,
        <ulf.hansson@linaro.org>, <bhelgaas@google.com>,
        <linux-kernel@vger.kernel.org>
CC:     <stable@vger.kernel.org>
Subject: [PATCH v2] misc: rtsx: init of rts522a add OCP power off when no card is present
Date:   Thu, 4 Feb 2021 16:31:15 +0800
Message-ID: <20210204083115.9471-1-ricky_wu@realtek.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.22.88.222]
X-ClientProxiedBy: RTEXMBS02.realtek.com.tw (172.21.6.95) To
 RTEXMBS01.realtek.com.tw (172.21.6.94)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ricky Wu <ricky_wu@realtek.com>

Power down OCP for power consumption
when no SD/MMC card is present

Cc: stable@vger.kernel.org
Signed-off-by: Ricky Wu <ricky_wu@realtek.com>
---

v2: update the subject line and description
---
 drivers/misc/cardreader/rts5227.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/misc/cardreader/rts5227.c b/drivers/misc/cardreader/rts5227.c
index 8859011672cb..8200af22b529 100644
--- a/drivers/misc/cardreader/rts5227.c
+++ b/drivers/misc/cardreader/rts5227.c
@@ -398,6 +398,11 @@ static int rts522a_extra_init_hw(struct rtsx_pcr *pcr)
 {
 	rts5227_extra_init_hw(pcr);
 
+	/* Power down OCP for power consumption */
+	if (!pcr->card_exist)
+		rtsx_pci_write_register(pcr, FPDCTL, OC_POWER_DOWN,
+				OC_POWER_DOWN);
+
 	rtsx_pci_write_register(pcr, FUNC_FORCE_CTL, FUNC_FORCE_UPME_XMT_DBG,
 		FUNC_FORCE_UPME_XMT_DBG);
 	rtsx_pci_write_register(pcr, PCLK_CTL, 0x04, 0x04);
-- 
2.17.1

