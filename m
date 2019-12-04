Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84A181133BD
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 19:19:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728611AbfLDSTL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 13:19:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:36714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731180AbfLDSKC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 13:10:02 -0500
Received: from localhost (unknown [217.68.49.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5953720675;
        Wed,  4 Dec 2019 18:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575483001;
        bh=olpRWpc1GqqmjX4xtToiGs6SgZGZO9jL77wfwEn4XNs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UiXfuUTSaRPC+h2zYk1kDkAK2L8QdxcuH5pxKBO5r2QA+u7KqF/kww3aGZu+g6G3w
         1sBYI5Be3jOfYQfYTqBMeZBT+QOtYDQMTEjKZAcafy+2KxmbtZBcw+5+zADUUNZxoq
         ArW9SNxMe4Cf/n+OpVusGn4iSHG9g8YaJ3821268=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 012/125] block: drbd: remove a stray unlock in __drbd_send_protocol()
Date:   Wed,  4 Dec 2019 18:55:17 +0100
Message-Id: <20191204175314.961180636@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191204175308.377746305@linuxfoundation.org>
References: <20191204175308.377746305@linuxfoundation.org>
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
index 83482721bc012..f5c24459fc5c1 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -793,7 +793,6 @@ int __drbd_send_protocol(struct drbd_connection *connection, enum drbd_packet cm
 
 	if (nc->tentative && connection->agreed_pro_version < 92) {
 		rcu_read_unlock();
-		mutex_unlock(&sock->mutex);
 		drbd_err(connection, "--dry-run is not supported by peer");
 		return -EOPNOTSUPP;
 	}
-- 
2.20.1



