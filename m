Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 152F92F79ED
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 13:44:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731755AbhAOMiw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:38:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:45834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387616AbhAOMis (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:38:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 370322333E;
        Fri, 15 Jan 2021 12:38:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610714312;
        bh=pYvsIQ3m+v4HkQIbMDv6EVsgtV4Q99P4GNDs7iJxQUU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hz8xbvHh6po6NY4ixLxU7d8KxlvItIbg4MGBGQqEq7JRJxBjToehupA+TJayL0pQV
         YEAAfsbt9/xRsZL7rge8AZBvOgo9WuHhrGFb4G1vSR1cS2cU2aG2zT1VVEoF3IKHtd
         EjjEceTk5JYSREWzkubrxx0w2/fuWIEcJ+JcYu8s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lu Baolu <baolu.lu@linux.intel.com>,
        Will Deacon <will@kernel.org>
Subject: [PATCH 5.10 080/103] iommu/vt-d: Fix misuse of ALIGN in qi_flush_piotlb()
Date:   Fri, 15 Jan 2021 13:28:13 +0100
Message-Id: <20210115122009.894424636@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115122006.047132306@linuxfoundation.org>
References: <20210115122006.047132306@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lu Baolu <baolu.lu@linux.intel.com>

commit 1efd17e7acb6692bffc6c58718f41f27fdfd62f5 upstream.

Use IS_ALIGNED() instead. Otherwise, an unaligned address will be ignored.

Fixes: 33cd6e642d6a ("iommu/vt-d: Flush PASID-based iotlb for iova over first level")
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Link: https://lore.kernel.org/r/20201231005323.2178523-1-baolu.lu@linux.intel.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iommu/intel/dmar.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/iommu/intel/dmar.c
+++ b/drivers/iommu/intel/dmar.c
@@ -1461,8 +1461,8 @@ void qi_flush_piotlb(struct intel_iommu
 		int mask = ilog2(__roundup_pow_of_two(npages));
 		unsigned long align = (1ULL << (VTD_PAGE_SHIFT + mask));
 
-		if (WARN_ON_ONCE(!ALIGN(addr, align)))
-			addr &= ~(align - 1);
+		if (WARN_ON_ONCE(!IS_ALIGNED(addr, align)))
+			addr = ALIGN_DOWN(addr, align);
 
 		desc.qw0 = QI_EIOTLB_PASID(pasid) |
 				QI_EIOTLB_DID(did) |


