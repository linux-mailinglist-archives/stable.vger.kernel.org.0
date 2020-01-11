Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2764137F52
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:18:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730132AbgAKKSa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:18:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:36760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729838AbgAKKSa (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:18:30 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 444DB20848;
        Sat, 11 Jan 2020 10:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578737910;
        bh=UR8VY5Eq6SHU64Zk5WIvzj+mQbgDQ6n8UbCfCScRUec=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ASc5Hdf4p5zHbs3meal3P6IFS+AhIxtPUo1CqHOKHdWLheQGo2kpMOrBlMHHSk1Tw
         xhNXeUDJaLFwP1V5n6wU+20EfDeuiFjab+tPMpc64XouiN/3BhYT9v2pJM+GulFVgr
         cs46QHU4puF8i6hGeVBJ/Dz0TqHJdvS/1F4hSpgc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Doug Meyer <dmeyer@gigaio.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Kelvin Cao <Kelvin.Cao@microchip.com>
Subject: [PATCH 4.19 64/84] PCI/switchtec: Read all 64 bits of part_event_bitmap
Date:   Sat, 11 Jan 2020 10:50:41 +0100
Message-Id: <20200111094910.117802780@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094845.328046411@linuxfoundation.org>
References: <20200111094845.328046411@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Logan Gunthorpe <logang@deltatee.com>

commit 6acdf7e19b37cb3a9258603d0eab315079c19c5e upstream.

The part_event_bitmap register is 64 bits wide, so read it with ioread64()
instead of the 32-bit ioread32().

Fixes: 52eabba5bcdb ("switchtec: Add IOCTLs to the Switchtec driver")
Link: https://lore.kernel.org/r/20190910195833.3891-1-logang@deltatee.com
Reported-by: Doug Meyer <dmeyer@gigaio.com>
Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: stable@vger.kernel.org	# v4.12+
Cc: Kelvin Cao <Kelvin.Cao@microchip.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/switch/switchtec.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/pci/switch/switchtec.c
+++ b/drivers/pci/switch/switchtec.c
@@ -13,7 +13,7 @@
 #include <linux/uaccess.h>
 #include <linux/poll.h>
 #include <linux/wait.h>
-
+#include <linux/io-64-nonatomic-lo-hi.h>
 #include <linux/nospec.h>
 
 MODULE_DESCRIPTION("Microsemi Switchtec(tm) PCIe Management Driver");
@@ -633,7 +633,7 @@ static int ioctl_event_summary(struct sw
 	u32 reg;
 
 	s.global = ioread32(&stdev->mmio_sw_event->global_summary);
-	s.part_bitmap = ioread32(&stdev->mmio_sw_event->part_event_bitmap);
+	s.part_bitmap = readq(&stdev->mmio_sw_event->part_event_bitmap);
 	s.local_part = ioread32(&stdev->mmio_part_cfg->part_event_summary);
 
 	for (i = 0; i < stdev->partition_count; i++) {


