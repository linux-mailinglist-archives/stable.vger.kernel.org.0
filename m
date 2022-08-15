Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EDE75947B3
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:04:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355433AbiHOX4I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:56:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355379AbiHOXwB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:52:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D3C892F57;
        Mon, 15 Aug 2022 13:16:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D2C17B81135;
        Mon, 15 Aug 2022 20:16:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27C7FC433C1;
        Mon, 15 Aug 2022 20:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594602;
        bh=lO8GNSYkrWDx3wny2tetua6wdMrcGQqvkHvBgkQeodM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dsLJPU48c7cTTec7xi5DKqo9T29xDzlhFZi34nwKMgOKURxoDn4sWfRYfBursfFSK
         9k3NfYU07kgzDswU5/AnyZdJKfZPPeVMzAp6PoWBCSbSPOmB3UDRdYuIO53qf++yQt
         puqrqEreKVg5ezG6LGINZFQ4W4fJxlO5wPfSLRRY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0500/1157] media: v4l: async: Also match secondary fwnode endpoints
Date:   Mon, 15 Aug 2022 19:57:36 +0200
Message-Id: <20220815180459.694288420@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sakari Ailus <sakari.ailus@linux.intel.com>

[ Upstream commit 46347e3ec61660562d4a4a933713e2c2b74598e2 ]

For camera sensor devices the firmware information of which comes from
non-DT (or some ACPI variants), the kernel makes the information visible
to the drivers in a form similar to DT. This takes place through device's
secondary fwnodes, in which case also the secondary fwnode needs to be
heterogenously (endpoint vs. device) matched.

Fixes: 1f391df44607 ("media: v4l2-async: Use endpoints in __v4l2_async_nf_add_fwnode_remote()")
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/v4l2-core/v4l2-async.c | 35 +++++++++++++++++-----------
 1 file changed, 21 insertions(+), 14 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
index c6995718237a..b16f3ce8e5ef 100644
--- a/drivers/media/v4l2-core/v4l2-async.c
+++ b/drivers/media/v4l2-core/v4l2-async.c
@@ -66,8 +66,10 @@ static bool match_i2c(struct v4l2_async_notifier *notifier,
 #endif
 }
 
-static bool match_fwnode(struct v4l2_async_notifier *notifier,
-			 struct v4l2_subdev *sd, struct v4l2_async_subdev *asd)
+static bool
+match_fwnode_one(struct v4l2_async_notifier *notifier,
+		 struct v4l2_subdev *sd, struct fwnode_handle *sd_fwnode,
+		 struct v4l2_async_subdev *asd)
 {
 	struct fwnode_handle *other_fwnode;
 	struct fwnode_handle *dev_fwnode;
@@ -80,15 +82,7 @@ static bool match_fwnode(struct v4l2_async_notifier *notifier,
 	 * fwnode or a device fwnode. Start with the simple case of direct
 	 * fwnode matching.
 	 */
-	if (sd->fwnode == asd->match.fwnode)
-		return true;
-
-	/*
-	 * Check the same situation for any possible secondary assigned to the
-	 * subdev's fwnode
-	 */
-	if (!IS_ERR_OR_NULL(sd->fwnode->secondary) &&
-	    sd->fwnode->secondary == asd->match.fwnode)
+	if (sd_fwnode == asd->match.fwnode)
 		return true;
 
 	/*
@@ -99,7 +93,7 @@ static bool match_fwnode(struct v4l2_async_notifier *notifier,
 	 * ACPI. This won't make a difference, as drivers should not try to
 	 * match unconnected endpoints.
 	 */
-	sd_fwnode_is_ep = fwnode_graph_is_endpoint(sd->fwnode);
+	sd_fwnode_is_ep = fwnode_graph_is_endpoint(sd_fwnode);
 	asd_fwnode_is_ep = fwnode_graph_is_endpoint(asd->match.fwnode);
 
 	if (sd_fwnode_is_ep == asd_fwnode_is_ep)
@@ -110,11 +104,11 @@ static bool match_fwnode(struct v4l2_async_notifier *notifier,
 	 * parent of the endpoint fwnode, and compare it with the other fwnode.
 	 */
 	if (sd_fwnode_is_ep) {
-		dev_fwnode = fwnode_graph_get_port_parent(sd->fwnode);
+		dev_fwnode = fwnode_graph_get_port_parent(sd_fwnode);
 		other_fwnode = asd->match.fwnode;
 	} else {
 		dev_fwnode = fwnode_graph_get_port_parent(asd->match.fwnode);
-		other_fwnode = sd->fwnode;
+		other_fwnode = sd_fwnode;
 	}
 
 	fwnode_handle_put(dev_fwnode);
@@ -143,6 +137,19 @@ static bool match_fwnode(struct v4l2_async_notifier *notifier,
 	return true;
 }
 
+static bool match_fwnode(struct v4l2_async_notifier *notifier,
+			 struct v4l2_subdev *sd, struct v4l2_async_subdev *asd)
+{
+	if (match_fwnode_one(notifier, sd, sd->fwnode, asd))
+		return true;
+
+	/* Also check the secondary fwnode. */
+	if (IS_ERR_OR_NULL(sd->fwnode->secondary))
+		return false;
+
+	return match_fwnode_one(notifier, sd, sd->fwnode->secondary, asd);
+}
+
 static LIST_HEAD(subdev_list);
 static LIST_HEAD(notifier_list);
 static DEFINE_MUTEX(list_lock);
-- 
2.35.1



