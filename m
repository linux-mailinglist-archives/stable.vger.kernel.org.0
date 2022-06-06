Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7FDF53E33F
	for <lists+stable@lfdr.de>; Mon,  6 Jun 2022 10:55:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230412AbiFFHE0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 03:04:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230409AbiFFHEZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 03:04:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEB6B17E19;
        Mon,  6 Jun 2022 00:04:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 565E661140;
        Mon,  6 Jun 2022 07:04:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34D11C385A9;
        Mon,  6 Jun 2022 07:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654499061;
        bh=NGgDrmewlw8NtH5/GpF0bqU7Zn+j+mZku9mJzAdPAHM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j+50+l6soZ5tNuTgVdwfjxT9imLb10weRO3huJmJXg57vf60sGbiaJGS8tg3vJrFB
         SphdSfp6Eh6uaJhT6po0GpbWGI3eahgrhigDnz3/PbFx/g4r4I6mD/9PjRDvAXGncI
         kH132LNC+6wPa+SGAOQEXK/P9Nj/yKYx27Hqhcb8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 4.14.282
Date:   Mon,  6 Jun 2022 09:04:18 +0200
Message-Id: <165449905781239@kroah.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <165449905734191@kroah.com>
References: <165449905734191@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Documentation/process/submitting-patches.rst b/Documentation/process/submitting-patches.rst
index 733478ade91b..db27ab65387e 100644
--- a/Documentation/process/submitting-patches.rst
+++ b/Documentation/process/submitting-patches.rst
@@ -133,7 +133,7 @@ as you intend it to.
 
 The maintainer will thank you if you write your patch description in a
 form which can be easily pulled into Linux's source code management
-system, ``git``, as a "commit log".  See :ref:`explicit_in_reply_to`.
+system, ``git``, as a "commit log".  See :ref:`the_canonical_patch_format`.
 
 Solve only one problem per patch.  If your description starts to get
 long, that's a sign that you probably need to split up your patch.
diff --git a/Makefile b/Makefile
index 20ad87b8bd56..14820e213362 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 4
 PATCHLEVEL = 14
-SUBLEVEL = 281
+SUBLEVEL = 282
 EXTRAVERSION =
 NAME = Petit Gorille
 
diff --git a/arch/x86/pci/xen.c b/arch/x86/pci/xen.c
index c4b3646bd04c..7135f35f9de7 100644
--- a/arch/x86/pci/xen.c
+++ b/arch/x86/pci/xen.c
@@ -442,6 +442,11 @@ void __init xen_msi_init(void)
 
 	x86_msi.setup_msi_irqs = xen_hvm_setup_msi_irqs;
 	x86_msi.teardown_msi_irq = xen_teardown_msi_irq;
+	/*
+	 * With XEN PIRQ/Eventchannels in use PCI/MSI[-X] masking is solely
+	 * controlled by the hypervisor.
+	 */
+	pci_msi_ignore_mask = 1;
 }
 #endif
 
