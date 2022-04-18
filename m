Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F26BF5058C4
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 16:09:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240976AbiDROK5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 10:10:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343846AbiDROIa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 10:08:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7A5E36685;
        Mon, 18 Apr 2022 06:10:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E7C44B80D9C;
        Mon, 18 Apr 2022 13:09:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F5A6C385A1;
        Mon, 18 Apr 2022 13:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650287395;
        bh=CPbEzVn9PNmRYzSrIGO54wh9zgMQsjLRi1foeIemc7s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iC169d7WZQDZUJUih+Hti37XAr7Yvxs6BijAANnro0fxHyazcgfAAWAeD4NElsS1F
         RG/MSA4rNRg+Cg2P2TaTSVR8Ag19UhRb223nW0bA0SLGyfVBrK2hKsvmKwo3SYTh2G
         z08o9ZRKoE1//eTxDeulXQ3hYybOt4nxpxn8b8sA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Quinn Tran <qutran@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 4.9 148/218] scsi: qla2xxx: Fix incorrect reporting of task management failure
Date:   Mon, 18 Apr 2022 14:13:34 +0200
Message-Id: <20220418121203.824023307@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121158.636999985@linuxfoundation.org>
References: <20220418121158.636999985@linuxfoundation.org>
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

From: Quinn Tran <qutran@marvell.com>

commit 58ca5999e0367d131de82a75257fbfd5aed0195d upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_isr.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1618,6 +1618,7 @@ qla24xx_tm_iocb_entry(scsi_qla_host_t *v
 		iocb->u.tmf.data = QLA_FUNCTION_FAILED;
 	} else if ((le16_to_cpu(sts->scsi_status) &
 	    SS_RESPONSE_INFO_LEN_VALID)) {
+		host_to_fcp_swap(sts->data, sizeof(sts->data));
 		if (le32_to_cpu(sts->rsp_data_len) < 4) {
 			ql_log(ql_log_warn, fcport->vha, 0x503b,
 			    "Async-%s error - hdl=%x not enough response(%d).\n",


