Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECCD688E6F
	for <lists+stable@lfdr.de>; Sat, 10 Aug 2019 22:55:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727755AbfHJUyh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Aug 2019 16:54:37 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:53794 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726477AbfHJUns (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Aug 2019 16:43:48 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDK-00053h-4F; Sat, 10 Aug 2019 21:43:46 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDJ-0003Zl-9Z; Sat, 10 Aug 2019 21:43:45 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Hulk Robot" <hulkci@huawei.com>,
        "YueHaibing" <yuehaibing@huawei.com>,
        "David S. Miller" <davem@davemloft.net>
Date:   Sat, 10 Aug 2019 21:40:07 +0100
Message-ID: <lsq.1565469607.156035753@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 029/157] net-sysfs: call dev_hold if kobject_init_and_add
 success
In-Reply-To: <lsq.1565469607.188083258@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.72-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: YueHaibing <yuehaibing@huawei.com>

commit a3e23f719f5c4a38ffb3d30c8d7632a4ed8ccd9e upstream.

In netdev_queue_add_kobject and rx_queue_add_kobject,
if sysfs_create_group failed, kobject_put will call
netdev_queue_release to decrease dev refcont, however
dev_hold has not be called. So we will see this while
unregistering dev:

unregister_netdevice: waiting for bcsh0 to become free. Usage count = -1

Reported-by: Hulk Robot <hulkci@huawei.com>
Fixes: d0d668371679 ("net: don't decrement kobj reference count on init failure")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/core/net-sysfs.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -788,6 +788,8 @@ static int rx_queue_add_kobject(struct n
 	if (error)
 		return error;
 
+	dev_hold(queue->dev);
+
 	if (net->sysfs_rx_queue_group) {
 		error = sysfs_create_group(kobj, net->sysfs_rx_queue_group);
 		if (error) {
@@ -797,7 +799,6 @@ static int rx_queue_add_kobject(struct n
 	}
 
 	kobject_uevent(kobj, KOBJ_ADD);
-	dev_hold(queue->dev);
 
 	return error;
 }
@@ -1146,6 +1147,8 @@ static int netdev_queue_add_kobject(stru
 	if (error)
 		return error;
 
+	dev_hold(queue->dev);
+
 #ifdef CONFIG_BQL
 	error = sysfs_create_group(kobj, &dql_group);
 	if (error) {
@@ -1155,7 +1158,6 @@ static int netdev_queue_add_kobject(stru
 #endif
 
 	kobject_uevent(kobj, KOBJ_ADD);
-	dev_hold(queue->dev);
 
 	return 0;
 }

