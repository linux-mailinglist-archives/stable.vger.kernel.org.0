Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFAF14F03F2
	for <lists+stable@lfdr.de>; Sat,  2 Apr 2022 16:30:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356480AbiDBOcm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 Apr 2022 10:32:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352793AbiDBOcm (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 2 Apr 2022 10:32:42 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6E4B4BFC8
        for <stable@vger.kernel.org>; Sat,  2 Apr 2022 07:30:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 103CFCE08C1
        for <stable@vger.kernel.org>; Sat,  2 Apr 2022 14:30:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B299C340EC;
        Sat,  2 Apr 2022 14:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648909847;
        bh=3vYgG3iBPAO70socQRR0BV9KXiKFube0w6EV3N/2GBo=;
        h=Subject:To:Cc:From:Date:From;
        b=0Uz1tQ+eEEZs5flUMXUYNhnO5UMWVnKS09S3JRLfRTDcAJDN2kWsIAFBpsoaI9yC9
         K9ZbKNoRKzGn7Cwd0laFI6LoUBSXbfaSk+qIbE5fyrFtypLyJ59yLn/Xc+2nfoOCHI
         X92FN7p0j/ONKrfnimwstf/wrqW+Gmy0zxcFQ4lQ=
Subject: FAILED: patch "[PATCH] scsi: qla2xxx: Fix incorrect reporting of task management" failed to apply to 4.14-stable tree
To:     qutran@marvell.com, himanshu.madhani@oracle.com,
        martin.petersen@oracle.com, njavali@marvell.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 02 Apr 2022 16:29:22 +0200
Message-ID: <164890976257183@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 58ca5999e0367d131de82a75257fbfd5aed0195d Mon Sep 17 00:00:00 2001
From: Quinn Tran <qutran@marvell.com>
Date: Thu, 10 Mar 2022 01:25:52 -0800
Subject: [PATCH] scsi: qla2xxx: Fix incorrect reporting of task management
 failure

User experienced no task management error while target device is responding
with error. The RSP_CODE field in the status IOCB is in little endian.
Driver assumes it's big endian and it picked up erroneous data.

Convert the data back to big endian as is on the wire.

Link: https://lore.kernel.org/r/20220310092604.22950-2-njavali@marvell.com
Fixes: faef62d13463 ("[SCSI] qla2xxx: Fix Task Management command asynchronous handling")
Cc: stable@vger.kernel.org
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 092e4b5da65a..21b31d6359c8 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -2498,6 +2498,7 @@ qla24xx_tm_iocb_entry(scsi_qla_host_t *vha, struct req_que *req, void *tsk)
 		iocb->u.tmf.data = QLA_FUNCTION_FAILED;
 	} else if ((le16_to_cpu(sts->scsi_status) &
 	    SS_RESPONSE_INFO_LEN_VALID)) {
+		host_to_fcp_swap(sts->data, sizeof(sts->data));
 		if (le32_to_cpu(sts->rsp_data_len) < 4) {
 			ql_log(ql_log_warn, fcport->vha, 0x503b,
 			    "Async-%s error - hdl=%x not enough response(%d).\n",

