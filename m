Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BE4555AA92
	for <lists+stable@lfdr.de>; Sat, 25 Jun 2022 15:43:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232126AbiFYNmx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Jun 2022 09:42:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233173AbiFYNmw (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Jun 2022 09:42:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBAD618B27;
        Sat, 25 Jun 2022 06:42:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 373BF61350;
        Sat, 25 Jun 2022 13:42:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD145C3411C;
        Sat, 25 Jun 2022 13:42:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656164569;
        bh=hqr3rRKitW3lvlqYfUgCWr30FvyB3h49Ag9tlRd7ioY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qKYxAI8ydxZt112GNOKe8fzvZQQiQG9l2Rbq0uMgipqybatADQxQJq7KLLBAvzEWe
         Lc+AlplFRVJJl8zkwbEDJ2uN+mXL2GrIlK3Pj20UUu9aZtnyqPVpgIp1tBNOUqUeeD
         MB2Y/u1ZXKqAKp50YzBVBYKws7DvpDUHrgDv+0Rc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.18.7
Date:   Sat, 25 Jun 2022 15:42:42 +0200
Message-Id: <165616456111352@kroah.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <16561645612100@kroah.com>
References: <16561645612100@kroah.com>
MIME-Version: 1.0
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

diff --git a/Documentation/devicetree/bindings/nvmem/fsl,layerscape-sfp.yaml b/Documentation/devicetree/bindings/nvmem/fsl,layerscape-sfp.yaml
index 80914b93638e..24c5e3858452 100644
--- a/Documentation/devicetree/bindings/nvmem/fsl,layerscape-sfp.yaml
+++ b/Documentation/devicetree/bindings/nvmem/fsl,layerscape-sfp.yaml
@@ -24,15 +24,29 @@ properties:
   reg:
     maxItems: 1
 
+  clocks:
+    maxItems: 1
+    description:
+      The SFP clock. Typically, this is the platform clock divided by 4.
+
+  clock-names:
+    const: sfp
+
 required:
   - compatible
   - reg
+  - clock-names
+  - clocks
 
 unevaluatedProperties: false
 
 examples:
   - |
+    #include <dt-bindings/clock/fsl,qoriq-clockgen.h>
     efuse@1e80000 {
         compatible = "fsl,ls1028a-sfp";
         reg = <0x1e80000 0x8000>;
+        clocks = <&clockgen QORIQ_CLK_PLATFORM_PLL
+                            QORIQ_CLK_PLL_DIV(4)>;
+        clock-names = "sfp";
     };
diff --git a/Makefile b/Makefile
index 27850d452d65..61d63068553c 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 18
-SUBLEVEL = 6
+SUBLEVEL = 7
 EXTRAVERSION =
 NAME = Superb Owl
 
diff --git a/arch/s390/mm/pgtable.c b/arch/s390/mm/pgtable.c
index 697df02362af..4909dcd762e8 100644
--- a/arch/s390/mm/pgtable.c
+++ b/arch/s390/mm/pgtable.c
@@ -748,7 +748,7 @@ void ptep_zap_key(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
 	pgste_val(pgste) |= PGSTE_GR_BIT | PGSTE_GC_BIT;
 	ptev = pte_val(*ptep);
 	if (!(ptev & _PAGE_INVALID) && (ptev & _PAGE_WRITE))
-		page_set_storage_key(ptev & PAGE_MASK, PAGE_DEFAULT_KEY, 1);
+		page_set_storage_key(ptev & PAGE_MASK, PAGE_DEFAULT_KEY, 0);
 	pgste_set_unlock(ptep, pgste);
 	preempt_enable();
 }
diff --git a/arch/x86/boot/boot.h b/arch/x86/boot/boot.h
index 34c9dbb6a47d..686a9d75a0e4 100644
--- a/arch/x86/boot/boot.h
+++ b/arch/x86/boot/boot.h
@@ -110,66 +110,78 @@ typedef unsigned int addr_t;
 
 static inline u8 rdfs8(addr_t addr)
 {
+	u8 *ptr = (u8 *)absolute_pointer(addr);
 	u8 v;
-	asm volatile("movb %%fs:%1,%0" : "=q" (v) : "m" (*(u8 *)addr));
+	asm volatile("movb %%fs:%1,%0" : "=q" (v) : "m" (*ptr));
 	return v;
 }
 static inline u16 rdfs16(addr_t addr)
 {
+	u16 *ptr = (u16 *)absolute_pointer(addr);
 	u16 v;
-	asm volatile("movw %%fs:%1,%0" : "=r" (v) : "m" (*(u16 *)addr));
+	asm volatile("movw %%fs:%1,%0" : "=r" (v) : "m" (*ptr));
 	return v;
 }
 static inline u32 rdfs32(addr_t addr)
 {
+	u32 *ptr = (u32 *)absolute_pointer(addr);
 	u32 v;
-	asm volatile("movl %%fs:%1,%0" : "=r" (v) : "m" (*(u32 *)addr));
+	asm volatile("movl %%fs:%1,%0" : "=r" (v) : "m" (*ptr));
 	return v;
 }
 
 static inline void wrfs8(u8 v, addr_t addr)
 {
-	asm volatile("movb %1,%%fs:%0" : "+m" (*(u8 *)addr) : "qi" (v));
+	u8 *ptr = (u8 *)absolute_pointer(addr);
+	asm volatile("movb %1,%%fs:%0" : "+m" (*ptr) : "qi" (v));
 }
 static inline void wrfs16(u16 v, addr_t addr)
 {
-	asm volatile("movw %1,%%fs:%0" : "+m" (*(u16 *)addr) : "ri" (v));
+	u16 *ptr = (u16 *)absolute_pointer(addr);
+	asm volatile("movw %1,%%fs:%0" : "+m" (*ptr) : "ri" (v));
 }
 static inline void wrfs32(u32 v, addr_t addr)
 {
-	asm volatile("movl %1,%%fs:%0" : "+m" (*(u32 *)addr) : "ri" (v));
+	u32 *ptr = (u32 *)absolute_pointer(addr);
+	asm volatile("movl %1,%%fs:%0" : "+m" (*ptr) : "ri" (v));
 }
 
 static inline u8 rdgs8(addr_t addr)
 {
+	u8 *ptr = (u8 *)absolute_pointer(addr);
 	u8 v;
-	asm volatile("movb %%gs:%1,%0" : "=q" (v) : "m" (*(u8 *)addr));
+	asm volatile("movb %%gs:%1,%0" : "=q" (v) : "m" (*ptr));
 	return v;
 }
 static inline u16 rdgs16(addr_t addr)
 {
+	u16 *ptr = (u16 *)absolute_pointer(addr);
 	u16 v;
-	asm volatile("movw %%gs:%1,%0" : "=r" (v) : "m" (*(u16 *)addr));
+	asm volatile("movw %%gs:%1,%0" : "=r" (v) : "m" (*ptr));
 	return v;
 }
 static inline u32 rdgs32(addr_t addr)
 {
+	u32 *ptr = (u32 *)absolute_pointer(addr);
 	u32 v;
-	asm volatile("movl %%gs:%1,%0" : "=r" (v) : "m" (*(u32 *)addr));
+	asm volatile("movl %%gs:%1,%0" : "=r" (v) : "m" (*ptr));
 	return v;
 }
 
 static inline void wrgs8(u8 v, addr_t addr)
 {
-	asm volatile("movb %1,%%gs:%0" : "+m" (*(u8 *)addr) : "qi" (v));
+	u8 *ptr = (u8 *)absolute_pointer(addr);
+	asm volatile("movb %1,%%gs:%0" : "+m" (*ptr) : "qi" (v));
 }
 static inline void wrgs16(u16 v, addr_t addr)
 {
-	asm volatile("movw %1,%%gs:%0" : "+m" (*(u16 *)addr) : "ri" (v));
+	u16 *ptr = (u16 *)absolute_pointer(addr);
+	asm volatile("movw %1,%%gs:%0" : "+m" (*ptr) : "ri" (v));
 }
 static inline void wrgs32(u32 v, addr_t addr)
 {
-	asm volatile("movl %1,%%gs:%0" : "+m" (*(u32 *)addr) : "ri" (v));
+	u32 *ptr = (u32 *)absolute_pointer(addr);
+	asm volatile("movl %1,%%gs:%0" : "+m" (*ptr) : "ri" (v));
 }
 
 /* Note: these only return true/false, not a signed return value! */
diff --git a/arch/x86/boot/main.c b/arch/x86/boot/main.c
index e3add857c2c9..c421af5a3cdc 100644
--- a/arch/x86/boot/main.c
+++ b/arch/x86/boot/main.c
@@ -33,7 +33,7 @@ static void copy_boot_params(void)
 		u16 cl_offset;
 	};
 	const struct old_cmdline * const oldcmd =
