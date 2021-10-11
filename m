Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B427429106
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 16:13:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237451AbhJKOO6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:14:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:35126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239779AbhJKOM5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 10:12:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 867EC611C2;
        Mon, 11 Oct 2021 14:03:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633961034;
        bh=i4KSlN2BJLnXvM1TLetSR1zb2SE69fE3rg4S2qP9WGI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wQK+l2n6ZIper7RV7zMs/uhl0G/FBnX1UTv7dkw8QKYd7JMhKy+z/eL53U9JGAAGB
         KuauGjbJkm+BB6e+A1TUUBeY8u8KZcuiU7cus8JvI+zk2SHSaI/VILg38l723ttsC9
         UssKl8hBNzFXJNaLQeIy9wsqYv85QFqawol6ZKZw=
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
Subject: [PATCH 5.14 115/151] i40e: Fix freeing of uninitialized misc IRQ vector
Date:   Mon, 11 Oct 2021 15:46:27 +0200
Message-Id: <20211011134521.534772209@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134517.833565002@linuxfoundation.org>
References: <20211011134517.833565002@linuxfoundation.org>
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
index 772dd05a0ae8..5d3d6b1dae7b 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -4868,7 +4868,8 @@ static void i40e_clear_interrupt_scheme(struct i40e_pf *pf)
 {
 	int i;
 
-	i40e_free_misc_vector(pf);
+	if (test_bit(__I40E_MISC_IRQ_REQUESTED, pf->state))
+		i40e_free_misc_vector(pf);
 
 	i40e_put_lump(pf->irq_pile, pf->iwarp_base_vector,
 		      I40E_IWARP_IRQ_PILE_ID);
-- 
2.33.0



