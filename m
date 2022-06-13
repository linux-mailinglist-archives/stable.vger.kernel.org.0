Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 649DE548DF2
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:16:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352760AbiFMLVF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 07:21:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352896AbiFMLTB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 07:19:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF77C39833;
        Mon, 13 Jun 2022 03:40:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CDD98610A0;
        Mon, 13 Jun 2022 10:40:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDEBBC34114;
        Mon, 13 Jun 2022 10:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655116846;
        bh=YxJ7oQOItiFqndzNT7SS3Vf+Ghx4qKzyaMSvq5xiiC4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xr4Mfh3RoqG1JDIHXoPPi8dUU0WlCDpfkOy6ANfwypQMNb5QOyB5oO4FjWPAieJ6o
         Mhe5/WSl//3i83cKg7/i1E56/n9bOyR1xvZA3YVGwfqGV6e9sW592R+ZbDQSAhX2Zv
         RkMIUnsRrUAzRkrvMenaqAGEjDtcQqCiZFkKExrA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "D. Ziegfeld" <dzigg@posteo.de>,
        =?UTF-8?q?J=C3=B6rg-Volker=20Peetz?= <jvpeetz@web.de>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 206/411] iommu/amd: Increase timeout waiting for GA log enablement
Date:   Mon, 13 Jun 2022 12:07:59 +0200
Message-Id: <20220613094934.834339349@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094928.482772422@linuxfoundation.org>
References: <20220613094928.482772422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

[ Upstream commit 42bb5aa043382f09bef2cc33b8431be867c70f8e ]

On some systems it can take a long time for the hardware to enable the
GA log of the AMD IOMMU. The current wait time is only 0.1ms, but
testing showed that it can take up to 14ms for the GA log to enter
running state after it has been enabled.

Sometimes the long delay happens when booting the system, sometimes
only on resume. Adjust the timeout accordingly to not print a warning
when hardware takes a longer than usual.

There has already been an attempt to fix this with commit

	9b45a7738eec ("iommu/amd: Fix loop timeout issue in iommu_ga_log_enable()")

But that commit was based on some wrong math and did not fix the issue
in all cases.

Cc: "D. Ziegfeld" <dzigg@posteo.de>
Cc: Jörg-Volker Peetz <jvpeetz@web.de>
Fixes: 8bda0cfbdc1a ("iommu/amd: Detect and initialize guest vAPIC log")
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Link: https://lore.kernel.org/r/20220520102214.12563-1-joro@8bytes.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd_iommu_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
index 7502fa84e253..82d008310418 100644
--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -83,7 +83,7 @@
 #define ACPI_DEVFLAG_LINT1              0x80
 #define ACPI_DEVFLAG_ATSDIS             0x10000000
 
-#define LOOP_TIMEOUT	100000
+#define LOOP_TIMEOUT	2000000
 /*
  * ACPI table definitions
  *
-- 
2.35.1



