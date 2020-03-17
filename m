Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CBA31881AF
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 12:20:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727912AbgCQLSW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 07:18:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:47852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728632AbgCQLGc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 07:06:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ACE5C20658;
        Tue, 17 Mar 2020 11:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584443192;
        bh=B4tdeLKm7NZ6cqVXu4gpvNgoZu6YVSYkH/hYD/HE9x4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZeA3F/0V90Fwcp80v5bG3BmmH84Mn63hB84yRhaUOMXYyzShn57OKO4CojPkU9IUr
         TBGz9ODs/bZ5n0mC10Rq9+GW3LHLiRXdKoGAUmBiMuJLc7pt3Kb+ysYXJ8+ow8Veds
         W2pX4n8P3Uf/QdTSD5sOEbHti+oIlSxc/bv1zDEw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lu Baolu <baolu.lu@linux.intel.com>,
        Zhenzhong Duan <zhenzhong.duan@gmail.com>,
        Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 5.4 117/123] iommu/vt-d: Fix the wrong printing in RHSA parsing
Date:   Tue, 17 Mar 2020 11:55:44 +0100
Message-Id: <20200317103319.300776916@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200317103307.343627747@linuxfoundation.org>
References: <20200317103307.343627747@linuxfoundation.org>
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
@@ -475,7 +475,7 @@ static int dmar_parse_one_rhsa(struct ac
 	pr_warn(FW_BUG
 		"Your BIOS is broken; RHSA refers to non-existent DMAR unit at %llx\n"
 		"BIOS vendor: %s; Ver: %s; Product Version: %s\n",
-		drhd->reg_base_addr,
+		rhsa->base_address,
 		dmi_get_system_info(DMI_BIOS_VENDOR),
 		dmi_get_system_info(DMI_BIOS_VERSION),
 		dmi_get_system_info(DMI_PRODUCT_VERSION));


