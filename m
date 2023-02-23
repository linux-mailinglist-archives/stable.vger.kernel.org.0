Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 482066A0991
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 14:08:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233716AbjBWNIH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 08:08:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233920AbjBWNIC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 08:08:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A61C5B8B
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 05:07:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DA1AC616FA
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 13:07:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC7A3C433EF;
        Thu, 23 Feb 2023 13:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677157673;
        bh=DledWV+MFoFCrspI9jfSlBT+lVZ32TzypVojq5oCp0g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DzsL93/gvcLTeDYEjOe331B7YOtyEzpR5rppxeWbGyUHz184Uqs2wo1fvOjShrDZG
         LqcwUNEp66kOvn1Gv0/5ir6mu9cwI35KkZBmmjWN63osKO4hHXxM4znLu7co6ERLFE
         muimxswk43/DZ2Yuo5gWe1jiqX+n5iPgSWUMf0as=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Zhang Wensheng <zhangwensheng5@huawei.com>,
        Yu Kuai <yukuai3@huawei.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Jens Axboe <axboe@kernel.dk>,
        Wen Yang <wenyang.linux@foxmail.com>
Subject: [PATCH 5.10 21/25] nbd: fix possible overflow on first_minor in nbd_dev_add()
Date:   Thu, 23 Feb 2023 14:06:38 +0100
Message-Id: <20230223130427.743152940@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230223130426.817998725@linuxfoundation.org>
References: <20230223130426.817998725@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Wensheng <zhangwensheng5@huawei.com>

commit 858f1bf65d3d9c00b5e2d8ca87dc79ed88267c98 upstream.

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
Signed-off-by: Wen Yang <wenyang.linux@foxmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/nbd.c |   23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -1771,17 +1771,7 @@ static int nbd_dev_add(int index)
 	refcount_set(&nbd->refs, 1);
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
-		goto out_free_idr;
-	}
-
 	disk->fops = &nbd_fops;
 	disk->private_data = nbd;
 	sprintf(disk->disk_name, "nbd%d", index);
@@ -1875,8 +1865,19 @@ static int nbd_genl_connect(struct sk_bu
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


