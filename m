Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03B224AA895
	for <lists+stable@lfdr.de>; Sat,  5 Feb 2022 13:15:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379741AbiBEMPI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Feb 2022 07:15:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379040AbiBEMPH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Feb 2022 07:15:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E54C3C061347;
        Sat,  5 Feb 2022 04:15:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7AA3BB800A0;
        Sat,  5 Feb 2022 12:15:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80E0DC340E8;
        Sat,  5 Feb 2022 12:15:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644063303;
        bh=tJ/OpNdL3XWoxXcG2t3hsyBBpox4Tn5WNN7ay0TiSK4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BgIrTSAncWXE8dwIElAzPLDqn4PgCL4O7azZTPS/4XQ3jDXS8fnKcXf3rrs+Fz4aV
         KK5bF73un4V7CebNmRBeW1L8pQpAqDp8wq3Wi02mGYFdsX/zx9UxhqWokG3csc4fh8
         /Zm4l6B+9pTPaIldhqukJE8XWaEQQU0FxD8xx3JY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.4.177
Date:   Sat,  5 Feb 2022 13:14:53 +0100
Message-Id: <1644063293152249@kroah.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <164406329313858@kroah.com>
References: <164406329313858@kroah.com>
MIME-Version: 1.0
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

diff --git a/Documentation/accounting/psi.rst b/Documentation/accounting/psi.rst
index 621111ce5740..28c0461ba2e1 100644
--- a/Documentation/accounting/psi.rst
+++ b/Documentation/accounting/psi.rst
@@ -90,7 +90,8 @@ Triggers can be set on more than one psi metric and more than one trigger
 for the same psi metric can be specified. However for each trigger a separate
 file descriptor is required to be able to poll it separately from others,
 therefore for each trigger a separate open() syscall should be made even
-when opening the same psi interface file.
+when opening the same psi interface file. Write operations to a file descriptor
+with an already existing psi trigger will fail with EBUSY.
 
 Monitors activate only when system enters stall state for the monitored
 psi metric and deactivates upon exit from the stall state. While system is
diff --git a/Makefile b/Makefile
index b23aa51ada93..324939b64d7b 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 4
-SUBLEVEL = 176
+SUBLEVEL = 177
 EXTRAVERSION =
 NAME = Kleptomaniac Octopus
 
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
index da8c2c4aca7e..0442d7e1cd20 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
@@ -721,7 +721,9 @@ static void xgbe_stop_timers(struct xgbe_prv_data *pdata)
 		if (!channel->tx_ring)
 			break;
 
+		/* Deactivate the Tx timer */
 		del_timer_sync(&channel->tx_timer);
+		channel->tx_timer_active = 0;
 	}
 }
 
@@ -2765,6 +2767,14 @@ static int xgbe_rx_poll(struct xgbe_channel *channel, int budget)
 			buf2_len = xgbe_rx_buf2_len(rdata, packet, len);
 			len += buf2_len;
 
