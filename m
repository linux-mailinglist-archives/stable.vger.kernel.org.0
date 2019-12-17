Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B388A122014
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 01:56:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727281AbfLQAvq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 19:51:46 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35498 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727160AbfLQAvo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Dec 2019 19:51:44 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15N-0003P6-JF; Tue, 17 Dec 2019 00:51:37 +0000
Received: from ben by deadeye with local (Exim 4.93-RC7)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15L-0005eS-4V; Tue, 17 Dec 2019 00:51:35 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Jens Axboe" <axboe@kernel.dk>,
        "Dan Carpenter" <dan.carpenter@oracle.com>
Date:   Tue, 17 Dec 2019 00:47:38 +0000
Message-ID: <lsq.1576543535.970054131@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 124/136] block: drbd: remove a stray unlock in
 __drbd_send_protocol()
In-Reply-To: <lsq.1576543534.33060804@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.80-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 8e9c523016cf9983b295e4bc659183d1fa6ef8e0 upstream.

There are two callers of this function and they both unlock the mutex so
this ends up being a double unlock.

Fixes: 44ed167da748 ("drbd: rcu_read_lock() and rcu_dereference() for tconn->net_conf")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/block/drbd/drbd_main.c | 1 -
 1 file changed, 1 deletion(-)

--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -786,7 +786,6 @@ int __drbd_send_protocol(struct drbd_con
 
 	if (nc->tentative && connection->agreed_pro_version < 92) {
 		rcu_read_unlock();
-		mutex_unlock(&sock->mutex);
 		drbd_err(connection, "--dry-run is not supported by peer");
 		return -EOPNOTSUPP;
 	}

