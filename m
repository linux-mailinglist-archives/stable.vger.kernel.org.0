Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A7E21FB749
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 17:47:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730157AbgFPPon (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 11:44:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:35232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732011AbgFPPom (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:44:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E72B21475;
        Tue, 16 Jun 2020 15:44:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592322282;
        bh=z8VABR2iloijjO5oU3eoMWMuhLAhwBXfYG9CbcWJDuk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zNHLxZ3mHYk8Ictk7lMHhJEb2YgGjjThphmoOaLE4hriz5V3Q/8hQ4o0tsCwP9jGK
         uPotw2JPFV8lT/oSj4yxzQNGbOvEgaPRoSIqomyF3dnBUyCR23wCUmZ8At9lk4RFvT
         cm1V73KbhJeRbm35YipWpJ2/NqjPS0993Y8mIe8U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qiushi Wu <wu000273@umn.edu>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.7 072/163] ACPI: sysfs: Fix reference count leak in acpi_sysfs_add_hotplug_profile()
Date:   Tue, 16 Jun 2020 17:34:06 +0200
Message-Id: <20200616153110.296258349@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153106.849127260@linuxfoundation.org>
References: <20200616153106.849127260@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qiushi Wu <wu000273@umn.edu>

commit 6e6c25283dff866308c87b49434c7dbad4774cc0 upstream.

kobject_init_and_add() takes reference even when it fails.
Thus, when kobject_init_and_add() returns an error,
kobject_put() must be called to properly clean up the kobject.

Fixes: 3f8055c35836 ("ACPI / hotplug: Introduce user space interface for hotplug profiles")
Signed-off-by: Qiushi Wu <wu000273@umn.edu>
Cc: 3.10+ <stable@vger.kernel.org> # 3.10+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/sysfs.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/acpi/sysfs.c
+++ b/drivers/acpi/sysfs.c
@@ -993,8 +993,10 @@ void acpi_sysfs_add_hotplug_profile(stru
 
 	error = kobject_init_and_add(&hotplug->kobj,
 		&acpi_hotplug_profile_ktype, hotplug_kobj, "%s", name);
-	if (error)
+	if (error) {
+		kobject_put(&hotplug->kobj);
 		goto err_out;
+	}
 
 	kobject_uevent(&hotplug->kobj, KOBJ_ADD);
 	return;


