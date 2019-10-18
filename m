Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12E4CDD40C
	for <lists+stable@lfdr.de>; Sat, 19 Oct 2019 00:23:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729500AbfJRWFW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 18:05:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:37098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729482AbfJRWFS (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Oct 2019 18:05:18 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 647D9222D2;
        Fri, 18 Oct 2019 22:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571436317;
        bh=o8P20wrNaZNXOqJF+YTebFW1ptiMmPp0UsImFpua9LQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hOi6OKOZyAfd3fQ4xIALDojORDcMCOL+lnIB6L0+vYbAVo4atc6LMcq6bi5d32vtB
         pkMjAZOMTzODOeRG0ILTybSJ4IGkc9j78Ts8W+PCqrob/IGCaafawGJeYBT/Ln0JQb
         JO3bv4YPr7tao2DyAte/fAhp0gcZIKDMXZUdrZa8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xiubo Li <xiubli@redhat.com>, Mike Christie <mchristi@redhat.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-block@vger.kernel.org, nbd@other.debian.org
Subject: [PATCH AUTOSEL 5.3 85/89] nbd: fix possible sysfs duplicate warning
Date:   Fri, 18 Oct 2019 18:03:20 -0400
Message-Id: <20191018220324.8165-85-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191018220324.8165-1-sashal@kernel.org>
References: <20191018220324.8165-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