diff --git a/block/bio.c b/block/bio.c
index 30df1b45dde8..1eaf31976702 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1657,7 +1657,7 @@ struct bio *bio_copy_kern(struct request_queue *q, void *data, unsigned int len,
 		if (bytes > len)
 			bytes = len;
 
-		page = alloc_page(q->bounce_gfp | gfp_mask);
+		page = alloc_page(q->bounce_gfp | __GFP_ZERO | gfp_mask);
 		if (!page)
 			goto cleanup;
 
diff --git a/drivers/acpi/sysfs.c b/drivers/acpi/sysfs.c
index 3b7e23866b42..63e4aa468ad6 100644
--- a/drivers/acpi/sysfs.c
+++ b/drivers/acpi/sysfs.c
@@ -436,18 +436,29 @@ static ssize_t acpi_data_show(struct file *filp, struct kobject *kobj,
 {
 	struct acpi_data_attr *data_attr;
 	void __iomem *base;
-	ssize_t rc;
+	ssize_t size;
 
 	data_attr = container_of(bin_attr, struct acpi_data_attr, attr);
+	size = data_attr->attr.size;
+
+	if (offset < 0)
+		return -EINVAL;
+
+	if (offset >= size)
+		return 0;
 
-	base = acpi_os_map_memory(data_attr->addr, data_attr->attr.size);
+	if (count > size - offset)
+		count = size - offset;
+
+	base = acpi_os_map_iomem(data_attr->addr, size);
 	if (!base)
 		return -ENOMEM;
-	rc = memory_read_from_buffer(buf, count, &offset, base,
-				     data_attr->attr.size);
-	acpi_os_unmap_memory(base, data_attr->attr.size);
 
-	return rc;
+	memcpy_fromio(buf, base + offset, count);
+
+	acpi_os_unmap_iomem(base, size);
+
+	return count;
 }
 
 static int acpi_bert_data_init(void *th, struct acpi_data_attr *data_attr)
diff --git a/drivers/char/tpm/tpm_ibmvtpm.c b/drivers/char/tpm/tpm_ibmvtpm.c
index 3ba67bc6baba..80647eb071fd 100644
--- a/drivers/char/tpm/tpm_ibmvtpm.c
+++ b/drivers/char/tpm/tpm_ibmvtpm.c
@@ -692,6 +692,7 @@ static int tpm_ibmvtpm_probe(struct vio_dev *vio_dev,
 	if (!wait_event_timeout(ibmvtpm->crq_queue.wq,
 				ibmvtpm->rtce_buf != NULL,
 				HZ)) {
+		rc = -ENODEV;
 		dev_err(dev, "CRQ response timed out\n");
 		goto init_irq_cleanup;
 	}
diff --git a/drivers/gpu/drm/i915/intel_pm.c b/drivers/gpu/drm/i915/intel_pm.c
index 087634693346..dfee112d9e89 100644
--- a/drivers/gpu/drm/i915/intel_pm.c
+++ b/drivers/gpu/drm/i915/intel_pm.c
@@ -2793,7 +2793,7 @@ hsw_compute_linetime_wm(const struct intel_crtc_state *cstate)
 }
 
 static void intel_read_wm_latency(struct drm_i915_private *dev_priv,
-				  uint16_t wm[8])
+				  uint16_t wm[])
 {
 	if (INTEL_GEN(dev_priv) >= 9) {
 		uint32_t val;
diff --git a/drivers/i2c/busses/i2c-thunderx-pcidrv.c b/drivers/i2c/busses/i2c-thunderx-pcidrv.c
index df0976f4432a..4f0456fe8691 100644
--- a/drivers/i2c/busses/i2c-thunderx-pcidrv.c
+++ b/drivers/i2c/busses/i2c-thunderx-pcidrv.c
@@ -215,6 +215,7 @@ static int thunder_i2c_probe_pci(struct pci_dev *pdev,
 	i2c->adap.bus_recovery_info = &octeon_i2c_recovery_info;
 	i2c->adap.dev.parent = dev;
 	i2c->adap.dev.of_node = pdev->dev.of_node;
+	i2c->adap.dev.fwnode = dev->fwnode;
 	snprintf(i2c->adap.name, sizeof(i2c->adap.name),
 		 "Cavium ThunderX i2c adapter at %s", dev_name(dev));
 	i2c_set_adapdata(&i2c->adap, i2c);
diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 0b6d4337aaab..353536ad46f3 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -2942,6 +2942,11 @@ static int crypt_map(struct dm_target *ti, struct bio *bio)
 	return DM_MAPIO_SUBMITTED;
 }
 
+static char hex2asc(unsigned char c)
+{
+	return c + '0' + ((unsigned)(9 - c) >> 4 & 0x27);
+}
+
 static void crypt_status(struct dm_target *ti, status_type_t type,
 			 unsigned status_flags, char *result, unsigned maxlen)
 {
@@ -2960,9 +2965,12 @@ static void crypt_status(struct dm_target *ti, status_type_t type,
 		if (cc->key_size > 0) {
 			if (cc->key_string)
 				DMEMIT(":%u:%s", cc->key_size, cc->key_string);
-			else
-				for (i = 0; i < cc->key_size; i++)
-					DMEMIT("%02x", cc->key[i]);
+			else {
+				for (i = 0; i < cc->key_size; i++) {
+					DMEMIT("%c%c", hex2asc(cc->key[i] >> 4),
+					       hex2asc(cc->key[i] & 0xf));
+				}
+			}
 		} else
 			DMEMIT("-");
 
diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index b6ca5b1100db..6579aa46f544 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -3156,8 +3156,6 @@ static int dm_integrity_ctr(struct dm_target *ti, unsigned argc, char **argv)
 	}
 
 	if (should_write_sb) {
-		int r;
-
 		init_journal(ic, 0, ic->journal_sections, 0);
 		r = dm_integrity_failed(ic);
 		if (unlikely(r)) {
diff --git a/drivers/md/dm-stats.c b/drivers/md/dm-stats.c
index a7868503d135..9734f506ecfd 100644
--- a/drivers/md/dm-stats.c
+++ b/drivers/md/dm-stats.c
@@ -224,6 +224,7 @@ void dm_stats_cleanup(struct dm_stats *stats)
 				       atomic_read(&shared->in_flight[READ]),
 				       atomic_read(&shared->in_flight[WRITE]));
 			}
+			cond_resched();
 		}
 		dm_stat_free(&s->rcu_head);
 	}
@@ -312,6 +313,7 @@ static int dm_stats_create(struct dm_stats *stats, sector_t start, sector_t end,
 	for (ni = 0; ni < n_entries; ni++) {
 		atomic_set(&s->stat_shared[ni].in_flight[READ], 0);
 		atomic_set(&s->stat_shared[ni].in_flight[WRITE], 0);
+		cond_resched();
 	}
 
 	if (s->n_histogram_entries) {
@@ -324,6 +326,7 @@ static int dm_stats_create(struct dm_stats *stats, sector_t start, sector_t end,
 		for (ni = 0; ni < n_entries; ni++) {
 			s->stat_shared[ni].tmp.histogram = hi;
 			hi += s->n_histogram_entries + 1;
+			cond_resched();
 		}
 	}
 
@@ -344,6 +347,7 @@ static int dm_stats_create(struct dm_stats *stats, sector_t start, sector_t end,
 			for (ni = 0; ni < n_entries; ni++) {
 				p[ni].histogram = hi;
 				hi += s->n_histogram_entries + 1;
+				cond_resched();
 			}
 		}
 	}
@@ -473,6 +477,7 @@ static int dm_stats_list(struct dm_stats *stats, const char *program,
 			}
 			DMEMIT("\n");
 		}
+		cond_resched();
 	}
 	mutex_unlock(&stats->mutex);
 
@@ -749,6 +754,7 @@ static void __dm_stat_clear(struct dm_stat *s, size_t idx_start, size_t idx_end,
 				local_irq_enable();
 			}
 		}
