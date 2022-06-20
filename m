Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B14A7551B81
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:47:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243485AbiFTNVQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:21:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345221AbiFTNTp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:19:45 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49E3F20BF3;
        Mon, 20 Jun 2022 06:08:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 51956CE138F;
        Mon, 20 Jun 2022 13:05:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1278DC341CA;
        Mon, 20 Jun 2022 13:05:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655730357;
        bh=z17Ga3WJ++lHqaiRT4zQgkK6L8bZErLb/32G5B5+XmY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IrEUybslz+t9paP26lOeTrIaRbbxJEmExFHfoxAQXzl46LiY1qxxErGKMKMbCw92e
         1pTlcUozaOh/bCGPXCEIcb1v/x6LFA4eyiB6HIYfbphckgs8XhaFnFGvilRVE1ON3o
         1c4WipGarFkp2eGfV857Xc+oAyaaduGLgqvhwoiQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Helge Deller <deller@gmx.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 027/106] scsi: mpt3sas: Fix out-of-bounds compiler warning
Date:   Mon, 20 Jun 2022 14:50:46 +0200
Message-Id: <20220620124725.189125923@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124724.380838401@linuxfoundation.org>
References: <20220620124724.380838401@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Helge Deller <deller@gmx.de>

[ Upstream commit 120f1d95efb1cdb6fe023c84e38ba06d8f78cd03 ]

I'm facing this warning when building for the parisc64 architecture:

drivers/scsi/mpt3sas/mpt3sas_base.c: In function ‘_base_make_ioc_operational’:
drivers/scsi/mpt3sas/mpt3sas_base.c:5396:40: warning: array subscript ‘Mpi2SasIOUnitPage1_t {aka struct _MPI2_CONFIG_PAGE_SASIOUNIT_1}[0]’ is partly outside array bounds of ‘unsigned char[20]’ [-Warray-bounds]
 5396 |             (le16_to_cpu(sas_iounit_pg1->SASWideMaxQueueDepth)) ?
drivers/scsi/mpt3sas/mpt3sas_base.c:5382:26: note: referencing an object of size 20 allocated by ‘kzalloc’
 5382 |         sas_iounit_pg1 = kzalloc(sz, GFP_KERNEL);
      |                          ^~~~~~~~~~~~~~~~~~~~~~~

The problem is, that only 20 bytes are allocated with kmalloc(), which is
sufficient to hold the bytes which are needed.  Nevertheless, gcc complains
because the whole Mpi2SasIOUnitPage1_t struct is 32 bytes in size and thus
doesn't fit into those 20 bytes.

This patch simply allocates all 32 bytes (instead of 20) and thus avoids
the warning. There is no functional change introduced by this patch.

While touching the code I cleaned up to calculation of max_wideport_qd,
max_narrowport_qd and max_sata_qd to make it easier readable.

Test successfully tested on a HP C8000 PA-RISC workstation with 64-bit
kernel.

Link: https://lore.kernel.org/r/YpZ197iZdDZSCzrT@p100
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index c38e68943205..fafa9fbf3b10 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -5381,6 +5381,7 @@ static int _base_assign_fw_reported_qd(struct MPT3SAS_ADAPTER *ioc)
 	Mpi2ConfigReply_t mpi_reply;
 	Mpi2SasIOUnitPage1_t *sas_iounit_pg1 = NULL;
 	Mpi26PCIeIOUnitPage1_t pcie_iounit_pg1;
+	u16 depth;
 	int sz;
 	int rc = 0;
 
@@ -5392,7 +5393,7 @@ static int _base_assign_fw_reported_qd(struct MPT3SAS_ADAPTER *ioc)
 		goto out;
 	/* sas iounit page 1 */
 	sz = offsetof(Mpi2SasIOUnitPage1_t, PhyData);
-	sas_iounit_pg1 = kzalloc(sz, GFP_KERNEL);
+	sas_iounit_pg1 = kzalloc(sizeof(Mpi2SasIOUnitPage1_t), GFP_KERNEL);
 	if (!sas_iounit_pg1) {
 		pr_err("%s: failure at %s:%d/%s()!\n",
 		    ioc->name, __FILE__, __LINE__, __func__);
@@ -5405,16 +5406,16 @@ static int _base_assign_fw_reported_qd(struct MPT3SAS_ADAPTER *ioc)
 		    ioc->name, __FILE__, __LINE__, __func__);
 		goto out;
 	}
-	ioc->max_wideport_qd =
-	    (le16_to_cpu(sas_iounit_pg1->SASWideMaxQueueDepth)) ?
-	    le16_to_cpu(sas_iounit_pg1->SASWideMaxQueueDepth) :
-	    MPT3SAS_SAS_QUEUE_DEPTH;
-	ioc->max_narrowport_qd =
-	    (le16_to_cpu(sas_iounit_pg1->SASNarrowMaxQueueDepth)) ?
-	    le16_to_cpu(sas_iounit_pg1->SASNarrowMaxQueueDepth) :
-	    MPT3SAS_SAS_QUEUE_DEPTH;
-	ioc->max_sata_qd = (sas_iounit_pg1->SATAMaxQDepth) ?
-	    sas_iounit_pg1->SATAMaxQDepth : MPT3SAS_SATA_QUEUE_DEPTH;
+
+	depth = le16_to_cpu(sas_iounit_pg1->SASWideMaxQueueDepth);
+	ioc->max_wideport_qd = (depth ? depth : MPT3SAS_SAS_QUEUE_DEPTH);
+
+	depth = le16_to_cpu(sas_iounit_pg1->SASNarrowMaxQueueDepth);
+	ioc->max_narrowport_qd = (depth ? depth : MPT3SAS_SAS_QUEUE_DEPTH);
+
+	depth = sas_iounit_pg1->SATAMaxQDepth;
+	ioc->max_sata_qd = (depth ? depth : MPT3SAS_SATA_QUEUE_DEPTH);
+
 	/* pcie iounit page 1 */
 	rc = mpt3sas_config_get_pcie_iounit_pg1(ioc, &mpi_reply,
 	    &pcie_iounit_pg1, sizeof(Mpi26PCIeIOUnitPage1_t));
-- 
2.35.1



