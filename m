Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DE8E29C038
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:13:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1817054AbgJ0RMe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:12:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:33144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1785104AbgJ0O7o (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:59:44 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D7E920714;
        Tue, 27 Oct 2020 14:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810783;
        bh=NtXoIMJCeTROgKuaHm67EDwfKRS+kP49fIqYA68hxQs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eG3ngfh+gIEBj7ZTKWz3RpdDz6bBgU+i+XgVY8IKvPdeWiHr7JKvIh+/8Cdzipyr3
         +urcbxDWISKnlzBWWnaCxCLuWKKCRnPw3M3kFkfcvCAFBfPzCblRx0Hw8IKrhSygKd
         V6JACTEZjUQY//agykszmjMH8NI2tngy+IGcy8dQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Huang Guobin <huangguobin4@huawei.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 245/633] net: wilc1000: clean up resource in error path of init mon interface
Date:   Tue, 27 Oct 2020 14:49:48 +0100
Message-Id: <20201027135534.168133078@linuxfoundation.org>
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
 drivers/staging/wilc1000/mon.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/mon.c b/drivers/staging/wilc1000/mon.c
index 60331417bd983..66f1c870f4f69 100644
--- a/drivers/staging/wilc1000/mon.c
+++ b/drivers/staging/wilc1000/mon.c
@@ -236,11 +236,10 @@ struct net_device *wilc_wfi_init_mon_interface(struct wilc *wl,
 
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



