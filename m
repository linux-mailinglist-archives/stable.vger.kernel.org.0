Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5A531D9007
	for <lists+stable@lfdr.de>; Tue, 19 May 2020 08:30:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726905AbgESGaG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 May 2020 02:30:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726841AbgESGaF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 May 2020 02:30:05 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAD12C061A0C
        for <stable@vger.kernel.org>; Mon, 18 May 2020 23:30:05 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id u61so15443465qtd.4
        for <stable@vger.kernel.org>; Mon, 18 May 2020 23:30:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:subject:from:to:cc;
        bh=4i4qxV9jzWOFxyzaAzTO+rgpHE0hlQwFwvneTDDF6kk=;
        b=uPr2mgJckyi8jTdbtTshjoDgkaEUxQDGNk4vOmUqCbXX1JpxXt+a8Yp0cU41arItdr
         tQv8uPlJcaLqtccsQmEPgKHVPoZUcYg4FQIHOBbQSwCIRFRcTweb/SuDgNFg/rrqONY2
         jmcrHO0lslojOi+zSQthcH4hJiu//PFcLe53qwOCSk8RpDnkBevXTSwpFtqLcH+SdTEL
         ChQHgfizKhUSzdlYNB59LMArkz2XPb59WrWph95MUzZBFMfT85OCPEa+lUMiuBMwiaof
         ACP/mG0ZPMQtFVr1pIPLT264aa6nOMp+3xqciI7gc4wdNDkagyusfaOC7iOielYSo5VF
         kxvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version:subject
         :from:to:cc;
        bh=4i4qxV9jzWOFxyzaAzTO+rgpHE0hlQwFwvneTDDF6kk=;
        b=ifdMwZUJgn1XWhvwOGevwQCEdxXOJ+cUoICX0BG0w0q6dt3WM8QqSyHDL0jM+HMm9d
         +2vraxeDPg1+40TNXAh84thQm4jDcc+SbIvUOgkzpohqPApoy5YRposhwPmI6clJPK9G
         EIATHdxcCkXd5Bimaer58/6oFgMviGcDvNLWpXqB6IBl96Mx2H8LaX4Byrj7H5YoSBTx
         CnSb5T3E0zOA6gqFpM3wmdGxqZekBbu9Dms7gR2CalyJywLp6eFTGrvAqpGc20ascxkn
         P2TSH3hYSprxAxaZhfmnkiHy/7ANX4sS5fHcFIpdSYO2Gxp6oslhNUfITEb2J5Ibn01n
         jb5A==
X-Gm-Message-State: AOAM532tpJASZ+LL+4IsDmHesaSzTHwi3KN0IZcu0k9rluekNbO0kIJj
        wvVRZzeWamph7xKvMcAr5BkABNnQ9zkJSZ0=
X-Google-Smtp-Source: ABdhPJyxYmRFI4xpzw7BbDsG467bmdxI3nMvfHGNehMyvRsCPd6nyXf4KL2CBP53AW+Wfl/qbFsaFX0rx0Q9sWE=
X-Received: by 2002:a0c:b501:: with SMTP id d1mr20008437qve.63.1589869804847;
 Mon, 18 May 2020 23:30:04 -0700 (PDT)
Date:   Mon, 18 May 2020 23:30:00 -0700
In-Reply-To: <20200518080327.GA3126260@kroah.com>
Message-Id: <20200519063000.128819-1-saravanak@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.26.2.761.g0e0b3e54be-goog
Subject: [PATCH v3] driver core: Fix SYNC_STATE_ONLY device link implementation
From:   Saravana Kannan <saravanak@google.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Saravana Kannan <saravanak@google.com>
Cc:     stable@vger.kernel.org, kernel-team@android.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When SYNC_STATE_ONLY support was added in commit 05ef983e0d65 ("driver
core: Add device link support for SYNC_STATE_ONLY flag"),
device_link_add() incorrectly skipped adding the new SYNC_STATE_ONLY
device link to the supplier's and consumer's "device link" list.

This causes multiple issues:
- The device link is lost forever from driver core if the caller
  didn't keep track of it (caller typically isn't expected to). This is
  a memory leak.
- The device link is also never visible to any other code path after
  device_link_add() returns.

If we fix the "device link" list handling, that exposes a bunch of
issues.

1. The device link "status" state management code rightfully doesn't
handle the case where a DL_FLAG_MANAGED device link exists between a
supplier and consumer, but the consumer manages to probe successfully
before the supplier. The addition of DL_FLAG_SYNC_STATE_ONLY links break
this assumption. This causes device_links_driver_bound() to throw a
warning when this happens.

Since DL_FLAG_SYNC_STATE_ONLY device links are mainly used for creating
proxy device links for child device dependencies and aren't useful once
the consumer device probes successfully, this patch just deletes
DL_FLAG_SYNC_STATE_ONLY device links once its consumer device probes.
This way, we avoid the warning, free up some memory and avoid
complicating the device links "status" state management code.

2. Creating a DL_FLAG_STATELESS device link between two devices that
already have a DL_FLAG_SYNC_STATE_ONLY device link will result in the
DL_FLAG_STATELESS flag not getting set correctly. This patch also fixes
this.

Lastly, this patch also fixes minor whitespace issues.

Cc: stable@vger.kernel.org
Fixes: 05ef983e0d65 ("driver core: Add device link support for SYNC_STATE_ONLY flag")
Signed-off-by: Saravana Kannan <saravanak@google.com>
---
v3:
- Added this changelog text
v2:
- Delete DL_FLAG_SYNC_STATE_ONLY device links on consumer probe
- Set DL_FLAG_STATELESS correct when added to an existing
  DL_FLAG_SYNC_STATE_ONLY device link.
