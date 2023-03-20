Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0E116C0844
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 02:08:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231559AbjCTBIU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Mar 2023 21:08:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231536AbjCTBH4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Mar 2023 21:07:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F9B11F4A0;
        Sun, 19 Mar 2023 18:00:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4E947B80D43;
        Mon, 20 Mar 2023 00:53:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4631C433D2;
        Mon, 20 Mar 2023 00:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679273626;
        bh=5VMwDl1Jsw26GjyXU8bTq4Dwad0lh0CCc32p19PzZOs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L9pJ0cn0FWdQRwcIIrRN9y9pYZsl60CLi8SCUNILSwNoyz3loxHJ0qPKbKqknfntQ
         Zq6xzs+wt6dOuLVs2YobH3on4bP/hFu+l1OYDIssxCzise6LVWmXMDGDK2HUj3JlNX
         BTaRFWpW5IaBCTVsZfzzZKkL6UBgKZZKzqiLrWjYwlIEVlL0FjAHCPM95CVkEA2uw/
         JQtRyyLSj9maY4JZBmdP9r3MryCvXbQ5rCL3ZCELDOxJrg1pivtwztwN2svPNVa4RH
         NIyDBHm+2NzkGdmtBehHBmxapaxm+mMkRzCP9llBaGJIdNDWTCcoaIFCX9lGsrdyYP
         N91WfyXuaziHQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ranjan Kumar <ranjan.kumar@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, sathya.prakash@broadcom.com,
        kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        jejb@linux.ibm.com, mpi3mr-linuxdrv.pdl@broadcom.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.2 20/30] scsi: mpi3mr: NVMe command size greater than 8K fails
Date:   Sun, 19 Mar 2023 20:52:45 -0400
Message-Id: <20230320005258.1428043-20-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230320005258.1428043-1-sashal@kernel.org>
References: <20230320005258.1428043-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ranjan Kumar <ranjan.kumar@broadcom.com>

[ Upstream commit 4f297e856a7b5da2f2c66a12e739666e23943560 ]

A wrong variable is checked while populating PRP entries in the PRP page
and this results in failure. No PRP entries in the PRP page were
successfully created and any NVMe Encapsulated commands with PRP of size
greater than 8K failed.

Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Link: https://lore.kernel.org/r/20230228140835.4075-6-ranjan.kumar@broadcom.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr_app.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index bff6377023979..d10c6afb7f9cd 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -886,7 +886,7 @@ static int mpi3mr_build_nvme_prp(struct mpi3mr_ioc *mrioc,
 			 * each time through the loop.
 			 */
 			*prp_entry = cpu_to_le64(dma_addr);
-			if (*prp1_entry & sgemod_mask) {
+			if (*prp_entry & sgemod_mask) {
 				dprint_bsg_err(mrioc,
 				    "%s: PRP address collides with SGE modifier\n",
 				    __func__);
@@ -895,7 +895,7 @@ static int mpi3mr_build_nvme_prp(struct mpi3mr_ioc *mrioc,
 			*prp_entry &= ~sgemod_mask;
 			*prp_entry |= sgemod_val;
 			prp_entry++;
-			prp_entry_dma++;
+			prp_entry_dma += prp_size;
 		}
 
 		/*
-- 
2.39.2

