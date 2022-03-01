Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65F1B4C9241
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 18:55:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233299AbiCAR41 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Mar 2022 12:56:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235961AbiCAR41 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Mar 2022 12:56:27 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39B7041F8A;
        Tue,  1 Mar 2022 09:55:46 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id 15-20020a17090a098f00b001bef0376d5cso439546pjo.5;
        Tue, 01 Mar 2022 09:55:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Jje77APtlL8Vy9okCJhF2WRN5jRkiUsyDRK6kheTyXw=;
        b=iR1TguCYJpdrsUxXZ4NOMS6MYwCcNWMW76Nct8yiQBghGhpMeD8mWfUldOfr8ww6d1
         QTN08lKL+lv2WyrxP78DWvp9SytFtnwASxpwNRyGGVHQ06Wqm5Lo13xXw68gVpdKmNXS
         IFI1CUMW7lr636dRH/JwnIsOGEnSQwzNf1F+DbHlYdiMsOqe2eJyX/Vj513uoLa15mg7
         c2rce/LRj/4LlYBTqpFOge3MkG3Vq5jiQgjH1WdV87oEwB0g8bEBDUikOkg1T62n3aBO
         mQ9AzZi5eodi9yBb6+GmbGOs96JYl1y7Tw2FrNDbVXKfGaOVqjyjjjM0NEZ192b9UkWQ
         81GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Jje77APtlL8Vy9okCJhF2WRN5jRkiUsyDRK6kheTyXw=;
        b=re+D4L9Oh5PAFT4Z4kW3WX1BFj/SvpupqYC4j7H5zyYIEEyAqlD+qiP4zehqKmxt1F
         b16Qz2ZaYwp7w1MseJQ0iIkTD63YSRNwrPGnxsXuMZjNxq2V81x95dp6SQeuwKVg30kr
         aOjzpdeWz7dybtjboQqsncRRggFLeIPTPhj6I+ujSPe2n8iz32R6C1mpbVo0bAuGMyUv
         86HviF6IdPg2kZAWlI+QwQOdNucn27GCB7bKjPBzRe2ln2b01PpjslZ4BrAoVXLX96Jx
         pBbpuxFsTU9TPuiD9QPxhWBFdfT3i//TpjqKIRBTuVTuo6xWb6Eyehh1OQ+OD97B+f8B
         hQkw==
X-Gm-Message-State: AOAM532XqT9mfEVKFb1hQYjI/DyLq6uLJ3p+5loJiEPq0id4cK26j0p6
        oKgvfJmcY/gOE+XibU8gby3/TWiFC2w=
X-Google-Smtp-Source: ABdhPJxtWW7+E0U0Pv9Cu44jPCPpdx+Qr3tLmWnQApMGDxwXudm5lH1R2Rde5XJtF2zaFCdsWXctGQ==
X-Received: by 2002:a17:90a:fe0c:b0:1bd:5ea:d079 with SMTP id ck12-20020a17090afe0c00b001bd05ead079mr20472947pjb.150.1646157345599;
        Tue, 01 Mar 2022 09:55:45 -0800 (PST)
Received: from mail-ash-it-01.broadcom.com (ip174-67-196-173.oc.oc.cox.net. [174.67.196.173])
        by smtp.gmail.com with ESMTPSA id pf15-20020a17090b1d8f00b001bc9d6a0f15sm2801985pjb.36.2022.03.01.09.55.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Mar 2022 09:55:45 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>, stable@vger.kernel.org,
        Shyam Sundar <ssundar@marvell.com>,
        Nilesh Javali <njavali@marvell.com>
Subject: [PATCH][REPOST] scsi_transport_fc: Fix FPIN Link Integrity statistics counters
Date:   Tue,  1 Mar 2022 09:55:36 -0800
Message-Id: <20220301175536.60250-1-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In the original FPIN commit, stats were incremented by the event_count.
Event_count is the minimum # of events that must occur before an FPIN is
sent. Thus, its not the actual number of events, and could be
significantly off (too low) as it doesn't reflect anything not reported.
Rather than attempt to count events, have the statistic count how many
FPINS cross the threshold and were reported.

Fixes: 3dcfe0de5a97 ("scsi: fc: Parse FPIN packets and update statistics")
Cc: <stable@vger.kernel.org> # v5.11+
Signed-off-by: James Smart <jsmart2021@gmail.com>
Cc: Shyam Sundar <ssundar@marvell.com>
Cc: Nilesh Javali <njavali@marvell.com>

---
This issue was originally reported in this thread, with no comments.
https://lore.kernel.org/linux-scsi/b472606d-e67c-66f1-06d1-ecc5fbb2071a@broadcom.com/
---
 drivers/scsi/scsi_transport_fc.c | 39 +++++++++++++-------------------
 1 file changed, 16 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 60e406bcf42a..a2524106206d 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -34,7 +34,7 @@ static int fc_bsg_hostadd(struct Scsi_Host *, struct fc_host_attrs *);
 static int fc_bsg_rportadd(struct Scsi_Host *, struct fc_rport *);
 static void fc_bsg_remove(struct request_queue *);
 static void fc_bsg_goose_queue(struct fc_rport *);
-static void fc_li_stats_update(struct fc_fn_li_desc *li_desc,
+static void fc_li_stats_update(u16 event_type,
 			       struct fc_fpin_stats *stats);
 static void fc_delivery_stats_update(u32 reason_code,
 				     struct fc_fpin_stats *stats);
@@ -670,42 +670,34 @@ fc_find_rport_by_wwpn(struct Scsi_Host *shost, u64 wwpn)
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
@@ -767,6 +759,7 @@ fc_fpin_li_stats_update(struct Scsi_Host *shost, struct fc_tlv_desc *tlv)
 	struct fc_rport *attach_rport = NULL;
 	struct fc_host_attrs *fc_host = shost_to_fc_host(shost);
 	struct fc_fn_li_desc *li_desc = (struct fc_fn_li_desc *)tlv;
+	u16 event_type = be16_to_cpu(li_desc->event_type);
 	u64 wwpn;
 
 	rport = fc_find_rport_by_wwpn(shost,
@@ -775,7 +768,7 @@ fc_fpin_li_stats_update(struct Scsi_Host *shost, struct fc_tlv_desc *tlv)
 	    (rport->roles & FC_PORT_ROLE_FCP_TARGET ||
 	     rport->roles & FC_PORT_ROLE_NVME_TARGET)) {
 		attach_rport = rport;
-		fc_li_stats_update(li_desc, &attach_rport->fpin_stats);
+		fc_li_stats_update(event_type, &attach_rport->fpin_stats);
 	}
 
 	if (be32_to_cpu(li_desc->pname_count) > 0) {
@@ -789,14 +782,14 @@ fc_fpin_li_stats_update(struct Scsi_Host *shost, struct fc_tlv_desc *tlv)
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
-- 
2.26.2

