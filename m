Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2C496E6398
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:42:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231866AbjDRMmC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:42:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231867AbjDRMmB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:42:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 405021446C
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:41:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 170B86332A
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:41:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2951EC433D2;
        Tue, 18 Apr 2023 12:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681821698;
        bh=hEQpbX8PcS+rl2LEoj69W0o+FjA/O/Jbw0vIpJRWI1Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TjbPmPiXHQcBulcxJQlXgW4RtzHINxirpiWDcoN8Io3uaOYGdHiwUK8NI9kEm6UuG
         LJdgzD7p8usq3xu5sENtz0DaeTQULEOwq53oVtLCo7otuC08uAqIEPn0uiVSv9FvuT
         MXHmScWCnT2/v7a5jVi7LOPG+nVk2k3eFoPmulwc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 69/91] powerpc/papr_scm: Update the NUMA distance table for the target node
Date:   Tue, 18 Apr 2023 14:22:13 +0200
Message-Id: <20230418120307.958951471@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120305.520719816@linuxfoundation.org>
References: <20230418120305.520719816@linuxfoundation.org>
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
index 5fb829256b59d..9c038c8cebebc 100644
--- a/arch/powerpc/mm/numa.c
+++ b/arch/powerpc/mm/numa.c
@@ -367,6 +367,7 @@ void update_numa_distance(struct device_node *node)
 	WARN(numa_distance_table[nid][nid] == -1,
 	     "NUMA distance details for node %d not provided\n", nid);
 }
+EXPORT_SYMBOL_GPL(update_numa_distance);
 
 /*
  * ibm,numa-lookup-index-table= {N, domainid1, domainid2, ..... domainidN}
diff --git a/arch/powerpc/platforms/pseries/papr_scm.c b/arch/powerpc/platforms/pseries/papr_scm.c
index f48e87ac89c9b..3cfcc748052e9 100644
--- a/arch/powerpc/platforms/pseries/papr_scm.c
+++ b/arch/powerpc/platforms/pseries/papr_scm.c
@@ -1159,6 +1159,13 @@ static int papr_scm_probe(struct platform_device *pdev)
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



