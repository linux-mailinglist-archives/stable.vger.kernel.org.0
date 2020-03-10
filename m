Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A06817FD65
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:29:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728496AbgCJMxk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 08:53:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:59778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729188AbgCJMxj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:53:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 40BE220674;
        Tue, 10 Mar 2020 12:53:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583844818;
        bh=naQVtRPDRLNxY6J0+1oRvdmUjT0QrCmqOH2sSU55jpY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nOduWI8+LgWhWuUCa2ALQ5KkTOTY0NMVgIcRmJo+ilO9FEdHOWAGsrM7e+BJM45ug
         oTwz5sssRzDxW6AsRX/K5StrmYs7b8SGxdx4y19sZ53ylhtIy3WjM6/75yTgGdbTd2
         o38OnGU5VsQEMi7CZR6K57SaTlWthNu67ltEy71E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rob Herring <robh@kernel.org>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Steven Price <steven.price@arm.com>,
        Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>
Subject: [PATCH 5.4 130/168] drm/panfrost: Dont try to map on error faults
Date:   Tue, 10 Mar 2020 13:39:36 +0100
Message-Id: <20200310123648.652336880@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123635.322799692@linuxfoundation.org>
References: <20200310123635.322799692@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tomeu Vizoso <tomeu.vizoso@collabora.com>

commit eb9d8ddbc107d02e489681f9dcbf93949e1a99a4 upstream.

If the exception type isn't a translation fault, don't try to map and
instead go straight to a terminal fault.

Otherwise, we can get flooded by kernel warnings and further faults.

Fixes: 187d2929206e ("drm/panfrost: Add support for GPU heap allocations")
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Reviewed-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Acked-by: Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200212202236.13095-1-robh@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/panfrost/panfrost_mmu.c |   44 +++++++++++++-------------------
 1 file changed, 19 insertions(+), 25 deletions(-)

--- a/drivers/gpu/drm/panfrost/panfrost_mmu.c
+++ b/drivers/gpu/drm/panfrost/panfrost_mmu.c
@@ -601,33 +601,27 @@ static irqreturn_t panfrost_mmu_irq_hand
 		source_id = (fault_status >> 16);
 
 		/* Page fault only */
-		if ((status & mask) == BIT(i)) {
-			WARN_ON(exception_type < 0xC1 || exception_type > 0xC4);
-
+		ret = -1;
+		if ((status & mask) == BIT(i) && (exception_type & 0xF8) == 0xC0)
 			ret = panfrost_mmu_map_fault_addr(pfdev, i, addr);
-			if (!ret) {
-				mmu_write(pfdev, MMU_INT_CLEAR, BIT(i));
-				status &= ~mask;
-				continue;
-			}
-		}
 
-		/* terminal fault, print info about the fault */
-		dev_err(pfdev->dev,
-			"Unhandled Page fault in AS%d at VA 0x%016llX\n"
-			"Reason: %s\n"
-			"raw fault status: 0x%X\n"
-			"decoded fault status: %s\n"
-			"exception type 0x%X: %s\n"
-			"access type 0x%X: %s\n"
-			"source id 0x%X\n",
-			i, addr,
-			"TODO",
-			fault_status,
-			(fault_status & (1 << 10) ? "DECODER FAULT" : "SLAVE FAULT"),
-			exception_type, panfrost_exception_name(pfdev, exception_type),
-			access_type, access_type_name(pfdev, fault_status),
-			source_id);
+		if (ret)
+			/* terminal fault, print info about the fault */
+			dev_err(pfdev->dev,
+				"Unhandled Page fault in AS%d at VA 0x%016llX\n"
+				"Reason: %s\n"
+				"raw fault status: 0x%X\n"
+				"decoded fault status: %s\n"
+				"exception type 0x%X: %s\n"
+				"access type 0x%X: %s\n"
+				"source id 0x%X\n",
+				i, addr,
+				"TODO",
+				fault_status,
+				(fault_status & (1 << 10) ? "DECODER FAULT" : "SLAVE FAULT"),
+				exception_type, panfrost_exception_name(pfdev, exception_type),
+				access_type, access_type_name(pfdev, fault_status),
+				source_id);
 
 		mmu_write(pfdev, MMU_INT_CLEAR, mask);
 


