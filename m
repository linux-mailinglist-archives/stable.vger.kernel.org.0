Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C82F2192FA6
	for <lists+stable@lfdr.de>; Wed, 25 Mar 2020 18:44:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727856AbgCYRoa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Mar 2020 13:44:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:60892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727843AbgCYRoa (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 25 Mar 2020 13:44:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 67F8A20777;
        Wed, 25 Mar 2020 17:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585158269;
        bh=mISHSjoMsIZ+fxJ0QKRj3gwZ7fgFWGgkHXQgCsKxo5o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=I3Ea4zUMbkESFEf7+hBBwqkHO8YVxddfJ+/IOi7LkWOVyoD2XzKkGj1dI4WIp1DHA
         z5aM03RnyzWLZbNJGadWBpM/DM4TtqaGKfS0z2DQjZt/QuJ/7+d3hQpN8xz8pcvCc3
         sR5dtKZkddb26d7cszp/nMnrd8Pn3mkn0yzeRZL4=
Date:   Wed, 25 Mar 2020 18:44:27 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Re: Linux 5.5.13
Message-ID: <20200325174427.GB3764758@kroah.com>
References: <20200325174421.GA3764758@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200325174421.GA3764758@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index d962fe0f26ce..d1574c99f83c 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 5
-SUBLEVEL = 12
+SUBLEVEL = 13
 EXTRAVERSION =
 NAME = Kleptomaniac Octopus
 
diff --git a/drivers/base/core.c b/drivers/base/core.c
index 3306d5ae92a6..dbb0f9130f42 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -718,6 +718,8 @@ static void __device_links_queue_sync_state(struct device *dev,
 {
 	struct device_link *link;
 
+	if (!dev_has_sync_state(dev))
+		return;
 	if (dev->state_synced)
 		return;
 
@@ -819,7 +821,7 @@ late_initcall(sync_state_resume_initcall);
 
 static void __device_links_supplier_defer_sync(struct device *sup)
 {
-	if (list_empty(&sup->links.defer_sync))
+	if (list_empty(&sup->links.defer_sync) && dev_has_sync_state(sup))
 		list_add_tail(&sup->links.defer_sync, &deferred_sync);
 }
 
diff --git a/include/linux/device.h b/include/linux/device.h
index 96ff76731e93..50d97767d8d6 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -1522,6 +1522,17 @@ static inline struct device_node *dev_of_node(struct device *dev)
 
 void driver_init(void);
 
+static inline bool dev_has_sync_state(struct device *dev)
+{
+	if (!dev)
+		return false;
+	if (dev->driver && dev->driver->sync_state)
+		return true;
+	if (dev->bus && dev->bus->sync_state)
+		return true;
+	return false;
+}
+
 /*
  * High level routines for use by the bus drivers
  */
