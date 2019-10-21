Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EDDCDE1A0
	for <lists+stable@lfdr.de>; Mon, 21 Oct 2019 02:57:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726681AbfJUA5E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 20 Oct 2019 20:57:04 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:36088 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726641AbfJUA5E (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 20 Oct 2019 20:57:04 -0400
Received: by mail-oi1-f195.google.com with SMTP id k20so9632375oih.3;
        Sun, 20 Oct 2019 17:57:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0+8yL95iA9xl8GU+Ns3sN6nA5PQJhOhlYk6Bv5EKaG0=;
        b=pU/2ULMA0Zej7JRCpaDtxdTKojYZt7kRfMz5O6x2B+eD4Dg2+IXPx6S0nq1nRh7Hti
         PB200PaupDDwJqoPTLb/qXzC4tMQGLlbFPqyNF5RgJf9uJTK9DIjA5STp9t7ge0djlKe
         BspOJtDAVyxoQKYWlaah/uxr6ybFUeoG577bRhgelHCDRDWKOvmTtf63eX8kPpnsEJCs
         z59uDUkhkQtCPluu2dec/yxZaSgjKYXnqksWM5EbyTOVW6bTWIPsfdfhXstvKsEDt5xB
         2oQ6rOBDirjmDaynnUArJBor5dEQsIjI8LOCQh8Wib64hNFWrfGgyiTR7vRe6/9OVxy0
         C4aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=0+8yL95iA9xl8GU+Ns3sN6nA5PQJhOhlYk6Bv5EKaG0=;
        b=ZAMml3FjL4GHzDBSFu2RHoMrKjgZf7gci9JtSzp75Fr0w58RZH8AznQyokbPPpkt6z
         fytacE0gwxvqdsjZs4NxfkhJrgMo+veRdzGyWXuDBumGvyr8MRwgpP4JqHzqrBCrM6CG
         xJmy8Suv9IrE31erUhqgT0us7smZ9mPTUpMQl8wXKd9IMtGaD3lG3HcAi6a1IpOoHsr7
         nhVTraIlwngnoBo0M/QMCG4fadqmL5UYvfcUvh4mj6HhmSj+ZYU0Z/nf2TSBeOVc4pZZ
         +RO+6XpdCtH065zYtBgM3LaXx8Z91YKoWFwD+1F01nt9qhjAPpKIXbuB07wLUiAhCuaW
         raFg==
X-Gm-Message-State: APjAAAX69yUnTLti5TCf6htIW3Kibnl8/B5FoP7y3o/30D9WE/ZW6Mad
        5EppXEjGkq+7ktYf9Jr5WfAt5XoF
X-Google-Smtp-Source: APXvYqxqVdmvXlYe078dVvRutR4VmN0GdcnINxJCtUY73aXIyLhWTO6iGI+uJPXsuz6mg6omM1q3SQ==
X-Received: by 2002:aca:c4d4:: with SMTP id u203mr17303935oif.121.1571619423006;
        Sun, 20 Oct 2019 17:57:03 -0700 (PDT)
Received: from localhost.localdomain (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id j138sm3321765oib.2.2019.10.20.17.57.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Oct 2019 17:57:01 -0700 (PDT)
From:   Larry Finger <Larry.Finger@lwfinger.net>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, pkshih@realtek.com,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Stable <stable@vger.kernel.org>
Subject: [PATCH V3] rtlwifi: rtl_pci: Fix problem of too small skb->len
Date:   Sun, 20 Oct 2019 19:56:58 -0500
Message-Id: <20191021005658.31391-1-Larry.Finger@lwfinger.net>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In commit 8020919a9b99 ("mac80211: Properly handle SKB with radiotap
only"), buffers whose length is too short cause a WARN_ON(1) to be
executed. This change exposed a fault in rtlwifi drivers, which is fixed
by regarding packets with skb->len <= FCS_LEN as though they are in error
and dropping them. The test is now annotated as likely.

Cc: Stable <stable@vger.kernel.org> # v5.0+
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
V2 - content dropped
V3 - changed fix to drop packet rather than arbitrarily increasing the length.
---
Material for 5.4.
---
 drivers/net/wireless/realtek/rtlwifi/pci.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/pci.c b/drivers/net/wireless/realtek/rtlwifi/pci.c
index 6087ec7a90a6..f88d26535978 100644
--- a/drivers/net/wireless/realtek/rtlwifi/pci.c
+++ b/drivers/net/wireless/realtek/rtlwifi/pci.c
@@ -822,7 +822,7 @@ static void _rtl_pci_rx_interrupt(struct ieee80211_hw *hw)
 		hdr = rtl_get_hdr(skb);
 		fc = rtl_get_fc(skb);
 
-		if (!stats.crc && !stats.hwerror) {
+		if (!stats.crc && !stats.hwerror && (skb->len > FCS_LEN)) {
 			memcpy(IEEE80211_SKB_RXCB(skb), &rx_status,
 			       sizeof(rx_status));
 
@@ -859,6 +859,7 @@ static void _rtl_pci_rx_interrupt(struct ieee80211_hw *hw)
 				_rtl_pci_rx_to_mac80211(hw, skb, rx_status);
 			}
 		} else {
+			/* drop packets with errors or those too short */
 			dev_kfree_skb_any(skb);
 		}
 new_trx_end:
-- 
2.23.0

