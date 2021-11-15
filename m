Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 492384510B6
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:50:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242574AbhKOSxG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:53:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:54308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240279AbhKOSuT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:50:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 435B2633A7;
        Mon, 15 Nov 2021 18:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999721;
        bh=1b1DCiBnuzfdBPAF32D2UpkHdSRFO5JOBtELVSsR/CE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K29W1PwiQQyWPGYpmZSDUI3SDZyTkEXNrvSBirvQaSQ/MCvt/bkQxbMEQDnAtQPbZ
         yb5FRHlUWK0VBOCCQdlfiAKjnK1N1GBgMb05C5YRHUvHSXZuZwcSGU50xwZojeS3T0
         eVkqNLsjdTIr9dKcsRkdxTfihmSse37hbA4ToT9w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anel Orazgaliyeva <anelkz@amazon.de>,
        Aman Priyadarshi <apeureka@amazon.de>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 400/849] cpuidle: Fix kobject memory leaks in error paths
Date:   Mon, 15 Nov 2021 17:58:03 +0100
Message-Id: <20211115165433.788385212@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
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
index 53ec9585ccd44..469e18547d06c 100644
--- a/drivers/cpuidle/sysfs.c
+++ b/drivers/cpuidle/sysfs.c
@@ -488,6 +488,7 @@ static int cpuidle_add_state_sysfs(struct cpuidle_device *device)
 					   &kdev->kobj, "state%d", i);
 		if (ret) {
 			kobject_put(&kobj->kobj);
+			kfree(kobj);
 			goto error_state;
 		}
 		cpuidle_add_s2idle_attr_group(kobj);
@@ -619,6 +620,7 @@ static int cpuidle_add_driver_sysfs(struct cpuidle_device *dev)
 				   &kdev->kobj, "driver");
 	if (ret) {
 		kobject_put(&kdrv->kobj);
+		kfree(kdrv);
 		return ret;
 	}
 
@@ -705,7 +707,6 @@ int cpuidle_add_sysfs(struct cpuidle_device *dev)
 	if (!kdev)
 		return -ENOMEM;
 	kdev->dev = dev;
-	dev->kobj_dev = kdev;
 
 	init_completion(&kdev->kobj_unregister);
 
@@ -713,9 +714,11 @@ int cpuidle_add_sysfs(struct cpuidle_device *dev)
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



