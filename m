Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8565A5176F0
	for <lists+stable@lfdr.de>; Mon,  2 May 2022 20:54:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230265AbiEBS5f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 May 2022 14:57:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230422AbiEBS5f (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 May 2022 14:57:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49068BE05
        for <stable@vger.kernel.org>; Mon,  2 May 2022 11:54:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D24D56149C
        for <stable@vger.kernel.org>; Mon,  2 May 2022 18:54:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26CB8C385A4;
        Mon,  2 May 2022 18:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651517644;
        bh=++g/O+FnOQ3OlzIS/GBrcUp9VZwq/lFAo++OdoAFc7k=;
        h=Subject:To:Cc:From:Date:From;
        b=fPnAHpRfV2AUkRo8G6HSISH5c5TUVXCJSuVJXpFS4NHSPFbHiB/476Ib9NrA+MZ2O
         I4rFqLU9wbgqHBcLTtrpn9EdFtsrslnpQ2b2B6/tGSBtzDQlTnQh0x3qUCUSRjPwof
         pj3BAWNMnYnEC91WqiWYzxteMaV3kYXClQGwrIwA=
Subject: FAILED: patch "[PATCH] scsi: target: pscsi: Set SCF_TREAT_READ_AS_NORMAL flag only" failed to apply to 5.10-stable tree
To:     djeffery@redhat.com, loberman@redhat.com,
        martin.petersen@oracle.com, scott.hamilton@atos.net
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 02 May 2022 20:54:02 +0200
Message-ID: <165151764223199@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 8be70a842f70c0fe8e00fd488b1966344fa10ff4 Mon Sep 17 00:00:00 2001
From: David Jeffery <djeffery@redhat.com>
Date: Wed, 27 Apr 2022 14:32:50 -0400
Subject: [PATCH] scsi: target: pscsi: Set SCF_TREAT_READ_AS_NORMAL flag only
 if there is valid data

With tape devices, the SCF_TREAT_READ_AS_NORMAL flag is used by the target
subsystem to mark commands which have both data to return as well as sense
data. But with pscsi, SCF_TREAT_READ_AS_NORMAL can be set even if there is
no data to return. The SCF_TREAT_READ_AS_NORMAL flag causes the target core
to call iscsit data-in callbacks even if there is no data, which iscsit
does not support. This results in iscsit going into an error state
requiring recovery and being unable to complete the command to the
initiator.

This issue can be resolved by fixing pscsi to only set
SCF_TREAT_READ_AS_NORMAL if there is valid data to return alongside the
sense data.

Link: https://lore.kernel.org/r/20220427183250.291881-1-djeffery@redhat.com
Fixes: bd81372065fa ("scsi: target: transport should handle st FM/EOM/ILI reads")
Reported-by: Scott Hamilton <scott.hamilton@atos.net>
Tested-by: Laurence Oberman <loberman@redhat.com>
Reviewed-by: Laurence Oberman <loberman@redhat.com>
Signed-off-by: David Jeffery <djeffery@redhat.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index ff292b75e23f..60dafe4c581b 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -588,7 +588,7 @@ static void pscsi_destroy_device(struct se_device *dev)
 }
 
 static void pscsi_complete_cmd(struct se_cmd *cmd, u8 scsi_status,
-			       unsigned char *req_sense)
+			       unsigned char *req_sense, int valid_data)
 {
 	struct pscsi_dev_virt *pdv = PSCSI_DEV(cmd->se_dev);
 	struct scsi_device *sd = pdv->pdv_sd;
@@ -681,7 +681,7 @@ static void pscsi_complete_cmd(struct se_cmd *cmd, u8 scsi_status,
 		 * back despite framework assumption that a
 		 * check condition means there is no data
 		 */
-		if (sd->type == TYPE_TAPE &&
+		if (sd->type == TYPE_TAPE && valid_data &&
 		    cmd->data_direction == DMA_FROM_DEVICE) {
 			/*
 			 * is sense data valid, fixed format,
@@ -1032,6 +1032,7 @@ static void pscsi_req_done(struct request *req, blk_status_t status)
 	struct se_cmd *cmd = req->end_io_data;
 	struct scsi_cmnd *scmd = blk_mq_rq_to_pdu(req);
 	enum sam_status scsi_status = scmd->result & 0xff;
+	int valid_data = cmd->data_length - scmd->resid_len;
 	u8 *cdb = cmd->priv;
 
 	if (scsi_status != SAM_STAT_GOOD) {
@@ -1039,12 +1040,11 @@ static void pscsi_req_done(struct request *req, blk_status_t status)
 			" 0x%02x Result: 0x%08x\n", cmd, cdb[0], scmd->result);
 	}
 
-	pscsi_complete_cmd(cmd, scsi_status, scmd->sense_buffer);
+	pscsi_complete_cmd(cmd, scsi_status, scmd->sense_buffer, valid_data);
 
 	switch (host_byte(scmd->result)) {
 	case DID_OK:
-		target_complete_cmd_with_length(cmd, scsi_status,
-			cmd->data_length - scmd->resid_len);
+		target_complete_cmd_with_length(cmd, scsi_status, valid_data);
 		break;
 	default:
 		pr_debug("PSCSI Host Byte exception at cmd: %p CDB:"

