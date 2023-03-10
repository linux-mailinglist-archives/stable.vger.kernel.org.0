Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB49E6B448E
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:25:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232183AbjCJOZ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:25:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231893AbjCJOY6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:24:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0B461814C
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:23:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7AB79B822BA
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:23:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6AC7C433EF;
        Fri, 10 Mar 2023 14:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678458235;
        bh=rorcVIFM7Y99ByvZHfjoSx9Txw7IXsxCBzE/mDJadeM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qOHWFUdQWYaip5hIGQvwFRuqAycZqPP3cyy5w/ir1ridFRC9JBzuQMuH99HG2lNPs
         eXvSzpOH+VMIgWLJFHRFvM8a1YmQQLdJzwzouSqXQA8zBiZHdYYbv/1MQudQsrwI7s
         1PwZnV3CfBPM3/dQvhln41Gn3e7XWT4sosxQ0Icc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhihao Cheng <chengzhihao1@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 209/252] ubi: Fix possible null-ptr-deref in ubi_free_volume()
Date:   Fri, 10 Mar 2023 14:39:39 +0100
Message-Id: <20230310133725.421529303@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.803482157@linuxfoundation.org>
References: <20230310133718.803482157@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit c15859bfd326c10230f09cb48a17f8a35f190342 ]

It willl cause null-ptr-deref in the following case:

uif_init()
  ubi_add_volume()
    cdev_add() -> if it fails, call kill_volumes()
    device_register()

kill_volumes() -> if ubi_add_volume() fails call this function
  ubi_free_volume()
    cdev_del()
    device_unregister() -> trying to delete a not added device,
			   it causes null-ptr-deref

So in ubi_free_volume(), it delete devices whether they are added
or not, it will causes null-ptr-deref.

Handle the error case whlie calling ubi_add_volume() to fix this
problem. If add volume fails, set the corresponding vol to null,
so it can not be accessed in kill_volumes() and release the
resource in ubi_add_volume() error path.

Fixes: 801c135ce73d ("UBI: Unsorted Block Images")
Suggested-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/ubi/build.c |  1 +
 drivers/mtd/ubi/vmt.c   | 12 ++++++------
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/mtd/ubi/build.c b/drivers/mtd/ubi/build.c
index bb3a87cbebf5e..3d0241f8f3ec7 100644
--- a/drivers/mtd/ubi/build.c
+++ b/drivers/mtd/ubi/build.c
@@ -480,6 +480,7 @@ static int uif_init(struct ubi_device *ubi)
 			err = ubi_add_volume(ubi, ubi->volumes[i]);
 			if (err) {
 				ubi_err(ubi, "cannot add volume %d", i);
+				ubi->volumes[i] = NULL;
 				goto out_volumes;
 			}
 		}
diff --git a/drivers/mtd/ubi/vmt.c b/drivers/mtd/ubi/vmt.c
index 405cc5289d89f..c5dec58846ce8 100644
--- a/drivers/mtd/ubi/vmt.c
+++ b/drivers/mtd/ubi/vmt.c
@@ -595,6 +595,7 @@ int ubi_add_volume(struct ubi_device *ubi, struct ubi_volume *vol)
 	if (err) {
 		ubi_err(ubi, "cannot add character device for volume %d, error %d",
 			vol_id, err);
+		vol_release(&vol->dev);
 		return err;
 	}
 
@@ -605,15 +606,14 @@ int ubi_add_volume(struct ubi_device *ubi, struct ubi_volume *vol)
 	vol->dev.groups = volume_dev_groups;
 	dev_set_name(&vol->dev, "%s_%d", ubi->ubi_name, vol->vol_id);
 	err = device_register(&vol->dev);
-	if (err)
-		goto out_cdev;
+	if (err) {
+		cdev_del(&vol->cdev);
+		put_device(&vol->dev);
+		return err;
+	}
 
 	self_check_volumes(ubi);
 	return err;
-
-out_cdev:
-	cdev_del(&vol->cdev);
-	return err;
 }
 
 /**
-- 
2.39.2



