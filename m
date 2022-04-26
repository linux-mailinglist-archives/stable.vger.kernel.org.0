Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41F4550F56B
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 10:53:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238740AbiDZIri (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 04:47:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346897AbiDZIp3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 04:45:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36FAEB1E6;
        Tue, 26 Apr 2022 01:36:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EA9C8B81CFE;
        Tue, 26 Apr 2022 08:36:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 470AFC385AC;
        Tue, 26 Apr 2022 08:36:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650962180;
        bh=Kb0biBkFZABp5DjxR6pFH9eVYKEyISk7HCQ3zv4bjvw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BhNjI/xbF8vRomstX0HlAs8L2BHtp4bgC/JE7+O79SFzIqRLnKWtLuY1j7418UUOs
         0gYgK41Z+CgLSoqG0EQuolY9cog1GucOcPvQ1WRPC/NZcZ0vDempR7Jpm/HymPXAC8
         oOdvhOfD/BhBRblnkSHbS4erCL7GHEzcR92wSaWg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Peter Wang <peter.wang@mediatek.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.15 013/124] scsi: ufs: core: scsi_get_lba() error fix
Date:   Tue, 26 Apr 2022 10:20:14 +0200
Message-Id: <20220426081747.676581071@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081747.286685339@linuxfoundation.org>
References: <20220426081747.286685339@linuxfoundation.org>
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
@@ -358,7 +358,7 @@ static void ufshcd_add_uic_command_trace
 static void ufshcd_add_command_trace(struct ufs_hba *hba, unsigned int tag,
 				     enum ufs_trace_str_t str_t)
 {
-	u64 lba;
+	u64 lba = 0;
 	u8 opcode = 0, group_id = 0;
 	u32 intr, doorbell;
 	struct ufshcd_lrb *lrbp = &hba->lrb[tag];
@@ -375,7 +375,6 @@ static void ufshcd_add_command_trace(str
 		return;
 
 	opcode = cmd->cmnd[0];
-	lba = scsi_get_lba(cmd);
 
 	if (opcode == READ_10 || opcode == WRITE_10) {
 		/*
@@ -383,6 +382,7 @@ static void ufshcd_add_command_trace(str
 		 */
 		transfer_len =
 		       be32_to_cpu(lrbp->ucd_req_ptr->sc.exp_data_transfer_len);
+		lba = scsi_get_lba(cmd);
 		if (opcode == WRITE_10)
 			group_id = lrbp->cmd->cmnd[6];
 	} else if (opcode == UNMAP) {
@@ -390,6 +390,7 @@ static void ufshcd_add_command_trace(str
 		 * The number of Bytes to be unmapped beginning with the lba.
 		 */
 		transfer_len = blk_rq_bytes(rq);
+		lba = scsi_get_lba(cmd);
 	}
 
 	intr = ufshcd_readl(hba, REG_INTERRUPT_STATUS);


