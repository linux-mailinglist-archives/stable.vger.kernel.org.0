Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00C2D328E58
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:31:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241638AbhCAT2S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:28:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:46148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241546AbhCATYE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:24:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8CE0D64F51;
        Mon,  1 Mar 2021 17:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620633;
        bh=kUD3+/tVBT3cHeGgTKkfpsbHif0MmT4Yj89DqJdF1N0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pDw5UgAXS0YdF6qFtPBZMV9w00FK3HYgf6OlyeGBMLEvIfT/97XsViPb8AxL9E2iT
         Q6jW/SqWRdC4rlqijOGvqqsXMzvaEBuSjv7RpiLP1VlipqBF6udOOHgm9z/MTh50nw
         dFhU5szXm2jNXYW3ou5COzmWjdfplQ5DDKoXLsQk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Daniel Scally <djrscally@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 223/775] media: software_node: Fix refcounts in software_node_get_next_child()
Date:   Mon,  1 Mar 2021 17:06:31 +0100
Message-Id: <20210301161212.644334301@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Scally <djrscally@gmail.com>

[ Upstream commit fb5ec981adf08b94e6ce27ca16b7765c94f4513c ]

The software_node_get_next_child() function currently does not hold
references to the child software_node that it finds or put the ref that
is held against the old child - fix that.

Fixes: 59abd83672f7 ("drivers: base: Introducing software nodes to the firmware node framework")
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Daniel Scally <djrscally@gmail.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/swnode.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/base/swnode.c b/drivers/base/swnode.c
index 4a4b2008fbc26..4fcc1a6fb724c 100644
--- a/drivers/base/swnode.c
+++ b/drivers/base/swnode.c
@@ -443,14 +443,18 @@ software_node_get_next_child(const struct fwnode_handle *fwnode,
 	struct swnode *c = to_swnode(child);
 
 	if (!p || list_empty(&p->children) ||
-	    (c && list_is_last(&c->entry, &p->children)))
+	    (c && list_is_last(&c->entry, &p->children))) {
+		fwnode_handle_put(child);
 		return NULL;
+	}
 
 	if (c)
 		c = list_next_entry(c, entry);
 	else
 		c = list_first_entry(&p->children, struct swnode, entry);
-	return &c->fwnode;
+
+	fwnode_handle_put(child);
+	return fwnode_handle_get(&c->fwnode);
 }
 
 static struct fwnode_handle *
-- 
2.27.0



