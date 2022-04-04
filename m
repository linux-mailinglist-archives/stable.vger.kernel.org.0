Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB6CB4F12D8
	for <lists+stable@lfdr.de>; Mon,  4 Apr 2022 12:13:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240890AbiDDKP2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Apr 2022 06:15:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244282AbiDDKP2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Apr 2022 06:15:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26C56D9F
        for <stable@vger.kernel.org>; Mon,  4 Apr 2022 03:13:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B9F0B614E2
        for <stable@vger.kernel.org>; Mon,  4 Apr 2022 10:13:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEFA4C2BBE4;
        Mon,  4 Apr 2022 10:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649067211;
        bh=ht9X7swWPVbhO0CX++MyDmSLGK1uFIJXcjq02xgdfKE=;
        h=Subject:To:Cc:From:Date:From;
        b=MsD4p3z/EkN8rbfJJiw7707Kw6ZyXVm1bfvDh66HaXLJc5cSXbdgg+JYlFpEItV4z
         vKpwhLoI+OJOOA3v7AOfM8uqnH9xkH/jXCxOY6AvqbCaLiIwHq0wULf0MHKcEd8/6N
         9HChswdtKTBdXFAyy80xxzT/9JK+sHwQxlLIDDBU=
Subject: FAILED: patch "[PATCH] nbd: fix possible overflow on 'first_minor' in nbd_dev_add()" failed to apply to 5.15-stable tree
To:     zhangwensheng5@huawei.com, axboe@kernel.dk, josef@toxicpanda.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 04 Apr 2022 12:13:28 +0200
Message-ID: <1649067208247118@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 6d35d04a9e18990040e87d2bbf72689252669d54 Mon Sep 17 00:00:00 2001
From: Zhang Wensheng <zhangwensheng5@huawei.com>
Date: Thu, 10 Mar 2022 17:32:24 +0800
Subject: [PATCH] nbd: fix possible overflow on 'first_minor' in nbd_dev_add()

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

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 5a1f98494ddd..b3cdfc0ffb98 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -1800,17 +1800,6 @@ static struct nbd_device *nbd_dev_add(int index, unsigned int refs)
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
@@ -1915,8 +1904,19 @@ static int nbd_genl_connect(struct sk_buff *skb, struct genl_info *info)
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

