Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F7B626B75D
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 02:22:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726860AbgIPAUq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 20:20:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:37098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726870AbgIOOVg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:21:36 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C258622264;
        Tue, 15 Sep 2020 14:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600179436;
        bh=JCN+z4P1uefTgGQWZHueo4+UFFSOUFLmxaYwH9BMxcw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bZPTTSNy3pMN3xXEzNEdW9LMB5xfz7wQB84DDs1OwtAuHwycu1YZmDJS/3eh4BOCM
         ndk8p0NgC0oRlck6G2hkDrXi984QX1cEOZTWUYI/qGue2Q2tsfW+rz79MsHRClbmiR
         zK0wJb36jblhWOPOcFnt3v2WqF0cYcerqFkPcWhM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 4.19 58/78] regulator: push allocation in set_consumer_device_supply() out of lock
Date:   Tue, 15 Sep 2020 16:13:23 +0200
Message-Id: <20200915140636.480295884@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140633.552502750@linuxfoundation.org>
References: <20200915140633.552502750@linuxfoundation.org>
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
@@ -1257,7 +1257,7 @@ static int set_consumer_device_supply(st
 				      const char *consumer_dev_name,
 				      const char *supply)
 {
-	struct regulator_map *node;
+	struct regulator_map *node, *new_node;
 	int has_dev;
 
 	if (supply == NULL)
@@ -1268,6 +1268,22 @@ static int set_consumer_device_supply(st
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
@@ -1285,26 +1301,19 @@ static int set_consumer_device_supply(st
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
@@ -4375,19 +4384,16 @@ regulator_register(const struct regulato
 
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


