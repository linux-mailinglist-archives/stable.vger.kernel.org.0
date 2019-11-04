Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10C0AEEE68
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:14:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389699AbfKDWH2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 17:07:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:39928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389476AbfKDWH1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 17:07:27 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A0072084D;
        Mon,  4 Nov 2019 22:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572905246;
        bh=o8P20wrNaZNXOqJF+YTebFW1ptiMmPp0UsImFpua9LQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uvQKfs9vczTwIDyAmhZmVkzvKI6wRw76+FWsT2WfeXlTtqm+c3sTkjoow47HbhrkL
         wusXtAYNHLghAAmZwSAFtKWwrKNnHhC6oXLKiuFRD8oPHVeqNbZ8oQSCkOl6E4OaGH
         bJlz5WXC+Fdgnzbk0STyq5MZ5maskytgjc3K7fkw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mike Christie <mchristi@redhat.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Xiubo Li <xiubli@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 078/163] nbd: fix possible sysfs duplicate warning
Date:   Mon,  4 Nov 2019 22:44:28 +0100
Message-Id: <20191104212145.976797456@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212140.046021995@linuxfoundation.org>
References: <20191104212140.046021995@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

[ Upstream commit 862488105b84ca744b3d8ff131e0fcfe10644be1 ]

1. nbd_put takes the mutex and drops nbd->ref to 0. It then does
idr_remove and drops the mutex.

2. nbd_genl_connect takes the mutex. idr_find/idr_for_each fails
to find an existing device, so it does nbd_dev_add.

3. just before the nbd_put could call nbd_dev_remove or not finished
totally, but if nbd_dev_add try to add_disk, we can hit:

debugfs: Directory 'nbd1' with parent 'block' already present!

This patch will make sure all the disk add/remove stuff are done
by holding the nbd_index_mutex lock.

Reported-by: Mike Christie <mchristi@redhat.com>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/nbd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 0b727f7432f9e..bd164192045b0 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -230,8 +230,8 @@ static void nbd_put(struct nbd_device *nbd)
 	if (refcount_dec_and_mutex_lock(&nbd->refs,
 					&nbd_index_mutex)) {
 		idr_remove(&nbd_index_idr, nbd->index);
-		mutex_unlock(&nbd_index_mutex);
 		nbd_dev_remove(nbd);
+		mutex_unlock(&nbd_index_mutex);
 	}
 }
 
-- 
2.20.1



