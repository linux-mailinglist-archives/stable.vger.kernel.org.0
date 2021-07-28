Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49C1C3D91B5
	for <lists+stable@lfdr.de>; Wed, 28 Jul 2021 17:20:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235620AbhG1PUQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Jul 2021 11:20:16 -0400
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:45412
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235574AbhG1PUP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Jul 2021 11:20:15 -0400
Received: from localhost.localdomain (unknown [123.112.69.26])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id 4C6AE3FE72;
        Wed, 28 Jul 2021 15:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1627485613;
        bh=xSB0qaqDh/asWPJ+mudyo/EtJoVdKDKKukQIrJQJs+g=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
        b=vdT40IT+LVwYdZ/M5qXYcm0fy41jbEsefIDuNKFLkeMFlKOnr2NwdqW3VnNqbjfjl
         gouitWPG3+92HoLvLfp0iNXZeYaMDVZeaa+ogfMVqP5YQPplJrQbOoOe736ZSA/kzi
         OyPTuPe8/lFUIVsumGj67S4stEG9TrRyvmk0Ix1BoCL7emX21t90s+zD0F1JmB3pw5
         aaaXgiE+aspv7c5hc28UvcZtv3+Am8vfMDfGdGE0Fvh0mdoVKYE0bX/b7/W1fALHXU
         m1ofCG3jtWFZBDkM7LQ4fOcXFAeHK4sOeEZUmIu9W/3J0gwr7WUeEO3qVAxBmFNjFG
         dp22TUB5BAbcg==
From:   Hui Wang <hui.wang@canonical.com>
To:     linux-acpi@vger.kernel.org, rafael.j.wysocki@intel.com,
        stable@vger.kernel.org
Cc:     manuelkrause@netscape.net, pgnet.dev@gmail.com
Subject: [PATCH] Revert "ACPI: resources: Add checks for ACPI IRQ override"
Date:   Wed, 28 Jul 2021 23:19:58 +0800
Message-Id: <20210728151958.15205-1-hui.wang@canonical.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The commit 0ec4e55e9f57 ("ACPI: resources: Add checks for ACPI IRQ
override") introduces regression on some platforms, at least it makes
the UART can't get correct irq setting on two different platforms,
and it makes the kernel can't bootup on these two platforms.

This reverts commit 0ec4e55e9f571f08970ed115ec0addc691eda613.

Regression-discuss: https://bugzilla.kernel.org/show_bug.cgi?id=213031
Reported-by: PGNd <pgnet.dev@gmail.com>
Cc: 5.4+ <stable@vger.kernel.org> # 5.4+
Signed-off-by: Hui Wang <hui.wang@canonical.com>
---
 drivers/acpi/resource.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/acpi/resource.c b/drivers/acpi/resource.c
index dc01fb550b28..ee78a210c606 100644
--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -423,13 +423,6 @@ static void acpi_dev_get_irqresource(struct resource *res, u32 gsi,
 	}
 }
 
-static bool irq_is_legacy(struct acpi_resource_irq *irq)
-{
-	return irq->triggering == ACPI_EDGE_SENSITIVE &&
-		irq->polarity == ACPI_ACTIVE_HIGH &&
-		irq->shareable == ACPI_EXCLUSIVE;
-}
-
 /**
  * acpi_dev_resource_interrupt - Extract ACPI interrupt resource information.
  * @ares: Input ACPI resource object.
@@ -468,7 +461,7 @@ bool acpi_dev_resource_interrupt(struct acpi_resource *ares, int index,
 		}
 		acpi_dev_get_irqresource(res, irq->interrupts[index],
 					 irq->triggering, irq->polarity,
-					 irq->shareable, irq_is_legacy(irq));
+					 irq->shareable, true);
 		break;
 	case ACPI_RESOURCE_TYPE_EXTENDED_IRQ:
 		ext_irq = &ares->data.extended_irq;
-- 
2.25.1

