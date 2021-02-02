Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4EB230C08F
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 15:02:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233430AbhBBOBZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 09:01:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:46320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233150AbhBBN7Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:59:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5720B64DD5;
        Tue,  2 Feb 2021 13:46:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273578;
        bh=GSJkFq/em2yA7BwCWM8LJkhhE5WPg9OYPmmnvEewQ/g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xF2SVVc6b1RVxmkHyF6ko3Camou/CpkqFbOCaT+b/alkgTlcup4nh4+aSBZSuV18Q
         LZ926l98PT2JUy0tGWeFtr+QF5j0dmf9Pk/1JR0hZPNHJqXqE9WdRJ1Wa8D3G0c+mH
         OjW1Gk2AY7xO+RATKSKprGJhuVrWAQXJ3IhIgx8g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.4 04/61] ACPI: sysfs: Prefer "compatible" modalias
Date:   Tue,  2 Feb 2021 14:37:42 +0100
Message-Id: <20210202132946.668113402@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132946.480479453@linuxfoundation.org>
References: <20210202132946.480479453@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

commit 36af2d5c4433fb40ee2af912c4ac0a30991aecfc upstream.

Commit 8765c5ba1949 ("ACPI / scan: Rework modalias creation when
"compatible" is present") may create two "MODALIAS=" in one uevent
file if specific conditions are met.

This breaks systemd-udevd, which assumes each "key" in one uevent file
to be unique. The internal implementation of systemd-udevd overwrites
the first MODALIAS with the second one, so its kmod rule doesn't load
the driver for the first MODALIAS.

So if both the ACPI modalias and the OF modalias are present, use the
latter to ensure that there will be only one MODALIAS.

Link: https://github.com/systemd/systemd/pull/18163
Suggested-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Fixes: 8765c5ba1949 ("ACPI / scan: Rework modalias creation when "compatible" is present")
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: 4.1+ <stable@vger.kernel.org> # 4.1+
[ rjw: Subject and changelog edits ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/device_sysfs.c |   20 ++++++--------------
 1 file changed, 6 insertions(+), 14 deletions(-)

--- a/drivers/acpi/device_sysfs.c
+++ b/drivers/acpi/device_sysfs.c
@@ -251,20 +251,12 @@ int __acpi_device_uevent_modalias(struct
 	if (add_uevent_var(env, "MODALIAS="))
 		return -ENOMEM;
 
-	len = create_pnp_modalias(adev, &env->buf[env->buflen - 1],
-				  sizeof(env->buf) - env->buflen);
-	if (len < 0)
-		return len;
-
-	env->buflen += len;
-	if (!adev->data.of_compatible)
-		return 0;
-
-	if (len > 0 && add_uevent_var(env, "MODALIAS="))
-		return -ENOMEM;
-
-	len = create_of_modalias(adev, &env->buf[env->buflen - 1],
-				 sizeof(env->buf) - env->buflen);
+	if (adev->data.of_compatible)
+		len = create_of_modalias(adev, &env->buf[env->buflen - 1],
+					 sizeof(env->buf) - env->buflen);
+	else
+		len = create_pnp_modalias(adev, &env->buf[env->buflen - 1],
+					  sizeof(env->buf) - env->buflen);
 	if (len < 0)
 		return len;
 


