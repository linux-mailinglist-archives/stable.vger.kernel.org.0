Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1FB2564689
	for <lists+stable@lfdr.de>; Sun,  3 Jul 2022 11:57:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231658AbiGCJ5Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 3 Jul 2022 05:57:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbiGCJ5Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 3 Jul 2022 05:57:24 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52CD7958D;
        Sun,  3 Jul 2022 02:57:22 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id d2so11778395ejy.1;
        Sun, 03 Jul 2022 02:57:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/C/3kmvKdwcy11chQHgeLWo3vKWTC13H+vJEKZUg6aQ=;
        b=gBAkdTMLRxz7uh4sx7BVV/ieaiZ2UurFW8df0aRzdrmm+6mymLplAIGLfLrkf7mAc/
         +J3dXmRTlXNfz6Cwxl7B66XZHKinkj6ENi4e1jJtq4P8KeLeh2jVvAK5+4rzzQA3Ual+
         y68Upda7iibOz+Z5akchFLLJTTiF3a5Aq1D0rEYDJqiJU4v4GUZtffoS+95U/+V9ScFN
         7s8KL9bV9rjSg0ye4a09cSf59E698eISK3j0+4S6kxZMKT9W1GzT+QCQT8O0JfWD+hQn
         3yonRCNrZSOki5V9DgbM49GOB4gBskyGajTrLE2xg1+qdSs9ZrIRSu/wr0SKpmH4Gjjr
         LZdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/C/3kmvKdwcy11chQHgeLWo3vKWTC13H+vJEKZUg6aQ=;
        b=GZ0ivRBTp1nrGnqmWXO3ogcYLicvejQPFZeNpQNZhHp+h0B0zxVX6pgRJA3m1+nHkd
         YNKb1/XE/9pPlfBzd8RGh8J5eNHwqDIHEK3Fg0Bf7QcSOyBQA9lf1mA70XxK3neF9FCF
         ZMVfdAH4qYevak1VzO+Wm9Ps1Yhx3143jhxO4BT/VnZqxanyUqHiWJh3D7sTb8HXiaNb
         ZXyER98EtYP2A/KYr1eEpacq5J/Bxh4U57znl4N3IGdJrIkWYqOPwKVjzxf3A3LyOirU
         ZaOnflSCNc6+U/zgZVq02oE/9QULomU9x3qmvvmFAG8m6qZeXJ1LREryKZd3m6pduQ3/
         pmGA==
X-Gm-Message-State: AJIora8F2+hwjjf4ex29yGiuM5N+oQlmuQz2vxfGWtCeZ8gkFASDoC6A
        UUxcwQVlJO7lOJRMy4IkW9w=
X-Google-Smtp-Source: AGRyM1sH6Rrxv1tF4lmThvYcgtG1sG3EVo7pQGOczrqcukLwu4ZUnCWj9eopFnPQEYP42FfYurzk/A==
X-Received: by 2002:a17:907:a421:b0:726:ee5f:718a with SMTP id sg33-20020a170907a42100b00726ee5f718amr22866229ejc.368.1656842240662;
        Sun, 03 Jul 2022 02:57:20 -0700 (PDT)
Received: from localhost.localdomain (93-42-70-190.ip85.fastwebnet.it. [93.42.70.190])
        by smtp.googlemail.com with ESMTPSA id m7-20020a056402050700b004356c0d7436sm18455030edv.42.2022.07.03.02.57.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Jul 2022 02:57:20 -0700 (PDT)
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Christian Marangi <ansuelsmth@gmail.com>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     kernel test robot <oliver.sang@intel.com>, stable@vger.kernel.org
Subject: [PATCH] mtd: core: fix NULL pointer dereference with mtd_check_of_node
Date:   Sun,  3 Jul 2022 11:56:31 +0200
Message-Id: <20220703095631.16508-1-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Actually check if mtd dev have a parent to fix NULL pointer dereference
kernel panic in mtd_check_of_node.

Reported-by: kernel test robot <oliver.sang@intel.com>
Fixes: ad9b10d1eaad ("mtd: core: introduce of support for dynamic partitions")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 drivers/mtd/mtdcore.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/mtdcore.c b/drivers/mtd/mtdcore.c
index 6fafea80fd98..48a357fcf2ed 100644
--- a/drivers/mtd/mtdcore.c
+++ b/drivers/mtd/mtdcore.c
@@ -558,8 +558,12 @@ static void mtd_check_of_node(struct mtd_info *mtd)
 	if (dev_of_node(&mtd->dev))
 		return;
 
-	/* Check if a partitions node exist */
+	/* Make sure we have a parent */
 	parent = mtd->parent;
+	if (!parent)
+		return;
+
+	/* Check if a partitions node exist */
 	parent_dn = dev_of_node(&parent->dev);
 	if (!parent_dn)
 		return;
-- 
2.36.1

