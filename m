Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07EFE1879F3
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 07:55:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726541AbgCQGzQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 02:55:16 -0400
Received: from mail-qv1-f73.google.com ([209.85.219.73]:57056 "EHLO
        mail-qv1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726521AbgCQGzO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Mar 2020 02:55:14 -0400
Received: by mail-qv1-f73.google.com with SMTP id ee5so16384012qvb.23
        for <stable@vger.kernel.org>; Mon, 16 Mar 2020 23:55:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=7ngORi0qjHGKSTPYP6jqwB2CTxTKHni0v/JyFS4TsJY=;
        b=Nab2iMTktoEDgr02ucqDK9isAmOo4ipKNIJmcdWX9C+9c6ibZ0ACWVVDLKrmvFK2Nv
         +n/CdhwFe7D0fcDDF+KueDiskyTSirfZzgH7ApN17BUlo33WGiDWYQxSdr+88om+U7ug
         yLoYp18sCc0bH6o010hAp7CyOux2D4YkIDi5T36j6CpG9ul39ZcoEkPKPhqNjdZI5Hbq
         126yvaty609YLDursNVsFv1zTmvhwtCRCM5ONcqGkUz4vJt9r3XlTRWSa/0fb+rJO1Jk
         ZCqKS5PHRoyv6IVk7cQ1Tmnu4uXf0ZkfZkTpEZsAsodLYoQolYkSZVpKlgOncY4D208G
         e0aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=7ngORi0qjHGKSTPYP6jqwB2CTxTKHni0v/JyFS4TsJY=;
        b=SZZ3ftIdSM/BcnEF1O3QrDHr02tZlHxAaH6qNz6+n7OOQ1IV1vOuVOZySpXymV5MKk
         WVmWUaQaOZYSE+Ye7NfD4ORG0WjZJYRmQZ9lJ1pFMzipzMkiNQnUNa50BhEcpDTxXcyW
         U92O1RyQtCBsyu6VoOyFv+8pWsBtYCxzJh6l8wm9FW0d2QvszCNf+uj8csJXJyOOOChC
         GFgGb7JiCUqVZwFDrRPIoWw++x0IP73NBKpwaBoli7/UFmj7C5O1XuHrO5q9aKVleDwh
         Pq20jo24+RXGkdogkp3Bwz75bMP5lAh6Pie4lMYun3eIjAx65ZJ4VUruJbyNC4tRgx5Y
         gMuw==
X-Gm-Message-State: ANhLgQ3QPFrPL83MKtiuQY4hju7Rqnznf+Er9dS38U/AZ9H34jT2Ly4J
        /eGVbXmEUgjSJfjUsz24Pgq5iXTO/zo1j+iSzU4blR3WCCm0s6/bWFlhFdeYYhERWfhBFjd5kXQ
        d/SMbypkAoq94aX+4+56crtwxsH9AfVqx+P2qwP/KWysrHc2sN6LVBr1KoOr52fIkgnIwlQ==
X-Google-Smtp-Source: ADFU+vu6Q/y175df99s4giYR9vMy2KQkhva5yiVcjNt6xji0hnXCikbzl84Cs4t7LJdeoDn8q4XTKNSqQvCeU0w=
X-Received: by 2002:ac8:3003:: with SMTP id f3mr3817009qte.293.1584428111301;
 Mon, 16 Mar 2020 23:55:11 -0700 (PDT)
Date:   Mon, 16 Mar 2020 23:54:50 -0700
In-Reply-To: <20200317065452.236670-1-saravanak@google.com>
Message-Id: <20200317065452.236670-5-saravanak@google.com>
Mime-Version: 1.0
References: <20200317065452.236670-1-saravanak@google.com>
X-Mailer: git-send-email 2.25.1.481.gfbce0eb801-goog
Subject: [PATCH v1 4/6] driver core: Add device link flag DL_FLAG_AUTOPROBE_CONSUMER
From:   Saravana Kannan <saravanak@google.com>
To:     stable@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Matthias Brugger <matthias.bgg@gmail.com>
Cc:     Saravana Kannan <saravanak@google.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, kernel-team@android.com,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

Add a new device link flag, DL_FLAG_AUTOPROBE_CONSUMER, to request the
driver core to probe for a consumer driver automatically after binding
a driver to the supplier device on a persistent managed device link.

As unbinding the supplier driver on a managed device link causes the
consumer driver to be detached from its device automatically, this
flag provides a complementary mechanism which is needed to address
some "composite device" use cases.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
(cherry picked from commit e7dd40105aac9ba051e44ad711123bc53a5e4c71)
Signed-off-by: Saravana Kannan <saravanak@google.com>
---
 Documentation/driver-api/device_link.rst |  9 +++++++++
 drivers/base/core.c                      | 16 +++++++++++++++-
 drivers/base/dd.c                        |  2 +-
 include/linux/device.h                   |  3 +++
 4 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/Documentation/driver-api/device_link.rst b/Documentation/driver-api/device_link.rst
index e249e074a8d2..c764755121c7 100644
--- a/Documentation/driver-api/device_link.rst
+++ b/Documentation/driver-api/device_link.rst
@@ -94,6 +94,15 @@ Similarly, when the device link is added from supplier's ``->probe`` callback,
 ``DL_FLAG_AUTOREMOVE_SUPPLIER`` causes the device link to be automatically
 purged when the supplier fails to probe or later unbinds.
 
+If neither ``DL_FLAG_AUTOREMOVE_CONSUMER`` nor ``DL_FLAG_AUTOREMOVE_SUPPLIER``
+is set, ``DL_FLAG_AUTOPROBE_CONSUMER`` can be used to request the driver core
+to probe for a driver for the consumer driver on the link automatically after
+a driver has been bound to the supplier device.
+
+Note, however, that any combinations of ``DL_FLAG_AUTOREMOVE_CONSUMER``,
+``DL_FLAG_AUTOREMOVE_SUPPLIER`` or ``DL_FLAG_AUTOPROBE_CONSUMER`` with
+``DL_FLAG_STATELESS`` are invalid and cannot be used.
+
 Limitations
 ===========
 
diff --git a/drivers/base/core.c b/drivers/base/core.c
index d8273792950b..3495da13b18a 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -195,6 +195,12 @@ void device_pm_move_to_tail(struct device *dev)
  * the link will be maintained until one of the devices pointed to by it (either
  * the consumer or the supplier) is unregistered.
  *
+ * Also, if DL_FLAG_STATELESS, DL_FLAG_AUTOREMOVE_CONSUMER and
+ * DL_FLAG_AUTOREMOVE_SUPPLIER are not set in @flags (that is, a persistent
+ * managed device link is being added), the DL_FLAG_AUTOPROBE_CONSUMER flag can
+ * be used to request the driver core to automaticall probe for a consmer
+ * driver after successfully binding a driver to the supplier device.
+ *
  * The combination of DL_FLAG_STATELESS and either DL_FLAG_AUTOREMOVE_CONSUMER
  * or DL_FLAG_AUTOREMOVE_SUPPLIER set in @flags at the same time is invalid and
  * will cause NULL to be returned upfront.
@@ -215,7 +221,12 @@ struct device_link *device_link_add(struct device *consumer,
 
 	if (!consumer || !supplier ||
 	    (flags & DL_FLAG_STATELESS &&
-	     flags & (DL_FLAG_AUTOREMOVE_CONSUMER | DL_FLAG_AUTOREMOVE_SUPPLIER)))
+	     flags & (DL_FLAG_AUTOREMOVE_CONSUMER |
+		      DL_FLAG_AUTOREMOVE_SUPPLIER |
+		      DL_FLAG_AUTOPROBE_CONSUMER)) ||
+	    (flags & DL_FLAG_AUTOPROBE_CONSUMER &&
+	     flags & (DL_FLAG_AUTOREMOVE_CONSUMER |
+		      DL_FLAG_AUTOREMOVE_SUPPLIER)))
 		return NULL;
 
 	if (flags & DL_FLAG_PM_RUNTIME && flags & DL_FLAG_RPM_ACTIVE) {
@@ -576,6 +587,9 @@ void device_links_driver_bound(struct device *dev)
 
 		WARN_ON(link->status != DL_STATE_DORMANT);
 		WRITE_ONCE(link->status, DL_STATE_AVAILABLE);
+
+		if (link->flags & DL_FLAG_AUTOPROBE_CONSUMER)
+			driver_deferred_probe_add(link->consumer);
 	}
 
 	list_for_each_entry(link, &dev->links.suppliers, c_node) {
diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 5f6416e6ba96..caaeb7910a04 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -116,7 +116,7 @@ static void deferred_probe_work_func(struct work_struct *work)
 }
 static DECLARE_WORK(deferred_probe_work, deferred_probe_work_func);
 
