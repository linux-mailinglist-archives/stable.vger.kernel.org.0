Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06704451F4D
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:36:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355961AbhKPAir (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:38:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:45404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344044AbhKOTXM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:23:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8202E6361C;
        Mon, 15 Nov 2021 18:50:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002241;
        bh=JEwMn5gTkrBchXO4VU1g4R/loMNyVmPXU0YgI8/IL9s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E1VyxMqjU9eCvuwA7RJjrKX2OZuuDwgXwvGYllhmS4xyE13ahykPEiUgfSjHhIcvQ
         wiPtfv65Jj/9ukikoYbickkNAvCH/U6wlVtVLrW5xOiFMAwkpio8oVIHUckAR74TLi
         tvRFYL7QFu8pqdS57qq8WEq1NX5bnyAONWwShsPY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ziyang Xuan <william.xuanziyang@huawei.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 484/917] rsi: stop thread firstly in rsi_91x_init() error handling
Date:   Mon, 15 Nov 2021 17:59:39 +0100
Message-Id: <20211115165445.191663068@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ziyang Xuan <william.xuanziyang@huawei.com>

[ Upstream commit 515e7184bdf0a3ebf1757cc77fb046b4fe282189 ]

When fail to init coex module, free 'common' and 'adapter' directly, but
common->tx_thread which will access 'common' and 'adapter' is running at
the same time. That will trigger the UAF bug.

==================================================================
BUG: KASAN: use-after-free in rsi_tx_scheduler_thread+0x50f/0x520 [rsi_91x]
Read of size 8 at addr ffff8880076dc000 by task Tx-Thread/124777
CPU: 0 PID: 124777 Comm: Tx-Thread Not tainted 5.15.0-rc5+ #19
Call Trace:
 dump_stack_lvl+0xe2/0x152
 print_address_description.constprop.0+0x21/0x140
 ? rsi_tx_scheduler_thread+0x50f/0x520
 kasan_report.cold+0x7f/0x11b
 ? rsi_tx_scheduler_thread+0x50f/0x520
 rsi_tx_scheduler_thread+0x50f/0x520
...

Freed by task 111873:
 kasan_save_stack+0x1b/0x40
 kasan_set_track+0x1c/0x30
 kasan_set_free_info+0x20/0x30
 __kasan_slab_free+0x109/0x140
 kfree+0x117/0x4c0
 rsi_91x_init+0x741/0x8a0 [rsi_91x]
 rsi_probe+0x9f/0x1750 [rsi_usb]

Stop thread before free 'common' and 'adapter' to fix it.

Fixes: 2108df3c4b18 ("rsi: add coex support")
Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20211015040335.1021546-1-william.xuanziyang@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/rsi/rsi_91x_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/rsi/rsi_91x_main.c b/drivers/net/wireless/rsi/rsi_91x_main.c
index 143224a3802ba..f1bf71e6c6081 100644
--- a/drivers/net/wireless/rsi/rsi_91x_main.c
+++ b/drivers/net/wireless/rsi/rsi_91x_main.c
@@ -369,6 +369,7 @@ struct rsi_hw *rsi_91x_init(u16 oper_mode)
 	if (common->coex_mode > 1) {
 		if (rsi_coex_attach(common)) {
 			rsi_dbg(ERR_ZONE, "Failed to init coex module\n");
+			rsi_kill_thread(&common->tx_thread);
 			goto err;
 		}
 	}
-- 
2.33.0



