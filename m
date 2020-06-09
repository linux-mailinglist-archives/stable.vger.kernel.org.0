Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 505CE1F44DB
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 20:09:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388435AbgFISJB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 14:09:01 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:41412 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388172AbgFISF7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Jun 2020 14:05:59 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jiidF-0001oP-0S; Tue, 09 Jun 2020 19:05:53 +0100
Received: from ben by deadeye with local (Exim 4.94)
        (envelope-from <ben@decadent.org.uk>)
        id 1jiidE-006Vus-Bt; Tue, 09 Jun 2020 19:05:52 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Tetsuo Handa" <penguin-kernel@I-love.SAKURA.ne.jp>,
        "Lukas Bulwahn" <lukas.bulwahn@gmail.com>,
        "David Miller" <davem@davemloft.net>,
        "Hulk Robot" <hulkci@huawei.com>,
        "Jouni Hogander" <jouni.hogander@unikie.com>
Date:   Tue, 09 Jun 2020 19:04:00 +0100
Message-ID: <lsq.1591725832.92989072@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 09/61] net-sysfs: Call dev_hold always in
 netdev_queue_add_kobject
In-Reply-To: <lsq.1591725831.850867383@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.85-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Jouni Hogander <jouni.hogander@unikie.com>

commit e0b60903b434a7ee21ba8d8659f207ed84101e89 upstream.

Dev_hold has to be called always in netdev_queue_add_kobject.
Otherwise usage count drops below 0 in case of failure in
kobject_init_and_add.

Fixes: b8eb718348b8 ("net-sysfs: Fix reference count leak in rx|netdev_queue_add_kobject")
Reported-by: Hulk Robot <hulkci@huawei.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: David Miller <davem@davemloft.net>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/core/net-sysfs.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -1143,14 +1143,17 @@ static int netdev_queue_add_kobject(stru
 	struct kobject *kobj = &queue->kobj;
 	int error = 0;
 
+	/* Kobject_put later will trigger netdev_queue_release call
+	 * which decreases dev refcount: Take that reference here
+	 */
+	dev_hold(queue->dev);
+
 	kobj->kset = net->queues_kset;
 	error = kobject_init_and_add(kobj, &netdev_queue_ktype, NULL,
 	    "tx-%u", index);
 	if (error)
 		goto err;
 
-	dev_hold(queue->dev);
-
 #ifdef CONFIG_BQL
 	error = sysfs_create_group(kobj, &dql_group);
 	if (error)

