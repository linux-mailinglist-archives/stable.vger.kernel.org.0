Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5B8211B6FA
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 17:05:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387850AbfLKQDX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 11:03:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:35828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730850AbfLKPND (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:13:03 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C0DFA24688;
        Wed, 11 Dec 2019 15:13:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077182;
        bh=3iC+18TvAnQn3O8cFqW+/Dl+rOgTPGJCJH7ffZJuQTI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M++Vv1mKMgVzeReukqpPa16Efa2bd/R0+80NHAqH5jLCp+A1UMXbiW8Ra6kjWGtQp
         PmLFJhOdodOwncUrX3rU8DO/wk9yGtSEjAFtM3CsA0GtPG6m4UL4s3ovvo8roV4B4p
         kfOjzQlGna1/IapB9ZU4587nu9cp29kDiceS4s7g=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tyrel Datwyler <tyreld@linux.ibm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 066/134] PCI: rpaphp: Don't rely on firmware feature to imply drc-info support
Date:   Wed, 11 Dec 2019 10:10:42 -0500
Message-Id: <20191211151150.19073-66-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191211151150.19073-1-sashal@kernel.org>
References: <20191211151150.19073-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tyrel Datwyler <tyreld@linux.ibm.com>

[ Upstream commit 52e2b0f16574afd082cff0f0e8567b2d9f68c033 ]

In the event that the partition is migrated to a platform with older
firmware that doesn't support the ibm,drc-info property the device
tree is modified to remove the ibm,drc-info property and replace it
with the older style ibm,drc-* properties for types, names, indexes,
and power-domains. One of the requirements of the drc-info firmware
feature is that the client is able to handle both the new property,
and old style properties at runtime. Therefore we can't rely on the
firmware feature alone to dictate which property is currently
present in the device tree.

Fix this short coming by checking explicitly for the ibm,drc-info
property, and falling back to the older ibm,drc-* properties if it
doesn't exist.

Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
Acked-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/1573449697-5448-6-git-send-email-tyreld@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/hotplug/rpaphp_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/hotplug/rpaphp_core.c b/drivers/pci/hotplug/rpaphp_core.c
index e3502644a45c3..e18e9a0e959c8 100644
--- a/drivers/pci/hotplug/rpaphp_core.c
+++ b/drivers/pci/hotplug/rpaphp_core.c
@@ -275,7 +275,7 @@ int rpaphp_check_drc_props(struct device_node *dn, char *drc_name,
 		return -EINVAL;
 	}
 
-	if (firmware_has_feature(FW_FEATURE_DRC_INFO))
+	if (of_find_property(dn->parent, "ibm,drc-info", NULL))
 		return rpaphp_check_drc_props_v2(dn, drc_name, drc_type,
 						*my_index);
 	else
-- 
2.20.1

