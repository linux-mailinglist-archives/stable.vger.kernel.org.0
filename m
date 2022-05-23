Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 801A9531821
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:53:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240626AbiEWRcb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:32:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241645AbiEWR04 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:26:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25B938AE48;
        Mon, 23 May 2022 10:22:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B1AC0B80FF4;
        Mon, 23 May 2022 17:20:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1387DC385AA;
        Mon, 23 May 2022 17:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653326442;
        bh=Jp8whgaOG+SNcEazAWN5Wo37zx2wduu0qsJXCRd8VhE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2MevLPd+6sqJ+DAGx8J3CJjXRwebZFWM7LbJitaNPEjjdC4NAv+NH5W2KbT6mgjmK
         GFY0o2wNvfyy8BjWUQTTlsTkR6y7VkbL3uufpvmUVkG5hLmdn5fZ9ZkBh0Mxt8ZwFb
         5p1ADdm54XTLC4FAe5l82GoKbSZEIadpXAfKZTg4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Michal Schmidt <mschmidt@redhat.com>,
        Dave Cain <dcain@redhat.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        Gurucharan <gurucharanx.g@intel.com>
Subject: [PATCH 5.15 083/132] ice: fix crash when writing timestamp on RX rings
Date:   Mon, 23 May 2022 19:04:52 +0200
Message-Id: <20220523165836.880950264@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165823.492309987@linuxfoundation.org>
References: <20220523165823.492309987@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>

[ Upstream commit 4503cc7fdf9a84cd631b0cb8ecb3c9b1bdbf3594 ]

Do not allow to write timestamps on RX rings if PF is being configured.
When PF is being configured RX rings can be freed or rebuilt. If at the
same time timestamps are updated, the kernel will crash by dereferencing
null RX ring pointer.

PID: 1449   TASK: ff187d28ed658040  CPU: 34  COMMAND: "ice-ptp-0000:51"
 #0 [ff1966a94a713bb0] machine_kexec at ffffffff9d05a0be
 #1 [ff1966a94a713c08] __crash_kexec at ffffffff9d192e9d
 #2 [ff1966a94a713cd0] crash_kexec at ffffffff9d1941bd
 #3 [ff1966a94a713ce8] oops_end at ffffffff9d01bd54
 #4 [ff1966a94a713d08] no_context at ffffffff9d06bda4
 #5 [ff1966a94a713d60] __bad_area_nosemaphore at ffffffff9d06c10c
 #6 [ff1966a94a713da8] do_page_fault at ffffffff9d06cae4
 #7 [ff1966a94a713de0] page_fault at ffffffff9da0107e
    [exception RIP: ice_ptp_update_cached_phctime+91]
    RIP: ffffffffc076db8b  RSP: ff1966a94a713e98  RFLAGS: 00010246
    RAX: 16e3db9c6b7ccae4  RBX: ff187d269dd3c180  RCX: ff187d269cd4d018
    RDX: 0000000000000000  RSI: 0000000000000000  RDI: 0000000000000000
    RBP: ff187d269cfcc644   R8: ff187d339b9641b0   R9: 0000000000000000
    R10: 0000000000000002  R11: 0000000000000000  R12: ff187d269cfcc648
    R13: ffffffff9f128784  R14: ffffffff9d101b70  R15: ff187d269cfcc640
    ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
 #8 [ff1966a94a713ea0] ice_ptp_periodic_work at ffffffffc076dbef [ice]
 #9 [ff1966a94a713ee0] kthread_worker_fn at ffffffff9d101c1b
 #10 [ff1966a94a713f10] kthread at ffffffff9d101b4d
 #11 [ff1966a94a713f50] ret_from_fork at ffffffff9da0023f

Fixes: 77a781155a65 ("ice: enable receive hardware timestamping")
Signed-off-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Reviewed-by: Michal Schmidt <mschmidt@redhat.com>
Tested-by: Dave Cain <dcain@redhat.com>
Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_ptp.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c b/drivers/net/ethernet/intel/ice/ice_ptp.c
index ef26ff351b57..9b50e9e6042a 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
@@ -254,12 +254,19 @@ ice_ptp_read_src_clk_reg(struct ice_pf *pf, struct ptp_system_timestamp *sts)
  * This function must be called periodically to ensure that the cached value
  * is never more than 2 seconds old. It must also be called whenever the PHC
  * time has been changed.
+ *
+ * Return:
+ * * 0 - OK, successfully updated
+ * * -EAGAIN - PF was busy, need to reschedule the update
  */
-static void ice_ptp_update_cached_phctime(struct ice_pf *pf)
+static int ice_ptp_update_cached_phctime(struct ice_pf *pf)
 {
 	u64 systime;
 	int i;
 
+	if (test_and_set_bit(ICE_CFG_BUSY, pf->state))
+		return -EAGAIN;
+
 	/* Read the current PHC time */
 	systime = ice_ptp_read_src_clk_reg(pf, NULL);
 
@@ -282,6 +289,9 @@ static void ice_ptp_update_cached_phctime(struct ice_pf *pf)
 			WRITE_ONCE(vsi->rx_rings[j]->cached_phctime, systime);
 		}
 	}
+	clear_bit(ICE_CFG_BUSY, pf->state);
+
+	return 0;
 }
 
 /**
@@ -1418,17 +1428,18 @@ static void ice_ptp_periodic_work(struct kthread_work *work)
 {
 	struct ice_ptp *ptp = container_of(work, struct ice_ptp, work.work);
 	struct ice_pf *pf = container_of(ptp, struct ice_pf, ptp);
+	int err;
 
 	if (!test_bit(ICE_FLAG_PTP, pf->flags))
 		return;
 
-	ice_ptp_update_cached_phctime(pf);
+	err = ice_ptp_update_cached_phctime(pf);
 
 	ice_ptp_tx_tstamp_cleanup(&pf->hw, &pf->ptp.port.tx);
 
-	/* Run twice a second */
+	/* Run twice a second or reschedule if phc update failed */
 	kthread_queue_delayed_work(ptp->kworker, &ptp->work,
-				   msecs_to_jiffies(500));
+				   msecs_to_jiffies(err ? 10 : 500));
 }
 
 /**
-- 
2.35.1



