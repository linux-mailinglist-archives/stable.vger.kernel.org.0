Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56E3337C8C7
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:43:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234469AbhELQMx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:12:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:36540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239092AbhELQHS (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:07:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EB54861C3E;
        Wed, 12 May 2021 15:36:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833769;
        bh=MgLKc5qxT4w9qK9k/Sa2RTrE3GT1zxTEWOFe2KkatKU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mfv2xsa83mYlH6oA8hgwhHmWewOznFSV80eDf5F5rR3LvpJ74w3u//9zZjj0Fk9/v
         tLJ2JGgjVb1R9JJo9u1xnzozAKJX/VxOktvV06zkbJ1tOpdKz8PPI0N8Abl4ZNMpzw
         mKP2sxex9wAu42JZpIiMdTSUQLAptcPn6V5JDPfU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 281/601] node: fix device cleanups in error handling code
Date:   Wed, 12 May 2021 16:45:58 +0200
Message-Id: <20210512144837.071037067@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 4ce535ec0084f0d712317cb99d383cad3288e713 ]

We can't use kfree() to free device managed resources so the kfree(dev)
is against the rules.

It's easier to write this code if we open code the device_register() as
a device_initialize() and device_add().  That way if dev_set_name() set
name fails we can call put_device() and it will clean up correctly.

Fixes: acc02a109b04 ("node: Add memory-side caching attributes")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/YHA0JUra+F64+NpB@mwanda
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/node.c | 26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

diff --git a/drivers/base/node.c b/drivers/base/node.c
index 04f71c7bc3f8..ec4bc09c2997 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -268,21 +268,20 @@ static void node_init_cache_dev(struct node *node)
 	if (!dev)
 		return;
 
+	device_initialize(dev);
 	dev->parent = &node->dev;
 	dev->release = node_cache_release;
 	if (dev_set_name(dev, "memory_side_cache"))
-		goto free_dev;
+		goto put_device;
 
-	if (device_register(dev))
-		goto free_name;
+	if (device_add(dev))
+		goto put_device;
 
 	pm_runtime_no_callbacks(dev);
 	node->cache_dev = dev;
 	return;
-free_name:
-	kfree_const(dev->kobj.name);
-free_dev:
-	kfree(dev);
+put_device:
+	put_device(dev);
 }
 
 /**
@@ -319,25 +318,24 @@ void node_add_cache(unsigned int nid, struct node_cache_attrs *cache_attrs)
 		return;
 
 	dev = &info->dev;
+	device_initialize(dev);
 	dev->parent = node->cache_dev;
 	dev->release = node_cacheinfo_release;
 	dev->groups = cache_groups;
 	if (dev_set_name(dev, "index%d", cache_attrs->level))
-		goto free_cache;
+		goto put_device;
 
 	info->cache_attrs = *cache_attrs;
-	if (device_register(dev)) {
+	if (device_add(dev)) {
 		dev_warn(&node->dev, "failed to add cache level:%d\n",
 			 cache_attrs->level);
-		goto free_name;
+		goto put_device;
 	}
 	pm_runtime_no_callbacks(dev);
 	list_add_tail(&info->node, &node->cache_attrs);
 	return;
-free_name:
-	kfree_const(dev->kobj.name);
-free_cache:
-	kfree(info);
+put_device:
+	put_device(dev);
 }
 
 static void node_remove_caches(struct node *node)
-- 
2.30.2



