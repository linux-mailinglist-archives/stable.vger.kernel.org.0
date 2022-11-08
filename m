Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02C88621437
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 14:58:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234773AbiKHN6n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 08:58:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234852AbiKHN6m (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 08:58:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A347020364
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 05:58:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3C97AB81AF7
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 13:58:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8510CC433D6;
        Tue,  8 Nov 2022 13:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667915917;
        bh=7TCBk8U5BLkKWIzCV7DrIaHxt5CWtVWC3SY2JmzW2BU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XK8gtSP5aiEOnNG291DwI3O4SpiYUspeRo1nDb2reOaXBVL1LGZN827/YHlhhA/0P
         EUXMcRCAgB67CxLHSdkBeyyp9seRbwbQQeMpHezFrPTcyQUQLKO0494pfjWZ/a63HD
         OGuJLZSEBL4i21k6LDtlE/eNrm3ccfuQ2TNLOXZY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Justin Tee <justin.tee@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 003/144] scsi: lpfc: Rework MIB Rx Monitor debug info logic
Date:   Tue,  8 Nov 2022 14:38:00 +0100
Message-Id: <20221108133345.493509496@linuxfoundation.org>
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

[ Upstream commit bd269188ea94e40ab002cad7b0df8f12b8f0de54 ]

The kernel test robot reported the following sparse warning:

arch/arm64/include/asm/cmpxchg.h:88:1: sparse: sparse: cast truncates
   bits from constant value (369 becomes 69)

On arm64, atomic_xchg only works on 8-bit byte fields.  Thus, the macro
usage of LPFC_RXMONITOR_TABLE_IN_USE can be unintentionally truncated
leading to all logic involving the LPFC_RXMONITOR_TABLE_IN_USE macro to not
work properly.

Replace the Rx Table atomic_t indexing logic with a new
lpfc_rx_info_monitor structure that holds a circular ring buffer.  For
locking semantics, a spinlock_t is used.

Link: https://lore.kernel.org/r/20220819011736.14141-4-jsmart2021@gmail.com
Fixes: 17b27ac59224 ("scsi: lpfc: Add rx monitoring statistics")
Cc: <stable@vger.kernel.org> # v5.15+
Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
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
index 924483368037..457ff86e02b3 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -1558,10 +1558,7 @@ struct lpfc_hba {
 	u32 cgn_acqe_cnt;
 
 	/* RX monitor handling for CMF */
-	struct rxtable_entry *rxtable;  /* RX_monitor information */
-	atomic_t rxtable_idx_head;
-#define LPFC_RXMONITOR_TABLE_IN_USE     (LPFC_MAX_RXMONITOR_ENTRY + 73)
-	atomic_t rxtable_idx_tail;
+	struct lpfc_rx_info_monitor *rx_monitor;
 	atomic_t rx_max_read_cnt;       /* Maximum read bytes */
 	uint64_t rx_block_cnt;
 
@@ -1610,7 +1607,7 @@ struct lpfc_hba {
 
 #define LPFC_MAX_RXMONITOR_ENTRY	800
 #define LPFC_MAX_RXMONITOR_DUMP		32
-struct rxtable_entry {
+struct rx_info_entry {
 	uint64_t cmf_bytes;	/* Total no of read bytes for CMF_SYNC_WQE */
 	uint64_t total_bytes;   /* Total no of read bytes requested */
 	uint64_t rcv_bytes;     /* Total no of read bytes completed */
@@ -1625,6 +1622,13 @@ struct rxtable_entry {
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
index c9770b1d2366..470239394e64 100644
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -90,6 +90,14 @@ void lpfc_cgn_dump_rxmonitor(struct lpfc_hba *phba);
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
index 61f8dcd072ac..8e8bbe734e87 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -5520,7 +5520,7 @@ lpfc_rx_monitor_open(struct inode *inode, struct file *file)
 	if (!debug)
 		goto out;
 
-	debug->buffer = vmalloc(MAX_DEBUGFS_RX_TABLE_SIZE);
+	debug->buffer = vmalloc(MAX_DEBUGFS_RX_INFO_SIZE);
 	if (!debug->buffer) {
 		kfree(debug);
 		goto out;
@@ -5541,57 +5541,18 @@ lpfc_rx_monitor_read(struct file *file, char __user *buf, size_t nbytes,
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
index 5dad0b07953f..855817f6fe67 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -5428,38 +5428,12 @@ lpfc_async_link_speed_to_read_top(struct lpfc_hba *phba, uint8_t speed_code)
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
 
@@ -5866,9 +5840,8 @@ lpfc_cmf_timer(struct hrtimer *timer)
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
@@ -5983,40 +5956,30 @@ lpfc_cmf_timer(struct hrtimer *timer)
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
index 0024c0e0afd3..d6e761adf1f1 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -7878,6 +7878,172 @@ static void lpfc_sli4_dip(struct lpfc_hba *phba)
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
@@ -8069,19 +8235,29 @@ lpfc_cmf_setup(struct lpfc_hba *phba)
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
2.35.1



