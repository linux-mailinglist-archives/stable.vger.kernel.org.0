Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B57C111F88
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:10:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728238AbfLCXKF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 18:10:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:58314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728755AbfLCWnD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:43:03 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD47420684;
        Tue,  3 Dec 2019 22:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575412983;
        bh=X86Vrv6PGSZskU4BlGggirNMOdnUzV9a7k70PO/RSQw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ysS6ZqwziLLsFuIg20Pk7xzUrvya/ldfhilKXwpdAXZ19Np7rB979tqTVO9IUEyq+
         tIloASziXbRxRcRQMIRmGfoNj1mxNVqdHO2F74L1w1QK2ag9KYcIPbeSj0TbPB5xOo
         zZsP7H3ifMW1MkBhyWj+aTNFxV0ZwgxBH63H6BGc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 092/135] block: drbd: remove a stray unlock in __drbd_send_protocol()
Date:   Tue,  3 Dec 2019 23:35:32 +0100
Message-Id: <20191203213036.714906816@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203213005.828543156@linuxfoundation.org>
References: <20191203213005.828543156@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 8e9c523016cf9983b295e4bc659183d1fa6ef8e0 ]

There are two callers of this function and they both unlock the mutex so
this ends up being a double unlock.

Fixes: 44ed167da748 ("drbd: rcu_read_lock() and rcu_dereference() for tconn->net_conf")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/drbd/drbd_main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 5b248763a6724..a18155cdce416 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -786,7 +786,6 @@ int __drbd_send_protocol(struct drbd_connection *connection, enum drbd_packet cm
 
 	if (nc->tentative && connection->agreed_pro_version < 92) {
 		rcu_read_unlock();
-		mutex_unlock(&sock->mutex);
 		drbd_err(connection, "--dry-run is not supported by peer");
 		return -EOPNOTSUPP;
 	}
-- 
2.20.1



