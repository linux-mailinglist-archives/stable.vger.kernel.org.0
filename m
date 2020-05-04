Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C6851C44EC
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 20:11:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731662AbgEDSEW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 14:04:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:33758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731660AbgEDSEW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 May 2020 14:04:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5CB28206B8;
        Mon,  4 May 2020 18:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588615461;
        bh=fyBOmnqKsuvNpxFwlXUHV4DLG7y2lqjw2zO/T3sFijI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d6Ra093W8+2ey56LWufxc4v/NMH7Cy+MYu4GroZ7hfmj9+MRtzugRLaNCFga/G9t/
         pXDTlXfCXe9VVSI3IkWUvs73pvaLOAOjaTUleI5zBtXVHf91297t6bxnNZvwVnDKrR
         r+1akX3w7Hi4wdRNplc0wxOtfEqZwlHv0SExO1jE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 5.4 48/57] iommu/amd: Fix legacy interrupt remapping for x2APIC-enabled system
Date:   Mon,  4 May 2020 19:57:52 +0200
Message-Id: <20200504165500.595704118@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200504165456.783676004@linuxfoundation.org>
References: <20200504165456.783676004@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>

commit b74aa02d7a30ee5e262072a7d6e8deff10b37924 upstream.

Currently, system fails to boot because the legacy interrupt remapping
mode does not enable 128-bit IRTE (GA), which is required for x2APIC
support.

Fix by using AMD_IOMMU_GUEST_IR_LEGACY_GA mode when booting with
kernel option amd_iommu_intr=legacy instead. The initialization
logic will check GASup and automatically fallback to using
AMD_IOMMU_GUEST_IR_LEGACY if GA mode is not supported.

Fixes: 3928aa3f5775 ("iommu/amd: Detect and enable guest vAPIC support")
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Link: https://lore.kernel.org/r/1587562202-14183-1-git-send-email-suravee.suthikulpanit@amd.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iommu/amd_iommu_init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -2946,7 +2946,7 @@ static int __init parse_amd_iommu_intr(c
 {
 	for (; *str; ++str) {
 		if (strncmp(str, "legacy", 6) == 0) {
-			amd_iommu_guest_ir = AMD_IOMMU_GUEST_IR_LEGACY;
+			amd_iommu_guest_ir = AMD_IOMMU_GUEST_IR_LEGACY_GA;
 			break;
 		}
 		if (strncmp(str, "vapic", 5) == 0) {


