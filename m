Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C87CE50F6E1
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 10:59:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245232AbiDZJBs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 05:01:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345833AbiDZI5p (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 04:57:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B55010FD9;
        Tue, 26 Apr 2022 01:42:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E44C060EC3;
        Tue, 26 Apr 2022 08:42:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E739EC385AC;
        Tue, 26 Apr 2022 08:42:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650962570;
        bh=ncQvWw7JzRWQcjtbP3A6tVL7qGQSof+qBgIvMduGnZU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2LmuQBBGL4cTIHHQ8OFpXEhdjQDu4rkM5/7/TH+qHUEHD9ZRgH4bo1RrvPla8d1KA
         L0gftQPFFHNqfJgpiX8/cUn7wP+La4pjQkXYfrh89QAGI8tGGb/UTctWUs8FqNX9ty
         /WiLV9BvVseteFlqTvZtbgygm5WMbo2NRu/4moF8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Peter Wang <peter.wang@mediatek.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.17 006/146] scsi: ufs: core: scsi_get_lba() error fix
Date:   Tue, 26 Apr 2022 10:20:01 +0200
Message-Id: <20220426081750.240666760@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081750.051179617@linuxfoundation.org>
References: <20220426081750.051179617@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Wang <peter.wang@mediatek.com>

commit 2bd3b6b75946db2ace06e145d53988e10ed7e99a upstream.

When ufs initializes without scmd->device->sector_size set, scsi_get_lba()
will get a wrong shift number and trigger an ubsan error.  The shift
exponent 4294967286 is too large for the 64-bit type 'sector_t' (aka
'unsigned long long').

Call scsi_get_lba() only when opcode is READ_10/WRITE_10/UNMAP.

Link: https://lore.kernel.org/r/20220307111752.10465-1-peter.wang@mediatek.com
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Peter Wang <peter.wang@mediatek.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/ufs/ufshcd.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -367,7 +367,7 @@ static void ufshcd_add_uic_command_trace
 static void ufshcd_add_command_trace(struct ufs_hba *hba, unsigned int tag,
 				     enum ufs_trace_str_t str_t)
 {
-	u64 lba;
+	u64 lba = 0;
 	u8 opcode = 0, group_id = 0;
 	u32 intr, doorbell;
 	struct ufshcd_lrb *lrbp = &hba->lrb[tag];
@@ -384,7 +384,6 @@ static void ufshcd_add_command_trace(str
 		return;
 
 	opcode = cmd->cmnd[0];
-	lba = scsi_get_lba(cmd);
 
 	if (opcode == READ_10 || opcode == WRITE_10) {
 		/*
@@ -392,6 +391,7 @@ static void ufshcd_add_command_trace(str
 		 */
 		transfer_len =
 		       be32_to_cpu(lrbp->ucd_req_ptr->sc.exp_data_transfer_len);
+		lba = scsi_get_lba(cmd);
 		if (opcode == WRITE_10)
 			group_id = lrbp->cmd->cmnd[6];
 	} else if (opcode == UNMAP) {
@@ -399,6 +399,7 @@ static void ufshcd_add_command_trace(str
 		 * The number of Bytes to be unmapped beginning with the lba.
 		 */
 		transfer_len = blk_rq_bytes(rq);
+		lba = scsi_get_lba(cmd);
 	}
 
 	intr = ufshcd_readl(hba, REG_INTERRUPT_STATUS);


