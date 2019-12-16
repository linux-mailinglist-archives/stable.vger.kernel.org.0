Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E2901216EB
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:33:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730146AbfLPSJj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:09:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:52122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730466AbfLPSJh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:09:37 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 646B620700;
        Mon, 16 Dec 2019 18:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576519776;
        bh=nYpJF1tKEGBHPBq7MFT8bGmcSansbuQytsUixITYff4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ls1/vD7Pj4qHCE3k3Ia3ypttx9lLDJV0GIAUovj8OJfNRmDgVncwzyzkBpgs4U4tK
         /LZW94KjfM+oIxMY8LTEvCbvPl/0ZNFblvgT0ODXqBjd7cYvVfK/c09jiw7cO5CxOB
         rOt6GLAr5CM5uryZ4mwYRJIQIKUnF8gMj9XTpALs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Larry Finger <Larry.Finger@lwfinger.net>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 5.3 063/180] rtlwifi: rtl8192de: Fix missing code to retrieve RX buffer address
Date:   Mon, 16 Dec 2019 18:48:23 +0100
Message-Id: <20191216174829.605165153@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174806.018988360@linuxfoundation.org>
References: <20191216174806.018988360@linuxfoundation.org>
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
@@ -818,13 +818,15 @@ u64 rtl92de_get_desc(struct ieee80211_hw
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


