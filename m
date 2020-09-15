Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F6E226B6E8
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 02:14:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727150AbgIPAMw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 20:12:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:38262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726931AbgIOO0a (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:26:30 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2238E22453;
        Tue, 15 Sep 2020 14:19:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600179557;
        bh=F8g5zk3l694uxU9LFQUhA2MdY0Obd1+vk5F2Z6KwFR4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SPeYJTUNY+YsrF+fWXn9T9hYdF2ExJr3WaRJrlm5NzMhPX+B9v1YmrtasVOo0lXSQ
         7syAh3vIOjMCQ76t6yqDX4t11GlHF8D3Q3cogNDOvbBpfQCn7KlQfb4iwF6KiqsYW0
         11bIUfqQh5bS9IW7UeixRymrj5YLC9YxKvOScPq8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 004/132] regulator: push allocation in regulator_ena_gpio_request() out of lock
Date:   Tue, 15 Sep 2020 16:11:46 +0200
Message-Id: <20200915140644.299950981@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140644.037604909@linuxfoundation.org>
References: <20200915140644.037604909@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michał Mirosław <mirq-linux@rere.qmqm.pl>

[ Upstream commit 467bf30142c64f2eb64e2ac67fa4595126230efd ]

Move another allocation out of regulator_list_mutex-protected region, as
reclaim might want to take the same lock.

WARNING: possible circular locking dependency detected
5.7.13+ #534 Not tainted
------------------------------------------------------
kswapd0/383 is trying to acquire lock:
c0e5d920 (regulator_list_mutex){+.+.}-{3:3}, at: regulator_lock_dependent+0x54/0x2c0

but task is already holding lock:
c0e38518 (fs_reclaim){+.+.}-{0:0}, at: __fs_reclaim_acquire+0x0/0x50

which lock already depends on the new lock.

the existing dependency chain (in reverse order) is:

-> #1 (fs_reclaim){+.+.}-{0:0}:
       fs_reclaim_acquire.part.11+0x40/0x50
       fs_reclaim_acquire+0x24/0x28
       kmem_cache_alloc_trace+0x40/0x1e8
       regulator_register+0x384/0x1630
       devm_regulator_register+0x50/0x84
       reg_fixed_voltage_probe+0x248/0x35c
[...]
other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(fs_reclaim);
                               lock(regulator_list_mutex);
                               lock(fs_reclaim);
  lock(regulator_list_mutex);

 *** DEADLOCK ***
[...]
2 locks held by kswapd0/383:
 #0: c0e38518 (fs_reclaim){+.+.}-{0:0}, at: __fs_reclaim_acquire+0x0/0x50
 #1: cb70e5e0 (hctx->srcu){....}-{0:0}, at: hctx_lock+0x60/0xb8
[...]

Fixes: 541d052d7215 ("regulator: core: Only support passing enable GPIO descriptors")
[this commit only changes context]
Fixes: f8702f9e4aa7 ("regulator: core: Use ww_mutex for regulators locking")
[this is when the regulator_list_mutex was introduced in reclaim locking path]

Signed-off-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
Link: https://lore.kernel.org/r/41fe6a9670335721b48e8f5195038c3d67a3bf92.1597195321.git.mirq-linux@rere.qmqm.pl
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/core.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index a17aebe0aa7a7..19826641881bb 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -2217,10 +2217,13 @@ EXPORT_SYMBOL_GPL(regulator_bulk_unregister_supply_alias);
 static int regulator_ena_gpio_request(struct regulator_dev *rdev,
 				const struct regulator_config *config)
 {
-	struct regulator_enable_gpio *pin;
+	struct regulator_enable_gpio *pin, *new_pin;
 	struct gpio_desc *gpiod;
 
 	gpiod = config->ena_gpiod;
+	new_pin = kzalloc(sizeof(*new_pin), GFP_KERNEL);
+
+	mutex_lock(&regulator_list_mutex);
 
 	list_for_each_entry(pin, &regulator_ena_gpio_list, list) {
 		if (pin->gpiod == gpiod) {
@@ -2229,9 +2232,13 @@ static int regulator_ena_gpio_request(struct regulator_dev *rdev,
 		}
 	}
 
-	pin = kzalloc(sizeof(struct regulator_enable_gpio), GFP_KERNEL);
-	if (pin == NULL)
+	if (new_pin == NULL) {
+		mutex_unlock(&regulator_list_mutex);
 		return -ENOMEM;
+	}
+
+	pin = new_pin;
+	new_pin = NULL;
 
 	pin->gpiod = gpiod;
 	list_add(&pin->list, &regulator_ena_gpio_list);
@@ -2239,6 +2246,10 @@ static int regulator_ena_gpio_request(struct regulator_dev *rdev,
 update_ena_gpio_to_rdev:
 	pin->request_count++;
 	rdev->ena_pin = pin;
+
+	mutex_unlock(&regulator_list_mutex);
+	kfree(new_pin);
+
 	return 0;
 }
 
@@ -5108,9 +5119,7 @@ regulator_register(const struct regulator_desc *regulator_desc,
 	}
 
 	if (config->ena_gpiod) {
-		mutex_lock(&regulator_list_mutex);
 		ret = regulator_ena_gpio_request(rdev, config);
-		mutex_unlock(&regulator_list_mutex);
 		if (ret != 0) {
 			rdev_err(rdev, "Failed to request enable GPIO: %d\n",
 				 ret);
-- 
2.25.1



