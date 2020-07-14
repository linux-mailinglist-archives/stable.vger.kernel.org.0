Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B21A21FCD1
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 21:12:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729288AbgGNSsQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 14:48:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:43628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729132AbgGNSsQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 14:48:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F091122B2C;
        Tue, 14 Jul 2020 18:48:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594752495;
        bh=HbMB8dhIsKbn9++zvk6mg7FNJbmb/n03UK2o+8Tq7c8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KpMnwaOi1FsxCgyiaCwJCWHyE2vRMr/FGrm5MPDQPdslvpIUChtsipdkkrc/TYMep
         4D8JbeXrTy9HqsHY600t9GzJ/BIcmcFreBgJUrqe8XguVeloaHh58pb04atgJGzM0r
         Ntlh/7rTH9RBLpSWQr3gw74RbPj9dooxJSGnVX1E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+934037347002901b8d2a@syzkaller.appspotmail.com,
        Zheng Bin <zhengbin13@huawei.com>,
        Eric Biggers <ebiggers@google.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 33/58] nbd: Fix memory leak in nbd_add_socket
Date:   Tue, 14 Jul 2020 20:44:06 +0200
Message-Id: <20200714184057.790468799@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714184056.149119318@linuxfoundation.org>
References: <20200714184056.149119318@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zheng Bin <zhengbin13@huawei.com>

[ Upstream commit 579dd91ab3a5446b148e7f179b6596b270dace46 ]

When adding first socket to nbd, if nsock's allocation failed, the data
structure member "config->socks" was reallocated, but the data structure
member "config->num_connections" was not updated. A memory leak will occur
then because the function "nbd_config_put" will free "config->socks" only
when "config->num_connections" is not zero.

Fixes: 03bf73c315ed ("nbd: prevent memory leak")
Reported-by: syzbot+934037347002901b8d2a@syzkaller.appspotmail.com
Signed-off-by: Zheng Bin <zhengbin13@huawei.com>
Reviewed-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/nbd.c | 25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 226103af30f05..d7c7232e438c9 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -974,25 +974,26 @@ static int nbd_add_socket(struct nbd_device *nbd, unsigned long arg,
 	     test_bit(NBD_BOUND, &config->runtime_flags))) {
 		dev_err(disk_to_dev(nbd->disk),
 			"Device being setup by another task");
-		sockfd_put(sock);
-		return -EBUSY;
+		err = -EBUSY;
+		goto put_socket;
+	}
+
+	nsock = kzalloc(sizeof(*nsock), GFP_KERNEL);
+	if (!nsock) {
+		err = -ENOMEM;
+		goto put_socket;
 	}
 
 	socks = krealloc(config->socks, (config->num_connections + 1) *
 			 sizeof(struct nbd_sock *), GFP_KERNEL);
 	if (!socks) {
-		sockfd_put(sock);
-		return -ENOMEM;
+		kfree(nsock);
+		err = -ENOMEM;
+		goto put_socket;
 	}
 
 	config->socks = socks;
 
-	nsock = kzalloc(sizeof(struct nbd_sock), GFP_KERNEL);
-	if (!nsock) {
-		sockfd_put(sock);
-		return -ENOMEM;
-	}
-
 	nsock->fallback_index = -1;
 	nsock->dead = false;
 	mutex_init(&nsock->tx_lock);
@@ -1004,6 +1005,10 @@ static int nbd_add_socket(struct nbd_device *nbd, unsigned long arg,
 	atomic_inc(&config->live_connections);
 
 	return 0;
+
+put_socket:
+	sockfd_put(sock);
+	return err;
 }
 
 static int nbd_reconnect_socket(struct nbd_device *nbd, unsigned long arg)
-- 
2.25.1



