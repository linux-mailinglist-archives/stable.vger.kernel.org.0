Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17CFB4F3257
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:56:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356217AbiDEKXa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:23:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235451AbiDEJah (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:30:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B258E540B;
        Tue,  5 Apr 2022 02:17:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6A830B80DA1;
        Tue,  5 Apr 2022 09:17:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF260C385A0;
        Tue,  5 Apr 2022 09:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649150254;
        bh=hkzJKH+9ntGpKLU8MpszvUYKaLGgVtdAemBPeotoG9c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0N1wQOGXpA8HR8aqqgBoGIJ0oCobM0S8YOlFV1spklCz1mxr6GsqDxsYPXkAVfjnP
         BIyT5H6azdAY0mFFdxRcpZSyfl8knmAYPMlRlF6Tod7UCpoeQtkLmY7KeEF96Z7R9K
         kd9BsRVIyGCosPB0/rFOFN5vUdwDJZf4ruftBIdM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Gabriel L. Somlo" <somlo@cmu.edu>,
        Borislav Petkov <bp@alien8.de>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.16 1010/1017] Revert "nbd: fix possible overflow on first_minor in nbd_dev_add()"
Date:   Tue,  5 Apr 2022 09:32:03 +0200
Message-Id: <20220405070424.178136408@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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

From: Jens Axboe <axboe@kernel.dk>

commit 7198bfc2017644c6b92d2ecef9b8b8e0363bb5fd upstream.

This reverts commit 6d35d04a9e18990040e87d2bbf72689252669d54.

Both Gabriel and Borislav report that this commit casues a regression
with nbd:

sysfs: cannot create duplicate filename '/dev/block/43:0'

Revert it before 5.18-rc1 and we'll investigage this separately in
due time.

Link: https://lore.kernel.org/all/YkiJTnFOt9bTv6A2@zn.tnic/
Reported-by: Gabriel L. Somlo <somlo@cmu.edu>
Reported-by: Borislav Petkov <bp@alien8.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/nbd.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -1800,6 +1800,17 @@ static struct nbd_device *nbd_dev_add(in
 	refcount_set(&nbd->refs, 0);
 	INIT_LIST_HEAD(&nbd->list);
 	disk->major = NBD_MAJOR;
+
+	/* Too big first_minor can cause duplicate creation of
+	 * sysfs files/links, since index << part_shift might overflow, or
+	 * MKDEV() expect that the max bits of first_minor is 20.
+	 */
+	disk->first_minor = index << part_shift;
+	if (disk->first_minor < index || disk->first_minor > MINORMASK) {
+		err = -EINVAL;
+		goto out_free_work;
+	}
+
 	disk->minors = 1 << part_shift;
 	disk->fops = &nbd_fops;
 	disk->private_data = nbd;
@@ -1904,19 +1915,8 @@ static int nbd_genl_connect(struct sk_bu
 	if (!netlink_capable(skb, CAP_SYS_ADMIN))
 		return -EPERM;
 
-	if (info->attrs[NBD_ATTR_INDEX]) {
+	if (info->attrs[NBD_ATTR_INDEX])
 		index = nla_get_u32(info->attrs[NBD_ATTR_INDEX]);
-
-		/*
-		 * Too big first_minor can cause duplicate creation of
-		 * sysfs files/links, since index << part_shift might overflow, or
-		 * MKDEV() expect that the max bits of first_minor is 20.
-		 */
-		if (index < 0 || index > MINORMASK >> part_shift) {
-			printk(KERN_ERR "nbd: illegal input index %d\n", index);
-			return -EINVAL;
-		}
-	}
 	if (!info->attrs[NBD_ATTR_SOCKETS]) {
 		printk(KERN_ERR "nbd: must specify at least one socket\n");
 		return -EINVAL;


