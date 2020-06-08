Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D44FF1F25AA
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 01:30:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732255AbgFHX2n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 19:28:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:58508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732249AbgFHX2l (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:28:41 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 78C8920899;
        Mon,  8 Jun 2020 23:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658921;
        bh=ePq/fBYgkru+4gDc00SaMaz/zDT+26mobWEOghmA9Bc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JYCi5rym9Xx/5mTDImY7pqjWG7V+iRzrZNP0lGES7HdYa1NgwQImesQypFlBQf54O
         kcfRQWbnx7B3WF9a4qFTppy/RBpo8qIHYY1iIndCR6LnYpiN+MRpq77pN1UU9xi403
         J/YcLWkXJWHCbD1pDPlrFkfem/C/zcGnqaJsi7OI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qiushi Wu <wu000273@umn.edu>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 36/37] cpuidle: Fix three reference count leaks
Date:   Mon,  8 Jun 2020 19:27:48 -0400
Message-Id: <20200608232750.3370747-36-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608232750.3370747-1-sashal@kernel.org>
References: <20200608232750.3370747-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qiushi Wu <wu000273@umn.edu>

[ Upstream commit c343bf1ba5efcbf2266a1fe3baefec9cc82f867f ]

kobject_init_and_add() takes reference even when it fails.
If this function returns an error, kobject_put() must be called to
properly clean up the memory associated with the object.

Previous commit "b8eb718348b8" fixed a similar problem.

Signed-off-by: Qiushi Wu <wu000273@umn.edu>
[ rjw: Subject ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpuidle/sysfs.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/cpuidle/sysfs.c b/drivers/cpuidle/sysfs.c
index 9e98a5fbbc1d..e7e92ed34f0c 100644
--- a/drivers/cpuidle/sysfs.c
+++ b/drivers/cpuidle/sysfs.c
@@ -412,7 +412,7 @@ static int cpuidle_add_state_sysfs(struct cpuidle_device *device)
 		ret = kobject_init_and_add(&kobj->kobj, &ktype_state_cpuidle,
 					   &kdev->kobj, "state%d", i);
 		if (ret) {
-			kfree(kobj);
+			kobject_put(&kobj->kobj);
 			goto error_state;
 		}
 		kobject_uevent(&kobj->kobj, KOBJ_ADD);
@@ -542,7 +542,7 @@ static int cpuidle_add_driver_sysfs(struct cpuidle_device *dev)
 	ret = kobject_init_and_add(&kdrv->kobj, &ktype_driver_cpuidle,
 				   &kdev->kobj, "driver");
 	if (ret) {
-		kfree(kdrv);
+		kobject_put(&kdrv->kobj);
 		return ret;
 	}
 
@@ -636,7 +636,7 @@ int cpuidle_add_sysfs(struct cpuidle_device *dev)
 	error = kobject_init_and_add(&kdev->kobj, &ktype_cpuidle, &cpu_dev->kobj,
 				   "cpuidle");
 	if (error) {
-		kfree(kdev);
+		kobject_put(&kdev->kobj);
 		return error;
 	}
 
-- 
2.25.1

