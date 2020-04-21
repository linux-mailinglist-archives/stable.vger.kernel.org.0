Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37FB81B2E21
	for <lists+stable@lfdr.de>; Tue, 21 Apr 2020 19:19:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726303AbgDURTA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 13:19:00 -0400
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:36575 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726012AbgDURS7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Apr 2020 13:18:59 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 9938D1940B13;
        Tue, 21 Apr 2020 13:11:01 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Tue, 21 Apr 2020 13:11:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=YdjEwu
        P/gdKEg/UXSEl/qghRa9fXxzKrdUwUXf/ZpOo=; b=GrX5xuwUcTyFQJhb3q6huK
        OxujEiDgogy2FBF3DSIasi5JMJhgSFhRQaRtLx6AIER5yo+KWeBF4d/J6g8R9bad
        RYxkUQvpm74PQv5S7jO/zLxqwuHqUlkOCjg1dz6rCfy4WezkIy3XaJmNYgHDRBoI
        t5mnabahh33xw2ZpR5iPEoGXUHCRuoOfSJ2nzbLe9XZYRWrdsBqnkYEeiG1zW+jm
        5bUhvPpZ6JZs66f+7c0rxjaSuu5cP9piuw0ZLy4ldG1bXk7qFCKypGxYDJ+SKs7U
        NQyMm37ElsPmjYyfeorhoazwXUbIk1oAAe+zBiCY4sSihOvOEeBZJ5jNzCHf6j1A
        ==
X-ME-Sender: <xms:JSmfXiIWUhEWoCUemQktxS5mjmTWwgySSishP0WopaRKeRP5ipBUAg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrgeehgddutdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpeegne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:JSmfXvj6kFRO5LqsPwRIHZPSaUUVhdegtqTbTyJHXYNNrmSyoXZzNA>
    <xmx:JSmfXlxDIE8OrN_wprOTPjru9HI_PBYO36IvK7DufC19jv9hVdSRfA>
    <xmx:JSmfXsBJ4yNO_WehaGZVioVJ7MUaWYmtB2kImVHY89tVfV5uw9_yOg>
    <xmx:JSmfXoxySqAAkA1oFvum6b50_rGOGK7-pKWIdJ9w0owrb4PYSa0xgA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2530C328006D;
        Tue, 21 Apr 2020 13:11:01 -0400 (EDT)
Subject: FAILED: patch "[PATCH] of: unittest: kmemleak in duplicate property update" failed to apply to 5.4-stable tree
To:     frank.rowand@sony.com, erhard_f@mailbox.org, robh@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 21 Apr 2020 19:10:52 +0200
Message-ID: <15874890521947@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

From 29acfb65598f91671413869e0d0a1ec4e74ac705 Mon Sep 17 00:00:00 2001
From: Frank Rowand <frank.rowand@sony.com>
Date: Thu, 16 Apr 2020 16:42:50 -0500
Subject: [PATCH] of: unittest: kmemleak in duplicate property update

kmemleak reports several memory leaks from devicetree unittest.
This is the fix for problem 5 of 5.

When overlay 'overlay_bad_add_dup_prop' is applied, the apply code
properly detects that a memory leak will occur if the overlay is removed
since the duplicate property is located in a base devicetree node and
reports via printk():

  OF: overlay: WARNING: memory leak will occur if overlay removed, property: /testcase-data-2/substation@100/motor-1/rpm_avail
  OF: overlay: WARNING: memory leak will occur if overlay removed, property: /testcase-data-2/substation@100/motor-1/rpm_avail

The overlay is removed when the apply code detects multiple changesets
modifying the same property.  This is reported via printk():

  OF: overlay: ERROR: multiple fragments add, update, and/or delete property /testcase-data-2/substation@100/motor-1/rpm_avail

As a result of this error, the overlay is removed resulting in the
expected memory leak.

Add another device node level to the overlay so that the duplicate
property is located in a node added by the overlay, thus no memory
leak will occur when the overlay is removed.

Thus users of kmemleak will not have to debug this leak in the future.

Fixes: 2fe0e8769df9 ("of: overlay: check prevents multiple fragments touching same property")
Reported-by: Erhard F. <erhard_f@mailbox.org>
Signed-off-by: Frank Rowand <frank.rowand@sony.com>
Signed-off-by: Rob Herring <robh@kernel.org>

