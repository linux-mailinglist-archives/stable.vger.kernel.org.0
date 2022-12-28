Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3A44657D82
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:44:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233983AbiL1Pn4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:43:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233982AbiL1Pnw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:43:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 738C817437
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:43:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AE69AB81729
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:43:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21FE2C433D2;
        Wed, 28 Dec 2022 15:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672242222;
        bh=QLQrOk/rUplvZ08j7gxCLQixWSeoLkiiQGJVzptBF/0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JkVC+2FIeFGP816YFl1Yx1tzN6+icPyYhzMMRY0HQ5VKIAyPSPbQYrZoXM+UuPrFG
         rntax+yHDyj/ygnoXDAg4oVnc5pUvjjnssdSyTqrJ7HK/12mdFgddqGeUDeGbKR6vg
         THKlUCbALCDWkAsF7lh8QNx38h/Mbls0G3vXFbyc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yu Kuai <yukuai3@huawei.com>,
        Mike Snitzer <snitzer@kernel.org>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0343/1146] dm: make sure create and remove dm device wont race with open and close table
Date:   Wed, 28 Dec 2022 15:31:22 +0100
Message-Id: <20221228144339.476150340@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit d563792c8933a810d28ce0f2831f0726c2b15a31 ]

open_table_device() and close_table_device() is protected by
table_devices_lock, hence use it to protect add_disk() and
del_gendisk().

Prepare to track per-add_disk holder relations in dm.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Mike Snitzer <snitzer@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20221115141054.1051801-6-yukuai1@huaweicloud.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 1a581b721699 ("dm: track per-add_disk holder relations in DM")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 8fb0b97b2df1..f10ac680cef4 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1965,7 +1965,14 @@ static void cleanup_mapped_device(struct mapped_device *md)
 		spin_unlock(&_minor_lock);
 		if (dm_get_md_type(md) != DM_TYPE_NONE) {
 			dm_sysfs_exit(md);
+
+			/*
+			 * Hold lock to make sure del_gendisk() won't concurrent
+			 * with open/close_table_device().
+			 */
+			mutex_lock(&md->table_devices_lock);
 			del_gendisk(md->disk);
+			mutex_unlock(&md->table_devices_lock);
 		}
 		dm_queue_destroy_crypto_profile(md->queue);
 		put_disk(md->disk);
@@ -2325,15 +2332,24 @@ int dm_setup_md_queue(struct mapped_device *md, struct dm_table *t)
 	if (r)
 		return r;
 
+	/*
+	 * Hold lock to make sure add_disk() and del_gendisk() won't concurrent
+	 * with open_table_device() and close_table_device().
+	 */
+	mutex_lock(&md->table_devices_lock);
 	r = add_disk(md->disk);
+	mutex_unlock(&md->table_devices_lock);
 	if (r)
 		return r;
 
 	r = dm_sysfs_init(md);
 	if (r) {
+		mutex_lock(&md->table_devices_lock);
 		del_gendisk(md->disk);
+		mutex_unlock(&md->table_devices_lock);
 		return r;
 	}
+
 	md->type = type;
 	return 0;
 }
-- 
2.35.1