v1:
- Add device link to list
- Minor whitespace fixes

 drivers/base/core.c | 61 +++++++++++++++++++++++++++++----------------
 1 file changed, 39 insertions(+), 22 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 84c569726d75..f804e561e0a2 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -363,13 +363,12 @@ struct device_link *device_link_add(struct device *consumer,
 
 		if (flags & DL_FLAG_STATELESS) {
 			kref_get(&link->kref);
+			link->flags |= DL_FLAG_STATELESS;
 			if (link->flags & DL_FLAG_SYNC_STATE_ONLY &&
-			    !(link->flags & DL_FLAG_STATELESS)) {
-				link->flags |= DL_FLAG_STATELESS;
+			    !(link->flags & DL_FLAG_STATELESS))
 				goto reorder;
-			} else {
+			else
 				goto out;
-			}
 		}
 
 		/*
@@ -436,12 +435,16 @@ struct device_link *device_link_add(struct device *consumer,
 	    flags & DL_FLAG_PM_RUNTIME)
 		pm_runtime_resume(supplier);
 
+	list_add_tail_rcu(&link->s_node, &supplier->links.consumers);
+	list_add_tail_rcu(&link->c_node, &consumer->links.suppliers);
+
 	if (flags & DL_FLAG_SYNC_STATE_ONLY) {
 		dev_dbg(consumer,
 			"Linked as a sync state only consumer to %s\n",
 			dev_name(supplier));
 		goto out;
 	}
+
 reorder:
 	/*
 	 * Move the consumer and all of the devices depending on it to the end
@@ -452,12 +455,9 @@ struct device_link *device_link_add(struct device *consumer,
 	 */
 	device_reorder_to_tail(consumer, NULL);
 
-	list_add_tail_rcu(&link->s_node, &supplier->links.consumers);
-	list_add_tail_rcu(&link->c_node, &consumer->links.suppliers);
-
 	dev_dbg(consumer, "Linked as a consumer to %s\n", dev_name(supplier));
 
- out:
+out:
 	device_pm_unlock();
 	device_links_write_unlock();
 
@@ -832,6 +832,13 @@ static void __device_links_supplier_defer_sync(struct device *sup)
 		list_add_tail(&sup->links.defer_sync, &deferred_sync);
 }
 
+static void device_link_drop_managed(struct device_link *link)
+{
+	link->flags &= ~DL_FLAG_MANAGED;
+	WRITE_ONCE(link->status, DL_STATE_NONE);
+	kref_put(&link->kref, __device_link_del);
+}
+
 /**
  * device_links_driver_bound - Update device links after probing its driver.
  * @dev: Device to update the links for.
@@ -845,7 +852,7 @@ static void __device_links_supplier_defer_sync(struct device *sup)
  */
 void device_links_driver_bound(struct device *dev)
 {
-	struct device_link *link;
+	struct device_link *link, *ln;
 	LIST_HEAD(sync_list);
 
 	/*
@@ -885,18 +892,35 @@ void device_links_driver_bound(struct device *dev)
 	else
 		__device_links_queue_sync_state(dev, &sync_list);
 
-	list_for_each_entry(link, &dev->links.suppliers, c_node) {
+	list_for_each_entry_safe(link, ln, &dev->links.suppliers, c_node) {
+		struct device *supplier;
+
 		if (!(link->flags & DL_FLAG_MANAGED))
 			continue;
 
-		WARN_ON(link->status != DL_STATE_CONSUMER_PROBE);
-		WRITE_ONCE(link->status, DL_STATE_ACTIVE);
+		supplier = link->supplier;
+		if (link->flags & DL_FLAG_SYNC_STATE_ONLY) {
+			/*
+			 * When DL_FLAG_SYNC_STATE_ONLY is set, it means no
+			 * other DL_MANAGED_LINK_FLAGS have been set. So, it's
+			 * save to drop the managed link completely.
+			 */
+			device_link_drop_managed(link);
+		} else {
+			WARN_ON(link->status != DL_STATE_CONSUMER_PROBE);
+			WRITE_ONCE(link->status, DL_STATE_ACTIVE);
+		}
 
+		/*
+		 * This needs to be done even for the deleted
+		 * DL_FLAG_SYNC_STATE_ONLY device link in case it was the last
+		 * device link that was preventing the supplier from getting a
+		 * sync_state() call.
+		 */
 		if (defer_sync_state_count)
-			__device_links_supplier_defer_sync(link->supplier);
+			__device_links_supplier_defer_sync(supplier);
 		else
-			__device_links_queue_sync_state(link->supplier,
-							&sync_list);
+			__device_links_queue_sync_state(supplier, &sync_list);
 	}
 
 	dev->links.status = DL_DEV_DRIVER_BOUND;
@@ -906,13 +930,6 @@ void device_links_driver_bound(struct device *dev)
 	device_links_flush_sync_list(&sync_list, dev);
 }
 
-static void device_link_drop_managed(struct device_link *link)
-{
-	link->flags &= ~DL_FLAG_MANAGED;
-	WRITE_ONCE(link->status, DL_STATE_NONE);
-	kref_put(&link->kref, __device_link_del);
-}
-
 /**
  * __device_links_no_driver - Update links of a device without a driver.
  * @dev: Device without a drvier.
-- 
2.26.2.761.g0e0b3e54be-goog

