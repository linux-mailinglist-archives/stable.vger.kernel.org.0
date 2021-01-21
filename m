Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FA1A2FF273
	for <lists+stable@lfdr.de>; Thu, 21 Jan 2021 18:52:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389242AbhAURvp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Jan 2021 12:51:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:52550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389123AbhAURrm (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 21 Jan 2021 12:47:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6DAED21973;
        Thu, 21 Jan 2021 17:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611251218;
        bh=5/CpjNzCYUvdit+J2tPaf4hrd9eu5NYoBJ0rK8Zuz7w=;
        h=Subject:To:From:Date:From;
        b=M5CxnplAuS91w4QAo5SCFrHLPErgOirjiEmElPE2p6PqCoGYDLYQJ2h/gAv0CLmDu
         Q6/iz9Cfa1J7C5weKbm9YcXnNIHFZRIGUQqOrm/l/z3SvkhUwesaXHJ8hnO9nn+18f
         qvHHh3yq/EwOQlEqvhfwNfr6vvnWbSKm89Rb0Yxk=
Subject: patch "driver core: Extend device_is_dependent()" added to driver-core-linus
To:     rafael.j.wysocki@intel.com, gregkh@linuxfoundation.org,
        saravanak@google.com, stable@vger.kernel.org, stephan@gerhold.net
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 21 Jan 2021 18:46:55 +0100
Message-ID: <16112512152956@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    driver core: Extend device_is_dependent()

to my driver-core git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git
in the driver-core-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 3d1cf435e201d1fd63e4346b141881aed086effd Mon Sep 17 00:00:00 2001
From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Date: Fri, 15 Jan 2021 19:30:51 +0100
Subject: driver core: Extend device_is_dependent()

If the device passed as the target (second argument) to
device_is_dependent() is not completely registered (that is, it has
been initialized, but not added yet), but the parent pointer of it
is set, it may be missing from the list of the parent's children
and device_for_each_child() called by device_is_dependent() cannot
be relied on to catch that dependency.

For this reason, modify device_is_dependent() to check the ancestors
of the target device by following its parent pointer in addition to
the device_for_each_child() walk.

Fixes: 9ed9895370ae ("driver core: Functional dependencies tracking support")
Reported-by: Stephan Gerhold <stephan@gerhold.net>
Tested-by: Stephan Gerhold <stephan@gerhold.net>
Reviewed-by: Saravana Kannan <saravanak@google.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://lore.kernel.org/r/17705994.d592GUb2YH@kreacher
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/core.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 25e08e5f40bd..3819fd012e27 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -208,6 +208,16 @@ int device_links_read_lock_held(void)
 #endif
 #endif /* !CONFIG_SRCU */
 
+static bool device_is_ancestor(struct device *dev, struct device *target)
+{
+	while (target->parent) {
+		target = target->parent;
+		if (dev == target)
+			return true;
+	}
+	return false;
+}
+
 /**
  * device_is_dependent - Check if one device depends on another one
  * @dev: Device to check dependencies for.
@@ -221,7 +231,12 @@ int device_is_dependent(struct device *dev, void *target)
 	struct device_link *link;
 	int ret;
 
-	if (dev == target)
+	/*
+	 * The "ancestors" check is needed to catch the case when the target
+	 * device has not been completely initialized yet and it is still
+	 * missing from the list of children of its parent device.
+	 */
+	if (dev == target || device_is_ancestor(dev, target))
 		return 1;
 
 	ret = device_for_each_child(dev, target, device_is_dependent);
-- 
2.30.0


