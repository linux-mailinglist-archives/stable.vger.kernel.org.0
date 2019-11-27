Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FDFB10BCC5
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:23:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731506AbfK0VEI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:04:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:57520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732111AbfK0VEH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:04:07 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A68D52086A;
        Wed, 27 Nov 2019 21:04:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888647;
        bh=6wPDkIfi1wyG2iZYHJrsHGb6q/8iTHRmXiBbUyAP03g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fj6uDsmELEpG5mBoRNHMtxYUtuxWSytMY18pMjdHAGczLhhL6I80Y8Z8IJX/+iXiB
         osxk4rtDIsZes71/mfsHAm8scbCE8QDREcj44rGtyzGwpWGGW3gJVunQt2QDOFG9S+
         An1bW4wYn3iSn/AERU/5Pw6jzJrFHz+ixp8QcGFw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maya Erez <merez@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 215/306] wil6210: fix RGF_CAF_ICR address for Talyn-MB
Date:   Wed, 27 Nov 2019 21:31:05 +0100
Message-Id: <20191127203130.799684406@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203114.766709977@linuxfoundation.org>
References: <20191127203114.766709977@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maya Erez <merez@codeaurora.org>

[ Upstream commit 7c69709f8ed27197b16aa1c3f9b0744402b2fa02 ]

RGF_CAF_ICR register location has changed in Talyn-MB.
Add RGF_CAF_ICR_TALYN_MB to support the new address.

Signed-off-by: Maya Erez <merez@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/wil6210/main.c    | 11 +++++++++--
 drivers/net/wireless/ath/wil6210/wil6210.h |  1 +
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 920cb233f4db7..10673fa9388ec 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -1397,8 +1397,15 @@ static void wil_pre_fw_config(struct wil6210_priv *wil)
 	wil6210_clear_irq(wil);
 	/* CAF_ICR - clear and mask */
 	/* it is W1C, clear by writing back same value */
-	wil_s(wil, RGF_CAF_ICR + offsetof(struct RGF_ICR, ICR), 0);
-	wil_w(wil, RGF_CAF_ICR + offsetof(struct RGF_ICR, IMV), ~0);
+	if (wil->hw_version < HW_VER_TALYN_MB) {
+		wil_s(wil, RGF_CAF_ICR + offsetof(struct RGF_ICR, ICR), 0);
+		wil_w(wil, RGF_CAF_ICR + offsetof(struct RGF_ICR, IMV), ~0);
+	} else {
+		wil_s(wil,
+		      RGF_CAF_ICR_TALYN_MB + offsetof(struct RGF_ICR, ICR), 0);
+		wil_w(wil, RGF_CAF_ICR_TALYN_MB +
+		      offsetof(struct RGF_ICR, IMV), ~0);
+	}
 	/* clear PAL_UNIT_ICR (potential D0->D3 leftover)
 	 * In Talyn-MB host cannot access this register due to
 	 * access control, hence PAL_UNIT_ICR is cleared by the FW
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 17c294b1ead13..75fe1a3b70466 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -319,6 +319,7 @@ struct RGF_ICR {
 /* MAC timer, usec, for packet lifetime */
 #define RGF_MAC_MTRL_COUNTER_0		(0x886aa8)
 
+#define RGF_CAF_ICR_TALYN_MB		(0x8893d4) /* struct RGF_ICR */
 #define RGF_CAF_ICR			(0x88946c) /* struct RGF_ICR */
 #define RGF_CAF_OSC_CONTROL		(0x88afa4)
 	#define BIT_CAF_OSC_XTAL_EN		BIT(0)
-- 
2.20.1



