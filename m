Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E29F4318E39
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 16:24:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230030AbhBKPXZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 10:23:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:52478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230268AbhBKPT5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Feb 2021 10:19:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 569AC64F22;
        Thu, 11 Feb 2021 15:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613055996;
        bh=xAiGLbiCn1pYgkjXtviHEXZeYJA+xkTi4eQyjog8xFE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B2y3tsAgRFAgjlpq9n80HQw/tjoNN3DWESBw6ZDd94XIOpNDjk0WGmobgoXss2uhQ
         wGKAHYGcmRl0ks+BEmmsg+nZ/1FbxyW7PNLea8w2dRBzQ44ji2jxInq8pVG2S5WURf
         287M8e37q2BUbkRUeq6d4q3l/Fc8AdP492PSehbg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, zhengbin <zhengbin13@huawei.com>,
        Jens Axboe <axboe@kernel.dk>,
        Jack Wang <jinpu.wang@cloud.ionos.com>
Subject: [PATCH 4.19 02/24] block: fix NULL pointer dereference in register_disk
Date:   Thu, 11 Feb 2021 16:02:36 +0100
Message-Id: <20210211150147.866158359@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210211150147.743660073@linuxfoundation.org>
References: <20210211150147.743660073@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: zhengbin <zhengbin13@huawei.com>

commit 4d7c1d3fd7c7eda7dea351f071945e843a46c145 upstream.

If __device_add_disk-->bdi_register_owner-->bdi_register-->
bdi_register_va-->device_create_vargs fails, bdi->dev is still
NULL, __device_add_disk-->register_disk will visit bdi->dev->kobj.
This patch fixes that.

Signed-off-by: zhengbin <zhengbin13@huawei.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Jack Wang <jinpu.wang@cloud.ionos.com>
---
 block/genhd.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/block/genhd.c
+++ b/block/genhd.c
@@ -652,10 +652,12 @@ exit:
 		kobject_uevent(&part_to_dev(part)->kobj, KOBJ_ADD);
 	disk_part_iter_exit(&piter);
 
-	err = sysfs_create_link(&ddev->kobj,
-				&disk->queue->backing_dev_info->dev->kobj,
-				"bdi");
-	WARN_ON(err);
+	if (disk->queue->backing_dev_info->dev) {
+		err = sysfs_create_link(&ddev->kobj,
+			  &disk->queue->backing_dev_info->dev->kobj,
+			  "bdi");
+		WARN_ON(err);
+	}
 }
 
 /**


