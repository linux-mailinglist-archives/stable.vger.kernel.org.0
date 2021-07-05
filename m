Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CEB53BC02F
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 17:34:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233167AbhGEPey (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 11:34:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:58458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232242AbhGEPd5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Jul 2021 11:33:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 44D9E619A8;
        Mon,  5 Jul 2021 15:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625499056;
        bh=guUlw7LbYXQaxl4LGiohWVurXUn41jhlIANKbqpwILs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eB2TQYOJFuk2YrrxYmDn+e+unIBeEU7zfvOmYzxhP5qqQrPNWNuH/XQ8sMVaok/L0
         5WfwVchUE+RYmFY0sTqSl9bHoxnoJSqHBLbSP55Dbme+Pgep3XHOYV+rj/Ck4Ry0TX
         3lnbPY0t6AN7oTRJLLbOlG4lNM88bovX90H80cP6SjctY7eaqlVn9LzHECVlQWdIHT
         FXa2o0e/ZT4eACPGkHcueh6uOKcdqm+NtdqSAhGMlzw23m9ori3KkqxOLVM5+Ptk6K
         ah6OP2Xf33Mk9YqeDvmt+LlcCUv/6yfPDt2LOZtLD2InrGT3F6sNBmjrCpbKo16tDv
         KAv+3ND8EI9gw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hui Wang <hui.wang@canonical.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Manuel Krause <manuelkrause@netscape.net>,
        Sasha Levin <sashal@kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 13/26] ACPI: resources: Add checks for ACPI IRQ override
Date:   Mon,  5 Jul 2021 11:30:26 -0400
Message-Id: <20210705153039.1521781-13-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210705153039.1521781-1-sashal@kernel.org>
References: <20210705153039.1521781-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From the existing comment in acpi_dev_get_irqresource(), the override
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
index 48ca9a844f06..55c57b703ea3 100644
--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -430,6 +430,13 @@ static void acpi_dev_get_irqresource(struct resource *res, u32 gsi,
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
@@ -468,7 +475,7 @@ bool acpi_dev_resource_interrupt(struct acpi_resource *ares, int index,
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

