Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8DEA1AEE2B
	for <lists+stable@lfdr.de>; Sat, 18 Apr 2020 16:12:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726423AbgDROLH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Apr 2020 10:11:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:39026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727921AbgDROKj (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 18 Apr 2020 10:10:39 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 692FF22253;
        Sat, 18 Apr 2020 14:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587219039;
        bh=WYwADE8W9KPmvHMc3c5wIpArVFGP+Hhg+m2Vbn8klTk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gs6g1+4VOiJQRNaBquvxYsDP9FI61vS+YZSuRnuCvgKuySinke+AGB3QDzTd6dr1K
         q8UBPJ++zPffCeG1kZnqMRoyytth5h0h04cnbRLOPpBeXBtxV2hRNkE9QM1/wk6Y0I
         FnCgLAXervzziEboou/TCOl3qhaSCvXkwpc5twZU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Frederic Barrat <fbarrat@linux.ibm.com>,
        Alastair D'Silva <alastair@d-silva.org>,
        Andrew Donnellan <ajd@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org,
        linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 72/75] pci/hotplug/pnv-php: Remove erroneous warning
Date:   Sat, 18 Apr 2020 10:09:07 -0400
Message-Id: <20200418140910.8280-72-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200418140910.8280-1-sashal@kernel.org>
References: <20200418140910.8280-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frederic Barrat <fbarrat@linux.ibm.com>

[ Upstream commit 658ab186dd22060408d94f5c5a6d02d809baba44 ]

On powernv, when removing a device through hotplug, the following
warning is logged:

     Invalid refcount <.> on <...>

It may be incorrect, the refcount may be set to a higher value than 1
and be valid. of_detach_node() can drop more than one reference. As it
doesn't seem trivial to assert the correct value, let's remove the
warning.

Reviewed-by: Alastair D'Silva <alastair@d-silva.org>
Reviewed-by: Andrew Donnellan <ajd@linux.ibm.com>
Signed-off-by: Frederic Barrat <fbarrat@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20191121134918.7155-7-fbarrat@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/hotplug/pnv_php.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/pci/hotplug/pnv_php.c b/drivers/pci/hotplug/pnv_php.c
index d7b2b47bc33eb..6037983c6e46b 100644
--- a/drivers/pci/hotplug/pnv_php.c
+++ b/drivers/pci/hotplug/pnv_php.c
@@ -151,17 +151,11 @@ static void pnv_php_rmv_pdns(struct device_node *dn)
 static void pnv_php_detach_device_nodes(struct device_node *parent)
 {
 	struct device_node *dn;
-	int refcount;
 
 	for_each_child_of_node(parent, dn) {
 		pnv_php_detach_device_nodes(dn);
 
 		of_node_put(dn);
-		refcount = kref_read(&dn->kobj.kref);
-		if (refcount != 1)
-			pr_warn("Invalid refcount %d on <%pOF>\n",
-				refcount, dn);
-
 		of_detach_node(dn);
 	}
 }
-- 
2.20.1

