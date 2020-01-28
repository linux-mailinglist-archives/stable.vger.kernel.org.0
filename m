Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39CF314B99F
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:34:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731616AbgA1OYt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:24:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:51606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732757AbgA1OYp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:24:45 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8393124690;
        Tue, 28 Jan 2020 14:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580221485;
        bh=Jl/m6jnZp9jCJNCIyANC8hoEDN1lD6koiO7lkxw94EE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0YRoWhVoaVl7JodfndaXQceWJN06sOvrPDAqDGCbD94Mwoi1lg5wPJnZz6K27k78U
         sU7Ff1ERyK/C2uW1EYm4dtCMX2pkuDrzZZveYb6P1OuOokjiNS4h6OJbCe+7lpQWNI
         q7OxIyuygflyoJigAw+D07p/dIgBV7k32Oo4EG4k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 4.9 244/271] hwmon: (core) Simplify sysfs attribute name allocation
Date:   Tue, 28 Jan 2020 15:06:33 +0100
Message-Id: <20200128135910.690862660@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135852.449088278@linuxfoundation.org>
References: <20200128135852.449088278@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>

commit 3a412d5e4a1c831723d0aaf305f1cf9a78ad9c90 upstream.

Allocating the sysfs attribute name only if needed and only with the
required minimum length looks optimal, but does not take the additional
overhead for both devm_ data structures and the allocation header itself
into account. This also results in unnecessary memory fragmentation.
Move the sysfs name string into struct hwmon_device_attribute and give it
a sufficient length to reduce this overhead.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwmon/hwmon.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

--- a/drivers/hwmon/hwmon.c
+++ b/drivers/hwmon/hwmon.c
@@ -38,12 +38,15 @@ struct hwmon_device {
 
 #define to_hwmon_device(d) container_of(d, struct hwmon_device, dev)
 
+#define MAX_SYSFS_ATTR_NAME_LENGTH	32
+
 struct hwmon_device_attribute {
 	struct device_attribute dev_attr;
 	const struct hwmon_ops *ops;
 	enum hwmon_sensor_types type;
 	u32 attr;
 	int index;
+	char name[MAX_SYSFS_ATTR_NAME_LENGTH];
 };
 
 #define to_hwmon_attr(d) \
@@ -232,20 +235,18 @@ static struct attribute *hwmon_genattr(s
 	if ((mode & S_IWUGO) && !ops->write)
 		return ERR_PTR(-EINVAL);
 
+	hattr = devm_kzalloc(dev, sizeof(*hattr), GFP_KERNEL);
+	if (!hattr)
+		return ERR_PTR(-ENOMEM);
+
 	if (type == hwmon_chip) {
 		name = (char *)template;
 	} else {
-		name = devm_kzalloc(dev, strlen(template) + 16, GFP_KERNEL);
-		if (!name)
-			return ERR_PTR(-ENOMEM);
-		scnprintf(name, strlen(template) + 16, template,
+		scnprintf(hattr->name, sizeof(hattr->name), template,
 			  index + hwmon_attr_base(type));
+		name = hattr->name;
 	}
 
-	hattr = devm_kzalloc(dev, sizeof(*hattr), GFP_KERNEL);
-	if (!hattr)
-		return ERR_PTR(-ENOMEM);
-
 	hattr->type = type;
 	hattr->attr = attr;
 	hattr->index = index;


