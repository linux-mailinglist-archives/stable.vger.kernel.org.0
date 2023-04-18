Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 187A16E64E9
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:53:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232230AbjDRMxb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:53:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232203AbjDRMx3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:53:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0718218391
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:53:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6D6326286F
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:53:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 810AFC433D2;
        Tue, 18 Apr 2023 12:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681822391;
        bh=oNRHKlpBGx5o+DM+fn7UAlEabvjKmS3NKQxywnfXrY4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pu5UdJBWy4rFsOUV7vbIUV/k+Kae6+FxFgO4eXJdUHl3WtYdofCq8R35SJ7VBZ8FR
         Mz0/waKQcjLpMHhyrqL0a9VkADto5oHLntyV02aGAk3zEDQObZTOCk4XVnX/M2KoNn
         dY6f+/fytSeSjGb80CQPXjC7VX98BJ60+hJc6O6s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 131/139] powerpc/papr_scm: Update the NUMA distance table for the target node
Date:   Tue, 18 Apr 2023 14:23:16 +0200
Message-Id: <20230418120318.799248789@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.725598495@linuxfoundation.org>
References: <20230418120313.725598495@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>

[ Upstream commit b277fc793daf258877b4c0744b52f69d6e6ba22e ]

Platform device helper routines won't update the NUMA distance table
while creating a platform device, even if the device is present on a
NUMA node that doesn't have memory or CPU. This is especially true for
pmem devices. If the target node of the pmem device is not online, we
find the nearest online node to the device and associate the pmem device
with that online node. To find the nearest online node, we should have
the numa distance table updated correctly. Update the distance
information during the device probe.

For a papr scm device on NUMA node 3 distance_lookup_table value for
distance_ref_points_depth = 2 before and after fix is below:

Before fix:
  node 3 distance depth 0  - 0
  node 3 distance depth 1  - 0
  node 4 distance depth 0  - 4
  node 4 distance depth 1  - 2
  node 5 distance depth 0  - 5
  node 5 distance depth 1  - 1

After fix
  node 3 distance depth 0  - 3
  node 3 distance depth 1  - 1
  node 4 distance depth 0  - 4
  node 4 distance depth 1  - 2
  node 5 distance depth 0  - 5
  node 5 distance depth 1  - 1

Without the fix, the nearest numa node to the pmem device (NUMA node 3)
will be picked as 4. After the fix, we get the correct numa node which
is 5.

Fixes: da1115fdbd6e ("powerpc/nvdimm: Pick nearby online node if the device node is not online")
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20230404041433.1781804-1-aneesh.kumar@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/mm/numa.c                    | 1 +
 arch/powerpc/platforms/pseries/papr_scm.c | 7 +++++++
 2 files changed, 8 insertions(+)

diff --git a/arch/powerpc/mm/numa.c b/arch/powerpc/mm/numa.c
index b44ce71917d75..16cfe56be05bb 100644
--- a/arch/powerpc/mm/numa.c
+++ b/arch/powerpc/mm/numa.c
@@ -366,6 +366,7 @@ void update_numa_distance(struct device_node *node)
 	WARN(numa_distance_table[nid][nid] == -1,
 	     "NUMA distance details for node %d not provided\n", nid);
 }
+EXPORT_SYMBOL_GPL(update_numa_distance);
 
 /*
  * ibm,numa-lookup-index-table= {N, domainid1, domainid2, ..... domainidN}
diff --git a/arch/powerpc/platforms/pseries/papr_scm.c b/arch/powerpc/platforms/pseries/papr_scm.c
index 2f8385523a132..1a53e048ceb76 100644
--- a/arch/powerpc/platforms/pseries/papr_scm.c
+++ b/arch/powerpc/platforms/pseries/papr_scm.c
@@ -1428,6 +1428,13 @@ static int papr_scm_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
+	/*
+	 * open firmware platform device create won't update the NUMA 
+	 * distance table. For PAPR SCM devices we use numa_map_to_online_node()
+	 * to find the nearest online NUMA node and that requires correct
+	 * distance table information.
+	 */
+	update_numa_distance(dn);
 
 	p = kzalloc(sizeof(*p), GFP_KERNEL);
 	if (!p)
-- 
2.39.2



