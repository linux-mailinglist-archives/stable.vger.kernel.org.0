Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A21C7452770
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 03:22:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237899AbhKPCZL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 21:25:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:53172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237471AbhKORYu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:24:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CCC8D63283;
        Mon, 15 Nov 2021 17:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636996670;
        bh=7IcZfBjUKltYjlbSxAUUm/t9fmDHrBNMuG8f4NLKptI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q7IhQ4MwjxsibJAfyhLaS6tvVMsi14UoPYfkD17BU/KlIQo8RMVKzwuihAfg+URV7
         153B6VhW8FwLwZyYPL4/mz+GUVq8V+luYjmqS+6K+fIRD0lQ/neF+n7P+6NYbxd4eU
         9iekqDynMKSYe83KsDx/KfN9DeUXpnEv8DehYWt0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anel Orazgaliyeva <anelkz@amazon.de>,
        Aman Priyadarshi <apeureka@amazon.de>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 207/355] cpuidle: Fix kobject memory leaks in error paths
Date:   Mon, 15 Nov 2021 18:02:11 +0100
Message-Id: <20211115165320.466726675@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165313.549179499@linuxfoundation.org>
References: <20211115165313.549179499@linuxfoundation.org>
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
index f8747322b3c70..e591f56f98c03 100644
--- a/drivers/cpuidle/sysfs.c
+++ b/drivers/cpuidle/sysfs.c
@@ -481,6 +481,7 @@ static int cpuidle_add_state_sysfs(struct cpuidle_device *device)
 					   &kdev->kobj, "state%d", i);
 		if (ret) {
 			kobject_put(&kobj->kobj);
+			kfree(kobj);
 			goto error_state;
 		}
 		cpuidle_add_s2idle_attr_group(kobj);
@@ -612,6 +613,7 @@ static int cpuidle_add_driver_sysfs(struct cpuidle_device *dev)
 				   &kdev->kobj, "driver");
 	if (ret) {
 		kobject_put(&kdrv->kobj);
+		kfree(kdrv);
 		return ret;
 	}
 
@@ -698,7 +700,6 @@ int cpuidle_add_sysfs(struct cpuidle_device *dev)
 	if (!kdev)
 		return -ENOMEM;
 	kdev->dev = dev;
-	dev->kobj_dev = kdev;
 
 	init_completion(&kdev->kobj_unregister);
 
@@ -706,9 +707,11 @@ int cpuidle_add_sysfs(struct cpuidle_device *dev)
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



