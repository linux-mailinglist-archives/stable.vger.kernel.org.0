Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32F81592040
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 16:47:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbiHNOrM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 10:47:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbiHNOrM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 10:47:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED33014013
        for <stable@vger.kernel.org>; Sun, 14 Aug 2022 07:47:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A769DB80B41
        for <stable@vger.kernel.org>; Sun, 14 Aug 2022 14:47:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E07A2C433C1;
        Sun, 14 Aug 2022 14:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660488428;
        bh=XrSNeeIgi89LaoCZSokcOrmapG0gL4d9xvHSOT+Pp5Q=;
        h=Subject:To:Cc:From:Date:From;
        b=S4JwWfox0KWNYswgBxvDpalSAFQ7fDy8W63jvpcGVBjyzKjTl6F9wXYAkHquVBDZa
         kqjhWJAY50LXfTwxAaltIvkwflAXWO6R6t0rcGeaBmeDb0/IRdRaFHIjRK0dyM+QqM
         2POlfG/vBNsDzcE9mzPyzBxWzv5I5HwG54hkCKkk=
Subject: FAILED: patch "[PATCH] drivers/base: fix userspace break from using bin_attributes" failed to apply to 5.15-stable tree
To:     pauld@redhat.com, gregkh@linuxfoundation.org, rafael@kernel.org,
        yury.norov@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 14 Aug 2022 16:47:05 +0200
Message-ID: <1660488425178123@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 7ee951acd31a88f941fd6535fbdee3a1567f1d63 Mon Sep 17 00:00:00 2001
From: Phil Auld <pauld@redhat.com>
Date: Fri, 15 Jul 2022 09:49:24 -0400
Subject: [PATCH] drivers/base: fix userspace break from using bin_attributes
 for cpumap and cpulist

