Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBA3D192C18
	for <lists+stable@lfdr.de>; Wed, 25 Mar 2020 16:19:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727674AbgCYPS4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Mar 2020 11:18:56 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:35817 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727538AbgCYPS4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Mar 2020 11:18:56 -0400
Received: by mail-io1-f67.google.com with SMTP id h8so2607549iob.2;
        Wed, 25 Mar 2020 08:18:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PwggEMzU8RT5gVextfFr6ZJ6Cb6aIGerS+OjEWSFzGM=;
        b=YkpVvk3cpUbmjXv2VeeH2Ikrh7SX9x5/EHloC3St2zeSPBRHUqXv50iLZfQkXRg5tK
         ZZkMUu7dL5a3Pu7U3dA2uAI7kfGNCv8nu5CX85tiKXmh4eU0LGq7ccnIWio+DY3BTHf5
         4bsQ9iCjmPM5BTtS5z9o7331oaMl+Y3nFAH/hBOI65DTAptyvuoX/m6r/rGHlOII8ZG/
         oOD4ScOEf2HKK7lH0Mt6P/gAUSSeYEas9rqTfE0FzP8A2n2Nob9l4gNBG5h9P3pzCbPS
         aZSkidmSKAYAlEj5tzPNYBoccl5zYgKX4+ZzHPqW3jwdF5vU6RvcoTb3IIIZoVY/5c/x
         qMfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PwggEMzU8RT5gVextfFr6ZJ6Cb6aIGerS+OjEWSFzGM=;
        b=PY5r7EyGpAB4ghKrE3f4ilZ9cI6KOq34WkOZnyzDSCr0f4ikLu7wkG/a6zWBBAESy4
         Qxk/POYPZUKF/kWJwbGzcbKuvz7+eA0lECCgtABJzmzIMDqNp40MamxVKO0wsYJ+BejT
         AykM/lyvpknJqb2mItqXwKjkFPjYAwg+nbg8HtaQKauXjhZBpjDY+lJSu7wpx6d+oN2f
         G4DuE8C+Io38L985IFJcHa5u0bcDYIFMbRuIwwDfRPyx67PZLNWhl97H1vYJoZ0WYYOD
         zPPrwT5C4ZxS3zGFQ/d3ffoB4FIvC0cH316CaSafVYDmj6dNlsH5SEqlCejZs/fwlTfO
         YyZA==
X-Gm-Message-State: ANhLgQ3PuhiWUVGHmuFkqRsOnSNZ0yzIshTqZ7FfLk+bWakE6RV2dp3E
        aBSf6f5GdAiaJ7kXcqhZU+rmNoipn69CkA==
X-Google-Smtp-Source: ADFU+vuVIMdR6DiEq04mOyja+XcS0ozqbhcLQiUa4XHsN5xHWYdfm9KfOs0VanJglVKI+l/wSGA/5w==
X-Received: by 2002:a5d:89d1:: with SMTP id a17mr2846961iot.11.1585149535139;
        Wed, 25 Mar 2020 08:18:55 -0700 (PDT)
Received: from localhost.localdomain (c-73-243-191-173.hsd1.co.comcast.net. [73.243.191.173])
        by smtp.gmail.com with ESMTPSA id p68sm7544047ilb.80.2020.03.25.08.18.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2020 08:18:54 -0700 (PDT)
From:   Kelsey Skunberg <skunberg.kelsey@gmail.com>
To:     linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Cc:     rbilovol@cisco.com, ddutile@redhat.com, bodong@mellanox.com,
        linux-kernel-mentees@lists.linuxfoundation.org,
        skhan@linuxfoundation.org, ruslan.bilovol@gmail.com,
        bhelgaas@google.com, Kelsey Skunberg <kelsey.skunberg@gmail.com>,
        stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH v2] PCI: sysfs: Change bus_rescan and dev_rescan to rescan
