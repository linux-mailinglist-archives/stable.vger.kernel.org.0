Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25E9A9B5BA
	for <lists+stable@lfdr.de>; Fri, 23 Aug 2019 19:49:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728885AbfHWRsW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Aug 2019 13:48:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34648 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725892AbfHWRsV (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 23 Aug 2019 13:48:21 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id AC5973058E0A;
        Fri, 23 Aug 2019 17:48:21 +0000 (UTC)
Received: from dhcp-44-196.space.revspace.nl (unknown [10.36.112.14])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 05B705D9CA;
        Fri, 23 Aug 2019 17:48:19 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>
Cc:     Hans de Goede <hdegoede@redhat.com>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH 1/2] platform/x86: intel_int0002_vgpio: Fix wakeups not working on Cherry Trail
Date:   Fri, 23 Aug 2019 19:48:14 +0200
Message-Id: <20190823174815.27861-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Fri, 23 Aug 2019 17:48:21 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 871f1f2bcb01 ("platform/x86: intel_int0002_vgpio: Only implement
irq_set_wake on Bay Trail") removed the irq_set_wake method from the
struct irq_chip used on Cherry Trail, but it did not set
IRQCHIP_SKIP_SET_WAKE causing  kernel/irq/manage.c: set_irq_wake_real()
to return -ENXIO.

This causes the kernel to no longer see PME events reported through the
INT0002 device as wakeup events. Which e.g. breaks wakeup by the (USB)
keyboard on many Cherry Trail 2-in-1 devices.

Cc: stable@vger.kernel.org
Fixes: 871f1f2bcb01 ("platform/x86: intel_int0002_vgpio: Only implement irq_set_wake on Bay Trail")
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/platform/x86/intel_int0002_vgpio.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/x86/intel_int0002_vgpio.c b/drivers/platform/x86/intel_int0002_vgpio.c
index d9542c661ddc..9ea1a2a19f86 100644
--- a/drivers/platform/x86/intel_int0002_vgpio.c
+++ b/drivers/platform/x86/intel_int0002_vgpio.c
@@ -144,6 +144,7 @@ static struct irq_chip int0002_cht_irqchip = {
 	 * No set_wake, on CHT the IRQ is typically shared with the ACPI SCI
 	 * and we don't want to mess with the ACPI SCI irq settings.
 	 */
+	.flags			= IRQCHIP_SKIP_SET_WAKE,
 };
 
 static const struct x86_cpu_id int0002_cpu_ids[] = {
-- 
2.22.0

