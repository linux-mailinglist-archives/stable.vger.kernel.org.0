Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BD853E394C
	for <lists+stable@lfdr.de>; Sun,  8 Aug 2021 09:15:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230360AbhHHHPs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Aug 2021 03:15:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:49066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229504AbhHHHPs (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 8 Aug 2021 03:15:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 688FC60F02;
        Sun,  8 Aug 2021 07:15:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628406929;
        bh=+Qpn6n+ukOpYrJIQbD4dOo8gjEMMsIbunGOn2Y4f4SA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AwHYo6clzMrc0KgMozFbSAh8gWN5p4VwPy6Ryth1of4PRMB8LSYjX5OUAm+oYzcBu
         B0ml0gHNrchKWpbRpbihyaxsT0zOLFGTpm10masKlRTFGxEYz+wVPwy667GE2ufIep
         5AWaIT4VEwJGs2kAf8vkVGjfCYVImBRPMy9/XkJ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 4.14.243
Date:   Sun,  8 Aug 2021 09:15:19 +0200
Message-Id: <162840691812352@kroah.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <1628406918121186@kroah.com>
References: <1628406918121186@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index 0179c3c463b3..c0664d65f9ef 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 4
 PATCHLEVEL = 14
-SUBLEVEL = 242
+SUBLEVEL = 243
 EXTRAVERSION =
 NAME = Petit Gorille
 
diff --git a/drivers/net/ethernet/qlogic/qed/qed_mcp.c b/drivers/net/ethernet/qlogic/qed/qed_mcp.c
index ef17ca09d303..789ecc19c412 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_mcp.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_mcp.c
@@ -497,14 +497,18 @@ _qed_mcp_cmd_and_union(struct qed_hwfn *p_hwfn,
 
 		spin_lock_bh(&p_hwfn->mcp_info->cmd_lock);
 
-		if (!qed_mcp_has_pending_cmd(p_hwfn))
+		if (!qed_mcp_has_pending_cmd(p_hwfn)) {
+			spin_unlock_bh(&p_hwfn->mcp_info->cmd_lock);
 			break;
+		}
 
 		rc = qed_mcp_update_pending_cmd(p_hwfn, p_ptt);
-		if (!rc)
+		if (!rc) {
+			spin_unlock_bh(&p_hwfn->mcp_info->cmd_lock);
 			break;
-		else if (rc != -EAGAIN)
+		} else if (rc != -EAGAIN) {
 			goto err;
+		}
 
 		spin_unlock_bh(&p_hwfn->mcp_info->cmd_lock);
 
@@ -521,6 +525,8 @@ _qed_mcp_cmd_and_union(struct qed_hwfn *p_hwfn,
 		return -EAGAIN;
 	}
 
+	spin_lock_bh(&p_hwfn->mcp_info->cmd_lock);
+
 	/* Send the mailbox command */
 	qed_mcp_reread_offsets(p_hwfn, p_ptt);
 	seq_num = ++p_hwfn->mcp_info->drv_mb_seq;
@@ -547,14 +553,18 @@ _qed_mcp_cmd_and_union(struct qed_hwfn *p_hwfn,
 
 		spin_lock_bh(&p_hwfn->mcp_info->cmd_lock);
 
-		if (p_cmd_elem->b_is_completed)
+		if (p_cmd_elem->b_is_completed) {
+			spin_unlock_bh(&p_hwfn->mcp_info->cmd_lock);
 			break;
+		}
 
 		rc = qed_mcp_update_pending_cmd(p_hwfn, p_ptt);
-		if (!rc)
+		if (!rc) {
+			spin_unlock_bh(&p_hwfn->mcp_info->cmd_lock);
 			break;
-		else if (rc != -EAGAIN)
+		} else if (rc != -EAGAIN) {
 			goto err;
+		}
 
 		spin_unlock_bh(&p_hwfn->mcp_info->cmd_lock);
 	} while (++cnt < max_retries);
@@ -575,6 +585,7 @@ _qed_mcp_cmd_and_union(struct qed_hwfn *p_hwfn,
 		return -EAGAIN;
 	}
 
+	spin_lock_bh(&p_hwfn->mcp_info->cmd_lock);
 	qed_mcp_cmd_del_elem(p_hwfn, p_cmd_elem);
 	spin_unlock_bh(&p_hwfn->mcp_info->cmd_lock);
 
diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 8da3c891c9e8..a5a4fef09b93 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -3953,9 +3953,10 @@ static int rtl8152_close(struct net_device *netdev)
 		tp->rtl_ops.down(tp);
 
 		mutex_unlock(&tp->control);
+	}
 
+	if (!res)
 		usb_autopm_put_interface(tp->intf);
-	}
 
 	free_all_mem(tp);
 
