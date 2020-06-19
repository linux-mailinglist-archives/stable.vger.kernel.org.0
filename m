Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3A0A201073
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:31:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393730AbgFSPae (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:30:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:34356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393727AbgFSPab (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:30:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2FB812193E;
        Fri, 19 Jun 2020 15:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592580629;
        bh=tW3rzovhW68qsjJSZ/Gwv429qUv1aDsTkra+6kgU6Do=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iYat2lR1+m0LKV7cNNL5S1qc6DBQgUgsrPBNFYEQIiwMSkSGPIGV5mO8DhrUgFwQr
         KXPMF4LZlrTB2Q3v6PiJCQ+7pb4ML6jbb22RHJoLd4yDFOimPUV2mfc6wkwLSzvzpH
         GfzbEKA9qdekmqjaCUW4i0gbI0hkYbF58fvj67LA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Brendan Higgins <brendanhiggins@google.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Petr Mladek <pmladek@suse.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        kernel test robot <rong.a.chen@intel.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 5.7 323/376] software node: implement software_node_unregister()
Date:   Fri, 19 Jun 2020 16:34:01 +0200
Message-Id: <20200619141725.619042745@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 46d26819a5056f4831649c5887ad5c71a16d86f7 upstream.

Sometimes it is better to unregister individual nodes instead of trying
to do them all at once with software_node_unregister_nodes(), so create
software_node_unregister() so that you can unregister them one at a
time.

This is especially important when creating nodes in a hierarchy, with
parent -> children representations.  Children always need to be removed
before a parent is, as the swnode logic assumes this is going to be the
case.

Fix up the lib/test_printf.c fwnode_pointer() test which to use this new
function as it had the problem of tearing things down in the backwards
order.

Fixes: f1ce39df508d ("lib/test_printf: Add tests for %pfw printk modifier")
Cc: stable <stable@vger.kernel.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Reported-by: kernel test robot <rong.a.chen@intel.com>
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Tested-by: Petr Mladek <pmladek@suse.com>
Tested-by: Randy Dunlap <rdunlap@infradead.org>
Tested-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Link: https://lore.kernel.org/r/20200524153041.2361-1-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/swnode.c    |   27 +++++++++++++++++++++------
 include/linux/property.h |    1 +
 lib/test_printf.c        |    4 +++-
 3 files changed, 25 insertions(+), 7 deletions(-)

--- a/drivers/base/swnode.c
+++ b/drivers/base/swnode.c
@@ -712,17 +712,18 @@ EXPORT_SYMBOL_GPL(software_node_register
  * @nodes: Zero terminated array of software nodes to be unregistered
  *
  * Unregister multiple software nodes at once.
+ *
+ * NOTE: Be careful using this call if the nodes had parent pointers set up in
+ * them before registering.  If so, it is wiser to remove the nodes
+ * individually, in the correct order (child before parent) instead of relying
+ * on the sequential order of the list of nodes in the array.
  */
 void software_node_unregister_nodes(const struct software_node *nodes)
 {
-	struct swnode *swnode;
 	int i;
 
-	for (i = 0; nodes[i].name; i++) {
-		swnode = software_node_to_swnode(&nodes[i]);
-		if (swnode)
-			fwnode_remove_software_node(&swnode->fwnode);
-	}
+	for (i = 0; nodes[i].name; i++)
+		software_node_unregister(&nodes[i]);
 }
 EXPORT_SYMBOL_GPL(software_node_unregister_nodes);
 
@@ -741,6 +742,20 @@ int software_node_register(const struct
 }
 EXPORT_SYMBOL_GPL(software_node_register);
 
+/**
+ * software_node_unregister - Unregister static software node
+ * @node: The software node to be unregistered
+ */
+void software_node_unregister(const struct software_node *node)
+{
+	struct swnode *swnode;
+
+	swnode = software_node_to_swnode(node);
+	if (swnode)
+		fwnode_remove_software_node(&swnode->fwnode);
+}
+EXPORT_SYMBOL_GPL(software_node_unregister);
+
 struct fwnode_handle *
 fwnode_create_software_node(const struct property_entry *properties,
 			    const struct fwnode_handle *parent)
--- a/include/linux/property.h
+++ b/include/linux/property.h
@@ -441,6 +441,7 @@ int software_node_register_nodes(const s
 void software_node_unregister_nodes(const struct software_node *nodes);
 
 int software_node_register(const struct software_node *node);
+void software_node_unregister(const struct software_node *node);
 
 int software_node_notify(struct device *dev, unsigned long action);
 
--- a/lib/test_printf.c
+++ b/lib/test_printf.c
@@ -637,7 +637,9 @@ static void __init fwnode_pointer(void)
 	test(second_name, "%pfwP", software_node_fwnode(&softnodes[1]));
 	test(third_name, "%pfwP", software_node_fwnode(&softnodes[2]));
 
-	software_node_unregister_nodes(softnodes);
+	software_node_unregister(&softnodes[2]);
+	software_node_unregister(&softnodes[1]);
+	software_node_unregister(&softnodes[0]);
 }
 
 static void __init


