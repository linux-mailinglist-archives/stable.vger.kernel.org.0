Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CB4A4EF4E5
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 17:41:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348745AbiDAOwV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 10:52:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349296AbiDAOpp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 10:45:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41EBF29A574;
        Fri,  1 Apr 2022 07:35:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6DAEDB824D5;
        Fri,  1 Apr 2022 14:35:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0962AC34115;
        Fri,  1 Apr 2022 14:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648823708;
        bh=6mM1adCGrD3rDYo/3TLkfQu8rH9G9TR8/XIofQoLSUI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rYNYdCqh6VkYk7U59oFph3eDLWgarDkRg2t7m0vKPQc6jgqhkAnqAFGRes5oPQwDQ
         RPSMwAy5rQ/wPAOFvzYJqsD3onCw6814vPHe3Eir6xMMP/tEpVR0+DgWzVOYE/XJIF
         2aDOqG6rtjziZdQD4+qxdIRtWDcAgnZBq1w2b6LYaJ7EPDhObpmzxlGrsfTx6mPpFb
         3P68kJ309EaQoM78I+PXajmICWeeXu9wIAnFv+8/1K2ycC2+CD3i8jJTsNrit9yFeO
         /tKc8Hykq8EfCtqB7WpnqJFuP5ePJ0czA+5umxxOg1K90BpKEXc3mnpFBI5J+xOJO3
         CaQ8pZsNuRC/g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, sathya.prakash@broadcom.com,
        kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        jejb@linux.ibm.com, mpi3mr-linuxdrv.pdl@broadcom.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 047/109] scsi: mpi3mr: Fix memory leaks
Date:   Fri,  1 Apr 2022 10:31:54 -0400
Message-Id: <20220401143256.1950537-47-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401143256.1950537-1-sashal@kernel.org>
References: <20220401143256.1950537-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sreekanth Reddy <sreekanth.reddy@broadcom.com>

[ Upstream commit d44b5fefb22e139408ae12b864da1ecb9ad9d1d2 ]

Fix memory leaks related to operational reply queue's memory segments which
are not getting freed while unloading the driver.

Link: https://lore.kernel.org/r/20220210095817.22828-9-sreekanth.reddy@broadcom.com
Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 2daf633ea295..9bb64a7b2af7 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -1275,7 +1275,7 @@ static void mpi3mr_free_op_req_q_segments(struct mpi3mr_ioc *mrioc, u16 q_idx)
 			    MPI3MR_MAX_SEG_LIST_SIZE,
 			    mrioc->req_qinfo[q_idx].q_segment_list,
 			    mrioc->req_qinfo[q_idx].q_segment_list_dma);
-			mrioc->op_reply_qinfo[q_idx].q_segment_list = NULL;
+			mrioc->req_qinfo[q_idx].q_segment_list = NULL;
 		}
 	} else
 		size = mrioc->req_qinfo[q_idx].segment_qd *
-- 
2.34.1