diff --git a/drivers/of/unittest-data/overlay_bad_add_dup_prop.dts b/drivers/of/unittest-data/overlay_bad_add_dup_prop.dts
index c190da54f175..6327d1ffb963 100644
--- a/drivers/of/unittest-data/overlay_bad_add_dup_prop.dts
+++ b/drivers/of/unittest-data/overlay_bad_add_dup_prop.dts
@@ -3,22 +3,37 @@
 /plugin/;
 
 /*
- * &electric_1/motor-1 and &spin_ctrl_1 are the same node:
- *   /testcase-data-2/substation@100/motor-1
+ * &electric_1/motor-1/electric and &spin_ctrl_1/electric are the same node:
+ *   /testcase-data-2/substation@100/motor-1/electric
  *
  * Thus the property "rpm_avail" in each fragment will
  * result in an attempt to update the same property twice.
  * This will result in an error and the overlay apply
  * will fail.
+ *
+ * The previous version of this test did not include the extra
+ * level of node 'electric'.  That resulted in the 'rpm_avail'
+ * property being located in the pre-existing node 'motor-1'.
+ * Modifying a property results in a WARNING that a memory leak
+ * will occur if the overlay is removed.  Since the overlay apply
+ * fails, the memory leak does actually occur, and kmemleak will
+ * further report the memory leak if CONFIG_DEBUG_KMEMLEAK is
+ * enabled.  Adding the overlay node 'electric' avoids the
+ * memory leak and thus people who use kmemleak will not
+ * have to debug this non-problem again.
  */
 
 &electric_1 {
 
 	motor-1 {
-		rpm_avail = < 100 >;
+		electric {
+			rpm_avail = < 100 >;
+		};
 	};
 };
 
 &spin_ctrl_1 {
-		rpm_avail = < 100 200 >;
+		electric {
+			rpm_avail = < 100 200 >;
+		};
 };
diff --git a/drivers/of/unittest.c b/drivers/of/unittest.c
index f238b7a3865d..398de04fd19c 100644
--- a/drivers/of/unittest.c
+++ b/drivers/of/unittest.c
@@ -3181,21 +3181,21 @@ static __init void of_unittest_overlay_high_level(void)
 		   "OF: overlay: ERROR: multiple fragments add and/or delete node /testcase-data-2/substation@100/motor-1/controller");
 
 	EXPECT_BEGIN(KERN_ERR,
-		     "OF: overlay: WARNING: memory leak will occur if overlay removed, property: /testcase-data-2/substation@100/motor-1/rpm_avail");
+		     "OF: overlay: ERROR: multiple fragments add and/or delete node /testcase-data-2/substation@100/motor-1/electric");
 	EXPECT_BEGIN(KERN_ERR,
-		     "OF: overlay: WARNING: memory leak will occur if overlay removed, property: /testcase-data-2/substation@100/motor-1/rpm_avail");
+		     "OF: overlay: ERROR: multiple fragments add, update, and/or delete property /testcase-data-2/substation@100/motor-1/electric/rpm_avail");
 	EXPECT_BEGIN(KERN_ERR,
-		     "OF: overlay: ERROR: multiple fragments add, update, and/or delete property /testcase-data-2/substation@100/motor-1/rpm_avail");
+		     "OF: overlay: ERROR: multiple fragments add, update, and/or delete property /testcase-data-2/substation@100/motor-1/electric/name");
 
 	unittest(overlay_data_apply("overlay_bad_add_dup_prop", NULL),
 		 "Adding overlay 'overlay_bad_add_dup_prop' failed\n");
 
 	EXPECT_END(KERN_ERR,
-		   "OF: overlay: ERROR: multiple fragments add, update, and/or delete property /testcase-data-2/substation@100/motor-1/rpm_avail");
+		     "OF: overlay: ERROR: multiple fragments add, update, and/or delete property /testcase-data-2/substation@100/motor-1/electric/name");
 	EXPECT_END(KERN_ERR,
-		   "OF: overlay: WARNING: memory leak will occur if overlay removed, property: /testcase-data-2/substation@100/motor-1/rpm_avail");
+		     "OF: overlay: ERROR: multiple fragments add, update, and/or delete property /testcase-data-2/substation@100/motor-1/electric/rpm_avail");
 	EXPECT_END(KERN_ERR,
-		   "OF: overlay: WARNING: memory leak will occur if overlay removed, property: /testcase-data-2/substation@100/motor-1/rpm_avail");
+		     "OF: overlay: ERROR: multiple fragments add and/or delete node /testcase-data-2/substation@100/motor-1/electric");
 
 	unittest(overlay_data_apply("overlay_bad_phandle", NULL),
 		 "Adding overlay 'overlay_bad_phandle' failed\n");

