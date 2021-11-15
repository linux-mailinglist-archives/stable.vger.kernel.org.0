Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72F924521CB
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:04:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353579AbhKPBGw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:06:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:44648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245386AbhKOTU0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:20:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0D46563535;
        Mon, 15 Nov 2021 18:33:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001226;
        bh=+y278zBEDQ1fqVOLstLpNxijn85+NAhFtAVSAsQdi2s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EFkroiWG4+wGmS8FhpmwI7GrBBCwSPcSBUIQOe3ToWgM9kLbEIFyolbfojnECChI3
         Y3S55vkws4BaGUixQlLeyqdDmAJV2RsPpRU8Kv5ubC61U7LgSzcGZ8rjhWtRho5bBm
         XvAE40YgoKV45OHikBqjeA0p0CTkAnfk1BdMHXn0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.15 092/917] PM: sleep: Do not let "syscore" devices runtime-suspend during system transitions
Date:   Mon, 15 Nov 2021 17:53:07 +0100
Message-Id: <20211115165431.866728265@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit 928265e3601cde78c7e0a3e518a93b27defed3b1 upstream.

There is no reason to allow "syscore" devices to runtime-suspend
during system-wide PM transitions, because they are subject to the
same possible failure modes as any other devices in that respect.

Accordingly, change device_prepare() and device_complete() to call
pm_runtime_get_noresume() and pm_runtime_put(), respectively, for
"syscore" devices too.

Fixes: 057d51a1268f ("Merge branch 'pm-sleep'")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: 3.10+ <stable@vger.kernel.org> # 3.10+
Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/power/main.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -1051,7 +1051,7 @@ static void device_complete(struct devic
 	const char *info = NULL;
 
 	if (dev->power.syscore)
-		return;
+		goto out;
 
 	device_lock(dev);
 
@@ -1081,6 +1081,7 @@ static void device_complete(struct devic
 
 	device_unlock(dev);
 
+out:
 	pm_runtime_put(dev);
 }
 
@@ -1794,9 +1795,6 @@ static int device_prepare(struct device
 	int (*callback)(struct device *) = NULL;
 	int ret = 0;
 
-	if (dev->power.syscore)
-		return 0;
-
 	/*
 	 * If a device's parent goes into runtime suspend at the wrong time,
 	 * it won't be possible to resume the device.  To prevent this we
@@ -1805,6 +1803,9 @@ static int device_prepare(struct device
 	 */
 	pm_runtime_get_noresume(dev);
 
+	if (dev->power.syscore)
+		return 0;
+
 	device_lock(dev);
 
 	dev->power.wakeup_path = false;


