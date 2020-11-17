Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82B8B2B61DA
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:23:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731231AbgKQNXD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:23:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:57616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731228AbgKQNXC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:23:02 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 412CE20781;
        Tue, 17 Nov 2020 13:23:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619381;
        bh=xwxz8r5FtmajNpC87PJfKNuW9ZOvDS/QdVyOUkgyzgA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DZtx0nOkvb955q7RUiHxxe4pd4S4CkxCWHK6pejFkT06SI13S+1t89NaQz+gMGFk6
         SUk4poUxIC4a3vDbNt+BOWn7iDeS/GTThwPwhpv18c0sAdkU5xkJrqNcq/eDItqd+D
         OTRIb+SgnNMNXb9F876UeOoSE/se0AduEnurQtxE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qian Cai <cai@redhat.com>,
        Oliver OHalloran <oohall@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 020/151] powerpc/eeh_cache: Fix a possible debugfs deadlock
Date:   Tue, 17 Nov 2020 14:04:10 +0100
Message-Id: <20201117122122.388656201@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122121.381905960@linuxfoundation.org>
References: <20201117122121.381905960@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qian Cai <cai@redhat.com>

[ Upstream commit fd552e0542b4532483289cce48fdbd27b692984b ]

Lockdep complains that a possible deadlock below in
eeh_addr_cache_show() because it is acquiring a lock with IRQ enabled,
but eeh_addr_cache_insert_dev() needs to acquire the same lock with IRQ
disabled. Let's just make eeh_addr_cache_show() acquire the lock with
IRQ disabled as well.

        CPU0                    CPU1
        ----                    ----
   lock(&pci_io_addr_cache_root.piar_lock);
                                local_irq_disable();
                                lock(&tp->lock);
                                lock(&pci_io_addr_cache_root.piar_lock);
   <Interrupt>
     lock(&tp->lock);

  *** DEADLOCK ***

  lock_acquire+0x140/0x5f0
  _raw_spin_lock_irqsave+0x64/0xb0
  eeh_addr_cache_insert_dev+0x48/0x390
  eeh_probe_device+0xb8/0x1a0
  pnv_pcibios_bus_add_device+0x3c/0x80
  pcibios_bus_add_device+0x118/0x290
  pci_bus_add_device+0x28/0xe0
  pci_bus_add_devices+0x54/0xb0
  pcibios_init+0xc4/0x124
  do_one_initcall+0xac/0x528
  kernel_init_freeable+0x35c/0x3fc
  kernel_init+0x24/0x148
  ret_from_kernel_thread+0x5c/0x80

  lock_acquire+0x140/0x5f0
  _raw_spin_lock+0x4c/0x70
  eeh_addr_cache_show+0x38/0x110
  seq_read+0x1a0/0x660
  vfs_read+0xc8/0x1f0
  ksys_read+0x74/0x130
  system_call_exception+0xf8/0x1d0
  system_call_common+0xe8/0x218

Fixes: 5ca85ae6318d ("powerpc/eeh_cache: Add a way to dump the EEH address cache")
Signed-off-by: Qian Cai <cai@redhat.com>
Reviewed-by: Oliver O'Halloran <oohall@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20201028152717.8967-1-cai@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/eeh_cache.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kernel/eeh_cache.c b/arch/powerpc/kernel/eeh_cache.c
index cf11277ebd020..000ebb5a6fb3c 100644
--- a/arch/powerpc/kernel/eeh_cache.c
+++ b/arch/powerpc/kernel/eeh_cache.c
@@ -272,8 +272,9 @@ static int eeh_addr_cache_show(struct seq_file *s, void *v)
 {
 	struct pci_io_addr_range *piar;
 	struct rb_node *n;
+	unsigned long flags;
 
-	spin_lock(&pci_io_addr_cache_root.piar_lock);
+	spin_lock_irqsave(&pci_io_addr_cache_root.piar_lock, flags);
 	for (n = rb_first(&pci_io_addr_cache_root.rb_root); n; n = rb_next(n)) {
 		piar = rb_entry(n, struct pci_io_addr_range, rb_node);
 
@@ -281,7 +282,7 @@ static int eeh_addr_cache_show(struct seq_file *s, void *v)
 		       (piar->flags & IORESOURCE_IO) ? "i/o" : "mem",
 		       &piar->addr_lo, &piar->addr_hi, pci_name(piar->pcidev));
 	}
-	spin_unlock(&pci_io_addr_cache_root.piar_lock);
+	spin_unlock_irqrestore(&pci_io_addr_cache_root.piar_lock, flags);
 
 	return 0;
 }
-- 
2.27.0



