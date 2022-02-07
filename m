Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C86EE4ABC76
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:48:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236891AbiBGLhk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:37:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382259AbiBGL3S (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:29:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0AF3C02B66A;
        Mon,  7 Feb 2022 03:27:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F35D3B811B2;
        Mon,  7 Feb 2022 11:27:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D363C340F1;
        Mon,  7 Feb 2022 11:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644233224;
        bh=MoTW/brTC+J+UXtfZY4dtaQdrJZe9Uc4Pjt72hZLdi4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ghV6XsvgMMe6/nrjno2KIiWUIeHf74/dfxM8Vg3gV9vEt3FZpmaII3KITpErqDsZZ
         nsKDREkfB/ZwJvuCySQ8t25+Bmj29rEoLmkTERakLwSRVm0bFTUCxt908L12FPmkx1
         ifrKEIrHE/0a8WysUbNTAYYBnh5n3FH4Rm373aok=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 5.15 049/110] iommu/amd: Fix loop timeout issue in iommu_ga_log_enable()
Date:   Mon,  7 Feb 2022 12:06:22 +0100
Message-Id: <20220207103803.944639925@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103802.280120990@linuxfoundation.org>
References: <20220207103802.280120990@linuxfoundation.org>
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
 drivers/iommu/amd/init.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -21,6 +21,7 @@
 #include <linux/export.h>
 #include <linux/kmemleak.h>
 #include <linux/mem_encrypt.h>
+#include <linux/iopoll.h>
 #include <asm/pci-direct.h>
 #include <asm/iommu.h>
 #include <asm/apic.h>
@@ -832,6 +833,7 @@ static int iommu_ga_log_enable(struct am
 		status = readl(iommu->mmio_base + MMIO_STATUS_OFFSET);
 		if (status & (MMIO_STATUS_GALOG_RUN_MASK))
 			break;
+		udelay(10);
 	}
 
 	if (WARN_ON(i >= LOOP_TIMEOUT))


