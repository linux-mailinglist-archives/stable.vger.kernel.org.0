Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEC0B366B94
	for <lists+stable@lfdr.de>; Wed, 21 Apr 2021 15:03:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240369AbhDUNDe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Apr 2021 09:03:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:43388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240429AbhDUNDc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 21 Apr 2021 09:03:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD67E61454;
        Wed, 21 Apr 2021 13:02:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619010178;
        bh=ilvzIN6tfgWcTf+MVyrxYFtWxIWfTtX5v7354GDmkIg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T+JojEH88BXUSmE4s561Lf9+0matDXs9veSkqyfO7gXaSzhFRtzTJOqhPRpoJV9o1
         ecXv/g5iDC1wGV2Qsc7CiMw3f4ObvPvhp8iSd2i4o4sjz9qAX2DjS/wV2bFhJ9cPQv
         DZ/GE31heE2g0z0H1e6Vf790u81JoMFKB4tUibK0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Qiushi Wu <wu000273@umn.edu>,
        "3 . 10+" <stable@vger.kernel.org>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 041/190] Revert "ACPI: sysfs: Fix reference count leak in acpi_sysfs_add_hotplug_profile()"
Date:   Wed, 21 Apr 2021 14:58:36 +0200
Message-Id: <20210421130105.1226686-42-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210421130105.1226686-1-gregkh@linuxfoundation.org>
References: <20210421130105.1226686-1-gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit 6e6c25283dff866308c87b49434c7dbad4774cc0.

Commits from @umn.edu addresses have been found to be submitted in "bad
faith" to try to test the kernel community's ability to review "known
malicious" changes.  The result of these submissions can be found in a
paper published at the 42nd IEEE Symposium on Security and Privacy
entitled, "Open Source Insecurity: Stealthily Introducing
Vulnerabilities via Hypocrite Commits" written by Qiushi Wu (University
of Minnesota) and Kangjie Lu (University of Minnesota).

Because of this, all submissions from this group must be reverted from
the kernel tree and will need to be re-reviewed again to determine if
they actually are a valid fix.  Until that work is complete, remove this
change to ensure that no problems are being introduced into the
codebase.

Cc: Qiushi Wu <wu000273@umn.edu>
Cc: 3.10+ <stable@vger.kernel.org> # 3.10+
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/sysfs.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/acpi/sysfs.c b/drivers/acpi/sysfs.c
index 8baf7644a0d0..842bf63b91e9 100644
--- a/drivers/acpi/sysfs.c
+++ b/drivers/acpi/sysfs.c
@@ -986,10 +986,8 @@ void acpi_sysfs_add_hotplug_profile(struct acpi_hotplug_profile *hotplug,
 
 	error = kobject_init_and_add(&hotplug->kobj,
 		&acpi_hotplug_profile_ktype, hotplug_kobj, "%s", name);
-	if (error) {
-		kobject_put(&hotplug->kobj);
+	if (error)
 		goto err_out;
-	}
 
 	kobject_uevent(&hotplug->kobj, KOBJ_ADD);
 	return;
-- 
2.31.1

