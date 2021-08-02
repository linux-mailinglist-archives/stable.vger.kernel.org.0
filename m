Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A44873DD868
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 15:51:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234184AbhHBNv5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 09:51:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:58758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234229AbhHBNuz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 09:50:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1D05360FC1;
        Mon,  2 Aug 2021 13:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912245;
        bh=k+5vxf2jg4fS0EDyw3i+2FAXvaetqSfv4NJ24XYIk6w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hZpwRYOh9RU7Dfj6ZI+IRuUmaQzf4JhWYCPT9ikh1zxnnb7clsykuC+kBEGZqTECc
         u3TQm+DVVH2E54YOuoeECz/ptyHPUuYw+bWWZ9MaOmW1YNthRlqHbgxefJ+XjY3Lqb
         gcT98qotMraR3J5bdWsKFKbR5bcykAYvqdHlocUU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, PGNd <pgnet.dev@gmail.com>,
        Hui Wang <hui.wang@canonical.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.4 05/40] Revert "ACPI: resources: Add checks for ACPI IRQ override"
Date:   Mon,  2 Aug 2021 15:44:45 +0200
Message-Id: <20210802134335.575690596@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134335.408294521@linuxfoundation.org>
References: <20210802134335.408294521@linuxfoundation.org>
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
@@ -430,13 +430,6 @@ static void acpi_dev_get_irqresource(str
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
@@ -475,7 +468,7 @@ bool acpi_dev_resource_interrupt(struct
 		}
 		acpi_dev_get_irqresource(res, irq->interrupts[index],
 					 irq->triggering, irq->polarity,
-					 irq->shareable, irq_is_legacy(irq));
+					 irq->shareable, true);
 		break;
 	case ACPI_RESOURCE_TYPE_EXTENDED_IRQ:
 		ext_irq = &ares->data.extended_irq;


