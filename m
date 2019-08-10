Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7337B88D73
	for <lists+stable@lfdr.de>; Sat, 10 Aug 2019 22:46:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727029AbfHJUqC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Aug 2019 16:46:02 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55328 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726903AbfHJUoH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Aug 2019 16:44:07 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDb-00053W-W4; Sat, 10 Aug 2019 21:44:04 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDL-0003dr-J9; Sat, 10 Aug 2019 21:43:47 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Joerg Roedel" <jroedel@suse.de>
Date:   Sat, 10 Aug 2019 21:40:07 +0100
Message-ID: <lsq.1565469607.467361670@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 080/157] iommu/amd: Set exclusion range correctly
In-Reply-To: <lsq.1565469607.188083258@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.72-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Joerg Roedel <jroedel@suse.de>

commit 3c677d206210f53a4be972211066c0f1cd47fe12 upstream.

The exlcusion range limit register needs to contain the
base-address of the last page that is part of the range, as
bits 0-11 of this register are treated as 0xfff by the
hardware for comparisons.

So correctly set the exclusion range in the hardware to the
last page which is _in_ the range.

Fixes: b2026aa2dce44 ('x86, AMD IOMMU: add functions for programming IOMMU MMIO space')
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/iommu/amd_iommu_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -293,7 +293,7 @@ static void iommu_write_l2(struct amd_io
 static void iommu_set_exclusion_range(struct amd_iommu *iommu)
 {
 	u64 start = iommu->exclusion_start & PAGE_MASK;
-	u64 limit = (start + iommu->exclusion_length) & PAGE_MASK;
+	u64 limit = (start + iommu->exclusion_length - 1) & PAGE_MASK;
 	u64 entry;
 
 	if (!iommu->exclusion_start)