Using bin_attributes with a 0 size causes fstat and friends to return that
0 size. This breaks userspace code that retrieves the size before reading
the file. Rather than reverting 75bd50fa841 ("drivers/base/node.c: use
bin_attribute to break the size limitation of cpumap ABI") let's put in a
size value at compile time.

For cpulist the maximum size is on the order of
	NR_CPUS * (ceil(log10(NR_CPUS)) + 1)/2

which for 8192 is 20480 (8192 * 5)/2. In order to get near that you'd need
a system with every other CPU on one node. For example: (0,2,4,8, ... ).
To simplify the math and support larger NR_CPUS in the future we are using
(NR_CPUS * 7)/2. We also set it to a min of PAGE_SIZE to retain the older
behavior for smaller NR_CPUS.

The cpumap file the size works out to be NR_CPUS/4 + NR_CPUS/32 - 1
(or NR_CPUS * 9/32 - 1) including the ","s.

Add a set of macros for these values to cpumask.h so they can be used in
multiple places. Apply these to the handful of such files in
drivers/base/topology.c as well as node.c.

As an example, on an 80 cpu 4-node system (NR_CPUS == 8192):

before:

-r--r--r--. 1 root root 0 Jul 12 14:08 system/node/node0/cpulist
-r--r--r--. 1 root root 0 Jul 11 17:25 system/node/node0/cpumap

after:

-r--r--r--. 1 root root 28672 Jul 13 11:32 system/node/node0/cpulist
-r--r--r--. 1 root root  4096 Jul 13 11:31 system/node/node0/cpumap

CONFIG_NR_CPUS = 16384
-r--r--r--. 1 root root 57344 Jul 13 14:03 system/node/node0/cpulist
-r--r--r--. 1 root root  4607 Jul 13 14:02 system/node/node0/cpumap

The actual number of cpus doesn't matter for the reported size since they
are based on NR_CPUS.

Fixes: 75bd50fa841d ("drivers/base/node.c: use bin_attribute to break the size limitation of cpumap ABI")
Fixes: bb9ec13d156e ("topology: use bin_attribute to break the size limitation of cpumap ABI")
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Yury Norov <yury.norov@gmail.com>
Cc: stable@vger.kernel.org
Acked-by: Yury Norov <yury.norov@gmail.com> (for include/linux/cpumask.h)
Signed-off-by: Phil Auld <pauld@redhat.com>
Link: https://lore.kernel.org/r/20220715134924.3466194-1-pauld@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/base/node.c b/drivers/base/node.c
index 0ac6376ef7a1..eb0f43784c2b 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -45,7 +45,7 @@ static inline ssize_t cpumap_read(struct file *file, struct kobject *kobj,
 	return n;
 }
 
-static BIN_ATTR_RO(cpumap, 0);
+static BIN_ATTR_RO(cpumap, CPUMAP_FILE_MAX_BYTES);
 
 static inline ssize_t cpulist_read(struct file *file, struct kobject *kobj,
 				   struct bin_attribute *attr, char *buf,
@@ -66,7 +66,7 @@ static inline ssize_t cpulist_read(struct file *file, struct kobject *kobj,
 	return n;
 }
 
-static BIN_ATTR_RO(cpulist, 0);
+static BIN_ATTR_RO(cpulist, CPULIST_FILE_MAX_BYTES);
 
 /**
  * struct node_access_nodes - Access class device to hold user visible
diff --git a/drivers/base/topology.c b/drivers/base/topology.c
index ac6ad9ab67f9..89f98be5c5b9 100644
--- a/drivers/base/topology.c
+++ b/drivers/base/topology.c
@@ -62,47 +62,47 @@ define_id_show_func(ppin, "0x%llx");
 static DEVICE_ATTR_ADMIN_RO(ppin);
 
 define_siblings_read_func(thread_siblings, sibling_cpumask);
-static BIN_ATTR_RO(thread_siblings, 0);
-static BIN_ATTR_RO(thread_siblings_list, 0);
+static BIN_ATTR_RO(thread_siblings, CPUMAP_FILE_MAX_BYTES);
+static BIN_ATTR_RO(thread_siblings_list, CPULIST_FILE_MAX_BYTES);
 
 define_siblings_read_func(core_cpus, sibling_cpumask);
-static BIN_ATTR_RO(core_cpus, 0);
-static BIN_ATTR_RO(core_cpus_list, 0);
+static BIN_ATTR_RO(core_cpus, CPUMAP_FILE_MAX_BYTES);
+static BIN_ATTR_RO(core_cpus_list, CPULIST_FILE_MAX_BYTES);
 
 define_siblings_read_func(core_siblings, core_cpumask);
-static BIN_ATTR_RO(core_siblings, 0);
-static BIN_ATTR_RO(core_siblings_list, 0);
+static BIN_ATTR_RO(core_siblings, CPUMAP_FILE_MAX_BYTES);
+static BIN_ATTR_RO(core_siblings_list, CPULIST_FILE_MAX_BYTES);
 
 #ifdef TOPOLOGY_CLUSTER_SYSFS
 define_siblings_read_func(cluster_cpus, cluster_cpumask);
-static BIN_ATTR_RO(cluster_cpus, 0);
-static BIN_ATTR_RO(cluster_cpus_list, 0);
+static BIN_ATTR_RO(cluster_cpus, CPUMAP_FILE_MAX_BYTES);
+static BIN_ATTR_RO(cluster_cpus_list, CPULIST_FILE_MAX_BYTES);
 #endif
 
 #ifdef TOPOLOGY_DIE_SYSFS
 define_siblings_read_func(die_cpus, die_cpumask);
-static BIN_ATTR_RO(die_cpus, 0);
-static BIN_ATTR_RO(die_cpus_list, 0);
+static BIN_ATTR_RO(die_cpus, CPUMAP_FILE_MAX_BYTES);
+static BIN_ATTR_RO(die_cpus_list, CPULIST_FILE_MAX_BYTES);
 #endif
 
 define_siblings_read_func(package_cpus, core_cpumask);
-static BIN_ATTR_RO(package_cpus, 0);
-static BIN_ATTR_RO(package_cpus_list, 0);
+static BIN_ATTR_RO(package_cpus, CPUMAP_FILE_MAX_BYTES);
+static BIN_ATTR_RO(package_cpus_list, CPULIST_FILE_MAX_BYTES);
 
 #ifdef TOPOLOGY_BOOK_SYSFS
 define_id_show_func(book_id, "%d");
 static DEVICE_ATTR_RO(book_id);
 define_siblings_read_func(book_siblings, book_cpumask);
-static BIN_ATTR_RO(book_siblings, 0);
-static BIN_ATTR_RO(book_siblings_list, 0);
+static BIN_ATTR_RO(book_siblings, CPUMAP_FILE_MAX_BYTES);
+static BIN_ATTR_RO(book_siblings_list, CPULIST_FILE_MAX_BYTES);
 #endif
 
 #ifdef TOPOLOGY_DRAWER_SYSFS
 define_id_show_func(drawer_id, "%d");
 static DEVICE_ATTR_RO(drawer_id);
 define_siblings_read_func(drawer_siblings, drawer_cpumask);
-static BIN_ATTR_RO(drawer_siblings, 0);
-static BIN_ATTR_RO(drawer_siblings_list, 0);
+static BIN_ATTR_RO(drawer_siblings, CPUMAP_FILE_MAX_BYTES);
+static BIN_ATTR_RO(drawer_siblings_list, CPULIST_FILE_MAX_BYTES);
 #endif
 
 static struct bin_attribute *bin_attrs[] = {
diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
index fe29ac7cc469..4592d0845941 100644
--- a/include/linux/cpumask.h
+++ b/include/linux/cpumask.h
@@ -1071,4 +1071,22 @@ cpumap_print_list_to_buf(char *buf, const struct cpumask *mask,
 	[0] =  1UL							\
 } }
 
+/*
+ * Provide a valid theoretical max size for cpumap and cpulist sysfs files
+ * to avoid breaking userspace which may allocate a buffer based on the size
+ * reported by e.g. fstat.
+ *
+ * for cpumap NR_CPUS * 9/32 - 1 should be an exact length.
+ *
+ * For cpulist 7 is (ceil(log10(NR_CPUS)) + 1) allowing for NR_CPUS to be up
+ * to 2 orders of magnitude larger than 8192. And then we divide by 2 to
+ * cover a worst-case of every other cpu being on one of two nodes for a
+ * very large NR_CPUS.
+ *
+ *  Use PAGE_SIZE as a minimum for smaller configurations.
+ */
+#define CPUMAP_FILE_MAX_BYTES  ((((NR_CPUS * 9)/32 - 1) > PAGE_SIZE) \
+					? (NR_CPUS * 9)/32 - 1 : PAGE_SIZE)
+#define CPULIST_FILE_MAX_BYTES  (((NR_CPUS * 7)/2 > PAGE_SIZE) ? (NR_CPUS * 7)/2 : PAGE_SIZE)
+
 #endif /* __LINUX_CPUMASK_H */

