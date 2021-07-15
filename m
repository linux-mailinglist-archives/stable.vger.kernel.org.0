Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 229763CA911
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:02:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241561AbhGOTFS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:05:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:39764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239126AbhGOTDS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:03:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6E896613C0;
        Thu, 15 Jul 2021 18:59:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375569;
        bh=2Kz9zqhvZs7yyv5qURt+mojxP6fondb6dFl4+uvaN0g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NbkxqCoXYQTU6XTa1bigiuXSWUIwbedQDQYE4dK8uF/vd9edYAnWrUUqWEkuwZNl2
         9Df/XWAsKewd73RRwffMC2KtgJ0u3M3U/DHRAFE3mi65siN7f7OQGQ8BCdRlvZS5ZR
         UUUkgxv7RpHnjtl61NzEvTMaWuGuykiSirP40zxs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hilda Wu <hildawu@realtek.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 142/242] Bluetooth: btusb: Add support USB ALT 3 for WBS
Date:   Thu, 15 Jul 2021 20:38:24 +0200
Message-Id: <20210715182618.110743359@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182551.731989182@linuxfoundation.org>
References: <20210715182551.731989182@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hilda Wu <hildawu@realtek.com>

[ Upstream commit e848dbd364aca44c9d23c04bef964fab79e2b34f ]

Because mSBC frames do not need to be aligned to the SCO packet
boundary. Using USB ALT 3 let HCI payload >= 60 bytes, let mSBC
data satisfy 60 Bytes avoid payload unaligned situation and fixed
some headset no voise issue.

USB Alt 3 supported also need HFP support transparent MTU in 72 Bytes.

Signed-off-by: Hilda Wu <hildawu@realtek.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 12f05093c46d..ec17772defc2 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -1749,6 +1749,13 @@ static void btusb_work(struct work_struct *work)
 			 * which work with WBS at all.
 			 */
 			new_alts = btusb_find_altsetting(data, 6) ? 6 : 1;
+			/* Because mSBC frames do not need to be aligned to the
+			 * SCO packet boundary. If support the Alt 3, use the
+			 * Alt 3 for HCI payload >= 60 Bytes let air packet
+			 * data satisfy 60 bytes.
+			 */
+			if (new_alts == 1 && btusb_find_altsetting(data, 3))
+				new_alts = 3;
 		}
 
 		if (btusb_switch_alt_setting(hdev, new_alts) < 0)
-- 
2.30.2



