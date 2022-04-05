Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0B764F2BD4
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:21:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235340AbiDEJBd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:01:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237553AbiDEImt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:42:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7295811172;
        Tue,  5 Apr 2022 01:35:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1E230B81BBF;
        Tue,  5 Apr 2022 08:35:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87B50C385A1;
        Tue,  5 Apr 2022 08:35:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147707;
        bh=upjup/PH9p+NOiB48oXfZdK7fKPqGxjGolVx04MBn/8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pG73wvd+N6RZ/803W6rHAouePhFZxOGW85/TsEhzS8lal4tMs9yRGzmZFfNw3kfrw
         ZLeSAmwUq0EcHDl2QrSIWxijU+ea6Uxboma2VvdshDFLURg2w+letUViMOqWz5cY8h
         jYGV3KSSxYmH0OQF2VAcsh8qFPNbCG1FGG65J8IQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shyam Sundar <ssundar@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        James Smart <jsmart2021@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.16 0093/1017] scsi: scsi_transport_fc: Fix FPIN Link Integrity statistics counters
Date:   Tue,  5 Apr 2022 09:16:46 +0200
Message-Id: <20220405070356.955557248@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: James Smart <jsmart2021@gmail.com>

commit 07e0984b96ec1ba8c6de1c092b986b00ea0c114c upstream.

In the original FPIN commit, stats were incremented by the event_count.
Event_count is the minimum # of events that must occur before an FPIN is
sent. Thus, its not the actual number of events, and could be significantly
off (too low) as it doesn't reflect anything not reported.  Rather than
attempt to count events, have the statistic count how many FPINS cross the
threshold and were reported.

Link: https://lore.kernel.org/r/20220301175536.60250-1-jsmart2021@gmail.com
Fixes: 3dcfe0de5a97 ("scsi: fc: Parse FPIN packets and update statistics")
Cc: <stable@vger.kernel.org> # v5.11+
Cc: Shyam Sundar <ssundar@marvell.com>
Cc: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/scsi_transport_fc.c |   39 ++++++++++++++++-----------------------
 1 file changed, 16 insertions(+), 23 deletions(-)

--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -34,7 +34,7 @@ static int fc_bsg_hostadd(struct Scsi_Ho
 static int fc_bsg_rportadd(struct Scsi_Host *, struct fc_rport *);
 static void fc_bsg_remove(struct request_queue *);
 static void fc_bsg_goose_queue(struct fc_rport *);
-static void fc_li_stats_update(struct fc_fn_li_desc *li_desc,
+static void fc_li_stats_update(u16 event_type,
 			       struct fc_fpin_stats *stats);
 static void fc_delivery_stats_update(u32 reason_code,
 				     struct fc_fpin_stats *stats);
@@ -670,42 +670,34 @@ fc_find_rport_by_wwpn(struct Scsi_Host *
 EXPORT_SYMBOL(fc_find_rport_by_wwpn);
 
 static void
-fc_li_stats_update(struct fc_fn_li_desc *li_desc,
+fc_li_stats_update(u16 event_type,
 		   struct fc_fpin_stats *stats)
 {
-	stats->li += be32_to_cpu(li_desc->event_count);
-	switch (be16_to_cpu(li_desc->event_type)) {
+	stats->li++;
+	switch (event_type) {
 	case FPIN_LI_UNKNOWN:
-		stats->li_failure_unknown +=
-		    be32_to_cpu(li_desc->event_count);
+		stats->li_failure_unknown++;
 		break;
 	case FPIN_LI_LINK_FAILURE:
-		stats->li_link_failure_count +=
-		    be32_to_cpu(li_desc->event_count);
+		stats->li_link_failure_count++;
 		break;
 	case FPIN_LI_LOSS_OF_SYNC:
-		stats->li_loss_of_sync_count +=
-		    be32_to_cpu(li_desc->event_count);
+		stats->li_loss_of_sync_count++;
 		break;
 	case FPIN_LI_LOSS_OF_SIG:
-		stats->li_loss_of_signals_count +=
-		    be32_to_cpu(li_desc->event_count);
+		stats->li_loss_of_signals_count++;
 		break;
 	case FPIN_LI_PRIM_SEQ_ERR:
-		stats->li_prim_seq_err_count +=
-		    be32_to_cpu(li_desc->event_count);
+		stats->li_prim_seq_err_count++;
 		break;
 	case FPIN_LI_INVALID_TX_WD:
-		stats->li_invalid_tx_word_count +=
-		    be32_to_cpu(li_desc->event_count);
+		stats->li_invalid_tx_word_count++;
 		break;
 	case FPIN_LI_INVALID_CRC:
-		stats->li_invalid_crc_count +=
-		    be32_to_cpu(li_desc->event_count);
+		stats->li_invalid_crc_count++;
 		break;
 	case FPIN_LI_DEVICE_SPEC:
-		stats->li_device_specific +=
-		    be32_to_cpu(li_desc->event_count);
+		stats->li_device_specific++;
 		break;
 	}
 }
@@ -767,6 +759,7 @@ fc_fpin_li_stats_update(struct Scsi_Host
 	struct fc_rport *attach_rport = NULL;
 	struct fc_host_attrs *fc_host = shost_to_fc_host(shost);
 	struct fc_fn_li_desc *li_desc = (struct fc_fn_li_desc *)tlv;
+	u16 event_type = be16_to_cpu(li_desc->event_type);
 	u64 wwpn;
 
 	rport = fc_find_rport_by_wwpn(shost,
@@ -775,7 +768,7 @@ fc_fpin_li_stats_update(struct Scsi_Host
 	    (rport->roles & FC_PORT_ROLE_FCP_TARGET ||
 	     rport->roles & FC_PORT_ROLE_NVME_TARGET)) {
 		attach_rport = rport;
-		fc_li_stats_update(li_desc, &attach_rport->fpin_stats);
+		fc_li_stats_update(event_type, &attach_rport->fpin_stats);
 	}
 
 	if (be32_to_cpu(li_desc->pname_count) > 0) {
@@ -789,14 +782,14 @@ fc_fpin_li_stats_update(struct Scsi_Host
 			    rport->roles & FC_PORT_ROLE_NVME_TARGET)) {
 				if (rport == attach_rport)
 					continue;
-				fc_li_stats_update(li_desc,
+				fc_li_stats_update(event_type,
 						   &rport->fpin_stats);
 			}
 		}
 	}
 
 	if (fc_host->port_name == be64_to_cpu(li_desc->attached_wwpn))
-		fc_li_stats_update(li_desc, &fc_host->fpin_stats);
+		fc_li_stats_update(event_type, &fc_host->fpin_stats);
 }
 
 /*


