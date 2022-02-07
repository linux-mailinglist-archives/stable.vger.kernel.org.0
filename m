Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 665EA4ABB48
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:37:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384314AbiBGL1t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:27:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382200AbiBGLSi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:18:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67B48C0401E8;
        Mon,  7 Feb 2022 03:18:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 19CAEB811BC;
        Mon,  7 Feb 2022 11:18:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38F54C340EB;
        Mon,  7 Feb 2022 11:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644232694;
        bh=EuqepuWbkSqG0A0WSgIvDIEWuqctD6IQU1eF4y0Vv1s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SSYmBjnXdJWmfriLpXFrOpEk9DqowbD+DzrdnYMEP94+TtQgoAF1SSYs5pt/U8dc9
         ENGPqe4pogLFbgvCnxnZ4ppa0kQGUMuL58g+Vsd6DyWvF5MMsZ8Od0ywi7whI6hIMp
         /ql8T7wpFtJtJUQJFTgNjMyjayZxb/OGS6CUGxqs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 4.19 66/86] iommu/amd: Fix loop timeout issue in iommu_ga_log_enable()
Date:   Mon,  7 Feb 2022 12:06:29 +0100
Message-Id: <20220207103759.724403023@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103757.550973048@linuxfoundation.org>
References: <20220207103757.550973048@linuxfoundation.org>
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
@@ -30,6 +30,7 @@
 #include <linux/iommu.h>
 #include <linux/kmemleak.h>
 #include <linux/mem_encrypt.h>
+#include <linux/iopoll.h>
 #include <asm/pci-direct.h>
 #include <asm/iommu.h>
 #include <asm/gart.h>
@@ -772,6 +773,7 @@ static int iommu_ga_log_enable(struct am
 		status = readl(iommu->mmio_base + MMIO_STATUS_OFFSET);
 		if (status & (MMIO_STATUS_GALOG_RUN_MASK))
 			break;
+		udelay(10);
 	}
 
 	if (i >= LOOP_TIMEOUT)