diff --git a/drivers/spi/spi-mt65xx.c b/drivers/spi/spi-mt65xx.c
index e2b171057b3b..690e8ddf5f6b 100644
--- a/drivers/spi/spi-mt65xx.c
+++ b/drivers/spi/spi-mt65xx.c
@@ -391,24 +391,15 @@ static int mtk_spi_fifo_transfer(struct spi_master *master,
 	mtk_spi_prepare_transfer(master, xfer);
 	mtk_spi_setup_packet(master);
 
-	cnt = xfer->len / 4;
-	if (xfer->tx_buf)
+	if (xfer->tx_buf) {
+		cnt = xfer->len / 4;
 		iowrite32_rep(mdata->base + SPI_TX_DATA_REG, xfer->tx_buf, cnt);
-
-	if (xfer->rx_buf)
-		ioread32_rep(mdata->base + SPI_RX_DATA_REG, xfer->rx_buf, cnt);
-
-	remainder = xfer->len % 4;
-	if (remainder > 0) {
-		reg_val = 0;
-		if (xfer->tx_buf) {
+		remainder = xfer->len % 4;
+		if (remainder > 0) {
+			reg_val = 0;
 			memcpy(&reg_val, xfer->tx_buf + (cnt * 4), remainder);
 			writel(reg_val, mdata->base + SPI_TX_DATA_REG);
 		}
-		if (xfer->rx_buf) {
-			reg_val = readl(mdata->base + SPI_RX_DATA_REG);
-			memcpy(xfer->rx_buf + (cnt * 4), &reg_val, remainder);
-		}
 	}
 
 	mtk_spi_enable_transfer(master);
diff --git a/drivers/watchdog/iTCO_wdt.c b/drivers/watchdog/iTCO_wdt.c
index 059c9eddb546..347f0389b089 100644
--- a/drivers/watchdog/iTCO_wdt.c
+++ b/drivers/watchdog/iTCO_wdt.c
@@ -75,8 +75,6 @@
 #define TCOBASE(p)	((p)->tco_res->start)
 /* SMI Control and Enable Register */
 #define SMI_EN(p)	((p)->smi_res->start)
-#define TCO_EN		(1 << 13)
-#define GBL_SMI_EN	(1 << 0)
 
 #define TCO_RLD(p)	(TCOBASE(p) + 0x00) /* TCO Timer Reload/Curr. Value */
 #define TCOv1_TMR(p)	(TCOBASE(p) + 0x01) /* TCOv1 Timer Initial Value*/
@@ -332,12 +330,8 @@ static int iTCO_wdt_set_timeout(struct watchdog_device *wd_dev, unsigned int t)
 
 	tmrval = seconds_to_ticks(p, t);
 
-	/*
-	 * If TCO SMIs are off, the timer counts down twice before rebooting.
-	 * Otherwise, the BIOS generally reboots when the SMI triggers.
-	 */
-	if (p->smi_res &&
-	    (SMI_EN(p) & (TCO_EN | GBL_SMI_EN)) != (TCO_EN | GBL_SMI_EN))
+	/* For TCO v1 the timer counts down twice before rebooting */
+	if (p->iTCO_version == 1)
 		tmrval /= 2;
 
 	/* from the specs: */
@@ -499,7 +493,7 @@ static int iTCO_wdt_probe(struct platform_device *pdev)
 		 * Disables TCO logic generating an SMI#
 		 */
 		val32 = inl(SMI_EN(p));
-		val32 &= ~TCO_EN;	/* Turn off SMI clearing watchdog */
+		val32 &= 0xffffdfff;	/* Turn off SMI clearing watchdog */
 		outl(val32, SMI_EN(p));
 	}
 
diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index ccd9c709375e..24341c97c13f 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -286,7 +286,7 @@ static void end_compressed_bio_write(struct bio *bio)
 					 cb->start,
 					 cb->start + cb->len - 1,
 					 NULL,
-					 bio->bi_status ? 0 : 1);
+					 !cb->errors);
 	cb->compressed_pages[0]->mapping = NULL;
 
 	end_compressed_writeback(inode, cb);
diff --git a/include/linux/mfd/rt5033-private.h b/include/linux/mfd/rt5033-private.h
index 1b63fc2f42d1..52d53d134f72 100644
--- a/include/linux/mfd/rt5033-private.h
+++ b/include/linux/mfd/rt5033-private.h
@@ -203,13 +203,13 @@ enum rt5033_reg {
 #define RT5033_REGULATOR_BUCK_VOLTAGE_MIN		1000000U
 #define RT5033_REGULATOR_BUCK_VOLTAGE_MAX		3000000U
 #define RT5033_REGULATOR_BUCK_VOLTAGE_STEP		100000U
-#define RT5033_REGULATOR_BUCK_VOLTAGE_STEP_NUM		32
+#define RT5033_REGULATOR_BUCK_VOLTAGE_STEP_NUM		21
 
 /* RT5033 regulator LDO output voltage uV */
 #define RT5033_REGULATOR_LDO_VOLTAGE_MIN		1200000U
 #define RT5033_REGULATOR_LDO_VOLTAGE_MAX		3000000U
 #define RT5033_REGULATOR_LDO_VOLTAGE_STEP		100000U
-#define RT5033_REGULATOR_LDO_VOLTAGE_STEP_NUM		32
+#define RT5033_REGULATOR_LDO_VOLTAGE_STEP_NUM		19
 
 /* RT5033 regulator SAFE LDO output voltage uV */
 #define RT5033_REGULATOR_SAFE_LDO_VOLTAGE		4900000U
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 0958dbdd2906..ba5c899d1edf 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -1569,6 +1569,14 @@ int hci_dev_do_close(struct hci_dev *hdev)
 
 	BT_DBG("%s %p", hdev->name, hdev);
 
+	if (!hci_dev_test_flag(hdev, HCI_UNREGISTER) &&
+	    !hci_dev_test_flag(hdev, HCI_USER_CHANNEL) &&
+	    test_bit(HCI_UP, &hdev->flags)) {
+		/* Execute vendor specific shutdown routine */
+		if (hdev->shutdown)
+			hdev->shutdown(hdev);
+	}
+
 	cancel_delayed_work(&hdev->power_off);
 
 	hci_request_cancel_all(hdev);
@@ -1636,14 +1644,6 @@ int hci_dev_do_close(struct hci_dev *hdev)
 		clear_bit(HCI_INIT, &hdev->flags);
 	}
 
