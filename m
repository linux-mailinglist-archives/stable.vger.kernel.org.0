Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28EC34B487C
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 10:57:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343622AbiBNJzC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 04:55:02 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343647AbiBNJxy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 04:53:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 861EE69CE8;
        Mon, 14 Feb 2022 01:44:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 330A8B80DBF;
        Mon, 14 Feb 2022 09:43:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1331FC340E9;
        Mon, 14 Feb 2022 09:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644831837;
        bh=/XACVBImzhKzlP3jqZ9K4mJM4G4DEA1zro0JuI/XhFM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EIDF5UT3Yr9jkpz4atO1OZyUAZl87g0ADAkLrXh+tfyokoO16M4A89ij5QEpARDIW
         NC8PQZ2xJg3/QCOJprEp3/kt/2FQuDTOmolxd+gbkWjTmU/aLTKBXwaF7KXvTudseU
         4LN61124wPg5cU+m3busKTPzUzTNILPkhsAA4RlE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Ewan D. Milne" <emilne@redhat.com>,
        James Smart <jsmart2021@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.10 113/116] scsi: lpfc: Reduce log messages seen after firmware download
Date:   Mon, 14 Feb 2022 10:26:52 +0100
Message-Id: <20220214092502.699048065@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092458.668376521@linuxfoundation.org>
References: <20220214092458.668376521@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

commit 5852ed2a6a39c862c8a3fdf646e1f4e01b91d710 upstream.

Messages around firmware download were incorrectly tagged as being related
to discovery trace events. Thus, firmware download status ended up dumping
the trace log as well as the firmware update message. As there were a
couple of log messages in this state, the trace log was dumped multiple
times.

Resolve this by converting from trace events to SLI events.

Link: https://lore.kernel.org/r/20220207180442.72836-1-jsmart2021@gmail.com
Reviewed-by: Ewan D. Milne <emilne@redhat.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/lpfc/lpfc_init.c |    2 +-
 drivers/scsi/lpfc/lpfc_sli.c  |    8 +++++++-
 2 files changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -1998,7 +1998,7 @@ lpfc_handle_eratt_s4(struct lpfc_hba *ph
 		}
 		if (reg_err1 == SLIPORT_ERR1_REG_ERR_CODE_2 &&
 		    reg_err2 == SLIPORT_ERR2_REG_FW_RESTART) {
-			lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
+			lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
 					"3143 Port Down: Firmware Update "
 					"Detected\n");
 			en_rn_msg = false;
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -12402,6 +12402,7 @@ lpfc_sli4_eratt_read(struct lpfc_hba *ph
 	uint32_t uerr_sta_hi, uerr_sta_lo;
 	uint32_t if_type, portsmphr;
 	struct lpfc_register portstat_reg;
+	u32 logmask;
 
 	/*
 	 * For now, use the SLI4 device internal unrecoverable error
@@ -12452,7 +12453,12 @@ lpfc_sli4_eratt_read(struct lpfc_hba *ph
 				readl(phba->sli4_hba.u.if_type2.ERR1regaddr);
 			phba->work_status[1] =
 				readl(phba->sli4_hba.u.if_type2.ERR2regaddr);
-			lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
+			logmask = LOG_TRACE_EVENT;
+			if (phba->work_status[0] ==
+				SLIPORT_ERR1_REG_ERR_CODE_2 &&
+			    phba->work_status[1] == SLIPORT_ERR2_REG_FW_RESTART)
+				logmask = LOG_SLI;
+			lpfc_printf_log(phba, KERN_ERR, logmask,
 					"2885 Port Status Event: "
 					"port status reg 0x%x, "
 					"port smphr reg 0x%x, "


