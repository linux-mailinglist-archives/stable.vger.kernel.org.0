Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8589BD2499
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 11:00:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389562AbfJJIr4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 04:47:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:54020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389557AbfJJIrz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:47:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6C746218AC;
        Thu, 10 Oct 2019 08:47:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570697274;
        bh=ncORTQ1kXiPJ1Jmsvk7yXBPI49kGK5AYSv8Z5rGFzJQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CJTSBrLW2q9aqONzQBZZ4LvW98BitXJYOThBobD0pOv4S96yvGsvcpJrl5VDXjgOT
         rOle5Viq1GE/Q73uV5Q4rJk+fX8VPutbYNlDxqWhHsmCbqYSBt2KZMsvNPZHD2Qa+K
         iRfKwioeF+Mn8KAbypNPYeYe03Dq8okepXuenXaE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        Xiubo Li <xiubli@redhat.com>,
        Mike Christie <mchristi@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 080/114] nbd: fix crash when the blksize is zero
Date:   Thu, 10 Oct 2019 10:36:27 +0200
Message-Id: <20191010083612.222117801@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010083544.711104709@linuxfoundation.org>
References: <20191010083544.711104709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

[ Upstream commit 553768d1169a48c0cd87c4eb4ab57534ee663415 ]

This will allow the blksize to be set zero and then use 1024 as
default.

Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Xiubo Li <xiubli@redhat.com>
[fix to use goto out instead of return in genl_connect]
Signed-off-by: Mike Christie <mchristi@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/nbd.c | 23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 21f54c7946a0e..bc2fa4e85f0ca 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -133,6 +133,8 @@ static struct dentry *nbd_dbg_dir;
 
 #define NBD_MAGIC 0x68797548
 
+#define NBD_DEF_BLKSIZE 1024
+
 static unsigned int nbds_max = 16;
 static int max_part = 16;
 static int part_shift;
@@ -1241,6 +1243,14 @@ static void nbd_clear_sock_ioctl(struct nbd_device *nbd,
 		nbd_config_put(nbd);
 }
 
+static bool nbd_is_valid_blksize(unsigned long blksize)
+{
+	if (!blksize || !is_power_of_2(blksize) || blksize < 512 ||
+	    blksize > PAGE_SIZE)
+		return false;
+	return true;
+}
+
 /* Must be called with config_lock held */
 static int __nbd_ioctl(struct block_device *bdev, struct nbd_device *nbd,
 		       unsigned int cmd, unsigned long arg)
@@ -1256,8 +1266,9 @@ static int __nbd_ioctl(struct block_device *bdev, struct nbd_device *nbd,
 	case NBD_SET_SOCK:
 		return nbd_add_socket(nbd, arg, false);
 	case NBD_SET_BLKSIZE:
-		if (!arg || !is_power_of_2(arg) || arg < 512 ||
-		    arg > PAGE_SIZE)
+		if (!arg)
+			arg = NBD_DEF_BLKSIZE;
+		if (!nbd_is_valid_blksize(arg))
 			return -EINVAL;
 		nbd_size_set(nbd, arg,
 			     div_s64(config->bytesize, arg));
@@ -1337,7 +1348,7 @@ static struct nbd_config *nbd_alloc_config(void)
 	atomic_set(&config->recv_threads, 0);
 	init_waitqueue_head(&config->recv_wq);
 	init_waitqueue_head(&config->conn_wait);
-	config->blksize = 1024;
+	config->blksize = NBD_DEF_BLKSIZE;
 	atomic_set(&config->live_connections, 0);
 	try_module_get(THIS_MODULE);
 	return config;
@@ -1773,6 +1784,12 @@ static int nbd_genl_connect(struct sk_buff *skb, struct genl_info *info)
 	if (info->attrs[NBD_ATTR_BLOCK_SIZE_BYTES]) {
 		u64 bsize =
 			nla_get_u64(info->attrs[NBD_ATTR_BLOCK_SIZE_BYTES]);
+		if (!bsize)
+			bsize = NBD_DEF_BLKSIZE;
+		if (!nbd_is_valid_blksize(bsize)) {
+			ret = -EINVAL;
+			goto out;
+		}
 		nbd_size_set(nbd, bsize, div64_u64(config->bytesize, bsize));
 	}
 	if (info->attrs[NBD_ATTR_TIMEOUT]) {
-- 
2.20.1



