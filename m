Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5149845BDD8
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:39:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344967AbhKXMlX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:41:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:35696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344974AbhKXMjC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:39:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 605F3613BD;
        Wed, 24 Nov 2021 12:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637756608;
        bh=ak1/9A/oX7Qv4EJ9zRp/nb/xwODyx71g0AZTwBPyOmU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=II4Cb7vWu+yAcv7Xrdcf0+wlwgNH3GxdRJK7nKUOQmqBV4Ns0uKEwVL0nSLZIT4u1
         6iVvu8o4aSkZZWJarZZmuHyuXEdzgz99r4w5WhOENSFR6U2zz1fINgIE1tCHPyghyN
         ECCkU0BlmDM8CqYRpeBGiISKLZurCkEXRg/padCw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anel Orazgaliyeva <anelkz@amazon.de>,
        Aman Priyadarshi <apeureka@amazon.de>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 111/251] cpuidle: Fix kobject memory leaks in error paths
Date:   Wed, 24 Nov 2021 12:55:53 +0100
Message-Id: <20211124115714.093531233@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115710.214900256@linuxfoundation.org>
References: <20211124115710.214900256@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anel Orazgaliyeva <anelkz@amazon.de>

[ Upstream commit e5f5a66c9aa9c331da5527c2e3fd9394e7091e01 ]

Commit c343bf1ba5ef ("cpuidle: Fix three reference count leaks")
fixes the cleanup of kobjects; however, it removes kfree() calls
altogether, leading to memory leaks.

Fix those and also defer the initialization of dev->kobj_dev until
after the error check, so that we do not end up with a dangling
pointer.

Fixes: c343bf1ba5ef ("cpuidle: Fix three reference count leaks")
Signed-off-by: Anel Orazgaliyeva <anelkz@amazon.de>
Suggested-by: Aman Priyadarshi <apeureka@amazon.de>
[ rjw: Subject edits ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpuidle/sysfs.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/cpuidle/sysfs.c b/drivers/cpuidle/sysfs.c
index 909bd2255978b..a29d7a6e68487 100644
--- a/drivers/cpuidle/sysfs.c
+++ b/drivers/cpuidle/sysfs.c
@@ -415,6 +415,7 @@ static int cpuidle_add_state_sysfs(struct cpuidle_device *device)
 					   &kdev->kobj, "state%d", i);
 		if (ret) {
 			kobject_put(&kobj->kobj);
+			kfree(kobj);
 			goto error_state;
 		}
 		kobject_uevent(&kobj->kobj, KOBJ_ADD);
@@ -545,6 +546,7 @@ static int cpuidle_add_driver_sysfs(struct cpuidle_device *dev)
 				   &kdev->kobj, "driver");
 	if (ret) {
 		kobject_put(&kdrv->kobj);
+		kfree(kdrv);
 		return ret;
 	}
 
@@ -631,7 +633,6 @@ int cpuidle_add_sysfs(struct cpuidle_device *dev)
 	if (!kdev)
 		return -ENOMEM;
 	kdev->dev = dev;
-	dev->kobj_dev = kdev;
 
 	init_completion(&kdev->kobj_unregister);
 
@@ -639,9 +640,11 @@ int cpuidle_add_sysfs(struct cpuidle_device *dev)
 				   "cpuidle");
 	if (error) {
 		kobject_put(&kdev->kobj);
+		kfree(kdev);
 		return error;
 	}
 
+	dev->kobj_dev = kdev;
 	kobject_uevent(&kdev->kobj, KOBJ_ADD);
 
 	return 0;
-- 
2.33.0



