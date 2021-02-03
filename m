Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBF9830DAF9
	for <lists+stable@lfdr.de>; Wed,  3 Feb 2021 14:22:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231493AbhBCNVH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Feb 2021 08:21:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231488AbhBCNVF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Feb 2021 08:21:05 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78DA1C0613D6
        for <stable@vger.kernel.org>; Wed,  3 Feb 2021 05:20:25 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id c4so21539027wru.9
        for <stable@vger.kernel.org>; Wed, 03 Feb 2021 05:20:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Od4EK2yVIIkurXebLowbqftTipY7/kgNJZJogZrgQvQ=;
        b=Sjf5GlQNY1QkFhYOckMecV3FmqsRIYAFGfeVgRKIG/OoivLdo1rCyF07/AJmmohZY+
         MKbHyrDktKZlxo0ycYetMdy4/Aj6zeaOv+NkJJj8XfWy0CUP4rNTHbVUouX/xeIQx1lk
         9A0MScMEbgJUrsgGM5uNoRWxqdQJ/G7jAhIMdyd5LNQ9HcO8EQB0kmm6Sc4H370RXw7r
         tx5vMtuT2bgrP4aZTppQ5/xwHOp62yihD8gh/sHOaxfcuclinm7jJ6N37xn7tXWC81cn
         Cajx7Xx6q6i9q0ocFoN/mbxtu/jMYukCuz66EHwTHNzujfyG7NeyvyAZWZOQIS/DO+ie
         /5RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Od4EK2yVIIkurXebLowbqftTipY7/kgNJZJogZrgQvQ=;
        b=eWcx8n3MpRl8UqMSYKO+WnZN2I0LwCpItHMQfIFgHdBYNPPK0unYqkSMTNoa+FL8x9
         LcgGH2sxZQ/lNZgPYwX+ROQaJlU8zCny5xGUgY3P030MOTT82MUfx6YR+hnQU8zbo2ew
         m8UtAfY+ZKS7CNtXMKam0+ctiBE4LZqTfBpMj/VrtULaky++Fs1EuKtlc0nnfwYzq8Gf
         vPNgMaWix2N1rwyZPGJkiTFCvzjAk1uX5DR3aYs/rU5j/2EJhO/bVTr6+QRngReYkvxz
         9CwtgQsKNw+W+x7Oc7QZz9d6qVi0w1ktWyY39yXqkKXZ3BJ6OrX6FLr/J2UepxALO0sY
         G3uQ==
X-Gm-Message-State: AOAM531nXvDjLIYqcA/5S6hR0TpWeqHpB2e/J2FpsX0iO7kCrrNF+TZ3
        E1pFufHvivXX2R+lvpsB9CNZ0up6bMQr7Q==
X-Google-Smtp-Source: ABdhPJxEv8Hb+n7xGjimcxlgQepVL4lqiOf2Hz6h/HZ988L7BcMKjam5+5nDlfdlarLuhAhjj/I2Jw==
X-Received: by 2002:adf:dd0d:: with SMTP id a13mr3514589wrm.143.1612358424285;
        Wed, 03 Feb 2021 05:20:24 -0800 (PST)
Received: from jwang-Latitude-5491.fritz.box ([2001:16b8:4947:3c00:7cf4:7472:391:9d0d])
        by smtp.gmail.com with ESMTPSA id d10sm3738430wrn.88.2021.02.03.05.20.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Feb 2021 05:20:23 -0800 (PST)
From:   Jack Wang <jinpu.wang@cloud.ionos.com>
To:     gregkh@linuxfoundation.org, sashal@kernel.org,
        stable@vger.kernel.org
Cc:     zhengbin <zhengbin13@huawei.com>, Jens Axboe <axboe@kernel.dk>
Subject: [stable-4.19 1/8] block: fix NULL pointer dereference in register_disk
Date:   Wed,  3 Feb 2021 14:20:15 +0100
Message-Id: <20210203132022.92406-2-jinpu.wang@cloud.ionos.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210203132022.92406-1-jinpu.wang@cloud.ionos.com>
References: <20210203132022.92406-1-jinpu.wang@cloud.ionos.com>
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

