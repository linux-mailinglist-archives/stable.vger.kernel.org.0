Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A74913F833
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 20:18:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732911AbgAPTQ3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 14:16:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:41310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732878AbgAPQzo (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:55:44 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D1FFF21D56;
        Thu, 16 Jan 2020 16:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193743;
        bh=DZkziBpfqckwNkeg7jDD1qzOPOfp/MLw+qLK75gTTdc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yo1evpO9gbTWjj++VsyQPLPlRzWWUivmxMNKEuV6aOhuvBUnFRY884JYwrgZobw1j
         v7q4QrqWb6yPI8l21zX8OmatSkA/bXEIs34R3uTJhqEBOCboi+4wVg6yn3znciKuZx
         QNzJ7xiLEsfMwY8icM2q4KEq6BF6YsC4b+LSJTD8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     YueHaibing <yuehaibing@huawei.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.19 034/671] powerpc/pseries/memory-hotplug: Fix return value type of find_aa_index
Date:   Thu, 16 Jan 2020 11:44:25 -0500
Message-Id: <20200116165502.8838-34-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116165502.8838-1-sashal@kernel.org>
References: <20200116165502.8838-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 7f86bc3eaade..62d3c72cd931 100644
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

