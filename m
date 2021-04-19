Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F57E3643B3
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:32:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240741AbhDSNVV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:21:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:56922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241138AbhDSNUA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:20:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E524B613C8;
        Mon, 19 Apr 2021 13:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618838138;
        bh=PALgB/1MrAnn6euMR3cmtML76YPFfxyh+J25fa1rfVs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I9LQn9ymVD7T467Y1240bHMa0yPRw1QsItKXrF+eaf3Rma1y7RQVMe8wk6LZDCLz2
         bpN1U946pxqFAcZ64HtAAFI3oUwvXY9bJ0mbYK+7gJcG40ULxl/0EKtEsexIUupeDO
         Su+wVwxZ7k/iuEZTqcbgy5rn7QDE7p0TX6v9SslE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yongxin Liu <yongxin.liu@windriver.com>,
        Dave Switzer <david.switzer@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 5.10 057/103] ixgbe: fix unbalanced device enable/disable in suspend/resume
Date:   Mon, 19 Apr 2021 15:06:08 +0200
Message-Id: <20210419130529.769492964@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210419130527.791982064@linuxfoundation.org>
References: <20210419130527.791982064@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yongxin Liu <yongxin.liu@windriver.com>

commit debb9df311582c83fe369baa35fa4b92e8a9c58a upstream.

pci_disable_device() called in __ixgbe_shutdown() decreases
dev->enable_cnt by 1. pci_enable_device_mem() which increases
dev->enable_cnt by 1, was removed from ixgbe_resume() in commit
6f82b2558735 ("ixgbe: use generic power management"). This caused
unbalanced increase/decrease. So add pci_enable_device_mem() back.

Fix the following call trace.

  ixgbe 0000:17:00.1: disabling already-disabled device
  Call Trace:
   __ixgbe_shutdown+0x10a/0x1e0 [ixgbe]
   ixgbe_suspend+0x32/0x70 [ixgbe]
   pci_pm_suspend+0x87/0x160
   ? pci_pm_freeze+0xd0/0xd0
   dpm_run_callback+0x42/0x170
   __device_suspend+0x114/0x460
   async_suspend+0x1f/0xa0
   async_run_entry_fn+0x3c/0xf0
   process_one_work+0x1dd/0x410
   worker_thread+0x34/0x3f0
   ? cancel_delayed_work+0x90/0x90
   kthread+0x14c/0x170
   ? kthread_park+0x90/0x90
   ret_from_fork+0x1f/0x30

Fixes: 6f82b2558735 ("ixgbe: use generic power management")
Signed-off-by: Yongxin Liu <yongxin.liu@windriver.com>
Tested-by: Dave Switzer <david.switzer@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -6896,6 +6896,11 @@ static int __maybe_unused ixgbe_resume(s
 
 	adapter->hw.hw_addr = adapter->io_addr;
 
+	err = pci_enable_device_mem(pdev);
+	if (err) {
+		e_dev_err("Cannot enable PCI device from suspend\n");
+		return err;
+	}
 	smp_mb__before_atomic();
 	clear_bit(__IXGBE_DISABLED, &adapter->state);
 	pci_set_master(pdev);


