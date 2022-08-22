Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5CF859BBFB
	for <lists+stable@lfdr.de>; Mon, 22 Aug 2022 10:50:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233484AbiHVIto (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 04:49:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233801AbiHVIt0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 04:49:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 839FC65D8
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 01:49:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2A8CB6106B
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 08:49:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D114C433D7;
        Mon, 22 Aug 2022 08:49:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661158163;
        bh=nGS7BIF1T8MGaagPKVFjdFHENf9tZq0gWLqZqpfUFKM=;
        h=Subject:To:Cc:From:Date:From;
        b=glvffybAUyWkKAfrZ49naJjmiMqQibiCbck6sJprebtnHRHB6OdbzmbaCNQDNdbyH
         qUGQkyQEUUoSD/JY0+i2xFAykWndJJY8spZ7HhhRt4sVkP2BaAq92JQFQs0QJXiOqF
         EWDKbjgyD3LoesflR5PFl0r/nItNaJqF+tZxjO5Y=
Subject: FAILED: patch "[PATCH] ACPI: property: Return type of acpi_add_nondev_subnodes()" failed to apply to 4.9-stable tree
To:     sakari.ailus@linux.intel.com, andriy.shevchenko@linux.intel.com,
        rafael.j.wysocki@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 22 Aug 2022 10:49:20 +0200
Message-ID: <166115816024313@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 85140ef275f577f64e8a2c5789447222dfc14fc4 Mon Sep 17 00:00:00 2001
From: Sakari Ailus <sakari.ailus@linux.intel.com>
Date: Mon, 11 Jul 2022 14:25:59 +0300
Subject: [PATCH] ACPI: property: Return type of acpi_add_nondev_subnodes()
 should be bool

The value acpi_add_nondev_subnodes() returns is bool so change the return
type of the function to match that.

Fixes: 445b0eb058f5 ("ACPI / property: Add support for data-only subnodes")
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

diff --git a/drivers/acpi/property.c b/drivers/acpi/property.c
index d3173811614e..bc9a645f8bb7 100644
--- a/drivers/acpi/property.c
+++ b/drivers/acpi/property.c
@@ -155,10 +155,10 @@ static bool acpi_nondev_subnode_ok(acpi_handle scope,
 	return acpi_nondev_subnode_data_ok(handle, link, list, parent);
 }
 
-static int acpi_add_nondev_subnodes(acpi_handle scope,
-				    const union acpi_object *links,
-				    struct list_head *list,
-				    struct fwnode_handle *parent)
+static bool acpi_add_nondev_subnodes(acpi_handle scope,
+				     const union acpi_object *links,
+				     struct list_head *list,
+				     struct fwnode_handle *parent)
 {
 	bool ret = false;
 	int i;

