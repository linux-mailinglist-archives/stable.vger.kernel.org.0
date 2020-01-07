Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0923D1333FC
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:23:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727376AbgAGVWw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 16:22:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:39732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728630AbgAGVBo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 16:01:44 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 784F320678;
        Tue,  7 Jan 2020 21:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578430903;
        bh=QWM3526XspiKj5r01Tp1958SjLfbuzw7SCfJrkHpn4k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O5PUIElGS99W0o1s01etltmzq1I2WYBJR54nl3BN2qagKImSJSk2zAqXvc6mecpA+
         I+c/Po+Ax6OTj9YAYJcvAnnqgit5Fe9iYKV9WXWcPjjul3L1OR8EKsD86YT+vM3igL
         1cM7mNjtV6n/ETHe5QZyemmt6Nr8jK+X7xQ3KuFU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 5.4 144/191] iommu/vt-d: Remove incorrect PSI capability check
Date:   Tue,  7 Jan 2020 21:54:24 +0100
Message-Id: <20200107205340.681533594@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205332.984228665@linuxfoundation.org>
References: <20200107205332.984228665@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lu Baolu <baolu.lu@linux.intel.com>

commit f81b846dcd9a1e6d120f73970a9a98b7fcaaffba upstream.

The PSI (Page Selective Invalidation) bit in the capability register
is only valid for second-level translation. Intel IOMMU supporting
scalable mode must support page/address selective IOTLB invalidation
for first-level translation. Remove the PSI capability check in SVA
cache invalidation code.

Fixes: 8744daf4b0699 ("iommu/vt-d: Remove global page flush support")
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iommu/intel-svm.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/drivers/iommu/intel-svm.c
+++ b/drivers/iommu/intel-svm.c
@@ -104,11 +104,7 @@ static void intel_flush_svm_range_dev (s
 {
 	struct qi_desc desc;
 
-	/*
-	 * Do PASID granu IOTLB invalidation if page selective capability is
-	 * not available.
-	 */
-	if (pages == -1 || !cap_pgsel_inv(svm->iommu->cap)) {
+	if (pages == -1) {
 		desc.qw0 = QI_EIOTLB_PASID(svm->pasid) |
 			QI_EIOTLB_DID(sdev->did) |
 			QI_EIOTLB_GRAN(QI_GRAN_NONG_PASID) |


