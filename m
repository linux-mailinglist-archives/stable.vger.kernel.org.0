Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 842DC681021
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:00:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236835AbjA3OAW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:00:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236856AbjA3OAR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:00:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0A071BAEC
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:00:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 48C7361052
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:00:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CC68C4339B;
        Mon, 30 Jan 2023 13:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087199;
        bh=wumQt6sHXmTBKAwGpUBCu7xeJbqjpwXp3m5ZwX7LMiM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YnhKBnMkbDD0kMoNxQX9mW9rdM9SHt96ewYlPLe/gy1+apJz4HbqNfwTGdQ+l44YO
         2Dm3dfzF/wqPaptoqM9MFx+wu3zSxkxKQtfP2atnECgghYIXGeT9mUrVEcJCf0FLV+
         8OBjAMw1GFsvlJ86OyR3eMiE+QiwFD0eFH7pqqnI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>,
        Daniel Scally <djrscally@gmail.com>
Subject: [PATCH 6.1 129/313] device property: fix of node refcount leak in fwnode_graph_get_next_endpoint()
Date:   Mon, 30 Jan 2023 14:49:24 +0100
Message-Id: <20230130134342.667094617@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 39af728649b05e88a2b40e714feeee6451c3f18e ]

The 'parent' returned by fwnode_graph_get_port_parent()
with refcount incremented when 'prev' is not NULL, it
needs be put when finish using it.

Because the parent is const, introduce a new variable to
store the returned fwnode, then put it before returning
from fwnode_graph_get_next_endpoint().

Fixes: b5b41ab6b0c1 ("device property: Check fwnode->secondary in fwnode_graph_get_next_endpoint()")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-and-tested-by: Daniel Scally <djrscally@gmail.com>
Link: https://lore.kernel.org/r/20221123022542.2999510-1-yangyingliang@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/property.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/base/property.c b/drivers/base/property.c
index 2a5a37fcd998..7f338cb4fb7b 100644
--- a/drivers/base/property.c
+++ b/drivers/base/property.c
@@ -989,26 +989,32 @@ struct fwnode_handle *
 fwnode_graph_get_next_endpoint(const struct fwnode_handle *fwnode,
 			       struct fwnode_handle *prev)
 {
+	struct fwnode_handle *ep, *port_parent = NULL;
 	const struct fwnode_handle *parent;
-	struct fwnode_handle *ep;
 
 	/*
 	 * If this function is in a loop and the previous iteration returned
 	 * an endpoint from fwnode->secondary, then we need to use the secondary
 	 * as parent rather than @fwnode.
 	 */
-	if (prev)
-		parent = fwnode_graph_get_port_parent(prev);
-	else
+	if (prev) {
+		port_parent = fwnode_graph_get_port_parent(prev);
+		parent = port_parent;
+	} else {
 		parent = fwnode;
+	}
 	if (IS_ERR_OR_NULL(parent))
 		return NULL;
 
 	ep = fwnode_call_ptr_op(parent, graph_get_next_endpoint, prev);
 	if (ep)
-		return ep;
+		goto out_put_port_parent;
+
+	ep = fwnode_graph_get_next_endpoint(parent->secondary, NULL);
 
-	return fwnode_graph_get_next_endpoint(parent->secondary, NULL);
+out_put_port_parent:
+	fwnode_handle_put(port_parent);
+	return ep;
 }
 EXPORT_SYMBOL_GPL(fwnode_graph_get_next_endpoint);
 
-- 
2.39.0



