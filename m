Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 871FF6E62E6
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:36:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231739AbjDRMg2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:36:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231721AbjDRMg1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:36:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB38A12C81
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:36:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6756E63289
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:36:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CAFAC433EF;
        Tue, 18 Apr 2023 12:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681821382;
        bh=/IIsCZbBlfHq7rDrO7dgQhqpRXp7gEq3Q9xbCj8QCzE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tpTReG/ieZJVIKIyBocVfSjqTmxmDJPfxqSKKIJRFGJmJLEXE/rhGQxj2AHlgL1cD
         zu8gSJ3Iek2V4oB9zkDoPfqOrn9TA+vbzbvyl/d8yZ9fBGdIyZTOHsmJcTUC/d/Frd
         +qU049P8xro7/ePcLIIMea7j3ktEDXe1wRGjSafQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 106/124] powerpc/papr_scm: Update the NUMA distance table for the target node
Date:   Tue, 18 Apr 2023 14:22:05 +0200
Message-Id: <20230418120313.666089899@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120309.539243408@linuxfoundation.org>
References: <20230418120309.539243408@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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
index cfc170935a58b..ce8569e16f0c4 100644
--- a/arch/powerpc/mm/numa.c
+++ b/arch/powerpc/mm/numa.c
@@ -372,6 +372,7 @@ void update_numa_distance(struct device_node *node)
 	WARN(numa_distance_table[nid][nid] == -1,
 	     "NUMA distance details for node %d not provided\n", nid);
 }
+EXPORT_SYMBOL_GPL(update_numa_distance);
 
 /*
  * ibm,numa-lookup-index-table= {N, domainid1, domainid2, ..... domainidN}
diff --git a/arch/powerpc/platforms/pseries/papr_scm.c b/arch/powerpc/platforms/pseries/papr_scm.c
index 057acbb9116dd..e3b7698b4762c 100644
--- a/arch/powerpc/platforms/pseries/papr_scm.c
+++ b/arch/powerpc/platforms/pseries/papr_scm.c
@@ -1079,6 +1079,13 @@ static int papr_scm_probe(struct platform_device *pdev)
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



