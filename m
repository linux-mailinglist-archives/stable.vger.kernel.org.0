Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77FA6621436
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 14:58:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234868AbiKHN6h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 08:58:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234852AbiKHN6g (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 08:58:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F077BE0B
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 05:58:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 81E79615A3
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 13:58:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52BFCC433C1;
        Tue,  8 Nov 2022 13:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667915913;
        bh=lxxHnBMbPf3AmLsRrVTt5GZ0l6Q47zW+l0J+TERUyyA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ArZlH7iYfRzcshCOwenafxp2Q77684w809OxXwVjUP+gG4gM64TEQV1y1U5C4uKCZ
         lXVE7quDzNDMeUcaJUL6y9WKVywrIs1R9cw65Tx0TqCdbl9Kbx4nrXbGR0pOWLihoP
         4WbHwNGoYSjAmkKuabktWKFVDK2YqPvbnjh86MSU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Justin Tee <justin.tee@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 002/144] scsi: lpfc: Adjust CMF total bytes and rxmonitor
Date:   Tue,  8 Nov 2022 14:37:59 +0100
Message-Id: <20221108133345.454807659@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133345.346704162@linuxfoundation.org>
References: <20221108133345.346704162@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

[ Upstream commit a6269f837045acb02904f31f05acde847ec8f8a7 ]

Calculate any extra bytes needed to account for timer accuracy. If we are
less than LPFC_CMF_INTERVAL, then calculate the adjustment needed for total
to reflect a full LPFC_CMF_INTERVAL.

Add additional info to rxmonitor, and adjust some log formatting.

Link: https://lore.kernel.org/r/20211204002644.116455-7-jsmart2021@gmail.com
Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: bd269188ea94 ("scsi: lpfc: Rework MIB Rx Monitor debug info logic")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc.h         |  1 +
 drivers/scsi/lpfc/lpfc_debugfs.c | 14 ++++++++------
 drivers/scsi/lpfc/lpfc_debugfs.h |  2 +-
 drivers/scsi/lpfc/lpfc_init.c    | 20 ++++++++++++--------
 4 files changed, 22 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index b2508a00bafd..924483368037 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -1611,6 +1611,7 @@ struct lpfc_hba {
 #define LPFC_MAX_RXMONITOR_ENTRY	800
 #define LPFC_MAX_RXMONITOR_DUMP		32
 struct rxtable_entry {
+	uint64_t cmf_bytes;	/* Total no of read bytes for CMF_SYNC_WQE */
 	uint64_t total_bytes;   /* Total no of read bytes requested */
 	uint64_t rcv_bytes;     /* Total no of read bytes completed */
 	uint64_t avg_io_size;
diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index 79bc86ba59b3..61f8dcd072ac 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -5561,22 +5561,24 @@ lpfc_rx_monitor_read(struct file *file, char __user *buf, size_t nbytes,
 	start = tail;
 
 	len += scnprintf(buffer + len, MAX_DEBUGFS_RX_TABLE_SIZE - len,
-			"        MaxBPI\t Total Data Cmd  Total Data Cmpl "
-			"  Latency(us)    Avg IO Size\tMax IO Size   IO cnt "
-			"Info BWutil(ms)\n");
+			"        MaxBPI    Tot_Data_CMF Tot_Data_Cmd "
+			"Tot_Data_Cmpl  Lat(us)  Avg_IO  Max_IO "
+			"Bsy IO_cnt Info BWutil(ms)\n");
 get_table:
 	for (i = start; i < last; i++) {
 		entry = &phba->rxtable[i];
 		len += scnprintf(buffer + len, MAX_DEBUGFS_RX_TABLE_SIZE - len,
-				"%3d:%12lld  %12lld\t%12lld\t"
-				"%8lldus\t%8lld\t%10lld "
-				"%8d   %2d %2d(%2d)\n",
+				"%3d:%12lld %12lld %12lld %12lld "
+				"%7lldus %8lld %7lld "
+				"%2d   %4d   %2d   %2d(%2d)\n",
 				i, entry->max_bytes_per_interval,
+				entry->cmf_bytes,
 				entry->total_bytes,
 				entry->rcv_bytes,
 				entry->avg_io_latency,
 				entry->avg_io_size,
 				entry->max_read_cnt,
+				entry->cmf_busy,
 				entry->io_cnt,
 				entry->cmf_info,
 				entry->timer_utilization,
diff --git a/drivers/scsi/lpfc/lpfc_debugfs.h b/drivers/scsi/lpfc/lpfc_debugfs.h
index a5bf71b34972..6dd361c1fd31 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.h
+++ b/drivers/scsi/lpfc/lpfc_debugfs.h
@@ -282,7 +282,7 @@ struct lpfc_idiag {
 	void *ptr_private;
 };
 
-#define MAX_DEBUGFS_RX_TABLE_SIZE	(100 * LPFC_MAX_RXMONITOR_ENTRY)
+#define MAX_DEBUGFS_RX_TABLE_SIZE	(128 * LPFC_MAX_RXMONITOR_ENTRY)
 struct lpfc_rx_monitor_debug {
 	char *i_private;
 	char *buffer;
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 38bd58fb2044..5dad0b07953f 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -5870,7 +5870,7 @@ lpfc_cmf_timer(struct hrtimer *timer)
 	uint32_t io_cnt;
 	uint32_t head, tail;
 	uint32_t busy, max_read;
-	uint64_t total, rcv, lat, mbpi, extra;
+	uint64_t total, rcv, lat, mbpi, extra, cnt;
 	int timer_interval = LPFC_CMF_INTERVAL;
 	uint32_t ms;
 	struct lpfc_cgn_stat *cgs;
@@ -5941,20 +5941,23 @@ lpfc_cmf_timer(struct hrtimer *timer)
 
 		/* Calculate any extra bytes needed to account for the
 		 * timer accuracy. If we are less than LPFC_CMF_INTERVAL
-		 * add an extra 3% slop factor, equal to LPFC_CMF_INTERVAL
-		 * add an extra 2%. The goal is to equalize total with a
-		 * time > LPFC_CMF_INTERVAL or <= LPFC_CMF_INTERVAL + 1
+		 * calculate the adjustment needed for total to reflect
+		 * a full LPFC_CMF_INTERVAL.
 		 */
-		if (ms == LPFC_CMF_INTERVAL)
-			extra = div_u64(total, 50);
-		else if (ms < LPFC_CMF_INTERVAL)
-			extra = div_u64(total, 33);
+		if (ms && ms < LPFC_CMF_INTERVAL) {
+			cnt = div_u64(total, ms); /* bytes per ms */
+			cnt *= LPFC_CMF_INTERVAL; /* what total should be */
+			if (cnt > mbpi)
+				cnt = mbpi;
+			extra = cnt - total;
+		}
 		lpfc_issue_cmf_sync_wqe(phba, LPFC_CMF_INTERVAL, total + extra);
 	} else {
 		/* For Monitor mode or link down we want mbpi
 		 * to be the full link speed
 		 */
 		mbpi = phba->cmf_link_byte_count;
+		extra = 0;
 	}
 	phba->cmf_timer_cnt++;
 
@@ -5985,6 +5988,7 @@ lpfc_cmf_timer(struct hrtimer *timer)
 				   LPFC_RXMONITOR_TABLE_IN_USE);
 		entry = &phba->rxtable[head];
 		entry->total_bytes = total;
+		entry->cmf_bytes = total + extra;
 		entry->rcv_bytes = rcv;
 		entry->cmf_busy = busy;
 		entry->cmf_info = phba->cmf_active_info;
-- 
2.35.1



