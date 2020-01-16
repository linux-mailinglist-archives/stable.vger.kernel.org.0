Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73AA313E0F8
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 17:46:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728963AbgAPQqG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 11:46:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:55172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729393AbgAPQqE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:46:04 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 25B8D207FF;
        Thu, 16 Jan 2020 16:45:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193163;
        bh=UamV5Q8Q8gJKB4pMHysaybJwmbtlpHw38APEO/EgeAQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0uzog9AxH+uvpMrUR+2aSBMDUykpkTOLQyStFBqJN3Or4SFVGiwzLiMvEgnx7qqmi
         WG9IBAceWHtMgWwpVs3gD6pjfuHw6r5IgxhgqgQcEksBHPASro78GUK3+ZjvkkzKat
         +maiafMlLQIcWI+bUogZiHELunqYVnWq0a7LCGtc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sakari Ailus <sakari.ailus@linux.intel.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 037/205] software node: Get reference to parent swnode in get_parent op
Date:   Thu, 16 Jan 2020 11:40:12 -0500
Message-Id: <20200116164300.6705-37-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116164300.6705-1-sashal@kernel.org>
References: <20200116164300.6705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index a1f3f0994f9f..d5b4905e2adb 100644
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

