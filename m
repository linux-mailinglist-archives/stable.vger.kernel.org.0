Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3635027C8B5
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:05:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731139AbgI2MEC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:04:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:60238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729069AbgI2Lic (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:38:32 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 434B021941;
        Tue, 29 Sep 2020 11:38:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379485;
        bh=OaIXy9pjhG6VdpJctz+9+sMtzA7P+US57dK2OhFZ3jE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vl119FvJHqFh9Pf46ZxS6z17bln5I4/TgcYrkYVgYbUKs9LCSmIx3NFkvS25Ce6vI
         mv2M4I8DrqJsy3k8ydcbPuhOBkzvdgU7Czq0K+SDXkGEt3kATDSpb0NhnVmVrYSs8u
         3Rt5E+4YGSD37JNT2nQPR0gGEREcxXbbv+zax0Zk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 183/388] r8169: improve RTL8168b FIFO overflow workaround
Date:   Tue, 29 Sep 2020 12:58:34 +0200
Message-Id: <20200929110019.337637946@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit 6b02e407cbf8d421477ebb7792cd6380affcd313 ]

So far only the reset bit it set, but the handler executing the reset
is not scheduled. Therefore nothing will happen until some other action
schedules the handler. Improve this by ensuring that the handler is
scheduled.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/realtek/r8169_main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 6fa9852e3f97f..903212ad9bb2f 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -6256,8 +6256,7 @@ static irqreturn_t rtl8169_interrupt(int irq, void *dev_instance)
 	if (unlikely(status & RxFIFOOver &&
 	    tp->mac_version == RTL_GIGA_MAC_VER_11)) {
 		netif_stop_queue(tp->dev);
-		/* XXX - Hack alert. See rtl_task(). */
-		set_bit(RTL_FLAG_TASK_RESET_PENDING, tp->wk.flags);
+		rtl_schedule_task(tp, RTL_FLAG_TASK_RESET_PENDING);
 	}
 
 	rtl_irq_disable(tp);
-- 
2.25.1



