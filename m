Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AF552C086C
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:16:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733218AbgKWMvA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:51:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:35182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387585AbgKWMuc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:50:32 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6F5532100A;
        Mon, 23 Nov 2020 12:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135823;
        bh=uFJsSGwd2OXnVl1xi4TGrsfTL2nOokD6AoShrLsFdX4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EaZunY43ExV4Zc+EdWLfmf9Z/t2X2hqHycxE+uoobIh3ajt7acNpCVH46p7f9VPEt
         P3ZVRuIK3kEHlC9As4MVSaY2TQ2IzAc+MnjVz1Jw6b5ylrUEruyCkiu4cU7gxACE5U
         xza30RA7KDaWlw6wwSK7euIIPoonOmcrAgOKp8MY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.9 207/252] ACPI: fan: Initialize performance state sysfs attribute
Date:   Mon, 23 Nov 2020 13:22:37 +0100
Message-Id: <20201123121845.553889393@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>

commit 7dc7a8b04f3da8aa3c3be514e155e2fa094e976f upstream.

The following warning is reported if lock debugging is enabled.

DEBUG_LOCKS_WARN_ON(1)
WARNING: CPU: 1 PID: 1 at kernel/locking/lockdep.c:4617 lockdep_init_map_waits+0x141/0x222
...
Call Trace:
 __kernfs_create_file+0x7a/0xd8
 sysfs_add_file_mode_ns+0x135/0x189
 sysfs_create_file_ns+0x70/0xa0
 acpi_fan_probe+0x547/0x621
 platform_drv_probe+0x67/0x8b
 ...

Dynamically allocated sysfs attributes need to be initialized to avoid
the warning.

Fixes: d19e470b6605 ("ACPI: fan: Expose fan performance state information")
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Cc: 5.6+ <stable@vger.kernel.org> # 5.6+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/fan.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/acpi/fan.c
+++ b/drivers/acpi/fan.c
@@ -351,6 +351,7 @@ static int acpi_fan_get_fps(struct acpi_
 		struct acpi_fan_fps *fps = &fan->fps[i];
 
 		snprintf(fps->name, ACPI_FPS_NAME_LEN, "state%d", i);
+		sysfs_attr_init(&fps->dev_attr.attr);
 		fps->dev_attr.show = show_state;
 		fps->dev_attr.store = NULL;
 		fps->dev_attr.attr.name = fps->name;


