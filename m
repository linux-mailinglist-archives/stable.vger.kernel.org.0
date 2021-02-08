Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69D54313629
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:07:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231754AbhBHPGw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:06:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232753AbhBHPFJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Feb 2021 10:05:09 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B18AC061788
        for <stable@vger.kernel.org>; Mon,  8 Feb 2021 07:04:29 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id c6so18527511ede.0
        for <stable@vger.kernel.org>; Mon, 08 Feb 2021 07:04:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Od4EK2yVIIkurXebLowbqftTipY7/kgNJZJogZrgQvQ=;
        b=gkWsleFufxbYGB31Xpuu3Ew0nmDJL2dPT1dQQHXNVjmAkTGyrTUsWEHNSK5wfRM0Mh
         o3nJ5HrA+GWWMRG2sNpRNYzhlqrOgnFub2loCMYIxgIutz5mUKnWLbcn+AwQhQJO/oHz
         ibrkjJzcY+ljr4aT7cid5A5ds1gDEwlYvDnhWCnwG5elg8BtD/C6G5ng+UuoJz7pvysc
         BxkmcmqUbveDsv5YKnWlq0IxW5gGWJ4aF0/3a4YFzgJKI+BwhFsvZ4vFyq7IGe93FEby
         RVjkIotPjo5moHFMo49X4sUUmmsRtDCD16HRhNv7zrIVddbr7BfQbIToMk/F8uGBq9T5
         W58A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Od4EK2yVIIkurXebLowbqftTipY7/kgNJZJogZrgQvQ=;
        b=Eq+hOWXYeePTdui0CnigGQZCfutXXNdR/p+ybD94CgW47JBv5kOXlhkZXdYU4kuJB8
         sNEG1qF0n8gbp2793hmZZFVzCepzql1ENqM1DaeCSYo8WPkrrtYuOYzHjzrBEIg70JKy
         6Ra1qcNvBV4MwPOOkwV0LrjFhMlThvQvWyVxwVNJqTDDHl01MuaoTN4zeod98O3FtaL3
         Rp5n9mKwa6XIRecKdjbBhxMY1T5P5EUy276S3nD6b4Uj1N0pUtVlL+FOO8D9TiGgfhVo
         U/QBWEQlOjaX1fdvlHVCIaZhtwTbBZEBSODPwL8piWcqd8Xz/fg0nsbgNyLHqxqDvpGQ
         k84w==
X-Gm-Message-State: AOAM533TcFy26iOUZv5awY1V2iThke5vpdf0rJo+6M+ChPCjXzCbsp4m
        88t1RQcfQCW8rdg/ydNNZiAZLg==
X-Google-Smtp-Source: ABdhPJwWlt27fiCNOFgDFZNVVmnLRQYaoTdbsi115S0r+YDG7ugxftMDPK/WsB4QYCu2e0rMPdHn6A==
X-Received: by 2002:a05:6402:b27:: with SMTP id bo7mr17358079edb.372.1612796668173;
        Mon, 08 Feb 2021 07:04:28 -0800 (PST)
Received: from jwang-Latitude-5491.fkb.profitbricks.net ([2001:16b8:4980:d900:bc0f:acd:c20a:c261])
        by smtp.gmail.com with ESMTPSA id kb25sm4359106ejc.19.2021.02.08.07.04.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Feb 2021 07:04:27 -0800 (PST)
From:   Jack Wang <jinpu.wang@cloud.ionos.com>
To:     gregkh@linuxfoundation.org, sashal@kernel.org, axboe@kernel.dk,
        stable@vger.kernel.org
Cc:     zhengbin <zhengbin13@huawei.com>
Subject: [stable-4.19 Resend 1/7] block: fix NULL pointer dereference in register_disk
Date:   Mon,  8 Feb 2021 16:04:20 +0100
Message-Id: <20210208150426.62755-2-jinpu.wang@cloud.ionos.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210208150426.62755-1-jinpu.wang@cloud.ionos.com>
References: <20210208150426.62755-1-jinpu.wang@cloud.ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: zhengbin <zhengbin13@huawei.com>

If __device_add_disk-->bdi_register_owner-->bdi_register-->
bdi_register_va-->device_create_vargs fails, bdi->dev is still
NULL, __device_add_disk-->register_disk will visit bdi->dev->kobj.
This patch fixes that.

Signed-off-by: zhengbin <zhengbin13@huawei.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
(cherry picked from commit 4d7c1d3fd7c7eda7dea351f071945e843a46c145)
Signed-off-by: Jack Wang <jinpu.wang@cloud.ionos.com>
---
 block/genhd.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 2b536ab570ac..6965dde96373 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -652,10 +652,12 @@ static void register_disk(struct device *parent, struct gendisk *disk)
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
-- 
2.25.1