+			if (buf2_len > rdata->rx.buf.dma_len) {
+				/* Hardware inconsistency within the descriptors
+				 * that has resulted in a length underflow.
+				 */
+				error = 1;
+				goto skip_data;
+			}
+
 			if (!skb) {
 				skb = xgbe_create_skb(pdata, napi, rdata,
 						      buf1_len);
@@ -2794,8 +2804,10 @@ static int xgbe_rx_poll(struct xgbe_channel *channel, int budget)
 		if (!last || context_next)
 			goto read_again;
 
-		if (!skb)
+		if (!skb || error) {
+			dev_kfree_skb(skb);
 			goto next_packet;
+		}
 
 		/* Be sure we don't exceed the configured MTU */
 		max_len = netdev->mtu + ETH_HLEN;
diff --git a/drivers/net/usb/ipheth.c b/drivers/net/usb/ipheth.c
index 345576f1a747..73ad78f47763 100644
--- a/drivers/net/usb/ipheth.c
+++ b/drivers/net/usb/ipheth.c
@@ -121,7 +121,7 @@ static int ipheth_alloc_urbs(struct ipheth_device *iphone)
 	if (tx_buf == NULL)
 		goto free_rx_urb;
 
-	rx_buf = usb_alloc_coherent(iphone->udev, IPHETH_BUF_SIZE,
+	rx_buf = usb_alloc_coherent(iphone->udev, IPHETH_BUF_SIZE + IPHETH_IP_ALIGN,
 				    GFP_KERNEL, &rx_urb->transfer_dma);
 	if (rx_buf == NULL)
 		goto free_tx_buf;
@@ -146,7 +146,7 @@ static int ipheth_alloc_urbs(struct ipheth_device *iphone)
 
 static void ipheth_free_urbs(struct ipheth_device *iphone)
 {
-	usb_free_coherent(iphone->udev, IPHETH_BUF_SIZE, iphone->rx_buf,
+	usb_free_coherent(iphone->udev, IPHETH_BUF_SIZE + IPHETH_IP_ALIGN, iphone->rx_buf,
 			  iphone->rx_urb->transfer_dma);
 	usb_free_coherent(iphone->udev, IPHETH_BUF_SIZE, iphone->tx_buf,
 			  iphone->tx_urb->transfer_dma);
@@ -317,7 +317,7 @@ static int ipheth_rx_submit(struct ipheth_device *dev, gfp_t mem_flags)
 
 	usb_fill_bulk_urb(dev->rx_urb, udev,
 			  usb_rcvbulkpipe(udev, dev->bulk_in),
-			  dev->rx_buf, IPHETH_BUF_SIZE,
+			  dev->rx_buf, IPHETH_BUF_SIZE + IPHETH_IP_ALIGN,
 			  ipheth_rcvbulk_callback,
 			  dev);
 	dev->rx_urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
diff --git a/drivers/pci/hotplug/pciehp_hpc.c b/drivers/pci/hotplug/pciehp_hpc.c
index 88b996764ff9..907b8be86ce0 100644
--- a/drivers/pci/hotplug/pciehp_hpc.c
+++ b/drivers/pci/hotplug/pciehp_hpc.c
@@ -577,6 +577,8 @@ static irqreturn_t pciehp_isr(int irq, void *dev_id)
 	 */
 	if (ctrl->power_fault_detected)
 		status &= ~PCI_EXP_SLTSTA_PFD;
+	else if (status & PCI_EXP_SLTSTA_PFD)
+		ctrl->power_fault_detected = true;
 
 	events |= status;
 	if (!events) {
@@ -586,7 +588,7 @@ static irqreturn_t pciehp_isr(int irq, void *dev_id)
 	}
 
 	if (status) {
-		pcie_capability_write_word(pdev, PCI_EXP_SLTSTA, events);
+		pcie_capability_write_word(pdev, PCI_EXP_SLTSTA, status);
 
 		/*
 		 * In MSI mode, all event bits must be zero before the port
@@ -660,8 +662,7 @@ static irqreturn_t pciehp_ist(int irq, void *dev_id)
 	}
 
 	/* Check Power Fault Detected */
-	if ((events & PCI_EXP_SLTSTA_PFD) && !ctrl->power_fault_detected) {
-		ctrl->power_fault_detected = 1;
+	if (events & PCI_EXP_SLTSTA_PFD) {
 		ctrl_err(ctrl, "Slot(%s): Power fault\n", slot_name(ctrl));
 		pciehp_set_indicators(ctrl, PCI_EXP_SLTCTL_PWR_IND_OFF,
 				      PCI_EXP_SLTCTL_ATTN_IND_ON);
diff --git a/include/linux/psi.h b/include/linux/psi.h
index 7b3de7321219..7712b5800927 100644
--- a/include/linux/psi.h
+++ b/include/linux/psi.h
@@ -31,7 +31,7 @@ void cgroup_move_task(struct task_struct *p, struct css_set *to);
 
 struct psi_trigger *psi_trigger_create(struct psi_group *group,
 			char *buf, size_t nbytes, enum psi_res res);
-void psi_trigger_replace(void **trigger_ptr, struct psi_trigger *t);
+void psi_trigger_destroy(struct psi_trigger *t);
 
 __poll_t psi_trigger_poll(void **trigger_ptr, struct file *file,
 			poll_table *wait);
diff --git a/include/linux/psi_types.h b/include/linux/psi_types.h
index 07aaf9b82241..0023052eab23 100644
--- a/include/linux/psi_types.h
+++ b/include/linux/psi_types.h
@@ -120,9 +120,6 @@ struct psi_trigger {
 	 * events to one per window
 	 */
 	u64 last_event_time;
-
-	/* Refcounting to prevent premature destruction */
-	struct kref refcount;
 };
 
 struct psi_group {
diff --git a/kernel/cgroup/cgroup-v1.c b/kernel/cgroup/cgroup-v1.c
index 2d0ef613ca07..5e465c4b1e64 100644
--- a/kernel/cgroup/cgroup-v1.c
+++ b/kernel/cgroup/cgroup-v1.c
@@ -549,6 +549,14 @@ static ssize_t cgroup_release_agent_write(struct kernfs_open_file *of,
 
 	BUILD_BUG_ON(sizeof(cgrp->root->release_agent_path) < PATH_MAX);
 
+	/*
+	 * Release agent gets called with all capabilities,
+	 * require capabilities to set release agent.
+	 */
+	if ((of->file->f_cred->user_ns != &init_user_ns) ||
+	    !capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
 	cgrp = cgroup_kn_lock_live(of->kn, false);
 	if (!cgrp)
 		return -ENODEV;
@@ -961,6 +969,12 @@ int cgroup1_parse_param(struct fs_context *fc, struct fs_parameter *param)
 		/* Specifying two release agents is forbidden */
 		if (ctx->release_agent)
 			return cg_invalf(fc, "cgroup1: release_agent respecified");
+		/*
+		 * Release agent gets called with all capabilities,
+		 * require capabilities to set release agent.
+		 */
+		if ((fc->user_ns != &init_user_ns) || !capable(CAP_SYS_ADMIN))
+			return cg_invalf(fc, "cgroup1: Setting release_agent not allowed");
 		ctx->release_agent = param->string;
 		param->string = NULL;
 		break;
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 1904ffcee0f1..ce1745ac7b8c 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -3659,6 +3659,12 @@ static ssize_t cgroup_pressure_write(struct kernfs_open_file *of, char *buf,
 	cgroup_get(cgrp);
 	cgroup_kn_unlock(of->kn);
 
+	/* Allow only one trigger per file descriptor */
+	if (of->priv) {
+		cgroup_put(cgrp);
+		return -EBUSY;
+	}
+
 	psi = cgroup_ino(cgrp) == 1 ? &psi_system : &cgrp->psi;
 	new = psi_trigger_create(psi, buf, nbytes, res);
 	if (IS_ERR(new)) {
@@ -3666,8 +3672,7 @@ static ssize_t cgroup_pressure_write(struct kernfs_open_file *of, char *buf,
 		return PTR_ERR(new);
 	}
 
-	psi_trigger_replace(&of->priv, new);
-
+	smp_store_release(&of->priv, new);
 	cgroup_put(cgrp);
 
 	return nbytes;
@@ -3702,7 +3707,7 @@ static __poll_t cgroup_pressure_poll(struct kernfs_open_file *of,
 
 static void cgroup_pressure_release(struct kernfs_open_file *of)
 {
-	psi_trigger_replace(&of->priv, NULL);
+	psi_trigger_destroy(of->priv);
 }
 #endif /* CONFIG_PSI */
 
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index badfa8f15359..411be8b2e837 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1558,8 +1558,7 @@ static int update_cpumask(struct cpuset *cs, struct cpuset *trialcs,
 	 * Make sure that subparts_cpus is a subset of cpus_allowed.
 	 */
 	if (cs->nr_subparts_cpus) {
-		cpumask_andnot(cs->subparts_cpus, cs->subparts_cpus,
-			       cs->cpus_allowed);
+		cpumask_and(cs->subparts_cpus, cs->subparts_cpus, cs->cpus_allowed);
 		cs->nr_subparts_cpus = cpumask_weight(cs->subparts_cpus);
 	}
 	spin_unlock_irq(&callback_lock);
diff --git a/kernel/sched/psi.c b/kernel/sched/psi.c
index 9154e745f097..9dd83eb74a9d 100644
--- a/kernel/sched/psi.c
+++ b/kernel/sched/psi.c
@@ -1046,7 +1046,6 @@ struct psi_trigger *psi_trigger_create(struct psi_group *group,
 	t->event = 0;
 	t->last_event_time = 0;
 	init_waitqueue_head(&t->event_wait);
-	kref_init(&t->refcount);
 
 	mutex_lock(&group->trigger_lock);
 
@@ -1079,15 +1078,19 @@ struct psi_trigger *psi_trigger_create(struct psi_group *group,
 	return t;
 }
 
-static void psi_trigger_destroy(struct kref *ref)
+void psi_trigger_destroy(struct psi_trigger *t)
 {
-	struct psi_trigger *t = container_of(ref, struct psi_trigger, refcount);
-	struct psi_group *group = t->group;
+	struct psi_group *group;
 	struct kthread_worker *kworker_to_destroy = NULL;
 
-	if (static_branch_likely(&psi_disabled))
+	/*
+	 * We do not check psi_disabled since it might have been disabled after
+	 * the trigger got created.
+	 */
+	if (!t)
 		return;
 
+	group = t->group;
 	/*
 	 * Wakeup waiters to stop polling. Can happen if cgroup is deleted
 	 * from under a polling process.
@@ -1122,9 +1125,9 @@ static void psi_trigger_destroy(struct kref *ref)
 	mutex_unlock(&group->trigger_lock);
 
 	/*
-	 * Wait for both *trigger_ptr from psi_trigger_replace and
-	 * poll_kworker RCUs to complete their read-side critical sections
-	 * before destroying the trigger and optionally the poll_kworker
+	 * Wait for psi_schedule_poll_work RCU to complete its read-side
+	 * critical section before destroying the trigger and optionally the
+	 * poll_task.
 	 */
 	synchronize_rcu();
 	/*
@@ -1146,18 +1149,6 @@ static void psi_trigger_destroy(struct kref *ref)
 	kfree(t);
 }
 
-void psi_trigger_replace(void **trigger_ptr, struct psi_trigger *new)
-{
-	struct psi_trigger *old = *trigger_ptr;
-
-	if (static_branch_likely(&psi_disabled))
-		return;
-
-	rcu_assign_pointer(*trigger_ptr, new);
-	if (old)
-		kref_put(&old->refcount, psi_trigger_destroy);
-}
-
 __poll_t psi_trigger_poll(void **trigger_ptr,
 				struct file *file, poll_table *wait)
 {
@@ -1167,24 +1158,15 @@ __poll_t psi_trigger_poll(void **trigger_ptr,
 	if (static_branch_likely(&psi_disabled))
 		return DEFAULT_POLLMASK | EPOLLERR | EPOLLPRI;
 
-	rcu_read_lock();
-
-	t = rcu_dereference(*(void __rcu __force **)trigger_ptr);
-	if (!t) {
-		rcu_read_unlock();
+	t = smp_load_acquire(trigger_ptr);
+	if (!t)
 		return DEFAULT_POLLMASK | EPOLLERR | EPOLLPRI;
-	}
-	kref_get(&t->refcount);
-
-	rcu_read_unlock();
 
 	poll_wait(file, &t->event_wait, wait);
 
 	if (cmpxchg(&t->event, 1, 0) == 1)
 		ret |= EPOLLPRI;
 
-	kref_put(&t->refcount, psi_trigger_destroy);
-
 	return ret;
 }
 
@@ -1208,14 +1190,24 @@ static ssize_t psi_write(struct file *file, const char __user *user_buf,
 
 	buf[buf_size - 1] = '\0';
 
-	new = psi_trigger_create(&psi_system, buf, nbytes, res);
-	if (IS_ERR(new))
-		return PTR_ERR(new);
-
 	seq = file->private_data;
+
 	/* Take seq->lock to protect seq->private from concurrent writes */
 	mutex_lock(&seq->lock);
-	psi_trigger_replace(&seq->private, new);
+
+	/* Allow only one trigger per file descriptor */
+	if (seq->private) {
+		mutex_unlock(&seq->lock);
+		return -EBUSY;
+	}
+
+	new = psi_trigger_create(&psi_system, buf, nbytes, res);
+	if (IS_ERR(new)) {
+		mutex_unlock(&seq->lock);
+		return PTR_ERR(new);
+	}
+
+	smp_store_release(&seq->private, new);
 	mutex_unlock(&seq->lock);
 
 	return nbytes;
@@ -1250,7 +1242,7 @@ static int psi_fop_release(struct inode *inode, struct file *file)
 {
 	struct seq_file *seq = file->private_data;
 
-	psi_trigger_replace(&seq->private, NULL);
+	psi_trigger_destroy(seq->private);
 	return single_release(inode, file);
 }
 
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 55c0f32b9375..dbc9b2f53649 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -3022,8 +3022,8 @@ static int __rtnl_newlink(struct sk_buff *skb, struct nlmsghdr *nlh,
 	struct nlattr *slave_attr[RTNL_SLAVE_MAX_TYPE + 1];
 	unsigned char name_assign_type = NET_NAME_USER;
 	struct nlattr *linkinfo[IFLA_INFO_MAX + 1];
-	const struct rtnl_link_ops *m_ops = NULL;
-	struct net_device *master_dev = NULL;
+	const struct rtnl_link_ops *m_ops;
+	struct net_device *master_dev;
 	struct net *net = sock_net(skb->sk);
 	const struct rtnl_link_ops *ops;
 	struct nlattr *tb[IFLA_MAX + 1];
@@ -3063,6 +3063,8 @@ static int __rtnl_newlink(struct sk_buff *skb, struct nlmsghdr *nlh,
 			dev = NULL;
 	}
 
+	master_dev = NULL;
+	m_ops = NULL;
 	if (dev) {
 		master_dev = netdev_master_upper_dev_get(dev);
 		if (master_dev)
diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 839e1caa57a5..ed11013d4b95 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -1729,7 +1729,10 @@ static int fanout_add(struct sock *sk, u16 id, u16 type_flags)
 		err = -ENOSPC;
 		if (refcount_read(&match->sk_ref) < PACKET_FANOUT_MAX) {
 			__dev_remove_pack(&po->prot_hook);
-			po->fanout = match;
+
+			/* Paired with packet_setsockopt(PACKET_FANOUT_DATA) */
+			WRITE_ONCE(po->fanout, match);
+
 			po->rollover = rollover;
 			rollover = NULL;
 			refcount_set(&match->sk_ref, refcount_read(&match->sk_ref) + 1);
@@ -3876,7 +3879,8 @@ packet_setsockopt(struct socket *sock, int level, int optname, char __user *optv
 	}
 	case PACKET_FANOUT_DATA:
 	{
-		if (!po->fanout)
+		/* Paired with the WRITE_ONCE() in fanout_add() */
+		if (!READ_ONCE(po->fanout))
 			return -EINVAL;
 
 		return fanout_set_data(po, optval, optlen);
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index a4c61205462a..80205b138d11 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -1928,9 +1928,9 @@ static int tc_new_tfilter(struct sk_buff *skb, struct nlmsghdr *n,
 	bool prio_allocate;
 	u32 parent;
 	u32 chain_index;
-	struct Qdisc *q = NULL;
+	struct Qdisc *q;
 	struct tcf_chain_info chain_info;
-	struct tcf_chain *chain = NULL;
+	struct tcf_chain *chain;
 	struct tcf_block *block;
 	struct tcf_proto *tp;
 	unsigned long cl;
@@ -1958,6 +1958,8 @@ static int tc_new_tfilter(struct sk_buff *skb, struct nlmsghdr *n,
 	tp = NULL;
 	cl = 0;
 	block = NULL;
+	q = NULL;
+	chain = NULL;
 
 	if (prio == 0) {
 		/* If no priority is provided by the user,
@@ -2764,8 +2766,8 @@ static int tc_ctl_chain(struct sk_buff *skb, struct nlmsghdr *n,
 	struct tcmsg *t;
 	u32 parent;
 	u32 chain_index;
-	struct Qdisc *q = NULL;
-	struct tcf_chain *chain = NULL;
+	struct Qdisc *q;
+	struct tcf_chain *chain;
 	struct tcf_block *block;
 	unsigned long cl;
 	int err;
@@ -2775,6 +2777,7 @@ static int tc_ctl_chain(struct sk_buff *skb, struct nlmsghdr *n,
 		return -EPERM;
 
 replay:
+	q = NULL;
 	err = nlmsg_parse_deprecated(n, sizeof(*t), tca, TCA_MAX,
 				     rtm_tca_policy, extack);
 	if (err < 0)
