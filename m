Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FCE2201862
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 19:01:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733289AbgFSOiY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 10:38:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:55350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387850AbgFSOiT (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 10:38:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 675D920DD4;
        Fri, 19 Jun 2020 14:38:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592577498;
        bh=QwZlJF/+R4YdAmj1GKRzB0FndTtKAoGvvrxX8c0MfLQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zD3ohIFT+E3ig8MuPO9Kdtr2THXAWWrUgoJgtybVgG7YstXS6bPhN+2mmF2uC1zoY
         pxfWmABQZU36ro3+ZXQpezfJFRNrVdieJAlvCGhUbb8zMItnscw1X1Sno/VWguIi2Z
         Kp8jQTfQkZd4tOaaU9nwXabtMKGyujgLJvaW7M5M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qiushi Wu <wu000273@umn.edu>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 075/101] cpuidle: Fix three reference count leaks
Date:   Fri, 19 Jun 2020 16:33:04 +0200
Message-Id: <20200619141617.938289499@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141614.001544111@linuxfoundation.org>
References: <20200619141614.001544111@linuxfoundation.org>
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
 drivers/cpuidle/sysfs.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/cpuidle/sysfs.c
+++ b/drivers/cpuidle/sysfs.c
@@ -412,7 +412,7 @@ static int cpuidle_add_state_sysfs(struc
 		ret = kobject_init_and_add(&kobj->kobj, &ktype_state_cpuidle,
 					   &kdev->kobj, "state%d", i);
 		if (ret) {
-			kfree(kobj);
+			kobject_put(&kobj->kobj);
 			goto error_state;
 		}
 		kobject_uevent(&kobj->kobj, KOBJ_ADD);
@@ -542,7 +542,7 @@ static int cpuidle_add_driver_sysfs(stru
 	ret = kobject_init_and_add(&kdrv->kobj, &ktype_driver_cpuidle,
 				   &kdev->kobj, "driver");
 	if (ret) {
-		kfree(kdrv);
+		kobject_put(&kdrv->kobj);
 		return ret;
 	}
 
@@ -636,7 +636,7 @@ int cpuidle_add_sysfs(struct cpuidle_dev
 	error = kobject_init_and_add(&kdev->kobj, &ktype_cpuidle, &cpu_dev->kobj,
 				   "cpuidle");
 	if (error) {
-		kfree(kdev);
+		kobject_put(&kdev->kobj);
 		return error;
 	}
 


