Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDB012FA960
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 19:55:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407861AbhARSye (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 13:54:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:36346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390627AbhARLke (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:40:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 707CD229CA;
        Mon, 18 Jan 2021 11:39:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610969993;
        bh=qQzdLG4bxTl9E5fLbCeEso1TliTaKDOCfKUbhoau/Kg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IygXU8baTQk1l8YXrLA6N+Z/AHyyfuFA1o+esDTmew7gW2KUlkcOJIX3jVhxNPfNf
         Jm0kwZGUjoyFJROBUz57mCgKaq1Ifg+95SljBfVZ54AYnEJj5VcIsbvasIi07Ez27Q
         JaGkc+xf/Zga0tMlwO8HvvoMD/U61W2krmoTh3v4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lu Baolu <baolu.lu@linux.intel.com>,
        Will Deacon <will@kernel.org>,
        Guo Kaijie <Kaijie.Guo@intel.com>
Subject: [PATCH 5.4 69/76] iommu/vt-d: Fix unaligned addresses for intel_flush_svm_range_dev()
Date:   Mon, 18 Jan 2021 12:35:09 +0100
Message-Id: <20210118113344.268229595@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113340.984217512@linuxfoundation.org>
References: <20210118113340.984217512@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lu Baolu <baolu.lu@linux.intel.com>

commit 2d6ffc63f12417b979955a5b22ad9a76d2af5de9 upstream.

The VT-d hardware will ignore those Addr bits which have been masked by
the AM field in the PASID-based-IOTLB invalidation descriptor. As the
result, if the starting address in the descriptor is not aligned with
the address mask, some IOTLB caches might not invalidate. Hence people
will see below errors.

[ 1093.704661] dmar_fault: 29 callbacks suppressed
[ 1093.704664] DMAR: DRHD: handling fault status reg 3
[ 1093.712738] DMAR: [DMA Read] Request device [7a:02.0] PASID 2
               fault addr 7f81c968d000 [fault reason 113]
               SM: Present bit in first-level paging entry is clear

Fix this by using aligned address for PASID-based-IOTLB invalidation.

Fixes: 1c4f88b7f1f9 ("iommu/vt-d: Shared virtual address in scalable mode")
Reported-and-tested-by: Guo Kaijie <Kaijie.Guo@intel.com>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Link: https://lore.kernel.org/r/20201231005323.2178523-2-baolu.lu@linux.intel.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iommu/intel-svm.c |   22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

--- a/drivers/iommu/intel-svm.c
+++ b/drivers/iommu/intel-svm.c
@@ -99,8 +99,10 @@ int intel_svm_finish_prq(struct intel_io
 	return 0;
 }
 
-static void intel_flush_svm_range_dev (struct intel_svm *svm, struct intel_svm_dev *sdev,
-				unsigned long address, unsigned long pages, int ih)
+static void __flush_svm_range_dev(struct intel_svm *svm,
+				  struct intel_svm_dev *sdev,
+				  unsigned long address,
+				  unsigned long pages, int ih)
 {
 	struct qi_desc desc;
 
@@ -151,6 +153,22 @@ static void intel_flush_svm_range_dev (s
 	}
 }
 
+static void intel_flush_svm_range_dev(struct intel_svm *svm,
+				      struct intel_svm_dev *sdev,
+				      unsigned long address,
+				      unsigned long pages, int ih)
+{
+	unsigned long shift = ilog2(__roundup_pow_of_two(pages));
+	unsigned long align = (1ULL << (VTD_PAGE_SHIFT + shift));
+	unsigned long start = ALIGN_DOWN(address, align);
+	unsigned long end = ALIGN(address + (pages << VTD_PAGE_SHIFT), align);
+
+	while (start < end) {
+		__flush_svm_range_dev(svm, sdev, start, align >> VTD_PAGE_SHIFT, ih);
+		start += align;
+	}
+}
+
 static void intel_flush_svm_range(struct intel_svm *svm, unsigned long address,
 				unsigned long pages, int ih)
 {


