Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DCBE3DD963
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 16:00:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234661AbhHBOAN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 10:00:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:40832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236229AbhHBN5U (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 09:57:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 932476115B;
        Mon,  2 Aug 2021 13:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912494;
        bh=0XcB6HIfVFLpVBNMqwdsa/GmiNeSFd0sMov7Z0yD9R0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oq1nt/Gz+Jb41v2ZTfohUXh/LaecYU0VsZ074KVZ84te+OcYDnAb0u+yofueyiI6O
         k0keEkSOlTNGiDD52HA4kBrEJnJ1y1vdAxMTqfHhcVhQF3DUkdlSkLU8m6kEhvP1MP
         AOGLyQ7wVNOOjGaLyfUlYNo049kDuCoSc5feIIew=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, PGNd <pgnet.dev@gmail.com>,
        Hui Wang <hui.wang@canonical.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.13 006/104] Revert "ACPI: resources: Add checks for ACPI IRQ override"
Date:   Mon,  2 Aug 2021 15:44:03 +0200
Message-Id: <20210802134344.228002849@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134344.028226640@linuxfoundation.org>
References: <20210802134344.028226640@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hui Wang <hui.wang@canonical.com>

commit e0eef3690dc66b3ecc6e0f1267f332403eb22bea upstream.

The commit 0ec4e55e9f57 ("ACPI: resources: Add checks for ACPI IRQ
override") introduces regression on some platforms, at least it makes
the UART can't get correct irq setting on two different platforms,
and it makes the kernel can't bootup on these two platforms.

This reverts commit 0ec4e55e9f571f08970ed115ec0addc691eda613.

Regression-discuss: https://bugzilla.kernel.org/show_bug.cgi?id=213031
Reported-by: PGNd <pgnet.dev@gmail.com>
Cc: 5.4+ <stable@vger.kernel.org> # 5.4+
Signed-off-by: Hui Wang <hui.wang@canonical.com>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/resource.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -423,13 +423,6 @@ static void acpi_dev_get_irqresource(str
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
@@ -468,7 +461,7 @@ bool acpi_dev_resource_interrupt(struct
 		}
 		acpi_dev_get_irqresource(res, irq->interrupts[index],
 					 irq->triggering, irq->polarity,
-					 irq->shareable, irq_is_legacy(irq));
+					 irq->shareable, true);
 		break;
 	case ACPI_RESOURCE_TYPE_EXTENDED_IRQ:
 		ext_irq = &ares->data.extended_irq;


