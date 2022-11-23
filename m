Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7115B635DAB
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 13:47:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236429AbiKWMpd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 07:45:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237708AbiKWMoe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 07:44:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAFAF1003;
        Wed, 23 Nov 2022 04:42:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 93700B81F5D;
        Wed, 23 Nov 2022 12:42:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12C26C433D6;
        Wed, 23 Nov 2022 12:42:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669207346;
        bh=bRLZHKh2zNHAUYhN/K+kEkdojDudkiQXqx8uEY36ZG4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mttLbjjshYwxMTanFR/jTqFlbrb1wxANkTomtln/Z2qDhxv++J8rTqgBIneHFJQW8
         Jo6STng8OvCAr5f1rmFptcRziGV+hc+mowOs21C69ziFj4sK1AqoEdaraKPSOOu1VE
         0QSmjql+YkqoRDzHNqVrFuA83qLT18UbT8VEfZ+Rhb8gWUvm/cJo2dp3G59RL0xGfW
         tFm68zlYs220puH02BSVv4NjpljS8+W1TjYerBVzclejPV4l6xGWZQ+rXfB2Pd2Q2+
         CwLOiHcZtLNCqCoZiG2KhOkRc1gFuwvm3wijD270ppxmW9HQM5GSFqxduRcU3Xt0FY
         5XnQqJCAP6QGw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, sathya.prakash@broadcom.com,
        kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        sreekanth.reddy@broadcom.com, jejb@linux.ibm.com,
        mpi3mr-linuxdrv.pdl@broadcom.com, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 40/44] scsi: mpi3mr: Suppress command reply debug prints
Date:   Wed, 23 Nov 2022 07:40:49 -0500
Message-Id: <20221123124057.264822-40-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221123124057.264822-1-sashal@kernel.org>
References: <20221123124057.264822-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

[ Upstream commit 7d21fcfb409500dc9b114567f0ef8d30b3190dee ]

After it receives command reply, mpi3mr driver checks command result. If
the result is not zero, it prints out command information. This debug
information is confusing since they are printed even when the non-zero
result is expected. "Power-on or device reset occurred" is printed for Test
Unit Ready command at drive detection. Inquiry failure for unsupported VPD
page header is also printed. They are harmless but look like failures.

To avoid the confusion, print the command reply debug information only when
the module parameter logging_level has value MPI3_DEBUG_SCSI_ERROR= 64, in
same manner as mpt3sas driver.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Link: https://lore.kernel.org/r/20221111014449.1649968-1-shinichiro.kawasaki@wdc.com
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr_os.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index bfa1165e23b6..1b4d1e562de8 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -2930,7 +2930,8 @@ void mpi3mr_process_op_reply_desc(struct mpi3mr_ioc *mrioc,
 	}
 
 	if (scmd->result != (DID_OK << 16) && (scmd->cmnd[0] != ATA_12) &&
-	    (scmd->cmnd[0] != ATA_16)) {
+	    (scmd->cmnd[0] != ATA_16) &&
+	    mrioc->logging_level & MPI3_DEBUG_SCSI_ERROR) {
 		ioc_info(mrioc, "%s :scmd->result 0x%x\n", __func__,
 		    scmd->result);
 		scsi_print_command(scmd);
-- 
2.35.1