Date:   Wed, 25 Mar 2020 09:17:08 -0600
Message-Id: <20200325151708.32612-1-skunberg.kelsey@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kelsey Skunberg <kelsey.skunberg@gmail.com>

rename device attribute name arguments 'bus_rescan' and 'dev_rescan' to 'rescan'
to avoid breaking userspace applications.

The attribute argument names were changed in the following commits:
8bdfa145f582 ("PCI: sysfs: Define device attributes with DEVICE_ATTR*()")
4e2b79436e4f ("PCI: sysfs: Change DEVICE_ATTR() to DEVICE_ATTR_WO()")

Revert the names used for attributes back to the names used before the above
patches were applied. This also requires to change DEVICE_ATTR_WO() to
DEVICE_ATTR() and __ATTR().

Note when using DEVICE_ATTR() the attribute is automatically named
dev_attr_<name>.attr. To avoid duplicated names between attributes, use
__ATTR() instead of DEVICE_ATTR() to a assign a custom attribute name for
dev_rescan.

change bus_rescan_store() to dev_bus_rescan_store() to complete matching the
names used before the mentioned patches were applied.

Fixes: 8bdfa145f582 ("PCI: sysfs: Define device attributes with DEVICE_ATTR*()")
Fixes: 4e2b79436e4f ("PCI: sysfs: Change DEVICE_ATTR() to DEVICE_ATTR_WO()")

Cc: stable <stable@vger.kernel.org>
Signed-off-by: Kelsey Skunberg <kelsey.skunberg@gmail.com>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---

v2 updates: 
	commit log updated to include 'Fixes: *' and Cc: stable to aid commit
	being backported properly.

 drivers/pci/pci-sysfs.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index 13f766db0684..667e13d597ff 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -464,7 +464,10 @@ static ssize_t dev_rescan_store(struct device *dev,
 	}
 	return count;
 }
-static DEVICE_ATTR_WO(dev_rescan);
+static struct device_attribute dev_rescan_attr = __ATTR(rescan,
+							0220, NULL,
+							dev_rescan_store);
+
 
 static ssize_t remove_store(struct device *dev, struct device_attribute *attr,
 			    const char *buf, size_t count)
@@ -481,9 +484,9 @@ static ssize_t remove_store(struct device *dev, struct device_attribute *attr,
 static DEVICE_ATTR_IGNORE_LOCKDEP(remove, 0220, NULL,
 				  remove_store);
 
-static ssize_t bus_rescan_store(struct device *dev,
-				struct device_attribute *attr,
-				const char *buf, size_t count)
+static ssize_t dev_bus_rescan_store(struct device *dev,
+				    struct device_attribute *attr,
+				    const char *buf, size_t count)
 {
 	unsigned long val;
 	struct pci_bus *bus = to_pci_bus(dev);
@@ -501,7 +504,7 @@ static ssize_t bus_rescan_store(struct device *dev,
 	}
 	return count;
 }
-static DEVICE_ATTR_WO(bus_rescan);
+static DEVICE_ATTR(rescan, 0220, NULL, dev_bus_rescan_store);
 
 #if defined(CONFIG_PM) && defined(CONFIG_ACPI)
 static ssize_t d3cold_allowed_store(struct device *dev,
@@ -641,7 +644,7 @@ static struct attribute *pcie_dev_attrs[] = {
 };
 
 static struct attribute *pcibus_attrs[] = {
-	&dev_attr_bus_rescan.attr,
+	&dev_attr_rescan.attr,
 	&dev_attr_cpuaffinity.attr,
 	&dev_attr_cpulistaffinity.attr,
 	NULL,
@@ -1487,7 +1490,7 @@ static umode_t pci_dev_attrs_are_visible(struct kobject *kobj,
 
 static struct attribute *pci_dev_hp_attrs[] = {
 	&dev_attr_remove.attr,
-	&dev_attr_dev_rescan.attr,
+	&dev_rescan_attr.attr,
 	NULL,
 };
 
-- 
2.20.1

