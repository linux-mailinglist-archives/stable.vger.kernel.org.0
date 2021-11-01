Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90B364418B7
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:49:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234437AbhKAJut (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:50:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:52288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234732AbhKAJss (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:48:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 79840610E8;
        Mon,  1 Nov 2021 09:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635759075;
        bh=BrOIcfZkfakfLm2U32HmhYXzwiyAaowKAZcqcGPr2uU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KgawaKnxC74rlfwCDkK0tsbk+oqDOhSFLZuLwClXTU4IwmFUHd6q9LHltA2n4aO0V
         0+pM02L32NFS98t5EQz6qeOXQgrT0WGmShylZoz5wdLMND6+9qpLrjQEom/78BFOP7
         xCdbqKU5PCAuiyvATXUk/ykNldlMSLiToZPMXWfU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yongxin Liu <yongxin.liu@windriver.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Gurucharan G <gurucharanx.g@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 5.14 072/125] ice: check whether PTP is initialized in ice_ptp_release()
Date:   Mon,  1 Nov 2021 10:17:25 +0100
Message-Id: <20211101082546.836982281@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082533.618411490@linuxfoundation.org>
References: <20211101082533.618411490@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yongxin Liu <yongxin.liu@windriver.com>

commit fd1b5beb177a8372cea2a0d014835491e4886f77 upstream.

PTP is currently only supported on E810 devices, it is checked
in ice_ptp_init(). However, there is no check in ice_ptp_release().
For other E800 series devices, ice_ptp_release() will be wrongly executed.

Fix the following calltrace.

  INFO: trying to register non-static key.
  The code is fine but needs lockdep annotation, or maybe
  you didn't initialize this object before use?
  turning off the locking correctness validator.
  Workqueue: ice ice_service_task [ice]
  Call Trace:
   dump_stack_lvl+0x5b/0x82
   dump_stack+0x10/0x12
   register_lock_class+0x495/0x4a0
   ? find_held_lock+0x3c/0xb0
   __lock_acquire+0x71/0x1830
   lock_acquire+0x1e6/0x330
   ? ice_ptp_release+0x3c/0x1e0 [ice]
   ? _raw_spin_lock+0x19/0x70
   ? ice_ptp_release+0x3c/0x1e0 [ice]
   _raw_spin_lock+0x38/0x70
   ? ice_ptp_release+0x3c/0x1e0 [ice]
   ice_ptp_release+0x3c/0x1e0 [ice]
   ice_prepare_for_reset+0xcb/0xe0 [ice]
   ice_do_reset+0x38/0x110 [ice]
   ice_service_task+0x138/0xf10 [ice]
   ? __this_cpu_preempt_check+0x13/0x20
   process_one_work+0x26a/0x650
   worker_thread+0x3f/0x3b0
   ? __kthread_parkme+0x51/0xb0
   ? process_one_work+0x650/0x650
   kthread+0x161/0x190
   ? set_kthread_struct+0x40/0x40
   ret_from_fork+0x1f/0x30

Fixes: 4dd0d5c33c3e ("ice: add lock around Tx timestamp tracker flush")
Signed-off-by: Yongxin Liu <yongxin.liu@windriver.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/ice/ice_ptp.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/ethernet/intel/ice/ice_ptp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
@@ -1582,6 +1582,9 @@ err_kworker:
  */
 void ice_ptp_release(struct ice_pf *pf)
 {
+	if (!test_bit(ICE_FLAG_PTP, pf->flags))
+		return;
+
 	/* Disable timestamping for both Tx and Rx */
 	ice_ptp_cfg_timestamp(pf, false);
 


