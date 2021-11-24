Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84FDA45C59F
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:57:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349151AbhKXN7b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:59:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:44604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353201AbhKXN44 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:56:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 17CE9633BA;
        Wed, 24 Nov 2021 13:07:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759248;
        bh=3DEEtA2d9eYMusYWKMLbgn+bfHLebArXs9TIeVEp3kA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Npt0Q+9EaQ+NH63Gw4kn6FP5CR4CCE5qp4fV/R6E17B+/Pr3LDexT8LC0uSptQczE
         P/sYsTbMBN3kCLvr4D7Rny1BkJm3pE6VQ4e4RGm76YYssjBmkuKaIonbvRNglz7KsQ
         iur9aNfu5eIEZvVFuUwWtibYVmRmBjFVBGhkziiw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 178/279] powerpc/pseries: rename numa_dist_table to form2_distances
Date:   Wed, 24 Nov 2021 12:57:45 +0100
Message-Id: <20211124115724.893956338@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Piggin <npiggin@gmail.com>

[ Upstream commit 0bd81274e3f1195ee7c820ef02d62f31077c42c3 ]

The name of the local variable holding the "form2" property address
conflicts with the numa_distance_table global.

This patch does 's/numa_dist_table/form2_distances/g' over the function,
which also renames numa_dist_table_length to form2_distances_length.

Suggested-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20211109064900.2041386-1-npiggin@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/mm/numa.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/powerpc/mm/numa.c b/arch/powerpc/mm/numa.c
index 6f14c8fb6359d..53e9901409163 100644
--- a/arch/powerpc/mm/numa.c
+++ b/arch/powerpc/mm/numa.c
@@ -376,9 +376,9 @@ static void initialize_form2_numa_distance_lookup_table(void)
 {
 	int i, j;
 	struct device_node *root;
-	const __u8 *numa_dist_table;
+	const __u8 *form2_distances;
 	const __be32 *numa_lookup_index;
-	int numa_dist_table_length;
+	int form2_distances_length;
 	int max_numa_index, distance_index;
 
 	if (firmware_has_feature(FW_FEATURE_OPAL))
@@ -392,20 +392,20 @@ static void initialize_form2_numa_distance_lookup_table(void)
 	max_numa_index = of_read_number(&numa_lookup_index[0], 1);
 
 	/* first element of the array is the size and is encode-int */
-	numa_dist_table = of_get_property(root, "ibm,numa-distance-table", NULL);
-	numa_dist_table_length = of_read_number((const __be32 *)&numa_dist_table[0], 1);
+	form2_distances = of_get_property(root, "ibm,numa-distance-table", NULL);
+	form2_distances_length = of_read_number((const __be32 *)&form2_distances[0], 1);
 	/* Skip the size which is encoded int */
-	numa_dist_table += sizeof(__be32);
+	form2_distances += sizeof(__be32);
 
-	pr_debug("numa_dist_table_len = %d, numa_dist_indexes_len = %d\n",
-		 numa_dist_table_length, max_numa_index);
+	pr_debug("form2_distances_len = %d, numa_dist_indexes_len = %d\n",
+		 form2_distances_length, max_numa_index);
 
 	for (i = 0; i < max_numa_index; i++)
 		/* +1 skip the max_numa_index in the property */
 		numa_id_index_table[i] = of_read_number(&numa_lookup_index[i + 1], 1);
 
 
-	if (numa_dist_table_length != max_numa_index * max_numa_index) {
+	if (form2_distances_length != max_numa_index * max_numa_index) {
 		WARN(1, "Wrong NUMA distance information\n");
 		/* consider everybody else just remote. */
 		for (i = 0;  i < max_numa_index; i++) {
@@ -427,7 +427,7 @@ static void initialize_form2_numa_distance_lookup_table(void)
 			int nodeA = numa_id_index_table[i];
 			int nodeB = numa_id_index_table[j];
 
-			numa_distance_table[nodeA][nodeB] = numa_dist_table[distance_index++];
+			numa_distance_table[nodeA][nodeB] = form2_distances[distance_index++];
 			pr_debug("dist[%d][%d]=%d ", nodeA, nodeB, numa_distance_table[nodeA][nodeB]);
 		}
 	}
-- 
2.33.0



