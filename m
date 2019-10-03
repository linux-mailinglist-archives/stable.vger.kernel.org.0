Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A610CCA8F0
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:20:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403784AbfJCQeu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:34:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:43480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392166AbfJCQer (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:34:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3481820830;
        Thu,  3 Oct 2019 16:34:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570120486;
        bh=l+Sn/vT20V4n9NS+jpT09f33J7KQnZFya5wMuhRIGZ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=txh1pYvEnZBjltGX4hGNNhVsC61L96gzv5pByxv+fgKWVRmV/8hs7ks2ygUNi7TL6
         vudKGdgpUOjNuybIrFGBUNxzgl5AkKmN0usBR2WAuBxE988HCmDTdGMQLipy3J1pNx
         la6wj/BAFhDXUNxFDhPGlR7t0OWqyOk5i1dh/+sY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 5.2 239/313] platform/x86: intel_int0002_vgpio: Fix wakeups not working on Cherry Trail
Date:   Thu,  3 Oct 2019 17:53:37 +0200
Message-Id: <20191003154556.585063804@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154533.590915454@linuxfoundation.org>
References: <20191003154533.590915454@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

commit 1bd43d0077b9a32a8b8059036471f3fc82dae342 upstream.

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
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/platform/x86/intel_int0002_vgpio.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/platform/x86/intel_int0002_vgpio.c
+++ b/drivers/platform/x86/intel_int0002_vgpio.c
@@ -155,6 +155,7 @@ static struct irq_chip int0002_cht_irqch
 	 * No set_wake, on CHT the IRQ is typically shared with the ACPI SCI
 	 * and we don't want to mess with the ACPI SCI irq settings.
 	 */
+	.flags			= IRQCHIP_SKIP_SET_WAKE,
 };
 
 static int int0002_probe(struct platform_device *pdev)


