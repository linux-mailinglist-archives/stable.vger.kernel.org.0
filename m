Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D1DD26B5EA
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 01:54:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727076AbgIOXyP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 19:54:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:42304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727058AbgIOObg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:31:36 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DB55F22283;
        Tue, 15 Sep 2020 14:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600179811;
        bh=D1+ttNOK59FJzK0a2yk/yaQDgkVZ7N+WPE3n1+X5Vrw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WUCWsVKci0OcTYLKSSGq0+/jh/PdtrEwHlJrrMkovFMHVq8z8lgllvnSGwgEAVhvm
         R5LGLry49iyLDBMfu+quFAs1Zk6zM1yym9ZWz+z8KIzK8U9ujX7ZBqW4bihmHvWkY2
         Cgiw+uIFquVLZjnggNAJbXIIqXYSHqYv7y3k7Ewo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.4 098/132] regulator: push allocation in set_consumer_device_supply() out of lock
Date:   Tue, 15 Sep 2020 16:13:20 +0200
Message-Id: <20200915140649.059032776@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140644.037604909@linuxfoundation.org>
References: <20200915140644.037604909@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michał Mirosław <mirq-linux@rere.qmqm.pl>

commit 5c06540165d443c6455123eb48e7f1a9b618ab34 upstream.

Pull regulator_list_mutex into set_consumer_device_supply() and keep
allocations outside of it. Fourth of the fs_reclaim deadlock case.

Fixes: 45389c47526d ("regulator: core: Add early supply resolution for regulators")
Signed-off-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/f0380bdb3d60aeefa9693c4e234d2dcda7e56747.1597195321.git.mirq-linux@rere.qmqm.pl
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/regulator/core.c |   46 ++++++++++++++++++++++++++--------------------
 1 file changed, 26 insertions(+), 20 deletions(-)

--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1456,7 +1456,7 @@ static int set_consumer_device_supply(st
 				      const char *consumer_dev_name,
 				      const char *supply)
 {
-	struct regulator_map *node;
+	struct regulator_map *node, *new_node;
 	int has_dev;
 
 	if (supply == NULL)
@@ -1467,6 +1467,22 @@ static int set_consumer_device_supply(st
 	else
 		has_dev = 0;
 
+	new_node = kzalloc(sizeof(struct regulator_map), GFP_KERNEL);
+	if (new_node == NULL)
+		return -ENOMEM;
+
+	new_node->regulator = rdev;
+	new_node->supply = supply;
+
+	if (has_dev) {
+		new_node->dev_name = kstrdup(consumer_dev_name, GFP_KERNEL);
+		if (new_node->dev_name == NULL) {
+			kfree(new_node);
+			return -ENOMEM;
+		}
+	}
+
+	mutex_lock(&regulator_list_mutex);
 	list_for_each_entry(node, &regulator_map_list, list) {
 		if (node->dev_name && consumer_dev_name) {
 			if (strcmp(node->dev_name, consumer_dev_name) != 0)
@@ -1484,26 +1500,19 @@ static int set_consumer_device_supply(st
 			 node->regulator->desc->name,
 			 supply,
 			 dev_name(&rdev->dev), rdev_get_name(rdev));
-		return -EBUSY;
+		goto fail;
 	}
 
-	node = kzalloc(sizeof(struct regulator_map), GFP_KERNEL);
-	if (node == NULL)
-		return -ENOMEM;
-
-	node->regulator = rdev;
-	node->supply = supply;
-
-	if (has_dev) {
-		node->dev_name = kstrdup(consumer_dev_name, GFP_KERNEL);
-		if (node->dev_name == NULL) {
-			kfree(node);
-			return -ENOMEM;
-		}
-	}
+	list_add(&new_node->list, &regulator_map_list);
+	mutex_unlock(&regulator_list_mutex);
 
-	list_add(&node->list, &regulator_map_list);
 	return 0;
+
+fail:
+	mutex_unlock(&regulator_list_mutex);
+	kfree(new_node->dev_name);
+	kfree(new_node);
+	return -EBUSY;
 }
 
 static void unset_regulator_supplies(struct regulator_dev *rdev)
@@ -5167,19 +5176,16 @@ regulator_register(const struct regulato
 
 	/* add consumers devices */
 	if (init_data) {
-		mutex_lock(&regulator_list_mutex);
 		for (i = 0; i < init_data->num_consumer_supplies; i++) {
 			ret = set_consumer_device_supply(rdev,
 				init_data->consumer_supplies[i].dev_name,
 				init_data->consumer_supplies[i].supply);
 			if (ret < 0) {
-				mutex_unlock(&regulator_list_mutex);
 				dev_err(dev, "Failed to set supply %s\n",
 					init_data->consumer_supplies[i].supply);
 				goto unset_supplies;
 			}
 		}
-		mutex_unlock(&regulator_list_mutex);
 	}
 
 	if (!rdev->desc->ops->get_voltage &&


