Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18BAD226476
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 17:45:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729678AbgGTPpS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 11:45:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:39586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730498AbgGTPpR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:45:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1D2F820773;
        Mon, 20 Jul 2020 15:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595259916;
        bh=baWO5rVjBPThrb1OlfN7ms8T0GJW+Kh/YpfW3Pae/JU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RcJ47KbjqGMr2EqUjlLJdjQbHZgDKrljjQGLY86K93/OIeMqf8C18qwBixRkG5t1C
         60N9CyI3dHn+h8IGWVp2+eJ3p2/c+kQm7bsQem+1vcNqJZhHmHH6+jct+0PbPd3wEq
         WmZuWBaVbxXSiEaAG/uMttr7tdMYRjgJuQgwVLv0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+934037347002901b8d2a@syzkaller.appspotmail.com,
        Zheng Bin <zhengbin13@huawei.com>,
        Eric Biggers <ebiggers@google.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 022/125] nbd: Fix memory leak in nbd_add_socket
Date:   Mon, 20 Jul 2020 17:36:01 +0200
Message-Id: <20200720152804.065584760@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152802.929969555@linuxfoundation.org>
References: <20200720152802.929969555@linuxfoundation.org>
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
index 8f56e6b2f114f..f22fad977c913 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -960,25 +960,26 @@ static int nbd_add_socket(struct nbd_device *nbd, unsigned long arg,
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
@@ -990,6 +991,10 @@ static int nbd_add_socket(struct nbd_device *nbd, unsigned long arg,
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



