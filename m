Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3193B18B730
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:32:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728437AbgCSNQy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:16:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:37528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728503AbgCSNQv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:16:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1715A21835;
        Thu, 19 Mar 2020 13:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584623811;
        bh=2vhibI530la2nXP38czFOi1Gon/TlBG9XWRRNIpIJCA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IJrmsX+2LYfFu0Gwa8blkupS1rV8nSrVPX8AznEZ8Mq8EgizxOCp8xfBKEwg7IiYA
         shpqMrLccn1cRKy/clDsDBBQSyhLirGVORRa93ZCSFCUsAG6+gMkbg81qucAmUyM2O
         5gL6fe4C38Vz94BAENl/o6NLJn3Sorc3BOGrjfm4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lu Baolu <baolu.lu@linux.intel.com>,
        Zhenzhong Duan <zhenzhong.duan@gmail.com>,
        Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 4.14 61/99] iommu/vt-d: Fix the wrong printing in RHSA parsing
Date:   Thu, 19 Mar 2020 14:03:39 +0100
Message-Id: <20200319124000.098327497@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123941.630731708@linuxfoundation.org>
References: <20200319123941.630731708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhenzhong Duan <zhenzhong.duan@gmail.com>

commit b0bb0c22c4db623f2e7b1a471596fbf1c22c6dc5 upstream.

When base address in RHSA structure doesn't match base address in
each DRHD structure, the base address in last DRHD is printed out.

This doesn't make sense when there are multiple DRHD units, fix it
by printing the buggy RHSA's base address.

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Zhenzhong Duan <zhenzhong.duan@gmail.com>
Fixes: fd0c8894893cb ("intel-iommu: Set a more specific taint flag for invalid BIOS DMAR tables")
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iommu/dmar.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iommu/dmar.c
+++ b/drivers/iommu/dmar.c
@@ -486,7 +486,7 @@ static int dmar_parse_one_rhsa(struct ac
 	pr_warn(FW_BUG
 		"Your BIOS is broken; RHSA refers to non-existent DMAR unit at %llx\n"
 		"BIOS vendor: %s; Ver: %s; Product Version: %s\n",
-		drhd->reg_base_addr,
+		rhsa->base_address,
 		dmi_get_system_info(DMI_BIOS_VENDOR),
 		dmi_get_system_info(DMI_BIOS_VERSION),
 		dmi_get_system_info(DMI_PRODUCT_VERSION));


