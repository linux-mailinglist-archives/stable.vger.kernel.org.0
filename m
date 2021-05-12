Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F28C37CB79
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:57:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242737AbhELQfh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:35:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:42866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241272AbhELQ07 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:26:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 39908619C6;
        Wed, 12 May 2021 15:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834666;
        bh=llp0Bgg9/jChzZe4pGkpuJQ9rTUhUQO4yDgMc/PuRss=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ELsCbzqHFMVp/IX62m+Y1jzaA4RnMNlmHfeKi92aewxcP5t/EH9XV+rsJt3bbOFEE
         CWNXxoYBaGJXHR8vyd8F7nZPJDNwIbE4qbfQrVoz3PJNLJC105LkVTO79YjW4J45DM
         Q1ROPnQ1rJUpi29m14Bzbd4XK1kx8giWPd8FXytQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 5.12 006/677] software node: Allow node addition to already existing device
Date:   Wed, 12 May 2021 16:40:52 +0200
Message-Id: <20210512144837.429620295@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heikki Krogerus <heikki.krogerus@linux.intel.com>

commit b622b24519f5b008f6d4e20e5675eaffa8fbd87b upstream.

If the node is added to an already exiting device, the node
needs to be also linked to the device separately.

This will make sure the reference count is kept in balance
also when the node is injected to a device afterwards.

Fixes: e68d0119e328 ("software node: Introduce device_add_software_node()")
Reported-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210414075438.64547-1-heikki.krogerus@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/swnode.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/base/swnode.c
+++ b/drivers/base/swnode.c
@@ -1032,6 +1032,7 @@ int device_add_software_node(struct devi
 	}
 
 	set_secondary_fwnode(dev, &swnode->fwnode);
+	software_node_notify(dev, KOBJ_ADD);
 
 	return 0;
 }
@@ -1105,8 +1106,8 @@ int software_node_notify(struct device *
 
 	switch (action) {
 	case KOBJ_ADD:
-		ret = sysfs_create_link(&dev->kobj, &swnode->kobj,
-					"software_node");
+		ret = sysfs_create_link_nowarn(&dev->kobj, &swnode->kobj,
+					       "software_node");
 		if (ret)
 			break;
 


