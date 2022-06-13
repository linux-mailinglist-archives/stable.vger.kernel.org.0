Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 050C85491FC
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:30:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380545AbiFMOAs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 10:00:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240537AbiFMN72 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:59:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D82268CCF5;
        Mon, 13 Jun 2022 04:37:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 27F32B80EA7;
        Mon, 13 Jun 2022 11:37:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 793E7C34114;
        Mon, 13 Jun 2022 11:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655120270;
        bh=ovWdpCpgjdPMTIbsc5BY64f75f6dLt9SBIE24tqDEoA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aLxxLu7qu5fCcQ34UsRyLRQLpMGbuYm/09On9osp+HoBHJNa8g4b/gGIwD0BTUE+m
         5X2edPB66PAYZeSgbVgzKdl6XzofNYel/9SLUEWnJ0LrHqbQNqHSC+nHWuxtuX21VS
         jIxQjMemMiyTao9+3VfAP2aqg9/QmTywUGP7A0MU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Justin Tee <justin.tee@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.18 304/339] scsi: lpfc: Address NULL pointer dereference after starget_to_rport()
Date:   Mon, 13 Jun 2022 12:12:09 +0200
Message-Id: <20220613094935.979173117@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094926.497929857@linuxfoundation.org>
References: <20220613094926.497929857@linuxfoundation.org>
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

From: James Smart <jsmart2021@gmail.com>

commit 6f808bd78e8296b4ded813b7182988d57e1f6176 upstream.

Calls to starget_to_rport() may return NULL.  Add check for NULL rport
before dereference.

Link: https://lore.kernel.org/r/20220603174329.63777-5-jsmart2021@gmail.com
Fixes: bb21fc9911ee ("scsi: lpfc: Use fc_block_rport()")
Cc: <stable@vger.kernel.org> # v5.18
Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/lpfc/lpfc_scsi.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -6316,6 +6316,9 @@ lpfc_device_reset_handler(struct scsi_cm
 	int status;
 	u32 logit = LOG_FCP;
 
+	if (!rport)
+		return FAILED;
+
 	rdata = rport->dd_data;
 	if (!rdata || !rdata->pnode) {
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
@@ -6394,6 +6397,9 @@ lpfc_target_reset_handler(struct scsi_cm
 	unsigned long flags;
 	DECLARE_WAIT_QUEUE_HEAD_ONSTACK(waitq);
 
+	if (!rport)
+		return FAILED;
+
 	rdata = rport->dd_data;
 	if (!rdata || !rdata->pnode) {
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,


