Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF26649732D
	for <lists+stable@lfdr.de>; Sun, 23 Jan 2022 17:49:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234142AbiAWQtR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Jan 2022 11:49:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238903AbiAWQtP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Jan 2022 11:49:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C02AC06173B
        for <stable@vger.kernel.org>; Sun, 23 Jan 2022 08:49:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 52712B80DBF
        for <stable@vger.kernel.org>; Sun, 23 Jan 2022 16:49:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BD24C340E4;
        Sun, 23 Jan 2022 16:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642956553;
        bh=Jpxf+F31p8/MFU051yMYMLSxh1yQfKTgHcMJNxvHVaQ=;
        h=Subject:To:Cc:From:Date:From;
        b=B+FIXiZolOwY8FGxOzm2QsLlSZytqyd09Z88lx92wSdOu1KfU+vHwBVrrdQuZPFdk
         3vvVIwAWKpqmcxbCX1tVO4vOcCMG68lR6kRsrJcV0yrCK5DO8zA6WD7ACdk+74uAmC
         4JOvfD9rpED3mBX9ceUWOvveCG78PE0uzP0NF0OY=
Subject: FAILED: patch "[PATCH] device property: Fix fwnode_graph_devcon_match() fwnode leak" failed to apply to 5.4-stable tree
To:     sakari.ailus@linux.intel.com, andriy.shevchenko@linux.intel.com,
        rafael.j.wysocki@intel.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 23 Jan 2022 17:49:10 +0100
Message-ID: <164295655014840@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 4a7f4110f79163fd53ea65438041994ed615e3af Mon Sep 17 00:00:00 2001
From: Sakari Ailus <sakari.ailus@linux.intel.com>
Date: Wed, 1 Dec 2021 14:59:29 +0200
Subject: [PATCH] device property: Fix fwnode_graph_devcon_match() fwnode leak

For each endpoint it encounters, fwnode_graph_devcon_match() checks
whether the endpoint's remote port parent device is available. If it is
not, it ignores the endpoint but does not put the reference to the remote
endpoint port parent fwnode. For available devices the fwnode handle
reference is put as expected.

Put the reference for unavailable devices now.

Fixes: 637e9e52b185 ("device connection: Find device connections also from device graphs")
Cc: 5.1+ <stable@vger.kernel.org> # 5.1+
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

diff --git a/drivers/base/property.c b/drivers/base/property.c
index d0960a9e8974..b7b3a7b86006 100644
--- a/drivers/base/property.c
+++ b/drivers/base/property.c
@@ -1158,8 +1158,10 @@ fwnode_graph_devcon_match(struct fwnode_handle *fwnode, const char *con_id,
 
 	fwnode_graph_for_each_endpoint(fwnode, ep) {
 		node = fwnode_graph_get_remote_port_parent(ep);
-		if (!fwnode_device_is_available(node))
+		if (!fwnode_device_is_available(node)) {
+			fwnode_handle_put(node);
 			continue;
+		}
 
 		ret = match(node, con_id, data);
 		fwnode_handle_put(node);

