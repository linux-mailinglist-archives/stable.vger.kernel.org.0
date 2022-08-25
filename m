Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEF255A1B3B
	for <lists+stable@lfdr.de>; Thu, 25 Aug 2022 23:39:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243869AbiHYVjN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Aug 2022 17:39:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243874AbiHYVjL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Aug 2022 17:39:11 -0400
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D0ACC2281;
        Thu, 25 Aug 2022 14:39:09 -0700 (PDT)
Received: by mail-pl1-f182.google.com with SMTP id w2so1260971pld.0;
        Thu, 25 Aug 2022 14:39:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=/Q/uS8GwCxdU7Nza7iEXgsPKHajLn69NKbXTdP6aZp4=;
        b=boAreIpsbh27GE16yEr2Tdt8z/eB6cwC7+W98QaIZCs9tjHEQv+WQx+W3ri0LB7d1D
         su8yao4cPDJ548ATI4XacHEw2kY/HQOk+WbiMu8aIuX1c1XD9w6PvEM7a87sqbBzsKB4
         fA42ZtSrLqbY7msN3ppeCK4K5c7CIt9TwKgAsDCME240hh3FQDKbgQEXjc0QIKIXwkZp
         JF/agLH5VVZYaBfv9yw42o53jtuxgTv/Kg/FHeOp32NTeqYu/9jVO6YtzNRLZW9pX2zP
         DT/Es5fD+5DYWe6Lnh2BPhaJsDWjnbRmRWGrmvoEYIHK/g6H5V5J/Jv4UTxBo+FVrohH
         kg6Q==
X-Gm-Message-State: ACgBeo3OXkYi3AqEx+h05YlZlyeOUtRympgLVw9iaJB43omv/mebuEIl
        gjfmI+g7iQ+YrgyWY1ZCkA1h5+xauiw=
X-Google-Smtp-Source: AA6agR4Mmlr+yIr2P0CBBQJP31VwCbS1NFgXnPtLO/2bQ4MMNIUJOYCTzfll7+w1y7qKMQOviKjhMA==
X-Received: by 2002:a17:90b:3e8d:b0:1fa:facf:672f with SMTP id rj13-20020a17090b3e8d00b001fafacf672fmr1086730pjb.0.1661463549043;
        Thu, 25 Aug 2022 14:39:09 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:349c:3078:d005:5a7e])
        by smtp.gmail.com with ESMTPSA id n27-20020aa7985b000000b005379e480445sm111676pfq.94.2022.08.25.14.39.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Aug 2022 14:39:08 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Leon Romanovsky <leonro@mellanox.com>, linux-rdma@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>, stable@vger.kernel.org
Subject: [PATCH 2/4] RDMA/srp: Remove the srp_host.released completion
Date:   Thu, 25 Aug 2022 14:38:58 -0700
Message-Id: <20220825213900.864587-3-bvanassche@acm.org>
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

Move the kfree(host) calls into srp_release_dev(). Convert a
device_unregister() call into a device_del() and a device_put() call.
Remove the host->released completion object. This patch prepares for
handling dev_set_name() failure in srp_add_port().

Cc: stable@vger.kernel.org
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 14 +++++---------
 drivers/infiniband/ulp/srp/ib_srp.h |  1 -
 2 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 8fd6a88f7a9c..1d3a15e63732 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -3178,7 +3178,7 @@ static void srp_release_dev(struct device *dev)
 	struct srp_host *host =
 		container_of(dev, struct srp_host, dev);
 
-	complete(&host->released);
+	kfree(host);
 }
 
 static struct class srp_class = {
@@ -3898,7 +3898,6 @@ static struct srp_host *srp_add_port(struct srp_device *device, u8 port)
 
 	INIT_LIST_HEAD(&host->target_list);
 	spin_lock_init(&host->target_lock);
-	init_completion(&host->released);
 	mutex_init(&host->add_target_mutex);
 	host->srp_dev = device;
 	host->port = port;
@@ -3922,8 +3921,6 @@ static struct srp_host *srp_add_port(struct srp_device *device, u8 port)
 put_host:
 	device_del(&host->dev);
 	put_device(&host->dev);
-	kfree(host);
-
 	return NULL;
 }
 
@@ -4029,12 +4026,11 @@ static void srp_remove_one(struct ib_device *device, void *client_data)
 	srp_dev = client_data;
 
 	list_for_each_entry_safe(host, tmp_host, &srp_dev->dev_list, list) {
-		device_unregister(&host->dev);
 		/*
-		 * Wait for the sysfs entry to go away, so that no new
-		 * target ports can be created.
+		 * Remove the add_target sysfs entry so that no new target ports
+		 * can be created.
 		 */
-		wait_for_completion(&host->released);
+		device_del(&host->dev);
 
 		/*
 		 * Remove all target ports.
@@ -4052,7 +4048,7 @@ static void srp_remove_one(struct ib_device *device, void *client_data)
 		 */
 		flush_workqueue(srp_remove_wq);
 
-		kfree(host);
+		put_device(&host->dev);
 	}
 
 	ib_dealloc_pd(srp_dev->pd);
diff --git a/drivers/infiniband/ulp/srp/ib_srp.h b/drivers/infiniband/ulp/srp/ib_srp.h
index 55a575e2cace..493e7fd1913e 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.h
+++ b/drivers/infiniband/ulp/srp/ib_srp.h
@@ -124,7 +124,6 @@ struct srp_host {
 	struct device		dev;
 	struct list_head	target_list;
 	spinlock_t		target_lock;
-	struct completion	released;
 	struct list_head	list;
 	struct mutex		add_target_mutex;
 };
