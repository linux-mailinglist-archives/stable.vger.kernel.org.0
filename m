Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 438B65A1B3A
	for <lists+stable@lfdr.de>; Thu, 25 Aug 2022 23:39:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243882AbiHYVjL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Aug 2022 17:39:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243860AbiHYVjK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Aug 2022 17:39:10 -0400
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31BDAC12F2;
        Thu, 25 Aug 2022 14:39:08 -0700 (PDT)
Received: by mail-pg1-f170.google.com with SMTP id v4so18971217pgi.10;
        Thu, 25 Aug 2022 14:39:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=P6eG2fgSnszX6mm7Oj+kln5CQ0vjnqN/f0OMZD3yboY=;
        b=S0yD4qMNXUFcolohocFOM+Ra9VWr/2CFc/RxyIkQJufDcsp5UO5Gv5tDY6PqhmliRL
         vH2UdYrAEpWQ5JaOwPOibDZFhg3rUMV2ArxDG0XAty0s22z/ei4RI/IKuyEJZzP91VjO
         RTDnuScmkTjTgWAd1EiYijs6UGZNtX/WzGHFkDNeWrZ6jJa+FO/Nl4/oQbDOHruxGhNS
         xCaUHfQwpOgbqY4TIu4ugGH07QQOZPugIn2c/jvP5ufU25Ow84uh2WcrjXb9FFzliX+n
         +zPpzrGzoHoDuUBZ4494oP3IZg/3F3cSwcf/WZ9oqfclL/EHYCdec+a7C0pki3O4pxAw
         YThw==
X-Gm-Message-State: ACgBeo2/WP3AoW8mXl/2bV48pXtticYIXxEmdY/CMPYaqFr5JthdMY2h
        /yxR3B9nTd6Xgjru8wg2VRs=
X-Google-Smtp-Source: AA6agR63e/VVzO6XU+/GXv61MDMVPrw7uJyouu+s99OvGjLX7hAz0BSyG5aH5qlqOw/Oa8Kytc+Z/A==
X-Received: by 2002:aa7:80d0:0:b0:52d:f9c6:bb14 with SMTP id a16-20020aa780d0000000b0052df9c6bb14mr992306pfn.57.1661463547210;
        Thu, 25 Aug 2022 14:39:07 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:349c:3078:d005:5a7e])
        by smtp.gmail.com with ESMTPSA id n27-20020aa7985b000000b005379e480445sm111676pfq.94.2022.08.25.14.39.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Aug 2022 14:39:06 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Leon Romanovsky <leonro@mellanox.com>, linux-rdma@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>, stable@vger.kernel.org
Subject: [PATCH 1/4] RDMA/srp: Rework the srp_add_port() error path
Date:   Thu, 25 Aug 2022 14:38:57 -0700
Message-Id: <20220825213900.864587-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
In-Reply-To: <20220825213900.864587-1-bvanassche@acm.org>
References: <20220825213900.864587-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

device_register() always calls device_initialize() so calling device_del()
is safe even if device_register() fails. Implement the following advice
from the comment block above device_register(): "NOTE: _Never_ directly free
@dev after calling this function, even if it returned an error! Always use
put_device() to give up the reference initialized in this function instead."
Keep the kfree() call in the error path since srp_release_dev() does not
free the host.

Cc: stable@vger.kernel.org
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 7720ea270ed8..8fd6a88f7a9c 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -3909,20 +3909,19 @@ static struct srp_host *srp_add_port(struct srp_device *device, u8 port)
 		     port);
 
 	if (device_register(&host->dev))
-		goto free_host;
+		goto put_host;
 	if (device_create_file(&host->dev, &dev_attr_add_target))
-		goto err_class;
+		goto put_host;
 	if (device_create_file(&host->dev, &dev_attr_ibdev))
-		goto err_class;
+		goto put_host;
 	if (device_create_file(&host->dev, &dev_attr_port))
-		goto err_class;
+		goto put_host;
 
 	return host;
 
-err_class:
-	device_unregister(&host->dev);
-
-free_host:
+put_host:
+	device_del(&host->dev);
+	put_device(&host->dev);
 	kfree(host);
 
 	return NULL;
