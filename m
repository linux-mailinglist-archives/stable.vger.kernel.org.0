Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38AB7411D67
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:18:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346788AbhITRUI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:20:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:47490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344921AbhITRRg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:17:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CE2EB61A3A;
        Mon, 20 Sep 2021 16:59:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632157170;
        bh=+IRgp8iJ9xtJxrBbNWlDkuTlgYynfQ71jkcBitNje1g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fBFs70lXzDPoSgZRs/1dj+WqLQzcjQGM4SbseH9IhqltXs0SmN1KgBnTSbAeAk7Ob
         ze5S+3XkueBolkuHQdpIvGRLRfVYvtLbUL93EJ1+V30lflHSxPxvD1bnGYyuY3pZVf
         Mco7buzZY8S5wCdo/G/ZIXknXUKasRNhPygBO0nk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zenghui Yu <yuzenghui@huawei.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 086/217] bcma: Fix memory leak for internally-handled cores
Date:   Mon, 20 Sep 2021 18:41:47 +0200
Message-Id: <20210920163927.551359062@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163924.591371269@linuxfoundation.org>
References: <20210920163924.591371269@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zenghui Yu <yuzenghui@huawei.com>

[ Upstream commit b63aed3ff195130fef12e0af590f4838cf0201d8 ]

kmemleak reported that dev_name() of internally-handled cores were leaked
on driver unbinding. Let's use device_initialize() to take refcounts for
them and put_device() to properly free the related stuff.

While looking at it, there's another potential issue for those which should
be *registered* into driver core. If device_register() failed, we put
device once and freed bcma_device structures. In bcma_unregister_cores(),
they're treated as unregistered and we hit both UAF and double-free. That
smells not good and has also been fixed now.

Fixes: ab54bc8460b5 ("bcma: fill core details for every device")
Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210727025232.663-2-yuzenghui@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bcma/main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/bcma/main.c b/drivers/bcma/main.c
index e6986c7608f1..b1783f5b5cb5 100644
--- a/drivers/bcma/main.c
+++ b/drivers/bcma/main.c
@@ -236,6 +236,7 @@ EXPORT_SYMBOL(bcma_core_irq);
 
 void bcma_prepare_core(struct bcma_bus *bus, struct bcma_device *core)
 {
+	device_initialize(&core->dev);
 	core->dev.release = bcma_release_core_dev;
 	core->dev.bus = &bcma_bus_type;
 	dev_set_name(&core->dev, "bcma%d:%d", bus->num, core->core_index);
@@ -299,11 +300,10 @@ static void bcma_register_core(struct bcma_bus *bus, struct bcma_device *core)
 {
 	int err;
 
-	err = device_register(&core->dev);
+	err = device_add(&core->dev);
 	if (err) {
 		bcma_err(bus, "Could not register dev for core 0x%03X\n",
 			 core->id.id);
-		put_device(&core->dev);
 		return;
 	}
 	core->dev_registered = true;
@@ -394,7 +394,7 @@ void bcma_unregister_cores(struct bcma_bus *bus)
 	/* Now noone uses internally-handled cores, we can free them */
 	list_for_each_entry_safe(core, tmp, &bus->cores, list) {
 		list_del(&core->list);
-		kfree(core);
+		put_device(&core->dev);
 	}
 }
 
-- 
2.30.2



