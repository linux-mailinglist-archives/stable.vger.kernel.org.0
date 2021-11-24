Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1662145C59E
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:56:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350293AbhKXN7a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:59:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:44614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353214AbhKXN44 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:56:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F1C49632D2;
        Wed, 24 Nov 2021 13:07:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759252;
        bh=1X6IycQq6ZS7VQDObEsRONXXu1Rym3Fy8sT2r031DDs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xDuWqpr4NpcQaG4QUddDm+ARG8PRExq/SCpTrNLtdnSCLjuAoDjgxyyH2752cFyuY
         mjD3lGRW8WeAaix2s3e9tZOm1rMChT0C8bOkBCwnmjkOkpkjTvjl9aJG/REbd3JKD/
         ZcitbKTPy0WD4WmI1dOtUvfPcq6tQVzX3+02R55A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 179/279] powerpc/pseries: Fix numa FORM2 parsing fallback code
Date:   Wed, 24 Nov 2021 12:57:46 +0100
Message-Id: <20211124115724.932548287@linuxfoundation.org>
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

[ Upstream commit 302039466f6a3b9421ecb9a6a2c528801dc24a86 ]

In case the FORM2 distance table from firmware is not the expected size,
there is fallback code that just populates the lookup table as local vs
remote.

However it then continues on to use the distance table. Fix.

Fixes: 1c6b5a7e7405 ("powerpc/pseries: Add support for FORM2 associativity")
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20211109064900.2041386-2-npiggin@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/mm/numa.c | 28 ++++++++++++----------------
 1 file changed, 12 insertions(+), 16 deletions(-)

diff --git a/arch/powerpc/mm/numa.c b/arch/powerpc/mm/numa.c
index 53e9901409163..59d3cfcd78879 100644
--- a/arch/powerpc/mm/numa.c
+++ b/arch/powerpc/mm/numa.c
@@ -407,30 +407,26 @@ static void initialize_form2_numa_distance_lookup_table(void)
 
 	if (form2_distances_length != max_numa_index * max_numa_index) {
 		WARN(1, "Wrong NUMA distance information\n");
-		/* consider everybody else just remote. */
-		for (i = 0;  i < max_numa_index; i++) {
-			for (j = 0; j < max_numa_index; j++) {
-				int nodeA = numa_id_index_table[i];
-				int nodeB = numa_id_index_table[j];
-
-				if (nodeA == nodeB)
-					numa_distance_table[nodeA][nodeB] = LOCAL_DISTANCE;
-				else
-					numa_distance_table[nodeA][nodeB] = REMOTE_DISTANCE;
-			}
-		}
+		form2_distances = NULL; // don't use it
 	}
-
 	distance_index = 0;
 	for (i = 0;  i < max_numa_index; i++) {
 		for (j = 0; j < max_numa_index; j++) {
 			int nodeA = numa_id_index_table[i];
 			int nodeB = numa_id_index_table[j];
-
-			numa_distance_table[nodeA][nodeB] = form2_distances[distance_index++];
-			pr_debug("dist[%d][%d]=%d ", nodeA, nodeB, numa_distance_table[nodeA][nodeB]);
+			int dist;
+
+			if (form2_distances)
+				dist = form2_distances[distance_index++];
+			else if (nodeA == nodeB)
+				dist = LOCAL_DISTANCE;
+			else
+				dist = REMOTE_DISTANCE;
+			numa_distance_table[nodeA][nodeB] = dist;
+			pr_debug("dist[%d][%d]=%d ", nodeA, nodeB, dist);
 		}
 	}
+
 	of_node_put(root);
 }
 
-- 
2.33.0



