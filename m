Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59C7F5EA2A5
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:12:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237573AbiIZLMD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:12:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237488AbiIZLLQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:11:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E600B5FF5B;
        Mon, 26 Sep 2022 03:35:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 80CA8B80972;
        Mon, 26 Sep 2022 10:35:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2540C43142;
        Mon, 26 Sep 2022 10:35:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188519;
        bh=S43vwTN5FCS7lBOECRJGWC/D4MWhEcu9+0J4OAHEcZo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nv+NZeBJRCJ0fHBbiIaUtUmqPoSx9cURe5HxLHd8CJ9qVzGPKzZYkMpjV8Z5WDi45
         ObhTkMvN3bqE2FN6qxHmZA2beYegrg6RAgOB0wsaq8v0Aip0u4DVH8O9aMmNqe2L5r
         LFmOjOXDGpvxmPt6llGs8pcx7NYpFC6nhYcmcN0k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Raghunathan Srinivasan <raghunathan.srinivasan@intel.com>,
        Yi Liu <yi.l.liu@intel.com>,
        Jerry Snitselaar <jsnitsel@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 5.15 034/148] iommu/vt-d: Check correct capability for sagaw determination
Date:   Mon, 26 Sep 2022 12:11:08 +0200
Message-Id: <20220926100757.320220944@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100756.074519146@linuxfoundation.org>
References: <20220926100756.074519146@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yi Liu <yi.l.liu@intel.com>

commit 154897807050c1161cb2660e502fc0470d46b986 upstream.

Check 5-level paging capability for 57 bits address width instead of
checking 1GB large page capability.

Fixes: 53fc7ad6edf2 ("iommu/vt-d: Correctly calculate sagaw value of IOMMU")
Cc: stable@vger.kernel.org
Reported-by: Raghunathan Srinivasan <raghunathan.srinivasan@intel.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
Reviewed-by: Jerry Snitselaar <jsnitsel@redhat.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Raghunathan Srinivasan <raghunathan.srinivasan@intel.com>
Link: https://lore.kernel.org/r/20220916071212.2223869-2-yi.l.liu@intel.com
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/intel/iommu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -539,7 +539,7 @@ static unsigned long __iommu_calculate_s
 {
 	unsigned long fl_sagaw, sl_sagaw;
 
-	fl_sagaw = BIT(2) | (cap_fl1gp_support(iommu->cap) ? BIT(3) : 0);
+	fl_sagaw = BIT(2) | (cap_5lp_support(iommu->cap) ? BIT(3) : 0);
 	sl_sagaw = cap_sagaw(iommu->cap);
 
 	/* Second level only. */


