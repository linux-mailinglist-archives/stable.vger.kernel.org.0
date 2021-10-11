Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E734A428F91
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 15:58:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237933AbhJKN7d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 09:59:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:49584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237300AbhJKN5s (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 09:57:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F0CE361164;
        Mon, 11 Oct 2021 13:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960464;
        bh=QbMR3sUc9zdTCVfFasbTeaKdU0gHHMXBsZM9tdEX+rA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ePSX9E+5vnaF6OJZSVe9cqPWMVebB5CXiocMGzdXq45ghm7E6CjqGUHh1DfQWhNgh
         lfe2mZEuSzG9Drw7xnaKYsbhkCq72RpA9sP9dyijTFZUIv7hQsdxxWL40n48idwlEm
         kAwUfeDs/pqdMbxkKmoll820+OglvrUVy3giQwnU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        PJ Waskiewicz <pwaskiewicz@jumptrading.com>,
        Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>,
        Mateusz Palczewski <mateusz.palczewski@intel.com>,
        Dave Switzer <david.switzer@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 65/83] i40e: Fix freeing of uninitialized misc IRQ vector
Date:   Mon, 11 Oct 2021 15:46:25 +0200
Message-Id: <20211011134510.624165923@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134508.362906295@linuxfoundation.org>
References: <20211011134508.362906295@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>

[ Upstream commit 2e5a20573a926302b233b0c2e1077f5debc7ab2e ]

When VSI set up failed in i40e_probe() as part of PF switch set up
driver was trying to free misc IRQ vectors in
i40e_clear_interrupt_scheme and produced a kernel Oops:

   Trying to free already-free IRQ 266
   WARNING: CPU: 0 PID: 5 at kernel/irq/manage.c:1731 __free_irq+0x9a/0x300
   Workqueue: events work_for_cpu_fn
   RIP: 0010:__free_irq+0x9a/0x300
   Call Trace:
   ? synchronize_irq+0x3a/0xa0
   free_irq+0x2e/0x60
   i40e_clear_interrupt_scheme+0x53/0x190 [i40e]
   i40e_probe.part.108+0x134b/0x1a40 [i40e]
   ? kmem_cache_alloc+0x158/0x1c0
   ? acpi_ut_update_ref_count.part.1+0x8e/0x345
   ? acpi_ut_update_object_reference+0x15e/0x1e2
   ? strstr+0x21/0x70
   ? irq_get_irq_data+0xa/0x20
   ? mp_check_pin_attr+0x13/0xc0
   ? irq_get_irq_data+0xa/0x20
   ? mp_map_pin_to_irq+0xd3/0x2f0
   ? acpi_register_gsi_ioapic+0x93/0x170
   ? pci_conf1_read+0xa4/0x100
   ? pci_bus_read_config_word+0x49/0x70
   ? do_pci_enable_device+0xcc/0x100
   local_pci_probe+0x41/0x90
   work_for_cpu_fn+0x16/0x20
   process_one_work+0x1a7/0x360
   worker_thread+0x1cf/0x390
   ? create_worker+0x1a0/0x1a0
   kthread+0x112/0x130
   ? kthread_flush_work_fn+0x10/0x10
   ret_from_fork+0x1f/0x40

The problem is that at that point misc IRQ vectors
were not allocated yet and we get a call trace
that driver is trying to free already free IRQ vectors.

Add a check in i40e_clear_interrupt_scheme for __I40E_MISC_IRQ_REQUESTED
PF state before calling i40e_free_misc_vector. This state is set only if
misc IRQ vectors were properly initialized.

Fixes: c17401a1dd21 ("i40e: use separate state bit for miscellaneous IRQ setup")
Reported-by: PJ Waskiewicz <pwaskiewicz@jumptrading.com>
Signed-off-by: Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>
Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
Tested-by: Dave Switzer <david.switzer@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 0a1eea0846e6..52c2d6fdeb7a 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -4839,7 +4839,8 @@ static void i40e_clear_interrupt_scheme(struct i40e_pf *pf)
 {
 	int i;
 
-	i40e_free_misc_vector(pf);
+	if (test_bit(__I40E_MISC_IRQ_REQUESTED, pf->state))
+		i40e_free_misc_vector(pf);
 
 	i40e_put_lump(pf->irq_pile, pf->iwarp_base_vector,
 		      I40E_IWARP_IRQ_PILE_ID);
-- 
2.33.0