-	if (!hci_dev_test_flag(hdev, HCI_UNREGISTER) &&
-	    !hci_dev_test_flag(hdev, HCI_USER_CHANNEL) &&
-	    test_bit(HCI_UP, &hdev->flags)) {
-		/* Execute vendor specific shutdown routine */
-		if (hdev->shutdown)
-			hdev->shutdown(hdev);
-	}
-
 	/* flush cmd  work */
 	flush_work(&hdev->cmd_work);
 
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 18dc8524e525..a278258e68cb 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -2702,8 +2702,11 @@ skb_zerocopy_headlen(const struct sk_buff *from)
 
 	if (!from->head_frag ||
 	    skb_headlen(from) < L1_CACHE_BYTES ||
-	    skb_shinfo(from)->nr_frags >= MAX_SKB_FRAGS)
+	    skb_shinfo(from)->nr_frags >= MAX_SKB_FRAGS) {
 		hlen = skb_headlen(from);
+		if (!hlen)
+			hlen = from->len;
+	}
 
 	if (skb_has_frag_list(from))
 		hlen = from->len;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 547ae59199db..36b9f2b29071 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1485,15 +1485,24 @@ static bool vma_is_valid(struct vm_area_struct *vma, bool write_fault)
 	return true;
 }
 
+static int kvm_try_get_pfn(kvm_pfn_t pfn)
+{
+	if (kvm_is_reserved_pfn(pfn))
+		return 1;
+	return get_page_unless_zero(pfn_to_page(pfn));
+}
+
 static int hva_to_pfn_remapped(struct vm_area_struct *vma,
 			       unsigned long addr, bool *async,
 			       bool write_fault, bool *writable,
 			       kvm_pfn_t *p_pfn)
 {
-	unsigned long pfn;
+	kvm_pfn_t pfn;
+	pte_t *ptep;
+	spinlock_t *ptl;
 	int r;
 
-	r = follow_pfn(vma, addr, &pfn);
+	r = follow_pte_pmd(vma->vm_mm, addr, NULL, NULL, &ptep, NULL, &ptl);
 	if (r) {
 		/*
 		 * get_user_pages fails for VM_IO and VM_PFNMAP vmas and does
@@ -1508,14 +1517,19 @@ static int hva_to_pfn_remapped(struct vm_area_struct *vma,
 		if (r)
 			return r;
 
-		r = follow_pfn(vma, addr, &pfn);
+		r = follow_pte_pmd(vma->vm_mm, addr, NULL, NULL, &ptep, NULL, &ptl);
 		if (r)
 			return r;
+	}
 
+	if (write_fault && !pte_write(*ptep)) {
+		pfn = KVM_PFN_ERR_RO_FAULT;
+		goto out;
 	}
 
 	if (writable)
-		*writable = true;
+		*writable = pte_write(*ptep);
+	pfn = pte_pfn(*ptep);
 
 	/*
 	 * Get a reference here because callers of *hva_to_pfn* and
@@ -1527,11 +1541,21 @@ static int hva_to_pfn_remapped(struct vm_area_struct *vma,
 	 * Whoever called remap_pfn_range is also going to call e.g.
 	 * unmap_mapping_range before the underlying pages are freed,
 	 * causing a call to our MMU notifier.
+	 *
+	 * Certain IO or PFNMAP mappings can be backed with valid
+	 * struct pages, but be allocated without refcounting e.g.,
+	 * tail pages of non-compound higher order allocations, which
+	 * would then underflow the refcount when the caller does the
+	 * required put_page. Don't allow those pages here.
 	 */ 
-	kvm_get_pfn(pfn);
+	if (!kvm_try_get_pfn(pfn))
+		r = -EFAULT;
 
+out:
+	pte_unmap_unlock(ptep, ptl);
 	*p_pfn = pfn;
-	return 0;
+
+	return r;
 }
 
 /*
