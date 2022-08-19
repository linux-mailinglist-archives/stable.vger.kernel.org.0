Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1EB3599268
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 03:19:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236179AbiHSBSU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Aug 2022 21:18:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239326AbiHSBSS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Aug 2022 21:18:18 -0400
Received: from mail-qv1-xf2a.google.com (mail-qv1-xf2a.google.com [IPv6:2607:f8b0:4864:20::f2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DF1325CF;
        Thu, 18 Aug 2022 18:18:13 -0700 (PDT)
Received: by mail-qv1-xf2a.google.com with SMTP id mz1so2431635qvb.4;
        Thu, 18 Aug 2022 18:18:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=l4qTzMOP0E5MqzkZNR0I02mqIEK/tkvkSBKrE+cqM1c=;
        b=ViB2Y29ytCH5LQp2EHr9HGOOzVK10N3ZsESPreGH611aBwlH+Hl6HsdZTAMoklAjfT
         49o48PNpLkSYoz1DjmS61NF471b+2ba6aQpGedhuZACEpB0ke0MSkF2f8l4vD66A0g0+
         WBPTIjOh0Oa82Cl0X8U0wQ2qwIK9FiHQSHYAN+kDYrIEw82+5cfuXt8ngQ9nSIAfV6Kp
         +7m7glOWMd41N8Ev73sFoMyGaUFpGAcp8R2QhM4af+/9xiUF5J3AETnaA0O4VEfhx2X6
         xJSeNl5bYJus2/DMXplkC3Cx0qjiDKEmhck1fXKj9RBz2fkR3fjkWBgg3LolHDLjIySZ
         AcqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=l4qTzMOP0E5MqzkZNR0I02mqIEK/tkvkSBKrE+cqM1c=;
        b=RPWMUgTIKqd59kj4KpC4pAlCNWU+5D4u42OSDeauJM1wHBWf2vUQLrAKNQK4J+PIRY
         U1elNi+CLsYmel8gg4bbl3ec7cxtHtEtAM68qVDhffu71iUbi2HPYxelFtOA0G1oDP8Y
         nB4h9GU322PYLOZUlO6CWA6CbJHiIO/hDQ6Z2p5FHwXEPaMjsNTRwB/P0n0+OLNPx4LF
         PVpjL1ulsL4kC5tcF0ZSe4xvhWbsnW+YeD4JhAPubvaWvbJC8gvdXMPwktL8cfMt54Kg
         oZY7gL7htqb9yn5t9YZZE044gSJDZi1BF/evA9Renc3usPOCm+Z7A/Zpbx57fgTYFCSU
         kjSg==
X-Gm-Message-State: ACgBeo10Ylo3OEVjfsqm2BjNdeGXgGSyjD4mEL/TyYsLgITfFCB6u5in
        RqVGi2nLo7qpgRO+lybw2yKXHOKf6i0=
X-Google-Smtp-Source: AA6agR4JZ4ooR9X9gD80thF1putuT3xxNc7pj16xtH5rQN7D692mY7Izg+R8NKNBx593VtdUyBZeuw==
X-Received: by 2002:a05:6214:2342:b0:473:e142:f758 with SMTP id hu2-20020a056214234200b00473e142f758mr4790756qvb.83.1660871892542;
        Thu, 18 Aug 2022 18:18:12 -0700 (PDT)
Received: from mail-ash-it-01.broadcom.com (ip98-164-255-77.oc.oc.cox.net. [98.164.255.77])
        by smtp.gmail.com with ESMTPSA id u5-20020a05620a0c4500b006b5e296452csm2612502qki.54.2022.08.18.18.18.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 18:18:12 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>, stable@vger.kernel.org,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 3/7] lpfc: Rework MIB Rx Monitor debug info logic
Date:   Thu, 18 Aug 2022 18:17:32 -0700
Message-Id: <20220819011736.14141-4-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220819011736.14141-1-jsmart2021@gmail.com>
References: <20220819011736.14141-1-jsmart2021@gmail.com>
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

The kernel test robot reported the following sparse warning:
arch/arm64/include/asm/cmpxchg.h:88:1: sparse: sparse: cast truncates
   bits from constant value (369 becomes 69)

On arm64, atomic_xchg only works on 8-bit byte fields.
Thus, the macro usage of LPFC_RXMONITOR_TABLE_IN_USE can be
unintentionally truncated leading to all logic involving the
LPFC_RXMONITOR_TABLE_IN_USE macro to not work properly.

Replace the Rx Table atomic_t indexing logic with a new
lpfc_rx_info_monitor structure that holds a circular ring buffer.
For locking semantics, a spinlock_t is used.

Fixes: 17b27ac59224 ("scsi: lpfc: Add rx monitoring statistics")
Cc: <stable@vger.kernel.org> # v5.15+
Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc.h         |  14 ++-
 drivers/scsi/lpfc/lpfc_crtn.h    |   8 ++
 drivers/scsi/lpfc/lpfc_debugfs.c |  59 ++--------
 drivers/scsi/lpfc/lpfc_debugfs.h |   2 +-
 drivers/scsi/lpfc/lpfc_init.c    |  83 ++++----------
 drivers/scsi/lpfc/lpfc_mem.c     |   9 +-
 drivers/scsi/lpfc/lpfc_sli.c     | 190 +++++++++++++++++++++++++++++--
 7 files changed, 240 insertions(+), 125 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index e6a083d098a1..11a05f2c88c4 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -1570,10 +1570,7 @@ struct lpfc_hba {
 	u32 cgn_acqe_cnt;
 
 	/* RX monitor handling for CMF */
-	struct rxtable_entry *rxtable;  /* RX_monitor information */
-	atomic_t rxtable_idx_head;
-#define LPFC_RXMONITOR_TABLE_IN_USE     (LPFC_MAX_RXMONITOR_ENTRY + 73)
-	atomic_t rxtable_idx_tail;
+	struct lpfc_rx_info_monitor *rx_monitor;
 	atomic_t rx_max_read_cnt;       /* Maximum read bytes */
 	uint64_t rx_block_cnt;
 
@@ -1622,7 +1619,7 @@ struct lpfc_hba {
 
 #define LPFC_MAX_RXMONITOR_ENTRY	800
 #define LPFC_MAX_RXMONITOR_DUMP		32
-struct rxtable_entry {
+struct rx_info_entry {
 	uint64_t cmf_bytes;	/* Total no of read bytes for CMF_SYNC_WQE */
 	uint64_t total_bytes;   /* Total no of read bytes requested */
 	uint64_t rcv_bytes;     /* Total no of read bytes completed */
@@ -1637,6 +1634,13 @@ struct rxtable_entry {
 	uint32_t timer_interval;
 };
 
+struct lpfc_rx_info_monitor {
+	struct rx_info_entry *ring; /* info organized in a circular buffer */
+	u32 head_idx, tail_idx; /* index to head/tail of ring */
+	spinlock_t lock; /* spinlock for ring */
+	u32 entries; /* storing number entries/size of ring */
+};
+
 static inline struct Scsi_Host *
 lpfc_shost_from_vport(struct lpfc_vport *vport)
 {
diff --git a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
index bcad91204328..c8cac90240b9 100644
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -92,6 +92,14 @@ void lpfc_cgn_dump_rxmonitor(struct lpfc_hba *phba);
 void lpfc_cgn_update_stat(struct lpfc_hba *phba, uint32_t dtag);
 void lpfc_unblock_requests(struct lpfc_hba *phba);
 void lpfc_block_requests(struct lpfc_hba *phba);
+int lpfc_rx_monitor_create_ring(struct lpfc_rx_info_monitor *rx_monitor,
+				u32 entries);
+void lpfc_rx_monitor_destroy_ring(struct lpfc_rx_info_monitor *rx_monitor);
+void lpfc_rx_monitor_record(struct lpfc_rx_info_monitor *rx_monitor,
+			    struct rx_info_entry *entry);
+u32 lpfc_rx_monitor_report(struct lpfc_hba *phba,
+			   struct lpfc_rx_info_monitor *rx_monitor, char *buf,
+			   u32 buf_len, u32 max_read_entries);
 
 void lpfc_mbx_cmpl_local_config_link(struct lpfc_hba *, LPFC_MBOXQ_t *);
 void lpfc_mbx_cmpl_reg_login(struct lpfc_hba *, LPFC_MBOXQ_t *);
diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index 5037ea09a810..e37b028eae5f 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -5531,7 +5531,7 @@ lpfc_rx_monitor_open(struct inode *inode, struct file *file)
 	if (!debug)
 		goto out;
 
-	debug->buffer = vmalloc(MAX_DEBUGFS_RX_TABLE_SIZE);
+	debug->buffer = vmalloc(MAX_DEBUGFS_RX_INFO_SIZE);
 	if (!debug->buffer) {
 		kfree(debug);
 		goto out;
@@ -5552,57 +5552,18 @@ lpfc_rx_monitor_read(struct file *file, char __user *buf, size_t nbytes,
 	struct lpfc_rx_monitor_debug *debug = file->private_data;
 	struct lpfc_hba *phba = (struct lpfc_hba *)debug->i_private;
 	char *buffer = debug->buffer;
-	struct rxtable_entry *entry;
-	int i, len = 0, head, tail, last, start;
-
-	head = atomic_read(&phba->rxtable_idx_head);
-	while (head == LPFC_RXMONITOR_TABLE_IN_USE) {
-		/* Table is getting updated */
-		msleep(20);
-		head = atomic_read(&phba->rxtable_idx_head);
-	}
 
-	tail = atomic_xchg(&phba->rxtable_idx_tail, head);
-	if (!phba->rxtable || head == tail) {
-		len += scnprintf(buffer + len, MAX_DEBUGFS_RX_TABLE_SIZE - len,
-				"Rxtable is empty\n");
-		goto out;
-	}
-	last = (head > tail) ?  head : LPFC_MAX_RXMONITOR_ENTRY;
-	start = tail;
-
-	len += scnprintf(buffer + len, MAX_DEBUGFS_RX_TABLE_SIZE - len,
-			"        MaxBPI    Tot_Data_CMF Tot_Data_Cmd "
-			"Tot_Data_Cmpl  Lat(us)  Avg_IO  Max_IO "
-			"Bsy IO_cnt Info BWutil(ms)\n");
-get_table:
-	for (i = start; i < last; i++) {
-		entry = &phba->rxtable[i];
-		len += scnprintf(buffer + len, MAX_DEBUGFS_RX_TABLE_SIZE - len,
-				"%3d:%12lld %12lld %12lld %12lld "
-				"%7lldus %8lld %7lld "
-				"%2d   %4d   %2d   %2d(%2d)\n",
-				i, entry->max_bytes_per_interval,
-				entry->cmf_bytes,
-				entry->total_bytes,
-				entry->rcv_bytes,
-				entry->avg_io_latency,
-				entry->avg_io_size,
-				entry->max_read_cnt,
-				entry->cmf_busy,
-				entry->io_cnt,
-				entry->cmf_info,
-				entry->timer_utilization,
-				entry->timer_interval);
+	if (!phba->rx_monitor) {
+		scnprintf(buffer, MAX_DEBUGFS_RX_INFO_SIZE,
+			  "Rx Monitor Info is empty.\n");
+	} else {
+		lpfc_rx_monitor_report(phba, phba->rx_monitor, buffer,
+				       MAX_DEBUGFS_RX_INFO_SIZE,
+				       LPFC_MAX_RXMONITOR_ENTRY);
 	}
 
-	if (head != last) {
-		start = 0;
-		last = head;
-		goto get_table;
-	}
-out:
-	return simple_read_from_buffer(buf, nbytes, ppos, buffer, len);
+	return simple_read_from_buffer(buf, nbytes, ppos, buffer,
+				       strlen(buffer));
 }
 
 static int
diff --git a/drivers/scsi/lpfc/lpfc_debugfs.h b/drivers/scsi/lpfc/lpfc_debugfs.h
index 6dd361c1fd31..f71e5b6311ac 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.h
+++ b/drivers/scsi/lpfc/lpfc_debugfs.h
@@ -282,7 +282,7 @@ struct lpfc_idiag {
 	void *ptr_private;
 };
 
-#define MAX_DEBUGFS_RX_TABLE_SIZE	(128 * LPFC_MAX_RXMONITOR_ENTRY)
+#define MAX_DEBUGFS_RX_INFO_SIZE	(128 * LPFC_MAX_RXMONITOR_ENTRY)
 struct lpfc_rx_monitor_debug {
 	char *i_private;
 	char *buffer;
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index c69c5a0979ec..460295b7c9fe 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -5569,38 +5569,12 @@ lpfc_async_link_speed_to_read_top(struct lpfc_hba *phba, uint8_t speed_code)
 void
 lpfc_cgn_dump_rxmonitor(struct lpfc_hba *phba)
 {
-	struct rxtable_entry *entry;
-	int cnt = 0, head, tail, last, start;
-
-	head = atomic_read(&phba->rxtable_idx_head);
-	tail = atomic_read(&phba->rxtable_idx_tail);
-	if (!phba->rxtable || head == tail) {
-		lpfc_printf_log(phba, KERN_ERR, LOG_CGN_MGMT,
-				"4411 Rxtable is empty\n");
-		return;
-	}
-	last = tail;
-	start = head;
-
-	/* Display the last LPFC_MAX_RXMONITOR_DUMP entries from the rxtable */
-	while (start != last) {
-		if (start)
-			start--;
-		else
-			start = LPFC_MAX_RXMONITOR_ENTRY - 1;
-		entry = &phba->rxtable[start];
+	if (!phba->rx_monitor) {
 		lpfc_printf_log(phba, KERN_INFO, LOG_CGN_MGMT,
-				"4410 %02d: MBPI %lld Xmit %lld Cmpl %lld "
-				"Lat %lld ASz %lld Info %02d BWUtil %d "
-				"Int %d slot %d\n",
-				cnt, entry->max_bytes_per_interval,
-				entry->total_bytes, entry->rcv_bytes,
-				entry->avg_io_latency, entry->avg_io_size,
-				entry->cmf_info, entry->timer_utilization,
-				entry->timer_interval, start);
-		cnt++;
-		if (cnt >= LPFC_MAX_RXMONITOR_DUMP)
-			return;
+				"4411 Rx Monitor Info is empty.\n");
+	} else {
+		lpfc_rx_monitor_report(phba, phba->rx_monitor, NULL, 0,
+				       LPFC_MAX_RXMONITOR_DUMP);
 	}
 }
 
@@ -6007,9 +5981,8 @@ lpfc_cmf_timer(struct hrtimer *timer)
 {
 	struct lpfc_hba *phba = container_of(timer, struct lpfc_hba,
 					     cmf_timer);
-	struct rxtable_entry *entry;
+	struct rx_info_entry entry;
 	uint32_t io_cnt;
-	uint32_t head, tail;
 	uint32_t busy, max_read;
 	uint64_t total, rcv, lat, mbpi, extra, cnt;
 	int timer_interval = LPFC_CMF_INTERVAL;
@@ -6129,40 +6102,30 @@ lpfc_cmf_timer(struct hrtimer *timer)
 	}
 
 	/* Save rxmonitor information for debug */
-	if (phba->rxtable) {
-		head = atomic_xchg(&phba->rxtable_idx_head,
-				   LPFC_RXMONITOR_TABLE_IN_USE);
-		entry = &phba->rxtable[head];
-		entry->total_bytes = total;
-		entry->cmf_bytes = total + extra;
-		entry->rcv_bytes = rcv;
-		entry->cmf_busy = busy;
-		entry->cmf_info = phba->cmf_active_info;
+	if (phba->rx_monitor) {
+		entry.total_bytes = total;
+		entry.cmf_bytes = total + extra;
+		entry.rcv_bytes = rcv;
+		entry.cmf_busy = busy;
+		entry.cmf_info = phba->cmf_active_info;
 		if (io_cnt) {
-			entry->avg_io_latency = div_u64(lat, io_cnt);
-			entry->avg_io_size = div_u64(rcv, io_cnt);
+			entry.avg_io_latency = div_u64(lat, io_cnt);
+			entry.avg_io_size = div_u64(rcv, io_cnt);
 		} else {
-			entry->avg_io_latency = 0;
-			entry->avg_io_size = 0;
+			entry.avg_io_latency = 0;
+			entry.avg_io_size = 0;
 		}
-		entry->max_read_cnt = max_read;
-		entry->io_cnt = io_cnt;
-		entry->max_bytes_per_interval = mbpi;
+		entry.max_read_cnt = max_read;
+		entry.io_cnt = io_cnt;
+		entry.max_bytes_per_interval = mbpi;
 		if (phba->cmf_active_mode == LPFC_CFG_MANAGED)
-			entry->timer_utilization = phba->cmf_last_ts;
+			entry.timer_utilization = phba->cmf_last_ts;
 		else
-			entry->timer_utilization = ms;
-		entry->timer_interval = ms;
+			entry.timer_utilization = ms;
+		entry.timer_interval = ms;
 		phba->cmf_last_ts = 0;
 
-		/* Increment rxtable index */
-		head = (head + 1) % LPFC_MAX_RXMONITOR_ENTRY;
-		tail = atomic_read(&phba->rxtable_idx_tail);
-		if (head == tail) {
-			tail = (tail + 1) % LPFC_MAX_RXMONITOR_ENTRY;
-			atomic_set(&phba->rxtable_idx_tail, tail);
-		}
-		atomic_set(&phba->rxtable_idx_head, head);
+		lpfc_rx_monitor_record(phba->rx_monitor, &entry);
 	}
 
 	if (phba->cmf_active_mode == LPFC_CFG_MONITOR) {
diff --git a/drivers/scsi/lpfc/lpfc_mem.c b/drivers/scsi/lpfc/lpfc_mem.c
index 870e53b8f81d..5d36b3514864 100644
--- a/drivers/scsi/lpfc/lpfc_mem.c
+++ b/drivers/scsi/lpfc/lpfc_mem.c
@@ -344,9 +344,12 @@ lpfc_mem_free_all(struct lpfc_hba *phba)
 		phba->cgn_i = NULL;
 	}
 
-	/* Free RX table */
-	kfree(phba->rxtable);
-	phba->rxtable = NULL;
+	/* Free RX Monitor */
+	if (phba->rx_monitor) {
+		lpfc_rx_monitor_destroy_ring(phba->rx_monitor);
+		kfree(phba->rx_monitor);
+		phba->rx_monitor = NULL;
+	}
 
 	/* Free the iocb lookup array */
 	kfree(psli->iocbq_lookup);
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 608016725db9..55c9eb39ea19 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -7959,6 +7959,172 @@ static void lpfc_sli4_dip(struct lpfc_hba *phba)
 	}
 }
 
+/**
+ * lpfc_rx_monitor_create_ring - Initialize ring buffer for rx_monitor
+ * @rx_monitor: Pointer to lpfc_rx_info_monitor object
+ * @entries: Number of rx_info_entry objects to allocate in ring
+ *
+ * Return:
+ * 0 - Success
+ * ENOMEM - Failure to kmalloc
+ **/
+int lpfc_rx_monitor_create_ring(struct lpfc_rx_info_monitor *rx_monitor,
+				u32 entries)
+{
+	rx_monitor->ring = kmalloc_array(entries, sizeof(struct rx_info_entry),
+					 GFP_KERNEL);
+	if (!rx_monitor->ring)
+		return -ENOMEM;
+
+	rx_monitor->head_idx = 0;
+	rx_monitor->tail_idx = 0;
+	spin_lock_init(&rx_monitor->lock);
+	rx_monitor->entries = entries;
+
+	return 0;
+}
+
+/**
+ * lpfc_rx_monitor_destroy_ring - Free ring buffer for rx_monitor
+ * @rx_monitor: Pointer to lpfc_rx_info_monitor object
+ **/
+void lpfc_rx_monitor_destroy_ring(struct lpfc_rx_info_monitor *rx_monitor)
+{
+	spin_lock(&rx_monitor->lock);
+	kfree(rx_monitor->ring);
+	rx_monitor->ring = NULL;
+	rx_monitor->entries = 0;
+	rx_monitor->head_idx = 0;
+	rx_monitor->tail_idx = 0;
+	spin_unlock(&rx_monitor->lock);
+}
+
+/**
+ * lpfc_rx_monitor_record - Insert an entry into rx_monitor's ring
+ * @rx_monitor: Pointer to lpfc_rx_info_monitor object
+ * @entry: Pointer to rx_info_entry
+ *
+ * Used to insert an rx_info_entry into rx_monitor's ring.  Note that this is a
+ * deep copy of rx_info_entry not a shallow copy of the rx_info_entry ptr.
+ *
+ * This is called from lpfc_cmf_timer, which is in timer/softirq context.
+ *
+ * In cases of old data overflow, we do a best effort of FIFO order.
+ **/
+void lpfc_rx_monitor_record(struct lpfc_rx_info_monitor *rx_monitor,
+			    struct rx_info_entry *entry)
+{
+	struct rx_info_entry *ring = rx_monitor->ring;
+	u32 *head_idx = &rx_monitor->head_idx;
+	u32 *tail_idx = &rx_monitor->tail_idx;
+	spinlock_t *ring_lock = &rx_monitor->lock;
+	u32 ring_size = rx_monitor->entries;
+
+	spin_lock(ring_lock);
+	memcpy(&ring[*tail_idx], entry, sizeof(*entry));
+	*tail_idx = (*tail_idx + 1) % ring_size;
+
+	/* Best effort of FIFO saved data */
+	if (*tail_idx == *head_idx)
+		*head_idx = (*head_idx + 1) % ring_size;
+
+	spin_unlock(ring_lock);
+}
+
+/**
+ * lpfc_rx_monitor_report - Read out rx_monitor's ring
+ * @phba: Pointer to lpfc_hba object
+ * @rx_monitor: Pointer to lpfc_rx_info_monitor object
+ * @buf: Pointer to char buffer that will contain rx monitor info data
+ * @buf_len: Length buf including null char
+ * @max_read_entries: Maximum number of entries to read out of ring
+ *
+ * Used to dump/read what's in rx_monitor's ring buffer.
+ *
+ * If buf is NULL || buf_len == 0, then it is implied that we want to log the
+ * information to kmsg instead of filling out buf.
+ *
+ * Return:
+ * Number of entries read out of the ring
+ **/
+u32 lpfc_rx_monitor_report(struct lpfc_hba *phba,
+			   struct lpfc_rx_info_monitor *rx_monitor, char *buf,
+			   u32 buf_len, u32 max_read_entries)
+{
+	struct rx_info_entry *ring = rx_monitor->ring;
+	struct rx_info_entry *entry;
+	u32 *head_idx = &rx_monitor->head_idx;
+	u32 *tail_idx = &rx_monitor->tail_idx;
+	spinlock_t *ring_lock = &rx_monitor->lock;
+	u32 ring_size = rx_monitor->entries;
+	u32 cnt = 0;
+	char tmp[DBG_LOG_STR_SZ] = {0};
+	bool log_to_kmsg = (!buf || !buf_len) ? true : false;
+
+	if (!log_to_kmsg) {
+		/* clear the buffer to be sure */
+		memset(buf, 0, buf_len);
+
+		scnprintf(buf, buf_len, "\t%-16s%-16s%-16s%-16s%-8s%-8s%-8s"
+					"%-8s%-8s%-8s%-16s\n",
+					"MaxBPI", "Tot_Data_CMF",
+					"Tot_Data_Cmd", "Tot_Data_Cmpl",
+					"Lat(us)", "Avg_IO", "Max_IO", "Bsy",
+					"IO_cnt", "Info", "BWutil(ms)");
+	}
+
+	/* Needs to be _bh because record is called from timer interrupt
+	 * context
+	 */
+	spin_lock_bh(ring_lock);
+	while (*head_idx != *tail_idx) {
+		entry = &ring[*head_idx];
+
+		/* Read out this entry's data. */
+		if (!log_to_kmsg) {
+			/* If !log_to_kmsg, then store to buf. */
+			scnprintf(tmp, sizeof(tmp),
+				  "%03d:\t%-16llu%-16llu%-16llu%-16llu%-8llu"
+				  "%-8llu%-8llu%-8u%-8u%-8u%u(%u)\n",
+				  *head_idx, entry->max_bytes_per_interval,
+				  entry->cmf_bytes, entry->total_bytes,
+				  entry->rcv_bytes, entry->avg_io_latency,
+				  entry->avg_io_size, entry->max_read_cnt,
+				  entry->cmf_busy, entry->io_cnt,
+				  entry->cmf_info, entry->timer_utilization,
+				  entry->timer_interval);
+
+			/* Check for buffer overflow */
+			if ((strlen(buf) + strlen(tmp)) >= buf_len)
+				break;
+
+			/* Append entry's data to buffer */
+			strlcat(buf, tmp, buf_len);
+		} else {
+			lpfc_printf_log(phba, KERN_INFO, LOG_CGN_MGMT,
+					"4410 %02u: MBPI %llu Xmit %llu "
+					"Cmpl %llu Lat %llu ASz %llu Info %02u "
+					"BWUtil %u Int %u slot %u\n",
+					cnt, entry->max_bytes_per_interval,
+					entry->total_bytes, entry->rcv_bytes,
+					entry->avg_io_latency,
+					entry->avg_io_size, entry->cmf_info,
+					entry->timer_utilization,
+					entry->timer_interval, *head_idx);
+		}
+
+		*head_idx = (*head_idx + 1) % ring_size;
+
+		/* Don't feed more than max_read_entries */
+		cnt++;
+		if (cnt >= max_read_entries)
+			break;
+	}
+	spin_unlock_bh(ring_lock);
+
+	return cnt;
+}
+
 /**
  * lpfc_cmf_setup - Initialize idle_stat tracking
  * @phba: Pointer to HBA context object.
@@ -8133,19 +8299,29 @@ lpfc_cmf_setup(struct lpfc_hba *phba)
 	phba->cmf_interval_rate = LPFC_CMF_INTERVAL;
 
 	/* Allocate RX Monitor Buffer */
-	if (!phba->rxtable) {
-		phba->rxtable = kmalloc_array(LPFC_MAX_RXMONITOR_ENTRY,
-					      sizeof(struct rxtable_entry),
-					      GFP_KERNEL);
-		if (!phba->rxtable) {
+	if (!phba->rx_monitor) {
+		phba->rx_monitor = kzalloc(sizeof(*phba->rx_monitor),
+					   GFP_KERNEL);
+
+		if (!phba->rx_monitor) {
 			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 					"2644 Failed to alloc memory "
 					"for RX Monitor Buffer\n");
 			return -ENOMEM;
 		}
+
+		/* Instruct the rx_monitor object to instantiate its ring */
+		if (lpfc_rx_monitor_create_ring(phba->rx_monitor,
+						LPFC_MAX_RXMONITOR_ENTRY)) {
+			kfree(phba->rx_monitor);
+			phba->rx_monitor = NULL;
+			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+					"2645 Failed to alloc memory "
+					"for RX Monitor's Ring\n");
+			return -ENOMEM;
+		}
 	}
-	atomic_set(&phba->rxtable_idx_head, 0);
-	atomic_set(&phba->rxtable_idx_tail, 0);
+
 	return 0;
 }
 
-- 
2.26.2