-		(const struct old_cmdline *)OLD_CL_ADDRESS;
+		absolute_pointer(OLD_CL_ADDRESS);
 
 	BUILD_BUG_ON(sizeof(boot_params) != 4096);
 	memcpy(&boot_params.hdr, &hdr, sizeof(hdr));
diff --git a/drivers/net/ethernet/sun/cassini.c b/drivers/net/ethernet/sun/cassini.c
index b04a6a7bf566..435dc00d04e5 100644
--- a/drivers/net/ethernet/sun/cassini.c
+++ b/drivers/net/ethernet/sun/cassini.c
@@ -1313,7 +1313,7 @@ static void cas_init_rx_dma(struct cas *cp)
 	writel(val, cp->regs + REG_RX_PAGE_SIZE);
 
 	/* enable the header parser if desired */
-	if (CAS_HP_FIRMWARE == cas_prog_null)
+	if (&CAS_HP_FIRMWARE[0] == &cas_prog_null[0])
 		return;
 
 	val = CAS_BASE(HP_CFG_NUM_CPU, CAS_NCPUS > 63 ? 0 : CAS_NCPUS);
@@ -3780,7 +3780,7 @@ static void cas_reset(struct cas *cp, int blkflag)
 
 	/* program header parser */
 	if ((cp->cas_flags & CAS_FLAG_TARGET_ABORT) ||
-	    (CAS_HP_ALT_FIRMWARE == cas_prog_null)) {
+	    (&CAS_HP_ALT_FIRMWARE[0] == &cas_prog_null[0])) {
 		cas_load_firmware(cp, CAS_HP_FIRMWARE);
 	} else {
 		cas_load_firmware(cp, CAS_HP_ALT_FIRMWARE);
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
index 51fe51bb0504..15e6a6aded31 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
@@ -2386,10 +2386,7 @@ void rtl92d_phy_reload_iqk_setting(struct ieee80211_hw *hw, u8 channel)
 			rtl_dbg(rtlpriv, COMP_SCAN, DBG_LOUD,
 				"Just Read IQK Matrix reg for channel:%d....\n",
 				channel);
-			if ((rtlphy->iqk_matrix[indexforchannel].
-			     value[0] != NULL)
-				/*&&(regea4 != 0) */)
-				_rtl92d_phy_patha_fill_iqk_matrix(hw, true,
+			_rtl92d_phy_patha_fill_iqk_matrix(hw, true,
 					rtlphy->iqk_matrix[
 					indexforchannel].value,	0,
 					(rtlphy->iqk_matrix[
diff --git a/drivers/net/wwan/iosm/iosm_ipc_protocol_ops.c b/drivers/net/wwan/iosm/iosm_ipc_protocol_ops.c
index c6b032f95d2e..4627847c6daa 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_protocol_ops.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_protocol_ops.c
@@ -372,8 +372,6 @@ bool ipc_protocol_dl_td_prepare(struct iosm_protocol *ipc_protocol,
 struct sk_buff *ipc_protocol_dl_td_process(struct iosm_protocol *ipc_protocol,
 					   struct ipc_pipe *pipe)
 {
-	u32 tail =
-		le32_to_cpu(ipc_protocol->p_ap_shm->tail_array[pipe->pipe_nr]);
 	struct ipc_protocol_td *p_td;
 	struct sk_buff *skb;
 
@@ -403,14 +401,6 @@ struct sk_buff *ipc_protocol_dl_td_process(struct iosm_protocol *ipc_protocol,
 		goto ret;
 	}
 
-	if (!IPC_CB(skb)) {
-		dev_err(ipc_protocol->dev, "pipe# %d, tail: %d skb_cb is NULL",
-			pipe->pipe_nr, tail);
-		ipc_pcie_kfree_skb(ipc_protocol->pcie, skb);
-		skb = NULL;
-		goto ret;
-	}
-
 	if (p_td->buffer.address != IPC_CB(skb)->mapping) {
 		dev_err(ipc_protocol->dev, "invalid buf=%llx or skb=%p",
 			(unsigned long long)p_td->buffer.address, skb->data);
diff --git a/fs/io_uring.c b/fs/io_uring.c
index 3d123ca028c9..68aab48838e4 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1647,7 +1647,7 @@ static inline void io_req_track_inflight(struct io_kiocb *req)
 {
 	if (!(req->flags & REQ_F_INFLIGHT)) {
 		req->flags |= REQ_F_INFLIGHT;
-		atomic_inc(&current->io_uring->inflight_tracked);
+		atomic_inc(&req->task->io_uring->inflight_tracked);
 	}
 }
 
diff --git a/fs/notify/fanotify/fanotify.c b/fs/notify/fanotify/fanotify.c
index 985e995d2a39..4f897e109547 100644
--- a/fs/notify/fanotify/fanotify.c
+++ b/fs/notify/fanotify/fanotify.c
@@ -319,12 +319,8 @@ static u32 fanotify_group_event_mask(struct fsnotify_group *group,
 			return 0;
 	}
 
-	fsnotify_foreach_iter_type(type) {
-		if (!fsnotify_iter_should_report_type(iter_info, type))
-			continue;
-		mark = iter_info->marks[type];
-
-		/* Apply ignore mask regardless of ISDIR and ON_CHILD flags */
+	fsnotify_foreach_iter_mark_type(iter_info, mark, type) {
+		/* Apply ignore mask regardless of mark's ISDIR flag */
 		marks_ignored_mask |= mark->ignored_mask;
 
 		/*
@@ -334,14 +330,6 @@ static u32 fanotify_group_event_mask(struct fsnotify_group *group,
 		if (event_mask & FS_ISDIR && !(mark->mask & FS_ISDIR))
 			continue;
 
-		/*
-		 * If the event is on a child and this mark is on a parent not
-		 * watching children, don't send it!
-		 */
-		if (type == FSNOTIFY_ITER_TYPE_PARENT &&
-		    !(mark->mask & FS_EVENT_ON_CHILD))
-			continue;
-
 		marks_mask |= mark->mask;
 
 		/* Record the mark types of this group that matched the event */
@@ -849,16 +837,14 @@ static struct fanotify_event *fanotify_alloc_event(
  */
 static __kernel_fsid_t fanotify_get_fsid(struct fsnotify_iter_info *iter_info)
 {
+	struct fsnotify_mark *mark;
 	int type;
 	__kernel_fsid_t fsid = {};
 
-	fsnotify_foreach_iter_type(type) {
+	fsnotify_foreach_iter_mark_type(iter_info, mark, type) {
 		struct fsnotify_mark_connector *conn;
 
-		if (!fsnotify_iter_should_report_type(iter_info, type))
-			continue;
-
-		conn = READ_ONCE(iter_info->marks[type]->connector);
+		conn = READ_ONCE(mark->connector);
 		/* Mark is just getting destroyed or created? */
 		if (!conn)
 			continue;
diff --git a/fs/notify/fsnotify.c b/fs/notify/fsnotify.c
index 70a8516b78bc..6d63423cd492 100644
--- a/fs/notify/fsnotify.c
+++ b/fs/notify/fsnotify.c
@@ -290,22 +290,15 @@ static int fsnotify_handle_event(struct fsnotify_group *group, __u32 mask,
 	}
 
 	if (parent_mark) {
-		/*
-		 * parent_mark indicates that the parent inode is watching
-		 * children and interested in this event, which is an event
-		 * possible on child. But is *this mark* watching children and
-		 * interested in this event?
-		 */
-		if (parent_mark->mask & FS_EVENT_ON_CHILD) {
-			ret = fsnotify_handle_inode_event(group, parent_mark, mask,
-							  data, data_type, dir, name, 0);
-			if (ret)
-				return ret;
-		}
-		if (!inode_mark)
-			return 0;
+		ret = fsnotify_handle_inode_event(group, parent_mark, mask,
+						  data, data_type, dir, name, 0);
+		if (ret)
+			return ret;
 	}
 
+	if (!inode_mark)
+		return 0;
+
 	if (mask & FS_EVENT_ON_CHILD) {
 		/*
 		 * Some events can be sent on both parent dir and child marks
@@ -335,31 +328,23 @@ static int send_to_group(__u32 mask, const void *data, int data_type,
 	struct fsnotify_mark *mark;
 	int type;
 
-	if (WARN_ON(!iter_info->report_mask))
+	if (!iter_info->report_mask)
 		return 0;
 
 	/* clear ignored on inode modification */
 	if (mask & FS_MODIFY) {
-		fsnotify_foreach_iter_type(type) {
-			if (!fsnotify_iter_should_report_type(iter_info, type))
-				continue;
-			mark = iter_info->marks[type];
-			if (mark &&
-			    !(mark->flags & FSNOTIFY_MARK_FLAG_IGNORED_SURV_MODIFY))
+		fsnotify_foreach_iter_mark_type(iter_info, mark, type) {
+			if (!(mark->flags &
+			      FSNOTIFY_MARK_FLAG_IGNORED_SURV_MODIFY))
 				mark->ignored_mask = 0;
 		}
 	}
 
-	fsnotify_foreach_iter_type(type) {
-		if (!fsnotify_iter_should_report_type(iter_info, type))
-			continue;
-		mark = iter_info->marks[type];
-		/* does the object mark tell us to do something? */
-		if (mark) {
-			group = mark->group;
-			marks_mask |= mark->mask;
-			marks_ignored_mask |= mark->ignored_mask;
-		}
+	/* Are any of the group marks interested in this event? */
+	fsnotify_foreach_iter_mark_type(iter_info, mark, type) {
+		group = mark->group;
+		marks_mask |= mark->mask;
+		marks_ignored_mask |= mark->ignored_mask;
 	}
 
 	pr_debug("%s: group=%p mask=%x marks_mask=%x marks_ignored_mask=%x data=%p data_type=%d dir=%p cookie=%d\n",
@@ -403,11 +388,11 @@ static struct fsnotify_mark *fsnotify_next_mark(struct fsnotify_mark *mark)
 
 /*
  * iter_info is a multi head priority queue of marks.
- * Pick a subset of marks from queue heads, all with the
- * same group and set the report_mask for selected subset.
- * Returns the report_mask of the selected subset.
+ * Pick a subset of marks from queue heads, all with the same group
+ * and set the report_mask to a subset of the selected marks.
+ * Returns false if there are no more groups to iterate.
  */
-static unsigned int fsnotify_iter_select_report_types(
+static bool fsnotify_iter_select_report_types(
 		struct fsnotify_iter_info *iter_info)
 {
 	struct fsnotify_group *max_prio_group = NULL;
@@ -423,30 +408,48 @@ static unsigned int fsnotify_iter_select_report_types(
 	}
 
 	if (!max_prio_group)
-		return 0;
+		return false;
 
 	/* Set the report mask for marks from same group as max prio group */
+	iter_info->current_group = max_prio_group;
 	iter_info->report_mask = 0;
 	fsnotify_foreach_iter_type(type) {
 		mark = iter_info->marks[type];
-		if (mark &&
-		    fsnotify_compare_groups(max_prio_group, mark->group) == 0)
+		if (mark && mark->group == iter_info->current_group) {
+			/*
+			 * FSNOTIFY_ITER_TYPE_PARENT indicates that this inode
+			 * is watching children and interested in this event,
+			 * which is an event possible on child.
+			 * But is *this mark* watching children?
+			 */
+			if (type == FSNOTIFY_ITER_TYPE_PARENT &&
+			    !(mark->mask & FS_EVENT_ON_CHILD))
+				continue;
+
 			fsnotify_iter_set_report_type(iter_info, type);
+		}
 	}
 
-	return iter_info->report_mask;
+	return true;
 }
 
 /*
- * Pop from iter_info multi head queue, the marks that were iterated in the
+ * Pop from iter_info multi head queue, the marks that belong to the group of
  * current iteration step.
  */
 static void fsnotify_iter_next(struct fsnotify_iter_info *iter_info)
 {
+	struct fsnotify_mark *mark;
 	int type;
 
+	/*
+	 * We cannot use fsnotify_foreach_iter_mark_type() here because we
+	 * may need to advance a mark of type X that belongs to current_group
+	 * but was not selected for reporting.
+	 */
 	fsnotify_foreach_iter_type(type) {
-		if (fsnotify_iter_should_report_type(iter_info, type))
+		mark = iter_info->marks[type];
+		if (mark && mark->group == iter_info->current_group)
 			iter_info->marks[type] =
 				fsnotify_next_mark(iter_info->marks[type]);
 	}
diff --git a/fs/zonefs/super.c b/fs/zonefs/super.c
index 1c2ece961128..15a4c7c07a3b 100644
--- a/fs/zonefs/super.c
+++ b/fs/zonefs/super.c
@@ -72,15 +72,51 @@ static inline void zonefs_i_size_write(struct inode *inode, loff_t isize)
 		zi->i_flags &= ~ZONEFS_ZONE_OPEN;
 }
 
-static int zonefs_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
-			      unsigned int flags, struct iomap *iomap,
-			      struct iomap *srcmap)
+static int zonefs_read_iomap_begin(struct inode *inode, loff_t offset,
+				   loff_t length, unsigned int flags,
+				   struct iomap *iomap, struct iomap *srcmap)
 {
 	struct zonefs_inode_info *zi = ZONEFS_I(inode);
 	struct super_block *sb = inode->i_sb;
 	loff_t isize;
 
-	/* All I/Os should always be within the file maximum size */
+	/*
+	 * All blocks are always mapped below EOF. If reading past EOF,
+	 * act as if there is a hole up to the file maximum size.
+	 */
+	mutex_lock(&zi->i_truncate_mutex);
+	iomap->bdev = inode->i_sb->s_bdev;
+	iomap->offset = ALIGN_DOWN(offset, sb->s_blocksize);
+	isize = i_size_read(inode);
+	if (iomap->offset >= isize) {
+		iomap->type = IOMAP_HOLE;
+		iomap->addr = IOMAP_NULL_ADDR;
+		iomap->length = length;
+	} else {
+		iomap->type = IOMAP_MAPPED;
+		iomap->addr = (zi->i_zsector << SECTOR_SHIFT) + iomap->offset;
+		iomap->length = isize - iomap->offset;
+	}
+	mutex_unlock(&zi->i_truncate_mutex);
+
+	trace_zonefs_iomap_begin(inode, iomap);
+
+	return 0;
+}
+
+static const struct iomap_ops zonefs_read_iomap_ops = {
+	.iomap_begin	= zonefs_read_iomap_begin,
+};
+
+static int zonefs_write_iomap_begin(struct inode *inode, loff_t offset,
+				    loff_t length, unsigned int flags,
+				    struct iomap *iomap, struct iomap *srcmap)
+{
+	struct zonefs_inode_info *zi = ZONEFS_I(inode);
+	struct super_block *sb = inode->i_sb;
+	loff_t isize;
+
+	/* All write I/Os should always be within the file maximum size */
 	if (WARN_ON_ONCE(offset + length > zi->i_max_size))
 		return -EIO;
 
@@ -90,7 +126,7 @@ static int zonefs_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 	 * operation.
 	 */
 	if (WARN_ON_ONCE(zi->i_ztype == ZONEFS_ZTYPE_SEQ &&
-			 (flags & IOMAP_WRITE) && !(flags & IOMAP_DIRECT)))
+			 !(flags & IOMAP_DIRECT)))
 		return -EIO;
 
 	/*
@@ -99,47 +135,44 @@ static int zonefs_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 	 * write pointer) and unwriten beyond.
 	 */
 	mutex_lock(&zi->i_truncate_mutex);
+	iomap->bdev = inode->i_sb->s_bdev;
+	iomap->offset = ALIGN_DOWN(offset, sb->s_blocksize);
+	iomap->addr = (zi->i_zsector << SECTOR_SHIFT) + iomap->offset;
 	isize = i_size_read(inode);
-	if (offset >= isize)
+	if (iomap->offset >= isize) {
 		iomap->type = IOMAP_UNWRITTEN;
-	else
+		iomap->length = zi->i_max_size - iomap->offset;
+	} else {
 		iomap->type = IOMAP_MAPPED;
-	if (flags & IOMAP_WRITE)
-		length = zi->i_max_size - offset;
-	else
-		length = min(length, isize - offset);
+		iomap->length = isize - iomap->offset;
+	}
 	mutex_unlock(&zi->i_truncate_mutex);
 
-	iomap->offset = ALIGN_DOWN(offset, sb->s_blocksize);
-	iomap->length = ALIGN(offset + length, sb->s_blocksize) - iomap->offset;
-	iomap->bdev = inode->i_sb->s_bdev;
-	iomap->addr = (zi->i_zsector << SECTOR_SHIFT) + iomap->offset;
-
 	trace_zonefs_iomap_begin(inode, iomap);
 
 	return 0;
 }
 
-static const struct iomap_ops zonefs_iomap_ops = {
-	.iomap_begin	= zonefs_iomap_begin,
+static const struct iomap_ops zonefs_write_iomap_ops = {
+	.iomap_begin	= zonefs_write_iomap_begin,
 };
 
 static int zonefs_readpage(struct file *unused, struct page *page)
 {
-	return iomap_readpage(page, &zonefs_iomap_ops);
+	return iomap_readpage(page, &zonefs_read_iomap_ops);
 }
 
 static void zonefs_readahead(struct readahead_control *rac)
 {
-	iomap_readahead(rac, &zonefs_iomap_ops);
+	iomap_readahead(rac, &zonefs_read_iomap_ops);
 }
 
 /*
  * Map blocks for page writeback. This is used only on conventional zone files,
  * which implies that the page range can only be within the fixed inode size.
  */
-static int zonefs_map_blocks(struct iomap_writepage_ctx *wpc,
-			     struct inode *inode, loff_t offset)
+static int zonefs_write_map_blocks(struct iomap_writepage_ctx *wpc,
+				   struct inode *inode, loff_t offset)
 {
 	struct zonefs_inode_info *zi = ZONEFS_I(inode);
 
@@ -153,12 +186,12 @@ static int zonefs_map_blocks(struct iomap_writepage_ctx *wpc,
 	    offset < wpc->iomap.offset + wpc->iomap.length)
 		return 0;
 
-	return zonefs_iomap_begin(inode, offset, zi->i_max_size - offset,
-				  IOMAP_WRITE, &wpc->iomap, NULL);
+	return zonefs_write_iomap_begin(inode, offset, zi->i_max_size - offset,
+					IOMAP_WRITE, &wpc->iomap, NULL);
 }
 
 static const struct iomap_writeback_ops zonefs_writeback_ops = {
-	.map_blocks		= zonefs_map_blocks,
+	.map_blocks		= zonefs_write_map_blocks,
 };
 
 static int zonefs_writepage(struct page *page, struct writeback_control *wbc)
@@ -188,7 +221,8 @@ static int zonefs_swap_activate(struct swap_info_struct *sis,
 		return -EINVAL;
 	}
 
-	return iomap_swapfile_activate(sis, swap_file, span, &zonefs_iomap_ops);
+	return iomap_swapfile_activate(sis, swap_file, span,
+				       &zonefs_read_iomap_ops);
 }
 
 static const struct address_space_operations zonefs_file_aops = {
@@ -607,7 +641,7 @@ static vm_fault_t zonefs_filemap_page_mkwrite(struct vm_fault *vmf)
 
 	/* Serialize against truncates */
 	filemap_invalidate_lock_shared(inode->i_mapping);
-	ret = iomap_page_mkwrite(vmf, &zonefs_iomap_ops);
+	ret = iomap_page_mkwrite(vmf, &zonefs_write_iomap_ops);
 	filemap_invalidate_unlock_shared(inode->i_mapping);
 
 	sb_end_pagefault(inode->i_sb);
@@ -860,7 +894,7 @@ static ssize_t zonefs_file_dio_write(struct kiocb *iocb, struct iov_iter *from)
 	if (append)
 		ret = zonefs_file_dio_append(iocb, from);
 	else
-		ret = iomap_dio_rw(iocb, from, &zonefs_iomap_ops,
+		ret = iomap_dio_rw(iocb, from, &zonefs_write_iomap_ops,
 				   &zonefs_write_dio_ops, 0, 0);
 	if (zi->i_ztype == ZONEFS_ZTYPE_SEQ &&
 	    (ret > 0 || ret == -EIOCBQUEUED)) {
@@ -902,7 +936,7 @@ static ssize_t zonefs_file_buffered_write(struct kiocb *iocb,
 	if (ret <= 0)
 		goto inode_unlock;
 
-	ret = iomap_file_buffered_write(iocb, from, &zonefs_iomap_ops);
+	ret = iomap_file_buffered_write(iocb, from, &zonefs_write_iomap_ops);
 	if (ret > 0)
 		iocb->ki_pos += ret;
 	else if (ret == -EIO)
@@ -995,7 +1029,7 @@ static ssize_t zonefs_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
 			goto inode_unlock;
 		}
 		file_accessed(iocb->ki_filp);
-		ret = iomap_dio_rw(iocb, to, &zonefs_iomap_ops,
+		ret = iomap_dio_rw(iocb, to, &zonefs_read_iomap_ops,
 				   &zonefs_read_dio_ops, 0, 0);
 	} else {
 		ret = generic_file_read_iter(iocb, to);
diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
index 0805b74cae44..beb9c99fea07 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -370,6 +370,7 @@ static inline bool fsnotify_valid_obj_type(unsigned int obj_type)
 
 struct fsnotify_iter_info {
 	struct fsnotify_mark *marks[FSNOTIFY_ITER_TYPE_COUNT];
+	struct fsnotify_group *current_group;
 	unsigned int report_mask;
 	int srcu_idx;
 };
@@ -386,20 +387,31 @@ static inline void fsnotify_iter_set_report_type(
 	iter_info->report_mask |= (1U << iter_type);
 }
 
-static inline void fsnotify_iter_set_report_type_mark(
-		struct fsnotify_iter_info *iter_info, int iter_type,
-		struct fsnotify_mark *mark)
+static inline struct fsnotify_mark *fsnotify_iter_mark(
+		struct fsnotify_iter_info *iter_info, int iter_type)
 {
-	iter_info->marks[iter_type] = mark;
-	iter_info->report_mask |= (1U << iter_type);
+	if (fsnotify_iter_should_report_type(iter_info, iter_type))
+		return iter_info->marks[iter_type];
+	return NULL;
+}
+
+static inline int fsnotify_iter_step(struct fsnotify_iter_info *iter, int type,
+				     struct fsnotify_mark **markp)
+{
+	while (type < FSNOTIFY_ITER_TYPE_COUNT) {
+		*markp = fsnotify_iter_mark(iter, type);
+		if (*markp)
+			break;
+		type++;
+	}
+	return type;
 }
 
 #define FSNOTIFY_ITER_FUNCS(name, NAME) \
 static inline struct fsnotify_mark *fsnotify_iter_##name##_mark( \
 		struct fsnotify_iter_info *iter_info) \
 { \
-	return (iter_info->report_mask & (1U << FSNOTIFY_ITER_TYPE_##NAME)) ? \
-		iter_info->marks[FSNOTIFY_ITER_TYPE_##NAME] : NULL; \
+	return fsnotify_iter_mark(iter_info, FSNOTIFY_ITER_TYPE_##NAME); \
 }
 
 FSNOTIFY_ITER_FUNCS(inode, INODE)
@@ -409,6 +421,11 @@ FSNOTIFY_ITER_FUNCS(sb, SB)
 
 #define fsnotify_foreach_iter_type(type) \
 	for (type = 0; type < FSNOTIFY_ITER_TYPE_COUNT; type++)
+#define fsnotify_foreach_iter_mark_type(iter, mark, type) \
+	for (type = 0; \
+	     type = fsnotify_iter_step(iter, type, &mark), \
+	     type < FSNOTIFY_ITER_TYPE_COUNT; \
+	     type++)
 
 /*
  * fsnotify_connp_t is what we embed in objects which connector can be attached
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 0918a39279f6..feef799884d1 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -5769,6 +5769,7 @@ static int btf_check_func_arg_match(struct bpf_verifier_env *env,
 				    struct bpf_reg_state *regs,
 				    bool ptr_to_mem_ok)
 {
+	enum bpf_prog_type prog_type = resolve_prog_type(env->prog);
 	struct bpf_verifier_log *log = &env->log;
 	u32 i, nargs, ref_id, ref_obj_id = 0;
 	bool is_kfunc = btf_is_kernel(btf);
@@ -5834,8 +5835,7 @@ static int btf_check_func_arg_match(struct bpf_verifier_env *env,
 		if (ret < 0)
 			return ret;
 
-		if (btf_get_prog_ctx_type(log, btf, t,
-					  env->prog->type, i)) {
+		if (btf_get_prog_ctx_type(log, btf, t, prog_type, i)) {
 			/* If function expects ctx type in BTF check that caller
 			 * is passing PTR_TO_CTX.
 			 */
diff --git a/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c b/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c
index d9aad15e0d24..02bb8cbf9194 100644
--- a/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c
+++ b/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c
@@ -395,6 +395,18 @@ static void test_func_map_prog_compatibility(void)
 				     "./test_attach_probe.o");
 }
 
+static void test_func_replace_global_func(void)
+{
+	const char *prog_name[] = {
+		"freplace/test_pkt_access",
+	};
+
+	test_fexit_bpf2bpf_common("./freplace_global_func.o",
+				  "./test_pkt_access.o",
+				  ARRAY_SIZE(prog_name),
+				  prog_name, false, NULL);
+}
+
 /* NOTE: affect other tests, must run in serial mode */
 void serial_test_fexit_bpf2bpf(void)
 {
@@ -416,4 +428,6 @@ void serial_test_fexit_bpf2bpf(void)
 		test_func_replace_multi();
 	if (test__start_subtest("fmod_ret_freplace"))
 		test_fmod_ret_freplace();
+	if (test__start_subtest("func_replace_global_func"))
+		test_func_replace_global_func();
 }
diff --git a/tools/testing/selftests/bpf/progs/freplace_global_func.c b/tools/testing/selftests/bpf/progs/freplace_global_func.c
new file mode 100644
index 000000000000..96cb61a6ce87
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/freplace_global_func.c
@@ -0,0 +1,18 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+
+__noinline
+int test_ctx_global_func(struct __sk_buff *skb)
+{
+	volatile int retval = 1;
+	return retval;
+}
+
+SEC("freplace/test_pkt_access")
+int new_test_pkt_access(struct __sk_buff *skb)
+{
+	return test_ctx_global_func(skb);
+}
+
+char _license[] SEC("license") = "GPL";
