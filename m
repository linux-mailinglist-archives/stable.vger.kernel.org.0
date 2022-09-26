Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 465765EA445
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:43:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238457AbiIZLnR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:43:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238379AbiIZLmX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:42:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8639571BCC;
        Mon, 26 Sep 2022 03:45:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E8900B80936;
        Mon, 26 Sep 2022 10:44:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 459D4C433D6;
        Mon, 26 Sep 2022 10:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664189091;
        bh=Q74uf3s621jYqCQHgIEhJcf7RNGBb1f0pLKmEvNefl4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KgRvGvOSVoBfjIvzQHG9CIiM/26Qr+g12BoaEG0Hu/h3mmwINxq39aBwWwIoRI39p
         eCEt2Pw7piMPKyKhIoDJqU4iPCcMRxltGdNc83tgckeW69N4RcnovWLquF9uvCV8gX
         +OplgaSiBBk8UnuTrfL4boqV6T/qc3N/uEOCp+RM=
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
Subject: [PATCH 5.19 039/207] iommu/vt-d: Check correct capability for sagaw determination
Date:   Mon, 26 Sep 2022 12:10:28 +0200
Message-Id: <20220926100808.370493079@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100806.522017616@linuxfoundation.org>
References: <20220926100806.522017616@linuxfoundation.org>
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
@@ -419,7 +419,7 @@ static unsigned long __iommu_calculate_s
 {
 	unsigned long fl_sagaw, sl_sagaw;
 
-	fl_sagaw = BIT(2) | (cap_fl1gp_support(iommu->cap) ? BIT(3) : 0);
+	fl_sagaw = BIT(2) | (cap_5lp_support(iommu->cap) ? BIT(3) : 0);
 	sl_sagaw = cap_sagaw(iommu->cap);
 
 	/* Second level only. */


