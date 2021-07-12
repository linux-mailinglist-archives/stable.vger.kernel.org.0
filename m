Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFCD63C5228
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:49:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349898AbhGLHo5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:44:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:46792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348149AbhGLHkq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:40:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B5F9160FF3;
        Mon, 12 Jul 2021 07:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075478;
        bh=uO7B9kAN4Ym7R2aVL62WvBNNwwYLwzp4Wp8NCOn3lSA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ssLT1Rs6NBl3ULgKb30jRr2bbJ9gFnlday9KAZZzeenhS6Am7SJW1sfl9qUK4zbzb
         Bp8+ayutbJ2TIl4Hu30xdVVfot9r87YISOwdT+ChSla8UoaSh5YLx72LcIsTSb7gMm
         znTZnOOzImc4yGV/RzQdmofAoxMyIMfFAUzS90jU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Manuel Krause <manuelkrause@netscape.net>,
        Hui Wang <hui.wang@canonical.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 233/800] ACPI: resources: Add checks for ACPI IRQ override
Date:   Mon, 12 Jul 2021 08:04:16 +0200
Message-Id: <20210712060946.556723112@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hui Wang <hui.wang@canonical.com>

[ Upstream commit 0ec4e55e9f571f08970ed115ec0addc691eda613 ]

The laptop keyboard doesn't work on many MEDION notebooks, but the
keyboard works well under Windows and Unix.

Through debugging, we found this log in the dmesg:

 ACPI: IRQ 1 override to edge, high
 pnp 00:03: Plug and Play ACPI device, IDs PNP0303 (active)

 And we checked the IRQ definition in the DSDT, it is:

    IRQ (Level, ActiveLow, Exclusive, )
        {1}

So the BIOS defines the keyboard IRQ to Level_Low, but the Linux
kernel override it to Edge_High. If the Linux kernel is modified
to skip the IRQ override, the keyboard will work normally.

>From the existing comment in acpi_dev_get_irqresource(), the override
function only needs to be called when IRQ() or IRQNoFlags() is used
to populate the resource descriptor, and according to Section 6.4.2.1
of ACPI 6.4 [1], if IRQ() is empty or IRQNoFlags() is used, the IRQ
is High true, edge sensitive and non-shareable. ACPICA also assumes
that to be the case (see acpi_rs_set_irq[] in rsirq.c).

In accordance with the above, check 3 additional conditions
(EdgeSensitive, ActiveHigh and Exclusive) when deciding whether or
not to treat an ACPI_RESOURCE_TYPE_IRQ resource as "legacy", in which
case the IRQ override is applicable to it.

Link: https://uefi.org/specs/ACPI/6.4/06_Device_Configuration/Device_Configuration.html#irq-descriptor # [1]
BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=213031
BugLink: http://bugs.launchpad.net/bugs/1909814
Suggested-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reported-by: Manuel Krause <manuelkrause@netscape.net>
Tested-by: Manuel Krause <manuelkrause@netscape.net>
Signed-off-by: Hui Wang <hui.wang@canonical.com>
[ rjw: Subject rewrite, changelog edits ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/resource.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/resource.c b/drivers/acpi/resource.c
index ee78a210c606..dc01fb550b28 100644
--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -423,6 +423,13 @@ static void acpi_dev_get_irqresource(struct resource *res, u32 gsi,
 	}
 }
 
+static bool irq_is_legacy(struct acpi_resource_irq *irq)
+{
+	return irq->triggering == ACPI_EDGE_SENSITIVE &&
+		irq->polarity == ACPI_ACTIVE_HIGH &&
+		irq->shareable == ACPI_EXCLUSIVE;
+}
+
 /**
  * acpi_dev_resource_interrupt - Extract ACPI interrupt resource information.
  * @ares: Input ACPI resource object.
@@ -461,7 +468,7 @@ bool acpi_dev_resource_interrupt(struct acpi_resource *ares, int index,
 		}
 		acpi_dev_get_irqresource(res, irq->interrupts[index],
 					 irq->triggering, irq->polarity,
-					 irq->shareable, true);
+					 irq->shareable, irq_is_legacy(irq));
 		break;
 	case ACPI_RESOURCE_TYPE_EXTENDED_IRQ:
 		ext_irq = &ares->data.extended_irq;
-- 
2.30.2



