Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 475EF12C841
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:16:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732310AbfL2Rwm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:52:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:39066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731852AbfL2Rwm (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:52:42 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 71E13206A4;
        Sun, 29 Dec 2019 17:52:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641961;
        bh=z39Fr7ia2l32HzW7ElZsr8NwpVDF8MpryY5I2YrPTSo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZFa75ui+++MFYPSFyHEecDxfHx0leIYbH6pNImWEKSyhHWKo0Rak40j2SPzqTsQTo
         S4voUukX3BiNa48svTBYLlTaIVhCWZySU8xBxx1AwRsSXalxrzk7D4dTS2k0jZqF1E
         9ljzRCyvR2DLpnnTwq3qZRIUXhKPGQlIdy6/K7Hg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Wahren <wahrenst@gmx.net>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 242/434] rtlwifi: fix memory leak in rtl92c_set_fw_rsvdpagepkt()
Date:   Sun, 29 Dec 2019 18:24:55 +0100
Message-Id: <20191229172717.957859542@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ping-Ke Shih <pkshih@realtek.com>

[ Upstream commit 5174f1e41074b5186608badc2e89441d021e8c08 ]

This leak was found by testing the EDIMAX EW-7612 on Raspberry Pi 3B+ with
Linux 5.4-rc5 (multi_v7_defconfig + rtlwifi + kmemleak) and noticed a
single memory leak during probe:

unreferenced object 0xec13ee40 (size 176):
  comm "kworker/u8:1", pid 36, jiffies 4294939321 (age 5580.790s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<fc1bbb3e>] __netdev_alloc_skb+0x9c/0x164
    [<863dfa6e>] rtl92c_set_fw_rsvdpagepkt+0x254/0x340 [rtl8192c_common]
    [<9572be0d>] rtl92cu_set_hw_reg+0xf48/0xfa4 [rtl8192cu]
    [<116df4d8>] rtl_op_bss_info_changed+0x234/0x96c [rtlwifi]
    [<8933575f>] ieee80211_bss_info_change_notify+0xb8/0x264 [mac80211]
    [<d4061e86>] ieee80211_assoc_success+0x934/0x1798 [mac80211]
    [<e55adb56>] ieee80211_rx_mgmt_assoc_resp+0x174/0x314 [mac80211]
    [<5974629e>] ieee80211_sta_rx_queued_mgmt+0x3f4/0x7f0 [mac80211]
    [<d91091c6>] ieee80211_iface_work+0x208/0x318 [mac80211]
    [<ac5fcae4>] process_one_work+0x22c/0x564
    [<f5e6d3b6>] worker_thread+0x44/0x5d8
    [<82c7b073>] kthread+0x150/0x154
    [<b43e1b7d>] ret_from_fork+0x14/0x2c
    [<794dff30>] 0x0

It is because 8192cu doesn't implement usb_cmd_send_packet(), and this
patch just frees the skb within the function to resolve memleak problem
by now. Since 8192cu doesn't turn on fwctrl_lps that needs to download
command packet for firmware via the function, applying this patch doesn't
affect driver behavior.

Reported-by: Stefan Wahren <wahrenst@gmx.net>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c
index 56cc3bc30860..f070f25bb735 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c
@@ -1540,6 +1540,8 @@ static bool usb_cmd_send_packet(struct ieee80211_hw *hw, struct sk_buff *skb)
    * This is maybe necessary:
    * rtlpriv->cfg->ops->fill_tx_cmddesc(hw, buffer, 1, 1, skb);
    */
+	dev_kfree_skb(skb);
+
 	return true;
 }
 
-- 
2.20.1



