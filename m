Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88BA610BBD8
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:17:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387543AbfK0VO3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:14:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:48292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387540AbfK0VO3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:14:29 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 42B6E2086A;
        Wed, 27 Nov 2019 21:14:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574889268;
        bh=tiZo7yfmOeXm6N5umuvy8LgJchgg6d+v0cQPRTP5Mw0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XsTIscrFnVErhEDgSYW2h9bGgIY8EeHBC661/YqF9LJj1RDuR6jDmfgd24kJwhsR3
         hvb5fwboFUyjBflT6JG9ZHFGGDmUFM27nMtYgPhrGtODzYKtWOXkp4C6Rat0jHzeQz
         evKZ5OQK/WVd9c06UgLaWZQOSckZG5zUuqfaqyjs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.4 12/66] nbd: prevent memory leak
Date:   Wed, 27 Nov 2019 21:32:07 +0100
Message-Id: <20191127202647.736404180@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127202632.536277063@linuxfoundation.org>
References: <20191127202632.536277063@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Navid Emamdoost <navid.emamdoost@gmail.com>

commit 03bf73c315edca28f47451913177e14cd040a216 upstream.

In nbd_add_socket when krealloc succeeds, if nsock's allocation fail the
reallocted memory is leak. The correct behaviour should be assigning the
reallocted memory to config->socks right after success.

Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/block/nbd.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -1032,14 +1032,15 @@ static int nbd_add_socket(struct nbd_dev
 		sockfd_put(sock);
 		return -ENOMEM;
 	}
+
+	config->socks = socks;
+
 	nsock = kzalloc(sizeof(struct nbd_sock), GFP_KERNEL);
 	if (!nsock) {
 		sockfd_put(sock);
 		return -ENOMEM;
 	}
 
-	config->socks = socks;
-
 	nsock->fallback_index = -1;
 	nsock->dead = false;
 	mutex_init(&nsock->tx_lock);


