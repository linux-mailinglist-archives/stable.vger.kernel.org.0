Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DA9F3C24ED
	for <lists+stable@lfdr.de>; Fri,  9 Jul 2021 15:23:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233079AbhGINZs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 09:25:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:57428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233004AbhGINZf (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 09:25:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5B872613C7;
        Fri,  9 Jul 2021 13:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1625836971;
        bh=6v3IVowOLz+r6UfmsELw2YAbMKJnpjoLoiw0XSdRFuA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EgllUZUTcbabeSU6EuUworqSpoavduBiUZn7xIsqvOGAYdzKDU2PbcaubGTcRxmNp
         G4TLRDUKz6jMx+2t/rrvPoZXbOajAg5qJGa0AMM+eDfcg+P1w0KMK72wgyyaqZsKUQ
         ZmWx+pS92C6AfaogtgmryprUnn3k9sFDgxF7ec+c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Wang <sean.wang@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, Deren Wu <Deren.Wu@mediatek.com>
Subject: [PATCH 5.12 10/11] mt76: mt7921: abort uncompleted scan by wifi reset
Date:   Fri,  9 Jul 2021 15:21:47 +0200
Message-Id: <20210709131603.155375987@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210709131549.679160341@linuxfoundation.org>
References: <20210709131549.679160341@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Wang <sean.wang@mediatek.com>

commit e513ae49088bbb0d00299a9f996f88f08cca7dc6 upstream.

Scan abort should be required for the uncompleted hardware scan
interrupted by wifi reset. Otherwise, it is possible that the scan
request after wifi reset gets error code -EBUSY from mac80211 and
then blocks the reconnectting to the access point.

Fixes: 0c1ce9884607 ("mt76: mt7921: add wifi reset support")
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Cc: Deren Wu <Deren.Wu@mediatek.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/mediatek/mt76/mt7921/mac.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
@@ -1386,6 +1386,14 @@ void mt7921_mac_reset_work(struct work_s
 	if (i == 10)
 		dev_err(dev->mt76.dev, "chip reset failed\n");
 
+	if (test_and_clear_bit(MT76_HW_SCANNING, &dev->mphy.state)) {
+		struct cfg80211_scan_info info = {
+			.aborted = true,
+		};
+
+		ieee80211_scan_completed(dev->mphy.hw, &info);
+	}
+
 	ieee80211_wake_queues(hw);
 	ieee80211_iterate_active_interfaces(hw,
 					    IEEE80211_IFACE_ITER_RESUME_ALL,


