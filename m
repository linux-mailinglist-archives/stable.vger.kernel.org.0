Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89B5012EC08
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:15:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725872AbgABWOe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:14:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:54860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727924AbgABWOd (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:14:33 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 91460227BF;
        Thu,  2 Jan 2020 22:14:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003273;
        bh=xlO0hW8HwwmBoIWU7FFfajmYwX2EVeIdAt9PO8IObF4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nblZCclKZs5C+NvbXJMCcIBndr5NcSNbww6Fx8E0JLa/y6+HFlKlWYCIItNLQKev/
         4Ns54uwt6/CYI157dQOW5zj/vmAWsCDIwqYvM7/FfrpOHyF2U6JCUGaGu5Jkg6/6Cs
         ABy573F3FZm9/5+iqywauntLkvk1RVdsNhRoabOE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tyrel Datwyler <tyreld@linux.ibm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 066/191] PCI: rpaphp: Dont rely on firmware feature to imply drc-info support
Date:   Thu,  2 Jan 2020 23:05:48 +0100
Message-Id: <20200102215837.052359330@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102215829.911231638@linuxfoundation.org>
References: <20200102215829.911231638@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index e3502644a45c..e18e9a0e959c 100644
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



