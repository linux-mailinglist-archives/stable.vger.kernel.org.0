Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B46D24EF0FA
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 16:39:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348058AbiDAOhI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 10:37:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347432AbiDAOcd (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 10:32:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D13BD1EE8DA;
        Fri,  1 Apr 2022 07:29:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6018EB824AF;
        Fri,  1 Apr 2022 14:29:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECA8DC36AE3;
        Fri,  1 Apr 2022 14:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648823348;
        bh=+w8+UgCH8qd5pzoPVExzhGnO6RgpcA8h/HJRk5r70bg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ep/CeFQBkfA9aE6E6CQVMZpCVF8yUa3wfhf86ykHGqH7o+3qY9xUtEivPBGjXw84+
         a35hoMlCBniKPJ7xGqfDOyw2CZ3MwUL9L/YEp9FHGr2vvnJtq99MhC72Yoo4e4jGnF
         T+78wsQxpQCdqWOraDy4nCeV/6iSkX1eYrvpQ2F1LT4JrOAfyqroBN9G8tEV1IIzwn
         nIIigbG/KTQEXa1I3Qs/e7yUFsxg9KcgtqukGUPPAPZM27yLR2rF69BkSRPyP1aGmj
         0Pyi2XcU7e+2aSciOeuz0lUCLvWj4d8MgoVuDlZGz+KYXaCMch8gtfHM7cZv1kr2ij
         y7EHMPmP/2Low==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, sathya.prakash@broadcom.com,
        kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        jejb@linux.ibm.com, mpi3mr-linuxdrv.pdl@broadcom.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 067/149] scsi: mpi3mr: Fix reporting of actual data transfer size
Date:   Fri,  1 Apr 2022 10:24:14 -0400
Message-Id: <20220401142536.1948161-67-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401142536.1948161-1-sashal@kernel.org>
References: <20220401142536.1948161-1-sashal@kernel.org>
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

[ Upstream commit 9992246127246a27cc7184f05cce6f62ac48f84e ]

The driver is missing to set the residual size while completing an
I/O. Ensure proper data transfer size is reported to the kernel on I/O
completion based on the transfer length reported by the firmware.

Link: https://lore.kernel.org/r/20220210095817.22828-7-sreekanth.reddy@broadcom.com
Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr_os.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index d205354be63a..f7893de35b26 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -2617,6 +2617,8 @@ void mpi3mr_process_op_reply_desc(struct mpi3mr_ioc *mrioc,
 		scmd->result = DID_OK << 16;
 		goto out_success;
 	}
+
+	scsi_set_resid(scmd, scsi_bufflen(scmd) - xfer_count);
 	if (ioc_status == MPI3_IOCSTATUS_SCSI_DATA_UNDERRUN &&
 	    xfer_count == 0 && (scsi_status == MPI3_SCSI_STATUS_BUSY ||
 	    scsi_status == MPI3_SCSI_STATUS_RESERVATION_CONFLICT ||
-- 
2.34.1