+		cond_resched();
 	}
 }
 
@@ -864,6 +870,8 @@ static int dm_stats_print(struct dm_stats *stats, int id,
 
 		if (unlikely(sz + 1 >= maxlen))
 			goto buffer_overflow;
+
+		cond_resched();
 	}
 
 	if (clear)
diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index 2dae30713eb3..77fca0432d25 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -1163,6 +1163,7 @@ static int verity_ctr(struct dm_target *ti, unsigned argc, char **argv)
 
 static struct target_type verity_target = {
 	.name		= "verity",
+	.features	= DM_TARGET_IMMUTABLE,
 	.version	= {1, 3, 0},
 	.module		= THIS_MODULE,
 	.ctr		= verity_ctr,
diff --git a/drivers/net/ethernet/faraday/ftgmac100.c b/drivers/net/ethernet/faraday/ftgmac100.c
index f35c5dbe54ee..a1caca6accf3 100644
--- a/drivers/net/ethernet/faraday/ftgmac100.c
+++ b/drivers/net/ethernet/faraday/ftgmac100.c
@@ -1845,6 +1845,11 @@ static int ftgmac100_probe(struct platform_device *pdev)
 	/* AST2400  doesn't have working HW checksum generation */
 	if (np && (of_device_is_compatible(np, "aspeed,ast2400-mac")))
 		netdev->hw_features &= ~NETIF_F_HW_CSUM;
+
+	/* AST2600 tx checksum with NCSI is broken */
+	if (priv->use_ncsi && of_device_is_compatible(np, "aspeed,ast2600-mac"))
+		netdev->hw_features &= ~NETIF_F_HW_CSUM;
+
 	if (np && of_get_property(np, "no-hw-checksum", NULL))
 		netdev->hw_features &= ~(NETIF_F_HW_CSUM | NETIF_F_RXCSUM);
 	netdev->features |= netdev->hw_features;
diff --git a/drivers/staging/rtl8723bs/os_dep/ioctl_linux.c b/drivers/staging/rtl8723bs/os_dep/ioctl_linux.c
index d51f6c452972..5afe958a9b4f 100644
--- a/drivers/staging/rtl8723bs/os_dep/ioctl_linux.c
+++ b/drivers/staging/rtl8723bs/os_dep/ioctl_linux.c
@@ -1438,9 +1438,11 @@ static int rtw_wx_set_scan(struct net_device *dev, struct iw_request_info *a,
 
 					sec_len = *(pos++); len-= 1;
 
-					if (sec_len>0 && sec_len<=len) {
+					if (sec_len > 0 &&
+					    sec_len <= len &&
+					    sec_len <= 32) {
 						ssid[ssid_index].SsidLength = sec_len;
-						memcpy(ssid[ssid_index].Ssid, pos, ssid[ssid_index].SsidLength);
+						memcpy(ssid[ssid_index].Ssid, pos, sec_len);
 						/* DBG_871X("%s COMBO_SCAN with specific ssid:%s, %d\n", __func__ */
 						/* 	, ssid[ssid_index].Ssid, ssid[ssid_index].SsidLength); */
 						ssid_index++;
diff --git a/fs/exec.c b/fs/exec.c
index c72ccfa49f54..2e26ba4ff47e 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1788,6 +1788,9 @@ static int do_execveat_common(int fd, struct filename *filename,
 		goto out_unmark;
 
 	bprm->argc = count(argv, MAX_ARG_STRINGS);
+	if (bprm->argc == 0)
+		pr_warn_once("process '%s' launched '%s' with NULL argv: empty string added\n",
+			     current->comm, bprm->filename);
 	if ((retval = bprm->argc) < 0)
 		goto out;
 
@@ -1812,6 +1815,20 @@ static int do_execveat_common(int fd, struct filename *filename,
 	if (retval < 0)
 		goto out;
 
+	/*
+	 * When argv is empty, add an empty string ("") as argv[0] to
+	 * ensure confused userspace programs that start processing
+	 * from argv[1] won't end up walking envp. See also
+	 * bprm_stack_limits().
+	 */
+	if (bprm->argc == 0) {
+		const char *argv[] = { "", NULL };
+		retval = copy_strings_kernel(1, argv, bprm);
+		if (retval < 0)
+			goto out;
+		bprm->argc = 1;
+	}
+
 	retval = exec_binprm(bprm);
 	if (retval < 0)
 		goto out;
diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 6720c82ac351..2adbf471d107 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -6351,16 +6351,12 @@ nfsd4_release_lockowner(struct svc_rqst *rqstp,
 		if (sop->so_is_open_owner || !same_owner_str(sop, owner))
 			continue;
 
-		/* see if there are still any locks associated with it */
-		lo = lockowner(sop);
-		list_for_each_entry(stp, &sop->so_stateids, st_perstateowner) {
-			if (check_for_locks(stp->st_stid.sc_file, lo)) {
-				status = nfserr_locks_held;
-				spin_unlock(&clp->cl_lock);
-				return status;
-			}
+		if (atomic_read(&sop->so_count) != 1) {
+			spin_unlock(&clp->cl_lock);
+			return nfserr_locks_held;
 		}
 
+		lo = lockowner(sop);
 		nfs4_get_stateowner(sop);
 		break;
 	}
diff --git a/include/net/inet_hashtables.h b/include/net/inet_hashtables.h
index e5f4d2711404..e079478bf5c9 100644
--- a/include/net/inet_hashtables.h
+++ b/include/net/inet_hashtables.h
@@ -390,7 +390,7 @@ static inline void sk_rcv_saddr_set(struct sock *sk, __be32 addr)
 }
 
 int __inet_hash_connect(struct inet_timewait_death_row *death_row,
-			struct sock *sk, u32 port_offset,
+			struct sock *sk, u64 port_offset,
 			int (*check_established)(struct inet_timewait_death_row *,
 						 struct sock *, __u16,
 						 struct inet_timewait_sock **));
diff --git a/include/net/netfilter/nf_conntrack_core.h b/include/net/netfilter/nf_conntrack_core.h
index 9b5e7634713e..1bbedb75de71 100644
--- a/include/net/netfilter/nf_conntrack_core.h
+++ b/include/net/netfilter/nf_conntrack_core.h
@@ -67,8 +67,13 @@ static inline int nf_conntrack_confirm(struct sk_buff *skb)
 	int ret = NF_ACCEPT;
 
 	if (ct) {
-		if (!nf_ct_is_confirmed(ct))
+		if (!nf_ct_is_confirmed(ct)) {
 			ret = __nf_conntrack_confirm(skb);
+
+			if (ret == NF_ACCEPT)
+				ct = (struct nf_conn *)skb_nfct(skb);
+		}
+
 		if (likely(ret == NF_ACCEPT))
 			nf_ct_deliver_cached_events(ct);
 	}
diff --git a/include/net/secure_seq.h b/include/net/secure_seq.h
index d7d2495f83c2..dac91aa38c5a 100644
--- a/include/net/secure_seq.h
+++ b/include/net/secure_seq.h
@@ -4,8 +4,8 @@
 
 #include <linux/types.h>
 
-u32 secure_ipv4_port_ephemeral(__be32 saddr, __be32 daddr, __be16 dport);
-u32 secure_ipv6_port_ephemeral(const __be32 *saddr, const __be32 *daddr,
+u64 secure_ipv4_port_ephemeral(__be32 saddr, __be32 daddr, __be16 dport);
+u64 secure_ipv6_port_ephemeral(const __be32 *saddr, const __be32 *daddr,
 			       __be16 dport);
 u32 secure_tcp_seq(__be32 saddr, __be32 daddr,
 		   __be16 sport, __be16 dport);
diff --git a/lib/assoc_array.c b/lib/assoc_array.c
index 9463d3445ccd..b40edebd5123 100644
--- a/lib/assoc_array.c
+++ b/lib/assoc_array.c
@@ -1478,6 +1478,7 @@ int assoc_array_gc(struct assoc_array *array,
 	struct assoc_array_ptr *cursor, *ptr;
 	struct assoc_array_ptr *new_root, *new_parent, **new_ptr_pp;
 	unsigned long nr_leaves_on_tree;
+	bool retained;
 	int keylen, slot, nr_free, next_slot, i;
 
 	pr_devel("-->%s()\n", __func__);
@@ -1554,6 +1555,7 @@ int assoc_array_gc(struct assoc_array *array,
 		goto descend;
 	}
 
+retry_compress:
 	pr_devel("-- compress node %p --\n", new_n);
 
 	/* Count up the number of empty slots in this node and work out the
@@ -1571,6 +1573,7 @@ int assoc_array_gc(struct assoc_array *array,
 	pr_devel("free=%d, leaves=%lu\n", nr_free, new_n->nr_leaves_on_branch);
 
 	/* See what we can fold in */
+	retained = false;
 	next_slot = 0;
 	for (slot = 0; slot < ASSOC_ARRAY_FAN_OUT; slot++) {
 		struct assoc_array_shortcut *s;
@@ -1620,9 +1623,14 @@ int assoc_array_gc(struct assoc_array *array,
 			pr_devel("[%d] retain node %lu/%d [nx %d]\n",
 				 slot, child->nr_leaves_on_branch, nr_free + 1,
 				 next_slot);
+			retained = true;
 		}
 	}
 
+	if (retained && new_n->nr_leaves_on_branch <= ASSOC_ARRAY_FAN_OUT) {
+		pr_devel("internal nodes remain despite enough space, retrying\n");
+		goto retry_compress;
+	}
 	pr_devel("after: %lu\n", new_n->nr_leaves_on_branch);
 
 	nr_leaves_on_tree = new_n->nr_leaves_on_branch;
diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index 6cdb49ae0001..fd706edd66ff 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -952,11 +952,40 @@ static void reset_page(struct page *page)
  */
 void lock_zspage(struct zspage *zspage)
 {
-	struct page *page = get_first_page(zspage);
+	struct page *curr_page, *page;
 
-	do {
-		lock_page(page);
-	} while ((page = get_next_page(page)) != NULL);
+	/*
+	 * Pages we haven't locked yet can be migrated off the list while we're
+	 * trying to lock them, so we need to be careful and only attempt to
+	 * lock each page under migrate_read_lock(). Otherwise, the page we lock
+	 * may no longer belong to the zspage. This means that we may wait for
+	 * the wrong page to unlock, so we must take a reference to the page
+	 * prior to waiting for it to unlock outside migrate_read_lock().
+	 */
+	while (1) {
+		migrate_read_lock(zspage);
+		page = get_first_page(zspage);
+		if (trylock_page(page))
+			break;
+		get_page(page);
+		migrate_read_unlock(zspage);
+		wait_on_page_locked(page);
+		put_page(page);
+	}
+
+	curr_page = page;
+	while ((page = get_next_page(curr_page))) {
+		if (trylock_page(page)) {
+			curr_page = page;
+		} else {
+			get_page(page);
+			migrate_read_unlock(zspage);
+			wait_on_page_locked(page);
+			put_page(page);
+			migrate_read_lock(zspage);
+		}
+	}
+	migrate_read_unlock(zspage);
 }
 
 int trylock_zspage(struct zspage *zspage)
diff --git a/net/core/filter.c b/net/core/filter.c
index 9b934767a1d8..afe27343051f 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -1443,7 +1443,7 @@ BPF_CALL_5(bpf_skb_store_bytes, struct sk_buff *, skb, u32, offset,
 
 	if (unlikely(flags & ~(BPF_F_RECOMPUTE_CSUM | BPF_F_INVALIDATE_HASH)))
 		return -EINVAL;
-	if (unlikely(offset > 0xffff))
+	if (unlikely(offset > INT_MAX))
 		return -EFAULT;
 	if (unlikely(bpf_try_make_writable(skb, offset + len)))
 		return -EFAULT;
@@ -1478,7 +1478,7 @@ BPF_CALL_4(bpf_skb_load_bytes, const struct sk_buff *, skb, u32, offset,
 {
 	void *ptr;
 
-	if (unlikely(offset > 0xffff))
+	if (unlikely(offset > INT_MAX))
 		goto err_clear;
 
 	ptr = skb_header_pointer(skb, offset, len, to);
diff --git a/net/core/secure_seq.c b/net/core/secure_seq.c
index 17683aea8a35..4aaae9220908 100644
--- a/net/core/secure_seq.c
+++ b/net/core/secure_seq.c
@@ -96,7 +96,7 @@ u32 secure_tcpv6_seq(const __be32 *saddr, const __be32 *daddr,
 }
 EXPORT_SYMBOL(secure_tcpv6_seq);
 
-u32 secure_ipv6_port_ephemeral(const __be32 *saddr, const __be32 *daddr,
+u64 secure_ipv6_port_ephemeral(const __be32 *saddr, const __be32 *daddr,
 			       __be16 dport)
 {
 	const struct {
@@ -145,7 +145,7 @@ u32 secure_tcp_seq(__be32 saddr, __be32 daddr,
 	return seq_scale(hash);
 }
 
-u32 secure_ipv4_port_ephemeral(__be32 saddr, __be32 daddr, __be16 dport)
+u64 secure_ipv4_port_ephemeral(__be32 saddr, __be32 daddr, __be16 dport)
 {
 	net_secret_init();
 	return siphash_4u32((__force u32)saddr, (__force u32)daddr,
diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index 1346e45cf8d1..1ebad5a024a7 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -389,7 +389,7 @@ static int __inet_check_established(struct inet_timewait_death_row *death_row,
 	return -EADDRNOTAVAIL;
 }
 
-static u32 inet_sk_port_offset(const struct sock *sk)
+static u64 inet_sk_port_offset(const struct sock *sk)
 {
 	const struct inet_sock *inet = inet_sk(sk);
 
@@ -587,8 +587,19 @@ void inet_unhash(struct sock *sk)
 }
 EXPORT_SYMBOL_GPL(inet_unhash);
 
+/* RFC 6056 3.3.4.  Algorithm 4: Double-Hash Port Selection Algorithm
+ * Note that we use 32bit integers (vs RFC 'short integers')
+ * because 2^16 is not a multiple of num_ephemeral and this
+ * property might be used by clever attacker.
+ * RFC claims using TABLE_LENGTH=10 buckets gives an improvement,
+ * we use 256 instead to really give more isolation and
+ * privacy, this only consumes 1 KB of kernel memory.
+ */
+#define INET_TABLE_PERTURB_SHIFT 8
+static u32 table_perturb[1 << INET_TABLE_PERTURB_SHIFT];
+
 int __inet_hash_connect(struct inet_timewait_death_row *death_row,
-		struct sock *sk, u32 port_offset,
+		struct sock *sk, u64 port_offset,
 		int (*check_established)(struct inet_timewait_death_row *,
 			struct sock *, __u16, struct inet_timewait_sock **))
 {
@@ -600,7 +611,7 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
 	struct inet_bind_bucket *tb;
 	u32 remaining, offset;
 	int ret, i, low, high;
-	static u32 hint;
+	u32 index;
 
 	if (port) {
 		head = &hinfo->bhash[inet_bhashfn(net, port,
@@ -625,7 +636,12 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
 	if (likely(remaining > 1))
 		remaining &= ~1U;
 
-	offset = (hint + port_offset) % remaining;
+	net_get_random_once(table_perturb, sizeof(table_perturb));
+	index = hash_32(port_offset, INET_TABLE_PERTURB_SHIFT);
+
+	offset = READ_ONCE(table_perturb[index]) + port_offset;
+	offset %= remaining;
+
 	/* In first pass we try ports of @low parity.
 	 * inet_csk_get_port() does the opposite choice.
 	 */
@@ -678,7 +694,7 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
 	return -EADDRNOTAVAIL;
 
 ok:
-	hint += i + 2;
+	WRITE_ONCE(table_perturb[index], READ_ONCE(table_perturb[index]) + i + 2);
 
 	/* Head lock still held and bh's disabled */
 	inet_bind_hash(sk, tb, port);
@@ -701,7 +717,7 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
 int inet_hash_connect(struct inet_timewait_death_row *death_row,
 		      struct sock *sk)
 {
-	u32 port_offset = 0;
+	u64 port_offset = 0;
 
 	if (!inet_sk(sk)->inet_num)
 		port_offset = inet_sk_port_offset(sk);
diff --git a/net/ipv6/inet6_hashtables.c b/net/ipv6/inet6_hashtables.c
index 24a21979d7df..7d83ab627b09 100644
--- a/net/ipv6/inet6_hashtables.c
+++ b/net/ipv6/inet6_hashtables.c
@@ -248,7 +248,7 @@ static int __inet6_check_established(struct inet_timewait_death_row *death_row,
 	return -EADDRNOTAVAIL;
 }
 
-static u32 inet6_sk_port_offset(const struct sock *sk)
+static u64 inet6_sk_port_offset(const struct sock *sk)
 {
 	const struct inet_sock *inet = inet_sk(sk);
 
@@ -260,7 +260,7 @@ static u32 inet6_sk_port_offset(const struct sock *sk)
 int inet6_hash_connect(struct inet_timewait_death_row *death_row,
 		       struct sock *sk)
 {
-	u32 port_offset = 0;
+	u64 port_offset = 0;
 
 	if (!inet_sk(sk)->inet_num)
 		port_offset = inet6_sk_port_offset(sk);
diff --git a/net/key/af_key.c b/net/key/af_key.c
index 3d5a46080169..990de0702b79 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -2908,7 +2908,7 @@ static int count_ah_combs(const struct xfrm_tmpl *t)
 			break;
 		if (!aalg->pfkey_supported)
 			continue;
-		if (aalg_tmpl_set(t, aalg))
+		if (aalg_tmpl_set(t, aalg) && aalg->available)
 			sz += sizeof(struct sadb_comb);
 	}
 	return sz + sizeof(struct sadb_prop);
@@ -2926,7 +2926,7 @@ static int count_esp_combs(const struct xfrm_tmpl *t)
 		if (!ealg->pfkey_supported)
 			continue;
 
-		if (!(ealg_tmpl_set(t, ealg)))
+		if (!(ealg_tmpl_set(t, ealg) && ealg->available))
 			continue;
 
 		for (k = 1; ; k++) {
@@ -2937,7 +2937,7 @@ static int count_esp_combs(const struct xfrm_tmpl *t)
 			if (!aalg->pfkey_supported)
 				continue;
 
-			if (aalg_tmpl_set(t, aalg))
+			if (aalg_tmpl_set(t, aalg) && aalg->available)
 				sz += sizeof(struct sadb_comb);
 		}
 	}
