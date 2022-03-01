Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 441294C922A
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 18:47:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236072AbiCARs0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Mar 2022 12:48:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231362AbiCARsZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Mar 2022 12:48:25 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F789FC3;
        Tue,  1 Mar 2022 09:47:43 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id e6so13537643pgn.2;
        Tue, 01 Mar 2022 09:47:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oKchhrdSs+HOTM0TpPvYJrRlEALmZ0/xkNKtFwagNaI=;
        b=I75myOC/Y6BsAULekR+kdFzgkvZtLsTB0l3EW9hTrpJElC+Cn56pF7jeHYQSUxP8gI
         Msx6fLeggCPUOzjqRcLJ6x8KQ9uLHRuyVbN3SDmKdzyfHpPlTnla+TMlR9ox/XVBjSz/
         Ft3b2dN7mrgIXxvnsLuSfEJWqamY3lFYriZtgAM8tDWHGJxFCOcLcD9DdVIFrKmE4UGd
         LHPjxqV8v6RuJ5W9kDJwbLm90ZbORiHDFpOq1mpdYbVsXZYYVvO+G26MzfXrO2+ruA5C
         7CyTkHoxZgBi6tx46EIUmnhL4MCB29Xrr/1XCAMI9FLRUn4UxpjXPeIaaTNXAl5126vY
         fgeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oKchhrdSs+HOTM0TpPvYJrRlEALmZ0/xkNKtFwagNaI=;
        b=LxGHbCaxHH3a+5R1bDMOAfpBd0NLd6xf8LPLnvcyrf2+Ki39HGxjqBlpp8wV+sCAIG
         19iTeso2+MpXaCY23m8QpXmychTJMpwWR5iJuSF2Bh+DNRhsWOi5lqMigRTg3Gn50hVD
         +I8lybpFMfiEJbZl/WvhH/esWulGTZiGMEUdFx7GDWWx6D2Xi+mCiOR4VYck2D18yfuc
         HjkAHcLRDyEC3jXb5fLxE6Pl3n+iKZOH8fYxynYBIY5DBAeJZ36IM09DVvG6zQmQKeNk
         x7rf9wuFhExDgZXy+LDETPGx+l9wa4hXzHliGhi4DlEpUoxK9nXUtbiE7rXhiOuW4NNp
         sBZQ==
X-Gm-Message-State: AOAM530Dt5O4gpRtfKjIrQk6xkkoThGd2IMbUTABKnWAPKsOmPAxAvhL
        RxlSaEE8OjhRY9rzdDkzECheRTdlVZA=
X-Google-Smtp-Source: ABdhPJzMO54zZO188yUxs0ufr/PhATftO5opHZ3E3l+aLoj4N2iiSi/Ljny8WEER0t8uTIoql9EwmQ==
X-Received: by 2002:a05:6a00:1d8a:b0:4e1:559d:2f62 with SMTP id z10-20020a056a001d8a00b004e1559d2f62mr28953139pfw.26.1646156862368;
        Tue, 01 Mar 2022 09:47:42 -0800 (PST)
Received: from mail-lvn-it-01.broadcom.com (ip174-67-196-173.oc.oc.cox.net. [174.67.196.173])
        by smtp.gmail.com with ESMTPSA id y13-20020aa79e0d000000b004f3cc59f884sm16956167pfq.132.2022.03.01.09.47.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Mar 2022 09:47:41 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>, stable@vger.kernel.org,
        Shyam Sundar <ssundar@marvell.com>,
        Nilesh Javali <njavali@marvell.com>
Subject: [PATCH] scsi_transport_fc: Fix FPIN Link Integrity statistics counters
Date:   Tue,  1 Mar 2022 09:47:33 -0800
Message-Id: <20220301174733.59993-1-jsmart2021@gmail.com>
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

This issue was originally reported in this thread, with no comments.
https://lore.kernel.org/linux-scsi/b472606d-e67c-66f1-06d1-ecc5fbb2071a@broadcom.com/

Fixes: 3dcfe0de5a97 ("scsi: fc: Parse FPIN packets and update statistics")
Cc: <stable@vger.kernel.org> # v5.11+
Signed-off-by: James Smart <jsmart2021@gmail.com>
Cc: Shyam Sundar <ssundar@marvell.com>
Cc: Nilesh Javali <njavali@marvell.com>
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

