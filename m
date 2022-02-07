Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B6CB4ABAB5
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:30:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384009AbiBGLY0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:24:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242774AbiBGLJ1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:09:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD97AC043181;
        Mon,  7 Feb 2022 03:09:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 605B7611AA;
        Mon,  7 Feb 2022 11:09:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B6CEC004E1;
        Mon,  7 Feb 2022 11:09:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644232165;
        bh=8ghriyWbh+VukJ7ln3XXsA/uQ+qN6yX00Mc0zjol/ck=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g7PJIoFyV2/D+xK8ZrRiRTDPcTIJoRXjwdGTlspCeC3c583L0Ly47K6cuWZbIiZCi
         xTCty5J+0flz/xJPXA2I/3riDgSP7ZbQbxNTSFER7P1cygxmKGa4JUVi6q8nmLfjpg
         DNnHtoqM527LdZPcuWwKjRniApiHPWnswnII8dFs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 4.9 37/48] iommu/amd: Fix loop timeout issue in iommu_ga_log_enable()
Date:   Mon,  7 Feb 2022 12:06:10 +0100
Message-Id: <20220207103753.546943012@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103752.341184175@linuxfoundation.org>
References: <20220207103752.341184175@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

commit 9b45a7738eec52bf0f5d8d3d54e822962781c5f2 upstream.

The polling loop for the register change in iommu_ga_log_enable() needs
to have a udelay() in it.  Otherwise the CPU might be faster than the
IOMMU hardware and wrongly trigger the WARN_ON() further down the code
stream. Use a 10us for udelay(), has there is some hardware where
activation of the GA log can take more than a 100ms.

A future optimization should move the activation check of the GA log
to the point where it gets used for the first time. But that is a
bigger change and not suitable for a fix.

Fixes: 8bda0cfbdc1a ("iommu/amd: Detect and initialize guest vAPIC log")
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Link: https://lore.kernel.org/r/20220204115537.3894-1-joro@8bytes.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/amd_iommu_init.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -28,6 +28,7 @@
 #include <linux/amd-iommu.h>
 #include <linux/export.h>
 #include <linux/iommu.h>
+#include <linux/iopoll.h>
 #include <asm/pci-direct.h>
 #include <asm/iommu.h>
 #include <asm/gart.h>
@@ -715,6 +716,7 @@ static int iommu_ga_log_enable(struct am
 		status = readl(iommu->mmio_base + MMIO_STATUS_OFFSET);
 		if (status & (MMIO_STATUS_GALOG_RUN_MASK))
 			break;
+		udelay(10);
 	}
 
 	if (i >= LOOP_TIMEOUT)


