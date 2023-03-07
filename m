Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 664106AF02E
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:29:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233098AbjCGS3X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:29:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231410AbjCGS2j (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:28:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94311ADC3C
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:21:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 31502614E8
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:21:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 336DCC433EF;
        Tue,  7 Mar 2023 18:21:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678213294;
        bh=deTLRwHs5/nt4/Mtbjl9vUvWGMm5yM6a6rAIw1u2KJc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s0LOb8RXHsvRr5DdEzC1ICffF8PxXI+qXK0P9ZE3W9o0DfmHsezajrZSdqbnGxQ1a
         C32uXGrh3AWmiSt2Xt7QDWh+byrxwywRnsJj9UdsyIFXlry3/VuMal9zuzZth8sNTO
         q4ybtFm9jxFXu0oCZWKUw74BNJCK0sHs+bY0V6Ps=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ashok Raj <ashok.raj@intel.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 461/885] iommu/vt-d: Set No Execute Enable bit in PASID table entry
Date:   Tue,  7 Mar 2023 17:56:35 +0100
Message-Id: <20230307170022.529226166@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lu Baolu <baolu.lu@linux.intel.com>

[ Upstream commit e06d24435596c8afcaa81c0c498f5b0ec4ee2b7c ]

Setup No Execute Enable bit (Bit 133) of a scalable mode PASID entry.
This is to allow the use of XD bit of the first level page table.

Fixes: ddf09b6d43ec ("iommu/vt-d: Setup pasid entries for iova over first level")
Signed-off-by: Ashok Raj <ashok.raj@intel.com>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Link: https://lore.kernel.org/r/20230126095438.354205-1-baolu.lu@linux.intel.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/pasid.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/iommu/intel/pasid.c b/drivers/iommu/intel/pasid.c
index e13d7e5273e19..13a5a4e05fe9a 100644
--- a/drivers/iommu/intel/pasid.c
+++ b/drivers/iommu/intel/pasid.c
@@ -362,6 +362,16 @@ static inline void pasid_set_page_snoop(struct pasid_entry *pe, bool value)
 	pasid_set_bits(&pe->val[1], 1 << 23, value << 23);
 }
 
+/*
+ * Setup No Execute Enable bit (Bit 133) of a scalable mode PASID
+ * entry. It is required when XD bit of the first level page table
+ * entry is about to be set.
+ */
+static inline void pasid_set_nxe(struct pasid_entry *pe)
+{
+	pasid_set_bits(&pe->val[2], 1 << 5, 1 << 5);
+}
+
 /*
  * Setup the Page Snoop (PGSNP) field (Bit 88) of a scalable mode
  * PASID entry.
@@ -555,6 +565,7 @@ int intel_pasid_setup_first_level(struct intel_iommu *iommu,
 	pasid_set_domain_id(pte, did);
 	pasid_set_address_width(pte, iommu->agaw);
 	pasid_set_page_snoop(pte, !!ecap_smpwc(iommu->ecap));
+	pasid_set_nxe(pte);
 
 	/* Setup Present and PASID Granular Transfer Type: */
 	pasid_set_translation_type(pte, PASID_ENTRY_PGTT_FL_ONLY);
-- 
2.39.2



