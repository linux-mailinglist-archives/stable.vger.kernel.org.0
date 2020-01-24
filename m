Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8247147BAC
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 10:46:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732393AbgAXJnR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:43:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:41060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732782AbgAXJnL (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:43:11 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6936020718;
        Fri, 24 Jan 2020 09:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579858991;
        bh=L2/UCNUEjW1SJywoJR6qxa6utPFIVwzjkPHb8D76B3U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u0eQTmHl+vx+hurWQ96tpRUOljLCNEM+ETvBkonqwy5SQzG5HvkIMIVW6N82ahSvc
         l9UhfBQEIzMlhkesR4nB3gHa1RpVS4DJt/6ueqg31m7UHL0lZbiKx6u/3+ZYpOEoaZ
         Y30xItoAkse2EDRRVAHKKFriBxpM0IPBn5I4bBqk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        David Miller <davem@davemloft.net>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 099/102] net-sysfs: Call dev_hold always in netdev_queue_add_kobject
Date:   Fri, 24 Jan 2020 10:31:40 +0100
Message-Id: <20200124092821.671503824@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092806.004582306@linuxfoundation.org>
References: <20200124092806.004582306@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jouni Hogander <jouni.hogander@unikie.com>

[ Upstream commit e0b60903b434a7ee21ba8d8659f207ed84101e89 ]

Dev_hold has to be called always in netdev_queue_add_kobject.
Otherwise usage count drops below 0 in case of failure in
kobject_init_and_add.

Fixes: b8eb718348b8 ("net-sysfs: Fix reference count leak in rx|netdev_queue_add_kobject")
Reported-by: Hulk Robot <hulkci@huawei.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: David Miller <davem@davemloft.net>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/net-sysfs.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index b4db68e5caa9a..4c826b8bf9b1e 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -1462,14 +1462,17 @@ static int netdev_queue_add_kobject(struct net_device *dev, int index)
 	struct kobject *kobj = &queue->kobj;
 	int error = 0;
 
+	/* Kobject_put later will trigger netdev_queue_release call
+	 * which decreases dev refcount: Take that reference here
+	 */
+	dev_hold(queue->dev);
+
 	kobj->kset = dev->queues_kset;
 	error = kobject_init_and_add(kobj, &netdev_queue_ktype, NULL,
 				     "tx-%u", index);
 	if (error)
 		goto err;
 
-	dev_hold(queue->dev);
-
 #ifdef CONFIG_BQL
 	error = sysfs_create_group(kobj, &dql_group);
 	if (error)
-- 
2.20.1



