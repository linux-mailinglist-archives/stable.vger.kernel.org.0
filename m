Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B5C44F2B7C
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:10:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245445AbiDEIzq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:55:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241234AbiDEIc5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:32:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 818D0D8A;
        Tue,  5 Apr 2022 01:30:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 353C1B81BC5;
        Tue,  5 Apr 2022 08:30:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98B42C385A1;
        Tue,  5 Apr 2022 08:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147410;
        bh=89+pR9PH12ki5m/MYnRkohyxE/wShs8jdpgwEW/JbyQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sFKzmcBbla+jn9uLmKVCyl9ZLwxvWhBqbVrY5b4id80JBkHYfGsW8p80kL8XFkFhW
         So+LFi+kEqkfTuldxXwxvPlFbJZpEgqVfImsUwfQWi9PDxHuI1HfLClyIaEpeI50kz
         x8c4ji5sAxbpiB8eEr5g0WtpN7oFBSr4MClfw8ao=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Wensheng <zhangwensheng5@huawei.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.17 1087/1126] nbd: fix possible overflow on first_minor in nbd_dev_add()
Date:   Tue,  5 Apr 2022 09:30:34 +0200
Message-Id: <20220405070439.356293544@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Wensheng <zhangwensheng5@huawei.com>

commit 6d35d04a9e18990040e87d2bbf72689252669d54 upstream.

When 'index' is a big numbers, it may become negative which forced
to 'int'. then 'index << part_shift' might overflow to a positive
value that is not greater than '0xfffff', then sysfs might complains
about duplicate creation. Because of this, move the 'index' judgment
to the front will fix it and be better.

Fixes: b0d9111a2d53 ("nbd: use an idr to keep track of nbd devices")
Fixes: 940c264984fd ("nbd: fix possible overflow for 'first_minor' in nbd_dev_add()")
Signed-off-by: Zhang Wensheng <zhangwensheng5@huawei.com>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Link: https://lore.kernel.org/r/20220310093224.4002895-1-zhangwensheng5@huawei.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/nbd.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -1800,17 +1800,6 @@ static struct nbd_device *nbd_dev_add(in
 	refcount_set(&nbd->refs, 0);
 	INIT_LIST_HEAD(&nbd->list);
 	disk->major = NBD_MAJOR;
-
-	/* Too big first_minor can cause duplicate creation of
-	 * sysfs files/links, since index << part_shift might overflow, or
-	 * MKDEV() expect that the max bits of first_minor is 20.
-	 */
-	disk->first_minor = index << part_shift;
-	if (disk->first_minor < index || disk->first_minor > MINORMASK) {
-		err = -EINVAL;
-		goto out_free_work;
-	}
-
 	disk->minors = 1 << part_shift;
 	disk->fops = &nbd_fops;
 	disk->private_data = nbd;
@@ -1915,8 +1904,19 @@ static int nbd_genl_connect(struct sk_bu
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


