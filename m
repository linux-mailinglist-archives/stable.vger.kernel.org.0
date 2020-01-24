Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE0F6147F5A
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:01:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730170AbgAXLBk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:01:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:34628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731514AbgAXLBk (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:01:40 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 099642075D;
        Fri, 24 Jan 2020 11:01:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579863699;
        bh=f5u5Esc9Dg6kRn/+Eea2oLe0Ud7hYJKU4FUVAAQPc58=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vo99PXKqXF1dm508Pr4/DUmvfaFLrUWLqYO1BRNUNTsSnMvt5xdb/rHftfZCSM6Cm
         75xZT+K8inn238uj+kA2KztzMYx/k0ehTwn+IkBDDlwtdObpa6MDXPrEJ+tJAJ4qo+
         2WiiA8E2juUoxlJO6ghlGJ6yaMiFoAH63a60JNb4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 051/639] powerpc/pseries/memory-hotplug: Fix return value type of find_aa_index
Date:   Fri, 24 Jan 2020 10:23:41 +0100
Message-Id: <20200124093053.800377097@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit b45e9d761ba2d60044b610297e3ef9f947ac157f ]

The variable 'aa_index' is defined as an unsigned value in
update_lmb_associativity_index(), but find_aa_index() may return -1
when dlpar_clone_property() fails. So change find_aa_index() to return
a bool, which indicates whether 'aa_index' was found or not.

Fixes: c05a5a40969e ("powerpc/pseries: Dynamic add entires to associativity lookup array")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Reviewed-by: Nathan Fontenot nfont@linux.vnet.ibm.com>
[mpe: Tweak changelog, rename is_found to just found]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../platforms/pseries/hotplug-memory.c        | 61 +++++++++----------
 1 file changed, 28 insertions(+), 33 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/hotplug-memory.c b/arch/powerpc/platforms/pseries/hotplug-memory.c
index 7f86bc3eaadec..62d3c72cd9316 100644
--- a/arch/powerpc/platforms/pseries/hotplug-memory.c
+++ b/arch/powerpc/platforms/pseries/hotplug-memory.c
@@ -101,11 +101,12 @@ static struct property *dlpar_clone_property(struct property *prop,
 	return new_prop;
 }
 
-static u32 find_aa_index(struct device_node *dr_node,
-			 struct property *ala_prop, const u32 *lmb_assoc)
+static bool find_aa_index(struct device_node *dr_node,
+			 struct property *ala_prop,
+			 const u32 *lmb_assoc, u32 *aa_index)
 {
-	u32 *assoc_arrays;
-	u32 aa_index;
+	u32 *assoc_arrays, new_prop_size;
+	struct property *new_prop;
 	int aa_arrays, aa_array_entries, aa_array_sz;
 	int i, index;
 
@@ -121,46 +122,39 @@ static u32 find_aa_index(struct device_node *dr_node,
 	aa_array_entries = be32_to_cpu(assoc_arrays[1]);
 	aa_array_sz = aa_array_entries * sizeof(u32);
 
-	aa_index = -1;
 	for (i = 0; i < aa_arrays; i++) {
 		index = (i * aa_array_entries) + 2;
 
 		if (memcmp(&assoc_arrays[index], &lmb_assoc[1], aa_array_sz))
 			continue;
 
-		aa_index = i;
-		break;
+		*aa_index = i;
+		return true;
 	}
 
-	if (aa_index == -1) {
-		struct property *new_prop;
-		u32 new_prop_size;
-
-		new_prop_size = ala_prop->length + aa_array_sz;
-		new_prop = dlpar_clone_property(ala_prop, new_prop_size);
-		if (!new_prop)
-			return -1;
-
-		assoc_arrays = new_prop->value;
+	new_prop_size = ala_prop->length + aa_array_sz;
+	new_prop = dlpar_clone_property(ala_prop, new_prop_size);
+	if (!new_prop)
+		return false;
 
-		/* increment the number of entries in the lookup array */
-		assoc_arrays[0] = cpu_to_be32(aa_arrays + 1);
+	assoc_arrays = new_prop->value;
 
-		/* copy the new associativity into the lookup array */
-		index = aa_arrays * aa_array_entries + 2;
-		memcpy(&assoc_arrays[index], &lmb_assoc[1], aa_array_sz);
+	/* increment the number of entries in the lookup array */
+	assoc_arrays[0] = cpu_to_be32(aa_arrays + 1);
 
-		of_update_property(dr_node, new_prop);
+	/* copy the new associativity into the lookup array */
+	index = aa_arrays * aa_array_entries + 2;
+	memcpy(&assoc_arrays[index], &lmb_assoc[1], aa_array_sz);
 
-		/*
-		 * The associativity lookup array index for this lmb is
-		 * number of entries - 1 since we added its associativity
-		 * to the end of the lookup array.
-		 */
-		aa_index = be32_to_cpu(assoc_arrays[0]) - 1;
-	}
+	of_update_property(dr_node, new_prop);
 
-	return aa_index;
+	/*
+	 * The associativity lookup array index for this lmb is
+	 * number of entries - 1 since we added its associativity
+	 * to the end of the lookup array.
+	 */
+	*aa_index = be32_to_cpu(assoc_arrays[0]) - 1;
+	return true;
 }
 
 static int update_lmb_associativity_index(struct drmem_lmb *lmb)
@@ -169,6 +163,7 @@ static int update_lmb_associativity_index(struct drmem_lmb *lmb)
 	struct property *ala_prop;
 	const u32 *lmb_assoc;
 	u32 aa_index;
+	bool found;
 
 	parent = of_find_node_by_path("/");
 	if (!parent)
@@ -200,12 +195,12 @@ static int update_lmb_associativity_index(struct drmem_lmb *lmb)
 		return -ENODEV;
 	}
 
-	aa_index = find_aa_index(dr_node, ala_prop, lmb_assoc);
+	found = find_aa_index(dr_node, ala_prop, lmb_assoc, &aa_index);
 
 	of_node_put(dr_node);
 	dlpar_free_cc_nodes(lmb_node);
 
-	if (aa_index < 0) {
+	if (!found) {
 		pr_err("Could not find LMB associativity\n");
 		return -1;
 	}
-- 
2.20.1



