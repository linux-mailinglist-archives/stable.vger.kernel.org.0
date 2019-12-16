Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55F4012139A
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:03:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729454AbfLPSDL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:03:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:39566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729221AbfLPSDI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:03:08 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B8A8320700;
        Mon, 16 Dec 2019 18:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576519387;
        bh=oqGTqd72PD79SesB2W3lERHEhT9QXB09SKLSXyGlIF8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dizV+6zd2tlMAOTDdgaYJAvdw/UAoA8znI/7gS18nkOQ+c2HQZt0HCT1hdY4ajF4g
         U5woMJ9SsJZEmHxOp+Klayx0TcnTxZhPF/F7d5bE4f57xvKQbuHg0lqTA9bE/5Y+fK
         Fs3MTFBRX2nPmc5ZAwf1YNpGc1BdTBO2bUzXYaNI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Larry Finger <Larry.Finger@lwfinger.net>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 4.19 044/140] rtlwifi: rtl8192de: Fix missing code to retrieve RX buffer address
Date:   Mon, 16 Dec 2019 18:48:32 +0100
Message-Id: <20191216174800.757144799@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174747.111154704@linuxfoundation.org>
References: <20191216174747.111154704@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Larry Finger <Larry.Finger@lwfinger.net>

commit 0e531cc575c4e9e3dd52ad287b49d3c2dc74c810 upstream.

In commit 38506ecefab9 ("rtlwifi: rtl_pci: Start modification for
new drivers"), a callback to get the RX buffer address was added to
the PCI driver. Unfortunately, driver rtl8192de was not modified
appropriately and the code runs into a WARN_ONCE() call. The use
of an incorrect array is also fixed.

Fixes: 38506ecefab9 ("rtlwifi: rtl_pci: Start modification for new drivers")
Cc: Stable <stable@vger.kernel.org> # 3.18+
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/trx.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/trx.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/trx.c
@@ -840,13 +840,15 @@ u64 rtl92de_get_desc(struct ieee80211_hw
 			break;
 		}
 	} else {
-		struct rx_desc_92c *pdesc = (struct rx_desc_92c *)p_desc;
 		switch (desc_name) {
 		case HW_DESC_OWN:
-			ret = GET_RX_DESC_OWN(pdesc);
+			ret = GET_RX_DESC_OWN(p_desc);
 			break;
 		case HW_DESC_RXPKT_LEN:
-			ret = GET_RX_DESC_PKT_LEN(pdesc);
+			ret = GET_RX_DESC_PKT_LEN(p_desc);
+			break;
+		case HW_DESC_RXBUFF_ADDR:
+			ret = GET_RX_DESC_BUFF_ADDR(p_desc);
 			break;
 		default:
 			WARN_ONCE(true, "rtl8192de: ERR rxdesc :%d not processed\n",


