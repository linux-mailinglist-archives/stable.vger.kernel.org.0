Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24294106ADF
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 11:39:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728739AbfKVKjC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:39:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:41838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728736AbfKVKjC (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:39:02 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3EF9F2071C;
        Fri, 22 Nov 2019 10:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574419141;
        bh=DCB1Lm+eD2UVyhgQSltdFYVeU1acKcu26rZLTF3FhfE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vGfw+Ui4U9ZFm6laVpFFDfzAmmGAHQeKl0zl4KNE5M4ZbpOn5ne/kbCICQpUtFSNv
         YMohIIaEM8g3OwieIJH9mlAE1Zx12xmIu+UrnpYXePlHoryz98QtOrx85cco8GLhYM
         N4mlnCa2jmQ7xgqz8Yk13RRiLSqXRWm0519+//9g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Auger <eric.auger@redhat.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 4.9 012/222] iommu/vt-d: Fix QI_DEV_IOTLB_PFSID and QI_DEV_EIOTLB_PFSID macros
Date:   Fri, 22 Nov 2019 11:25:52 +0100
Message-Id: <20191122100833.140963219@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100830.874290814@linuxfoundation.org>
References: <20191122100830.874290814@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Auger <eric.auger@redhat.com>

commit 4e7120d79edb31e4ee68e6f8421448e4603be1e9 upstream.

For both PASID-based-Device-TLB Invalidate Descriptor and
Device-TLB Invalidate Descriptor, the Physical Function Source-ID
value is split according to this layout:

PFSID[3:0] is set at offset 12 and PFSID[15:4] is put at offset 52.
Fix the part laid out at offset 52.

Fixes: 0f725561e1684 ("iommu/vt-d: Add definitions for PFSID")
Signed-off-by: Eric Auger <eric.auger@redhat.com>
Acked-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: stable@vger.kernel.org # v4.19+
Acked-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/intel-iommu.h |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/include/linux/intel-iommu.h
+++ b/include/linux/intel-iommu.h
@@ -295,7 +295,8 @@ enum {
 #define QI_DEV_IOTLB_SID(sid)	((u64)((sid) & 0xffff) << 32)
 #define QI_DEV_IOTLB_QDEP(qdep)	(((qdep) & 0x1f) << 16)
 #define QI_DEV_IOTLB_ADDR(addr)	((u64)(addr) & VTD_PAGE_MASK)
-#define QI_DEV_IOTLB_PFSID(pfsid) (((u64)(pfsid & 0xf) << 12) | ((u64)(pfsid & 0xfff) << 52))
+#define QI_DEV_IOTLB_PFSID(pfsid) (((u64)(pfsid & 0xf) << 12) | \
+				   ((u64)((pfsid >> 4) & 0xfff) << 52))
 #define QI_DEV_IOTLB_SIZE	1
 #define QI_DEV_IOTLB_MAX_INVS	32
 
@@ -320,7 +321,8 @@ enum {
 #define QI_DEV_EIOTLB_PASID(p)	(((u64)p) << 32)
 #define QI_DEV_EIOTLB_SID(sid)	((u64)((sid) & 0xffff) << 16)
 #define QI_DEV_EIOTLB_QDEP(qd)	((u64)((qd) & 0x1f) << 4)
-#define QI_DEV_EIOTLB_PFSID(pfsid) (((u64)(pfsid & 0xf) << 12) | ((u64)(pfsid & 0xfff) << 52))
+#define QI_DEV_EIOTLB_PFSID(pfsid) (((u64)(pfsid & 0xf) << 12) | \
+				    ((u64)((pfsid >> 4) & 0xfff) << 52))
 #define QI_DEV_EIOTLB_MAX_INVS	32
 
 #define QI_PGRP_IDX(idx)	(((u64)(idx)) << 55)


