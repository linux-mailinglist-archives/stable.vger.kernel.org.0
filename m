Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEDAA4121B5
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:07:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346079AbhITSIZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:08:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:60428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1358299AbhITSGN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:06:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2D7D963249;
        Mon, 20 Sep 2021 17:17:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158273;
        bh=FYYmUAcosH6wJTlRB+8qa2A7eYG5KleotZPuCN4eOfY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EWdIpWyjlVaLrUCXPB+7nI1T8wG5U4GtlonUE4Il8kc6ZcSRzgIWcCe2oRT+X4DoY
         /II33Wz7Pk01lm/kCJI7duxzLqn8VbrbDCG0EAlK3KQq2ZEuYQd3jUXA8Foq2XTozr
         oK+B1qgDPnkoNWHRWN16IGt6tOl5eJYG1965UQLg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Assmann <sassmann@kpanic.de>,
        Konrad Jankowski <konrad0.jankowski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 079/260] iavf: do not override the adapter state in the watchdog task
Date:   Mon, 20 Sep 2021 18:41:37 +0200
Message-Id: <20210920163933.821894148@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163931.123590023@linuxfoundation.org>
References: <20210920163931.123590023@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Assmann <sassmann@kpanic.de>

[ Upstream commit 22c8fd71d3a5e6fe584ccc2c1e8760e5baefd5aa ]

The iavf watchdog task overrides adapter->state to __IAVF_RESETTING
when it detects a pending reset. Then schedules iavf_reset_task() which
takes care of the reset.

The reset task is capable of handling the reset without changing
adapter->state. In fact we lose the state information when the watchdog
task prematurely changes the adapter state. This may lead to a crash if
instead of the reset task the iavf_remove() function gets called before
the reset task.
In that case (if we were in state __IAVF_RUNNING previously) the
iavf_remove() function triggers iavf_close() which fails to close the
device because of the incorrect state information.

This may result in a crash due to pending interrupts.
kernel BUG at drivers/pci/msi.c:357!
[...]
Call Trace:
 [<ffffffffbddf24dd>] pci_disable_msix+0x3d/0x50
 [<ffffffffc08d2a63>] iavf_reset_interrupt_capability+0x23/0x40 [iavf]
 [<ffffffffc08d312a>] iavf_remove+0x10a/0x350 [iavf]
 [<ffffffffbddd3359>] pci_device_remove+0x39/0xc0
 [<ffffffffbdeb492f>] __device_release_driver+0x7f/0xf0
 [<ffffffffbdeb49c3>] device_release_driver+0x23/0x30
 [<ffffffffbddcabb4>] pci_stop_bus_device+0x84/0xa0
 [<ffffffffbddcacc2>] pci_stop_and_remove_bus_device+0x12/0x20
 [<ffffffffbddf361f>] pci_iov_remove_virtfn+0xaf/0x160
 [<ffffffffbddf3bcc>] sriov_disable+0x3c/0xf0
 [<ffffffffbddf3ca3>] pci_disable_sriov+0x23/0x30
 [<ffffffffc0667365>] i40e_free_vfs+0x265/0x2d0 [i40e]
 [<ffffffffc0667624>] i40e_pci_sriov_configure+0x144/0x1f0 [i40e]
 [<ffffffffbddd5307>] sriov_numvfs_store+0x177/0x1d0
Code: 00 00 e8 3c 25 e3 ff 49 c7 86 88 08 00 00 00 00 00 00 5b 41 5c 41 5d 41 5e 41 5f 5d c3 48 8b 7b 28 e8 0d 44
RIP  [<ffffffffbbbf1068>] free_msi_irqs+0x188/0x190

The solution is to not touch the adapter->state in iavf_watchdog_task()
and let the reset task handle the state transition.

Signed-off-by: Stefan Assmann <sassmann@kpanic.de>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 94a3f000e999..3e76111af872 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -1961,7 +1961,6 @@ static void iavf_watchdog_task(struct work_struct *work)
 		/* check for hw reset */
 	reg_val = rd32(hw, IAVF_VF_ARQLEN1) & IAVF_VF_ARQLEN1_ARQENABLE_MASK;
 	if (!reg_val) {
-		adapter->state = __IAVF_RESETTING;
 		adapter->flags |= IAVF_FLAG_RESET_PENDING;
 		adapter->aq_required = 0;
 		adapter->current_op = VIRTCHNL_OP_UNKNOWN;
-- 
2.30.2



