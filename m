Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 357EA541BF1
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:56:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381993AbiFGVze (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:55:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384223AbiFGVyV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:54:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D7D837BD3;
        Tue,  7 Jun 2022 12:13:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CD2E0617D0;
        Tue,  7 Jun 2022 19:12:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAAA0C385A2;
        Tue,  7 Jun 2022 19:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629158;
        bh=B/QuFEpq78xkrF1rplhhWqWNV0Fu2qI+glk260VWyvc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z6bzvGyP0Zwy/Qa6IAci3NZ6Zz+bBiygf675ZyvdaWwU8VSF9ndiq7tWs+9wzHW7N
         GdZQoQt2/97LKjZNmUJXs+kz7zu6spWt5BUGHwzQGaR8t7e3Wq8NDX26YMp1cFvm5E
         x6efrM2Kg7+21h5hdLdPXJLnvEri4dPExrsbwp60=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Ben Widawsky <ben.widawsky@intel.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Dan Williams <dan.j.williams@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 550/879] cxl/pci: Add debug for DVSEC range init failures
Date:   Tue,  7 Jun 2022 19:01:08 +0200
Message-Id: <20220607165018.830980067@linuxfoundation.org>
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

[ Upstream commit e39f9be08d9dfe685c8a325ac1755c04f383effc ]

In preparation for not treating DVSEC range initialization failures as
fatal to cxl_pci_probe() add individual dev_dbg() statements for each of
the major failure reasons in cxl_dvsec_ranges().

The rationale for cxl_dvsec_ranges() failure not being fatal is that
there is still value for cxl_pci to enable mailbox operations even if
CXL.mem operation is disabled.

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Ben Widawsky <ben.widawsky@intel.com>
Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
Link: https://lore.kernel.org/r/164730734812.3806189.2726330688692684104.stgit@dwillia2-desk3.amr.corp.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/pci.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/cxl/pci.c b/drivers/cxl/pci.c
index 3f2182d66829..c4941a3ca6a8 100644
--- a/drivers/cxl/pci.c
+++ b/drivers/cxl/pci.c
@@ -466,12 +466,15 @@ static int cxl_dvsec_ranges(struct cxl_dev_state *cxlds)
 {
 	struct cxl_endpoint_dvsec_info *info = &cxlds->info;
 	struct pci_dev *pdev = to_pci_dev(cxlds->dev);
+	struct device *dev = &pdev->dev;
 	int d = cxlds->cxl_dvsec;
 	int hdm_count, rc, i;
 	u16 cap, ctrl;
 
-	if (!d)
+	if (!d) {
+		dev_dbg(dev, "No DVSEC Capability\n");
 		return -ENXIO;
+	}
 
 	rc = pci_read_config_word(pdev, d + CXL_DVSEC_CAP_OFFSET, &cap);
 	if (rc)
@@ -481,8 +484,10 @@ static int cxl_dvsec_ranges(struct cxl_dev_state *cxlds)
 	if (rc)
 		return rc;
 
-	if (!(cap & CXL_DVSEC_MEM_CAPABLE))
+	if (!(cap & CXL_DVSEC_MEM_CAPABLE)) {
+		dev_dbg(dev, "Not MEM Capable\n");
 		return -ENXIO;
+	}
 
 	/*
 	 * It is not allowed by spec for MEM.capable to be set and have 0 legacy
@@ -495,8 +500,10 @@ static int cxl_dvsec_ranges(struct cxl_dev_state *cxlds)
 		return -EINVAL;
 
 	rc = wait_for_valid(cxlds);
-	if (rc)
+	if (rc) {
+		dev_dbg(dev, "Failure awaiting MEM_INFO_VALID (%d)\n", rc);
 		return rc;
+	}
 
 	info->mem_enabled = FIELD_GET(CXL_DVSEC_MEM_ENABLE, ctrl);
 
-- 
2.35.1



