Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7ED5D635636
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:28:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237681AbiKWJ14 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:27:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237715AbiKWJ07 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:26:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDA921121CD
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:26:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8AFA3B81EE5
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:26:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E20C1C433D6;
        Wed, 23 Nov 2022 09:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669195559;
        bh=+HtQsJXUD/tUXB4hJR5VdZXpy+wB3CM3oE5cDANrSwY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HkQ9Jpfy7D4Rt8GGM3R25oBqhIHbFxHHEsN4apQVwVlvDd6cfQP9NYYBRVe91Pb6p
         pjTN2FYOLFhQ7sfh+GbaEVV8zU8Q2dsArmNVpKEBurx+UWwfGgV7oxWMK2IX7EVHSQ
         ra2DbpVnEve6hlGgQ98xp5Z1Ejiy2zLJ5idxcDYI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Tina Zhang <tina.zhang@intel.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 5.10 118/149] iommu/vt-d: Set SRE bit only when hardware has SRS cap
Date:   Wed, 23 Nov 2022 09:51:41 +0100
Message-Id: <20221123084602.191762733@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.945845710@linuxfoundation.org>
References: <20221123084557.945845710@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tina Zhang <tina.zhang@intel.com>

commit 7fc961cf7ffcb130c4e93ee9a5628134f9de700a upstream.

SRS cap is the hardware cap telling if the hardware IOMMU can support
requests seeking supervisor privilege or not. SRE bit in scalable-mode
PASID table entry is treated as Reserved(0) for implementation not
supporting SRS cap.

Checking SRS cap before setting SRE bit can avoid the non-recoverable
fault of "Non-zero reserved field set in PASID Table Entry" caused by
setting SRE bit while there is no SRS cap support. The fault messages
look like below:

 DMAR: DRHD: handling fault status reg 2
 DMAR: [DMA Read NO_PASID] Request device [00:0d.0] fault addr 0x1154e1000
       [fault reason 0x5a]
       SM: Non-zero reserved field set in PASID Table Entry

Fixes: 6f7db75e1c46 ("iommu/vt-d: Add second level page table interface")
Cc: stable@vger.kernel.org
Signed-off-by: Tina Zhang <tina.zhang@intel.com>
Link: https://lore.kernel.org/r/20221115070346.1112273-1-tina.zhang@intel.com
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Link: https://lore.kernel.org/r/20221116051544.26540-3-baolu.lu@linux.intel.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/intel/pasid.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/iommu/intel/pasid.c
+++ b/drivers/iommu/intel/pasid.c
@@ -669,7 +669,7 @@ int intel_pasid_setup_second_level(struc
 	 * Since it is a second level only translation setup, we should
 	 * set SRE bit as well (addresses are expected to be GPAs).
 	 */
-	if (pasid != PASID_RID2PASID)
+	if (pasid != PASID_RID2PASID && ecap_srs(iommu->ecap))
 		pasid_set_sre(pte);
 	pasid_set_present(pte);
 	pasid_flush_caches(iommu, pte, pasid, did);
@@ -704,7 +704,8 @@ int intel_pasid_setup_pass_through(struc
 	 * We should set SRE bit as well since the addresses are expected
 	 * to be GPAs.
 	 */
-	pasid_set_sre(pte);
+	if (ecap_srs(iommu->ecap))
+		pasid_set_sre(pte);
 	pasid_set_present(pte);
 	pasid_flush_caches(iommu, pte, pasid, did);
 


