Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 130AB2014DA
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:21:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390883AbgFSPCp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:02:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:59350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390876AbgFSPCn (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:02:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8B50A21841;
        Fri, 19 Jun 2020 15:02:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592578963;
        bh=vLM00da0dcPE+XpMqn8kxehxh+b2qBbY1T82WW91wwQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b0zoFdov4rbFAdP1zmzQrEiqpDIw70de+OGSeEvLhmpLU77OaqTlATPKAFWP9S0v4
         NhoWxbGIKF/iCCX4lVA65uPtFVJ0fTTniA8HDSA6A9p+KjwFMH8LBzP8XQRtANIHR4
         JhwBYW0YJyK7tKS+ShVHerx7GAJZ4ka+SyYHO8aQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qiushi Wu <wu000273@umn.edu>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 183/267] cpuidle: Fix three reference count leaks
Date:   Fri, 19 Jun 2020 16:32:48 +0200
Message-Id: <20200619141657.547951085@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141648.840376470@linuxfoundation.org>
References: <20200619141648.840376470@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index e754c7aae7f7..66979dc33680 100644
--- a/drivers/cpuidle/sysfs.c
+++ b/drivers/cpuidle/sysfs.c
@@ -467,7 +467,7 @@ static int cpuidle_add_state_sysfs(struct cpuidle_device *device)
 		ret = kobject_init_and_add(&kobj->kobj, &ktype_state_cpuidle,
 					   &kdev->kobj, "state%d", i);
 		if (ret) {
-			kfree(kobj);
+			kobject_put(&kobj->kobj);
 			goto error_state;
 		}
 		cpuidle_add_s2idle_attr_group(kobj);
@@ -598,7 +598,7 @@ static int cpuidle_add_driver_sysfs(struct cpuidle_device *dev)
 	ret = kobject_init_and_add(&kdrv->kobj, &ktype_driver_cpuidle,
 				   &kdev->kobj, "driver");
 	if (ret) {
-		kfree(kdrv);
+		kobject_put(&kdrv->kobj);
 		return ret;
 	}
 
@@ -692,7 +692,7 @@ int cpuidle_add_sysfs(struct cpuidle_device *dev)
 	error = kobject_init_and_add(&kdev->kobj, &ktype_cpuidle, &cpu_dev->kobj,
 				   "cpuidle");
 	if (error) {
-		kfree(kdev);
+		kobject_put(&kdev->kobj);
 		return error;
 	}
 
-- 
2.25.1



