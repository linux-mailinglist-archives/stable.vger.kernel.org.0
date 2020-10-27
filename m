Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F56829B7D0
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:07:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1796449AbgJ0PSm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:18:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:52850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1796250AbgJ0PQR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:16:17 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E24020728;
        Tue, 27 Oct 2020 15:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811776;
        bh=dXX67ugBaay3YEwWMjuBSOIs7iMiA2XdkQBHJ0q0d94=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LJKPhDNAdMZDeg+ZCUNrQNZmnwmXa0yPrqk2GvShRiZP3oy8GaDEzzj/4RQTKF9Gc
         MNpkfr/7hvNfbFHZ+1WXMzgIXzScuNn7aGAcpGIb+v8XF+3a2ZQ0QvkZvctY+uqIab
         tCrv/WqJlclc8fqmiiZL5FGLZxMhNr25FAHa15XI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot <syzbot+dc4127f950da51639216@syzkaller.appspotmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Brian Norris <briannorris@chromium.org>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 611/633] mwifiex: dont call del_timer_sync() on uninitialized timer
Date:   Tue, 27 Oct 2020 14:55:54 +0100
Message-Id: <20201027135551.490070552@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

[ Upstream commit 621a3a8b1c0ecf16e1e5667ea5756a76a082b738 ]

syzbot is reporting that del_timer_sync() is called from
mwifiex_usb_cleanup_tx_aggr() from mwifiex_unregister_dev() without
checking timer_setup() from mwifiex_usb_tx_init() was called [1].

Ganapathi Bhat proposed a possibly cleaner fix, but it seems that
that fix was forgotten [2].

"grep -FrB1 'del_timer' drivers/ | grep -FA1 '.function)'" says that
currently there are 28 locations which call del_timer[_sync]() only if
that timer's function field was initialized (because timer_setup() sets
that timer's function field). Therefore, let's use same approach here.

[1] https://syzkaller.appspot.com/bug?id=26525f643f454dd7be0078423e3cdb0d57744959
[2] https://lkml.kernel.org/r/CA+ASDXMHt2gq9Hy+iP_BYkWXsSreWdp3_bAfMkNcuqJ3K+-jbQ@mail.gmail.com

Reported-by: syzbot <syzbot+dc4127f950da51639216@syzkaller.appspotmail.com>
Cc: Ganapathi Bhat <ganapathi.bhat@nxp.com>
Cc: Brian Norris <briannorris@chromium.org>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Reviewed-by: Brian Norris <briannorris@chromium.org>
Acked-by: Ganapathi Bhat <ganapathi.bhat@nxp.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20200821082720.7716-1-penguin-kernel@I-love.SAKURA.ne.jp
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/marvell/mwifiex/usb.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/usb.c b/drivers/net/wireless/marvell/mwifiex/usb.c
index 6f3cfde4654cc..426e39d4ccf0f 100644
--- a/drivers/net/wireless/marvell/mwifiex/usb.c
+++ b/drivers/net/wireless/marvell/mwifiex/usb.c
@@ -1353,7 +1353,8 @@ static void mwifiex_usb_cleanup_tx_aggr(struct mwifiex_adapter *adapter)
 				skb_dequeue(&port->tx_aggr.aggr_list)))
 				mwifiex_write_data_complete(adapter, skb_tmp,
 							    0, -1);
-		del_timer_sync(&port->tx_aggr.timer_cnxt.hold_timer);
+		if (port->tx_aggr.timer_cnxt.hold_timer.function)
+			del_timer_sync(&port->tx_aggr.timer_cnxt.hold_timer);
 		port->tx_aggr.timer_cnxt.is_hold_timer_set = false;
 		port->tx_aggr.timer_cnxt.hold_tmo_msecs = 0;
 	}
-- 
2.25.1



