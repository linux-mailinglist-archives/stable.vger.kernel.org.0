Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 459A0313794
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:29:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233871AbhBHP2H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:28:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:33700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233779AbhBHPWB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:22:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C491664F0A;
        Mon,  8 Feb 2021 15:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612797234;
        bh=F62tx6LP7JeGwQJCwT9w7adBWae/vVK9wnFblI/pk7A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z/QzIpQIFI/qm+eNYwBScnwhhnyjPoj1IhtxBbQwgUZUs/5Tg7udU9+0v+kKyxi6r
         4CWrV1rugHBr1YyG+JxpOCNBCnLZIYhbUIKeVVA/mxeKrfAi2PTpB+uEdIciS82MIc
         D9ThyBGHh3DegyzcEerYl7bRw7LVlWSBrnlhMVRg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>, Lijun Pan <ljp@linux.ibm.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 039/120] ibmvnic: device remove has higher precedence over reset
Date:   Mon,  8 Feb 2021 16:00:26 +0100
Message-Id: <20210208145819.976343427@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145818.395353822@linuxfoundation.org>
References: <20210208145818.395353822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lijun Pan <ljp@linux.ibm.com>

[ Upstream commit 5e9eff5dfa460cd1a74b7c1fde4fced7c04383af ]

Returning -EBUSY in ibmvnic_remove() does not actually hold the
removal procedure since driver core doesn't care for the return
value (see __device_release_driver() in drivers/base/dd.c
calling dev->bus->remove()) though vio_bus_remove
(in arch/powerpc/platforms/pseries/vio.c) records the
return value and passes it on. [1]

During the device removal precedure, checking for resetting
bit is dropped so that we can continue executing all the
cleanup calls in the rest of the remove function. Otherwise,
it can cause latent memory leaks and kernel crashes.

[1] https://lore.kernel.org/linuxppc-dev/20210117101242.dpwayq6wdgfdzirl@pengutronix.de/T/#m48f5befd96bc9842ece2a3ad14f4c27747206a53
Reported-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Fixes: 7d7195a026ba ("ibmvnic: Do not process device remove during device reset")
Signed-off-by: Lijun Pan <ljp@linux.ibm.com>
Link: https://lore.kernel.org/r/20210129043402.95744-1-ljp@linux.ibm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 627ce1a20473a..2f281d0f98070 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -5339,11 +5339,6 @@ static int ibmvnic_remove(struct vio_dev *dev)
 	unsigned long flags;
 
 	spin_lock_irqsave(&adapter->state_lock, flags);
-	if (test_bit(0, &adapter->resetting)) {
-		spin_unlock_irqrestore(&adapter->state_lock, flags);
-		return -EBUSY;
-	}
-
 	adapter->state = VNIC_REMOVING;
 	spin_unlock_irqrestore(&adapter->state_lock, flags);
 
-- 
2.27.0



