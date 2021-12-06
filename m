Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB986469CB8
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:21:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358599AbhLFPYn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:24:43 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:52344 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357060AbhLFPWl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:22:41 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1A835B810F1;
        Mon,  6 Dec 2021 15:19:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FBF4C341C1;
        Mon,  6 Dec 2021 15:19:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803950;
        bh=7QxFzh3mup/DD19iIzE1R7I2bKpdoeKE7fecMZelwk8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sOe0Ekdwlp2x6CMwl9v08IgXV37c+Dt7zotwksClKWtK2zkh/naJfpriEffqYpolN
         DVjwc9gb4b4SRkaqp/AZweCNqoAK/WzB8EQV+nZm9wia9mFvDjbtcScxL5ix2g0qAo
         KkEzY42TDmaUMl/ymqeQMlJkdPWyLsgmTfhe5UDs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 5.10 073/130] mt76: mt7915: fix NULL pointer dereference in mt7915_get_phy_mode
Date:   Mon,  6 Dec 2021 15:56:30 +0100
Message-Id: <20211206145602.196339370@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145559.607158688@linuxfoundation.org>
References: <20211206145559.607158688@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

commit 6e53d6d26920d5221d3f4d4f5ffdd629ea69aa5c upstream.

Fix the following NULL pointer dereference in mt7915_get_phy_mode
routine adding an ibss interface to the mt7915 driver.

[  101.137097] wlan0: Trigger new scan to find an IBSS to join
[  102.827039] wlan0: Creating new IBSS network, BSSID 26:a4:50:1a:6e:69
[  103.064756] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000000
[  103.073670] Mem abort info:
[  103.076520]   ESR = 0x96000005
[  103.079614]   EC = 0x25: DABT (current EL), IL = 32 bits
[  103.084934]   SET = 0, FnV = 0
[  103.088042]   EA = 0, S1PTW = 0
[  103.091215] Data abort info:
[  103.094104]   ISV = 0, ISS = 0x00000005
[  103.098041]   CM = 0, WnR = 0
[  103.101044] user pgtable: 4k pages, 39-bit VAs, pgdp=00000000460b1000
[  103.107565] [0000000000000000] pgd=0000000000000000, p4d=0000000000000000, pud=0000000000000000
[  103.116590] Internal error: Oops: 96000005 [#1] SMP
[  103.189066] CPU: 1 PID: 333 Comm: kworker/u4:3 Not tainted 5.10.75 #0
[  103.195498] Hardware name: MediaTek MT7622 RFB1 board (DT)
[  103.201124] Workqueue: phy0 ieee80211_iface_work [mac80211]
[  103.206695] pstate: 20000005 (nzCv daif -PAN -UAO -TCO BTYPE=--)
[  103.212705] pc : mt7915_get_phy_mode+0x68/0x120 [mt7915e]
[  103.218103] lr : mt7915_mcu_add_bss_info+0x11c/0x760 [mt7915e]
[  103.223927] sp : ffffffc011cdb9e0
[  103.227235] x29: ffffffc011cdb9e0 x28: ffffff8006563098
[  103.232545] x27: ffffff8005f4da22 x26: ffffff800685ac40
[  103.237855] x25: 0000000000000001 x24: 000000000000011f
[  103.243165] x23: ffffff8005f4e260 x22: ffffff8006567918
[  103.248475] x21: ffffff8005f4df80 x20: ffffff800685ac58
[  103.253785] x19: ffffff8006744400 x18: 0000000000000000
[  103.259094] x17: 0000000000000000 x16: 0000000000000001
[  103.264403] x15: 000899c3a2d9d2e4 x14: 000899bdc3c3a1c8
[  103.269713] x13: 0000000000000000 x12: 0000000000000000
[  103.275024] x11: ffffffc010e30c20 x10: 0000000000000000
[  103.280333] x9 : 0000000000000050 x8 : ffffff8006567d88
[  103.285642] x7 : ffffff8006563b5c x6 : ffffff8006563b44
[  103.290952] x5 : 0000000000000002 x4 : 0000000000000001
[  103.296262] x3 : 0000000000000001 x2 : 0000000000000001
[  103.301572] x1 : 0000000000000000 x0 : 0000000000000011
[  103.306882] Call trace:
[  103.309328]  mt7915_get_phy_mode+0x68/0x120 [mt7915e]
[  103.314378]  mt7915_bss_info_changed+0x198/0x200 [mt7915e]
[  103.319941]  ieee80211_bss_info_change_notify+0x128/0x290 [mac80211]
[  103.326360]  __ieee80211_sta_join_ibss+0x308/0x6c4 [mac80211]
[  103.332171]  ieee80211_sta_create_ibss+0x8c/0x10c [mac80211]
[  103.337895]  ieee80211_ibss_work+0x3dc/0x614 [mac80211]
[  103.343185]  ieee80211_iface_work+0x388/0x3f0 [mac80211]
[  103.348495]  process_one_work+0x288/0x690
[  103.352499]  worker_thread+0x70/0x464
[  103.356157]  kthread+0x144/0x150
[  103.359380]  ret_from_fork+0x10/0x18
[  103.362952] Code: 394008c3 52800220 394000e4 7100007f (39400023)

Fixes: 37f4ca907c46 ("mt76: mt7915: register per-phy HE capabilities for each interface")
Fixes: e57b7901469f ("mt76: add mac80211 driver for MT7915 PCIe-based chipsets")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Acked-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/ddae419a740f1fb9e48afd432035e9f394f512ee.1637239456.git.lorenzo@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
@@ -182,7 +182,7 @@ mt7915_get_phy_mode(struct mt7915_dev *d
 		if (ht_cap->ht_supported)
 			mode |= PHY_MODE_GN;
 
-		if (he_cap->has_he)
+		if (he_cap && he_cap->has_he)
 			mode |= PHY_MODE_AX_24G;
 	} else if (band == NL80211_BAND_5GHZ) {
 		mode |= PHY_MODE_A;
@@ -193,7 +193,7 @@ mt7915_get_phy_mode(struct mt7915_dev *d
 		if (vht_cap->vht_supported)
 			mode |= PHY_MODE_AC;
 
-		if (he_cap->has_he)
+		if (he_cap && he_cap->has_he)
 			mode |= PHY_MODE_AX_5G;
 	}
 


