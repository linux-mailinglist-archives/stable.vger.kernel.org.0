Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 193E529B813
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:08:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1799383AbgJ0PbN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:31:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:48150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1799377AbgJ0PbM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:31:12 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D216020728;
        Tue, 27 Oct 2020 15:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812671;
        bh=2TzIHl0kPIYQTAfi7N+ug8l1pq0QyQPeO1ZrHoPGuJ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eqeXafVTV8KNfrtWf2F7P3u7vB5QRrmcCf5QvLR+1NYKRc3oE1mhYh5SvKNp8yUcQ
         JwQmpjQDDaFxsULKZQ8g+aJBlUioSQj0keZT4kh7J9ej9wjbxHK3zDDyJ6ahTei5Hb
         qzJ6y7OjKklPyS4ZPy2RSU0rqF+fgI8erLr31GX8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Huang Guobin <huangguobin4@huawei.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 291/757] net: wilc1000: clean up resource in error path of init mon interface
Date:   Tue, 27 Oct 2020 14:49:01 +0100
Message-Id: <20201027135504.217106844@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Huang Guobin <huangguobin4@huawei.com>

[ Upstream commit 55bd149978679742374c800e56e8f6bc74378bbe ]

The wilc_wfi_init_mon_int() forgets to clean up resource when
register_netdevice() failed. Add the missed call to fix it.
And the return value of netdev_priv can't be NULL, so remove
the unnecessary error handling.

Fixes: 588713006ea4 ("staging: wilc1000: avoid the use of 'wilc_wfi_mon' static variable")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Huang Guobin <huangguobin4@huawei.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20200917123019.206382-1-huangguobin4@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/microchip/wilc1000/mon.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/mon.c b/drivers/net/wireless/microchip/wilc1000/mon.c
index 358ac86013338..b5a1b65c087ca 100644
--- a/drivers/net/wireless/microchip/wilc1000/mon.c
+++ b/drivers/net/wireless/microchip/wilc1000/mon.c
@@ -235,11 +235,10 @@ struct net_device *wilc_wfi_init_mon_interface(struct wilc *wl,
 
 	if (register_netdevice(wl->monitor_dev)) {
 		netdev_err(real_dev, "register_netdevice failed\n");
+		free_netdev(wl->monitor_dev);
 		return NULL;
 	}
 	priv = netdev_priv(wl->monitor_dev);
-	if (!priv)
-		return NULL;
 
 	priv->real_ndev = real_dev;
 
-- 
2.25.1



