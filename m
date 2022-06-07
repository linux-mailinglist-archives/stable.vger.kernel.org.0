Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7629541C2F
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:57:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379051AbiFGV4q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:56:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384053AbiFGVyE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:54:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF7AC24851F;
        Tue,  7 Jun 2022 12:12:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3A131B82375;
        Tue,  7 Jun 2022 19:12:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D7D2C3411C;
        Tue,  7 Jun 2022 19:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629161;
        bh=idSTYfKqID3ycqU0J+RD3lPvbre/1DQacziwM3YLQwg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Eq9lXSCAsc8ZK1UDNFf9xI/MR8VlhGvdDsCh1lGHHkaDbvURjpb/kgxmgsZqY08VJ
         wfs2dnIOeWvk8LtyFfEmU59FR9yvY7/kHuK62rCPtGjhKv/DblmSD5goMXoUodXWMw
         f4UWindDtRxeAxq1zNcWWU6jeNVleBuv7bA+f8IY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Zach <krzysztof.zach@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Dan Williams <dan.j.williams@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 551/879] cxl/pci: Make cxl_dvsec_ranges() failure not fatal to cxl_pci
Date:   Tue,  7 Jun 2022 19:01:09 +0200
Message-Id: <20220607165018.860048093@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Williams <dan.j.williams@intel.com>

[ Upstream commit 36bfc6ad508af38f212cf5a38147d867fb3f80a8 ]

cxl_dvsec_ranges(), the helper for enumerating the presence of an active
legacy CXL.mem configuration on a CXL 2.0 Memory Expander, is not fatal
for cxl_pci because there is still value to enable mailbox operations
even if CXL.mem operation is disabled. Recall that the reason cxl_pci
does this initialization and not cxl_mem is to preserve the useful
property (for unit testing) that cxl_mem is cxl_memdev + mmio generic,
and does not require access to a 'struct pci_dev' to issue config
cycles.

Update 'struct cxl_endpoint_dvsec_info' to carry either a positive
number of non-zero size legacy CXL DVSEC ranges, or the negative error
code from __cxl_dvsec_ranges() in its @ranges member.

Reported-by: Krzysztof Zach <krzysztof.zach@intel.com>
Fixes: 560f78559006 ("cxl/pci: Retrieve CXL DVSEC memory info")
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
Link: https://lore.kernel.org/r/164730735869.3806189.4032428192652531946.stgit@dwillia2-desk3.amr.corp.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/pci.c | 27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff --git a/drivers/cxl/pci.c b/drivers/cxl/pci.c
index c4941a3ca6a8..bb92853c3b93 100644
--- a/drivers/cxl/pci.c
+++ b/drivers/cxl/pci.c
@@ -462,13 +462,18 @@ static int wait_for_media_ready(struct cxl_dev_state *cxlds)
 	return 0;
 }
 
-static int cxl_dvsec_ranges(struct cxl_dev_state *cxlds)
+/*
+ * Return positive number of non-zero ranges on success and a negative
+ * error code on failure. The cxl_mem driver depends on ranges == 0 to
+ * init HDM operation.
+ */
+static int __cxl_dvsec_ranges(struct cxl_dev_state *cxlds,
+			      struct cxl_endpoint_dvsec_info *info)
 {
-	struct cxl_endpoint_dvsec_info *info = &cxlds->info;
 	struct pci_dev *pdev = to_pci_dev(cxlds->dev);
+	int hdm_count, rc, i, ranges = 0;
 	struct device *dev = &pdev->dev;
 	int d = cxlds->cxl_dvsec;
-	int hdm_count, rc, i;
 	u16 cap, ctrl;
 
 	if (!d) {
@@ -545,10 +550,17 @@ static int cxl_dvsec_ranges(struct cxl_dev_state *cxlds)
 		};
 
 		if (size)
-			info->ranges++;
+			ranges++;
 	}
 
-	return 0;
+	return ranges;
+}
+
+static void cxl_dvsec_ranges(struct cxl_dev_state *cxlds)
+{
+	struct cxl_endpoint_dvsec_info *info = &cxlds->info;
+
+	info->ranges = __cxl_dvsec_ranges(cxlds, info);
 }
 
 static int cxl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
@@ -617,10 +629,7 @@ static int cxl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (rc)
 		return rc;
 
-	rc = cxl_dvsec_ranges(cxlds);
-	if (rc)
-		dev_warn(&pdev->dev,
-			 "Failed to get DVSEC range information (%d)\n", rc);
+	cxl_dvsec_ranges(cxlds);
 
 	cxlmd = devm_cxl_add_memdev(cxlds);
 	if (IS_ERR(cxlmd))
-- 
2.35.1



