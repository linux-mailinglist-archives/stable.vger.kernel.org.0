Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37708147B19
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 10:42:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732613AbgAXJkt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:40:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:38258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731622AbgAXJkt (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:40:49 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E1D720709;
        Fri, 24 Jan 2020 09:40:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579858848;
        bh=GTifRHZot2pqSEr0ua7mI7+H9Cxt5UAbIQ03Dk+Jhg8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EbWIKEafcmiwiGGGTd19gfV7t/HFX4vXxs6sl4BoEvKv1givRRXe5MYvqywZPdwce
         fBI75/RrI9FU9k+2nnvucE9TJCP+BLkeHKFhQuwb+qoHUCj9Js+0ynmJSp8WstCbot
         kdSTSwcnr12u6rD2j9k4ljjMCw3v9BNpB/whSTtk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 057/102] software node: Get reference to parent swnode in get_parent op
Date:   Fri, 24 Jan 2020 10:30:58 +0100
Message-Id: <20200124092814.958046246@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092806.004582306@linuxfoundation.org>
References: <20200124092806.004582306@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sakari Ailus <sakari.ailus@linux.intel.com>

[ Upstream commit 51c100a651a471fcb8ead1ecc1224471eb0d61b9 ]

The software_node_get_parent() returned a pointer to the parent swnode,
but did not take a reference to it, leading the caller to put a reference
that was not taken. Take that reference now.

Fixes: 59abd83672f7 ("drivers: base: Introducing software nodes to the firmware node framework")
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/swnode.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/base/swnode.c b/drivers/base/swnode.c
index a1f3f0994f9f9..d5b4905e2adbd 100644
--- a/drivers/base/swnode.c
+++ b/drivers/base/swnode.c
@@ -520,7 +520,10 @@ software_node_get_parent(const struct fwnode_handle *fwnode)
 {
 	struct swnode *swnode = to_swnode(fwnode);
 
-	return swnode ? (swnode->parent ? &swnode->parent->fwnode : NULL) : NULL;
+	if (!swnode || !swnode->parent)
+		return NULL;
+
+	return fwnode_handle_get(&swnode->parent->fwnode);
 }
 
 static struct fwnode_handle *
-- 
2.20.1