-static void driver_deferred_probe_add(struct device *dev)
+void driver_deferred_probe_add(struct device *dev)
 {
 	mutex_lock(&deferred_probe_mutex);
 	if (list_empty(&dev->p->deferred_probe)) {
diff --git a/include/linux/device.h b/include/linux/device.h
index c74ce473589a..7569cff2f4dc 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -339,6 +339,7 @@ struct device *driver_find_device(struct device_driver *drv,
 				  struct device *start, void *data,
 				  int (*match)(struct device *dev, void *data));
 
+void driver_deferred_probe_add(struct device *dev);
 int driver_deferred_probe_check_state(struct device *dev);
 
 /**
@@ -824,12 +825,14 @@ enum device_link_state {
  * PM_RUNTIME: If set, the runtime PM framework will use this link.
  * RPM_ACTIVE: Run pm_runtime_get_sync() on the supplier during link creation.
  * AUTOREMOVE_SUPPLIER: Remove the link automatically on supplier driver unbind.
+ * AUTOPROBE_CONSUMER: Probe consumer driver automatically after supplier binds.
  */
 #define DL_FLAG_STATELESS		BIT(0)
 #define DL_FLAG_AUTOREMOVE_CONSUMER	BIT(1)
 #define DL_FLAG_PM_RUNTIME		BIT(2)
 #define DL_FLAG_RPM_ACTIVE		BIT(3)
 #define DL_FLAG_AUTOREMOVE_SUPPLIER	BIT(4)
+#define DL_FLAG_AUTOPROBE_CONSUMER	BIT(5)
 
 /**
  * struct device_link - Device link representation.
-- 
2.25.1.481.gfbce0eb801-goog

