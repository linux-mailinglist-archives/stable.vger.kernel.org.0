Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08030549173
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:28:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378270AbiFMNlA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:41:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378980AbiFMNjd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:39:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FC62793B7;
        Mon, 13 Jun 2022 04:28:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6138BB80D3A;
        Mon, 13 Jun 2022 11:28:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4475C34114;
        Mon, 13 Jun 2022 11:28:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655119700;
        bh=f9WPULOGIs30Qh+gAi1tpU505UmF8eRJzh//NO3M3Lc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IF1URcVnA4Aq2fEPKmRkDvAHUyhlpbCOPP0fniLwgBD7MHCZY0KvLwKy2TQn9UgM5
         +IQW7qPVoH/KTjiMPbQyvqo/nFc/ayygde2LXiisYdowjLRJ4k8RZH/LOBQcD5x8iE
         t6VoCwrI89H019epkay+UKz95XK/zAGavk92P+48=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Wensheng <zhangwensheng5@huawei.com>,
        Yu Kuai <yukuai3@huawei.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 107/339] nbd: fix possible overflow on first_minor in nbd_dev_add()
Date:   Mon, 13 Jun 2022 12:08:52 +0200
Message-Id: <20220613094929.756746786@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094926.497929857@linuxfoundation.org>
References: <20220613094926.497929857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Wensheng <zhangwensheng5@huawei.com>

[ Upstream commit 858f1bf65d3d9c00b5e2d8ca87dc79ed88267c98 ]

When 'index' is a big numbers, it may become negative which forced
to 'int'. then 'index << part_shift' might overflow to a positive
value that is not greater than '0xfffff', then sysfs might complains
about duplicate creation. Because of this, move the 'index' judgment
to the front will fix it and be better.

Fixes: b0d9111a2d53 ("nbd: use an idr to keep track of nbd devices")
Fixes: 940c264984fd ("nbd: fix possible overflow for 'first_minor' in nbd_dev_add()")
Signed-off-by: Zhang Wensheng <zhangwensheng5@huawei.com>
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Link: https://lore.kernel.org/r/20220521073749.3146892-6-yukuai3@huawei.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/nbd.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index ed678037ba6d..c860a9930855 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -1814,17 +1814,7 @@ static struct nbd_device *nbd_dev_add(int index, unsigned int refs)
 	refcount_set(&nbd->refs, 0);
 	INIT_LIST_HEAD(&nbd->list);
 	disk->major = NBD_MAJOR;
-
-	/* Too big first_minor can cause duplicate creation of
-	 * sysfs files/links, since index << part_shift might overflow, or
-	 * MKDEV() expect that the max bits of first_minor is 20.
-	 */
 	disk->first_minor = index << part_shift;
-	if (disk->first_minor < index || disk->first_minor > MINORMASK) {
-		err = -EINVAL;
-		goto out_free_work;
-	}
-
 	disk->minors = 1 << part_shift;
 	disk->fops = &nbd_fops;
 	disk->private_data = nbd;
@@ -1929,8 +1919,19 @@ static int nbd_genl_connect(struct sk_buff *skb, struct genl_info *info)
 	if (!netlink_capable(skb, CAP_SYS_ADMIN))
 		return -EPERM;
 
-	if (info->attrs[NBD_ATTR_INDEX])
+	if (info->attrs[NBD_ATTR_INDEX]) {
 		index = nla_get_u32(info->attrs[NBD_ATTR_INDEX]);
+
+		/*
+		 * Too big first_minor can cause duplicate creation of
+		 * sysfs files/links, since index << part_shift might overflow, or
+		 * MKDEV() expect that the max bits of first_minor is 20.
+		 */
+		if (index < 0 || index > MINORMASK >> part_shift) {
+			printk(KERN_ERR "nbd: illegal input index %d\n", index);
+			return -EINVAL;
+		}
+	}
 	if (!info->attrs[NBD_ATTR_SOCKETS]) {
 		printk(KERN_ERR "nbd: must specify at least one socket\n");
 		return -EINVAL;
-- 
2.35.1



