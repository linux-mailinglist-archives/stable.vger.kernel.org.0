Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08A3926B427
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 01:18:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727232AbgIOXRq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 19:17:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:48770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727240AbgIOOj2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:39:28 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0AF3A224D3;
        Tue, 15 Sep 2020 14:29:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600180162;
        bh=zT8bxYk15jJbBtQ+dPBi70lJ/lpTYg4QNO75lT+DDcc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wPThzLKXUI+H/VO3o8KlX2MP0wtjzF/Kw4JkXbhfJuYEob7YZ3YSqBx1RV0gQnkPq
         S0ulJIen4SdId6W0hsQCQYNGclfMBEqTuN5uG27OyYpxejM4SN4o28hTxJSp65TjgJ
         gKbIvXTP3aFK1kQXX6v2pXJHidGCgy3RVKjE9pog=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
        Dmitry Osipenko <digetx@gmail.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.8 133/177] regulator: push allocation in regulator_init_coupling() outside of lock
Date:   Tue, 15 Sep 2020 16:13:24 +0200
Message-Id: <20200915140700.026505613@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140653.610388773@linuxfoundation.org>
References: <20200915140653.610388773@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michał Mirosław <mirq-linux@rere.qmqm.pl>

commit 73a32129f8ccb556704a26b422f54e048bf14bd0 upstream.

Allocating memory with regulator_list_mutex held makes lockdep unhappy
when memory pressure makes the system do fs_reclaim on eg. eMMC using
a regulator. Push the lock inside regulator_init_coupling() after the
allocation.

======================================================
WARNING: possible circular locking dependency detected
5.7.13+ #533 Not tainted
------------------------------------------------------
kswapd0/383 is trying to acquire lock:
cca78ca4 (&sbi->write_io[i][j].io_rwsem){++++}-{3:3}, at: __submit_merged_write_cond+0x104/0x154
but task is already holding lock:
c0e38518 (fs_reclaim){+.+.}-{0:0}, at: __fs_reclaim_acquire+0x0/0x50
which lock already depends on the new lock.
the existing dependency chain (in reverse order) is:
-> #2 (fs_reclaim){+.+.}-{0:0}:
       fs_reclaim_acquire.part.11+0x40/0x50
       fs_reclaim_acquire+0x24/0x28
       __kmalloc+0x54/0x218
       regulator_register+0x860/0x1584
       dummy_regulator_probe+0x60/0xa8
[...]
other info that might help us debug this:

Chain exists of:
  &sbi->write_io[i][j].io_rwsem --> regulator_list_mutex --> fs_reclaim

Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(fs_reclaim);
                               lock(regulator_list_mutex);
                               lock(fs_reclaim);
  lock(&sbi->write_io[i][j].io_rwsem);
 *** DEADLOCK ***

1 lock held by kswapd0/383:
 #0: c0e38518 (fs_reclaim){+.+.}-{0:0}, at: __fs_reclaim_acquire+0x0/0x50
[...]

Fixes: d8ca7d184b33 ("regulator: core: Introduce API for regulators coupling customization")
Signed-off-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
Reviewed-by: Dmitry Osipenko <digetx@gmail.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/1a889cf7f61c6429c9e6b34ddcdde99be77a26b6.1597195321.git.mirq-linux@rere.qmqm.pl
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/regulator/core.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -4978,7 +4978,10 @@ static int regulator_init_coupling(struc
 	if (!of_check_coupling_data(rdev))
 		return -EPERM;
 
+	mutex_lock(&regulator_list_mutex);
 	rdev->coupling_desc.coupler = regulator_find_coupler(rdev);
+	mutex_unlock(&regulator_list_mutex);
+
 	if (IS_ERR(rdev->coupling_desc.coupler)) {
 		err = PTR_ERR(rdev->coupling_desc.coupler);
 		rdev_err(rdev, "failed to get coupler: %d\n", err);
@@ -5184,9 +5187,7 @@ regulator_register(const struct regulato
 	if (ret < 0)
 		goto wash;
 
-	mutex_lock(&regulator_list_mutex);
 	ret = regulator_init_coupling(rdev);
-	mutex_unlock(&regulator_list_mutex);
 	if (ret < 0)
 		goto wash;
 


