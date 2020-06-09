Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DF4C1F2E76
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:42:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727813AbgFIAlz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 20:41:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:60204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727992AbgFHXMh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:12:37 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DB33D208C3;
        Mon,  8 Jun 2020 23:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657956;
        bh=TriZ2AXZWfUqYLeoauSonlhvCHyMp9LqIaolwBUV8xM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r0mWaxnkswdbj4ELd00SsmJxMU7+isZTU1NKtgkKdBvd+gM1WxErJJGYfXj4n2qBH
         546ZBYmeonNuyVnsqTsslaEunwQMOsgJz9jYNqiEcTF2pfz+vVH42UNuJi1vIljaQ3
         7XU7NFZG9an7BGgvAIF98pTIqOqHJMeCsNo0cufA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Christoph Hellwig <hch@lst.de>,
        Hillf Danton <hdanton@sina.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jeremy Linton <jeremy.linton@arm.com>,
        syzbot+353be47c9ce21b68b7ed@syzkaller.appspotmail.com,
        linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 021/606] USB: usbfs: fix mmap dma mismatch
Date:   Mon,  8 Jun 2020 19:02:26 -0400
Message-Id: <20200608231211.3363633-21-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit a0e710a7def471b8eb779ff551fc27701da49599 upstream.

In commit 2bef9aed6f0e ("usb: usbfs: correct kernel->user page attribute
mismatch") we switched from always calling remap_pfn_range() to call
dma_mmap_coherent() to handle issues with systems with non-coherent USB host
controller drivers.  Unfortunatly, as syzbot quickly told us, not all the world
is host controllers with DMA support, so we need to check what host controller
we are attempting to talk to before doing this type of allocation.

Thanks to Christoph for the quick idea of how to fix this.

Fixes: 2bef9aed6f0e ("usb: usbfs: correct kernel->user page attribute mismatch")
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Jeremy Linton <jeremy.linton@arm.com>
Cc: stable <stable@vger.kernel.org>
Reported-by: syzbot+353be47c9ce21b68b7ed@syzkaller.appspotmail.com
Reviewed-by: Jeremy Linton <jeremy.linton@arm.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20200514112711.1858252-1-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/devio.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
index b9db9812d6c5..d93d94d7ff50 100644
--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -251,9 +251,19 @@ static int usbdev_mmap(struct file *file, struct vm_area_struct *vma)
 	usbm->vma_use_count = 1;
 	INIT_LIST_HEAD(&usbm->memlist);
 
-	if (dma_mmap_coherent(hcd->self.sysdev, vma, mem, dma_handle, size)) {
-		dec_usb_memory_use_count(usbm, &usbm->vma_use_count);
-		return -EAGAIN;
+	if (hcd->localmem_pool || !hcd_uses_dma(hcd)) {
+		if (remap_pfn_range(vma, vma->vm_start,
+				    virt_to_phys(usbm->mem) >> PAGE_SHIFT,
+				    size, vma->vm_page_prot) < 0) {
+			dec_usb_memory_use_count(usbm, &usbm->vma_use_count);
+			return -EAGAIN;
+		}
+	} else {
+		if (dma_mmap_coherent(hcd->self.sysdev, vma, mem, dma_handle,
+				      size)) {
+			dec_usb_memory_use_count(usbm, &usbm->vma_use_count);
+			return -EAGAIN;
+		}
 	}
 
 	vma->vm_flags |= VM_IO;
-- 
2.25.1

