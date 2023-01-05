Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D545D65EBDF
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 14:04:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233954AbjAENDo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Jan 2023 08:03:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234158AbjAENDS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Jan 2023 08:03:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 687135AC69
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 05:03:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ED942619FF
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 13:03:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0BFBC433D2;
        Thu,  5 Jan 2023 13:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672923796;
        bh=m8TGsAWOSBY6vCVu5akm/OT09nAGnWoim/XOLJGESB0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bzD/rfRBaLL8ddge3p+wx9NW044TeEL2O4hckSWUB+4dE0sgfl6Y88skMhPsN6ZG5
         rkv77jTaXY6L4g8wphi0O/42Fya8mzAEMOPhhWRXSjn/xoPBaxhg2INv2FHy74DA4h
         19QDUqK490EIfptm/1fdapJOz4yhbT/YsNRWF1T8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zheng Wang <zyytlz.wz@163.com>,
        Dimitri Sivanich <sivanich@hpe.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 136/251] misc: sgi-gru: fix use-after-free error in gru_set_context_option, gru_fault and gru_handle_user_call_os
Date:   Thu,  5 Jan 2023 13:54:33 +0100
Message-Id: <20230105125341.057473277@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230105125334.727282894@linuxfoundation.org>
References: <20230105125334.727282894@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zheng Wang <zyytlz.wz@163.com>

[ Upstream commit 643a16a0eb1d6ac23744bb6e90a00fc21148a9dc ]

In some bad situation, the gts may be freed gru_check_chiplet_assignment.
The call chain can be gru_unload_context->gru_free_gru_context->gts_drop
and kfree finally. However, the caller didn't know if the gts is freed
or not and use it afterwards. This will trigger a Use after Free bug.

Fix it by introducing a return value to see if it's in error path or not.
Free the gts in caller if gru_check_chiplet_assignment check failed.

Fixes: 55484c45dbec ("gru: allow users to specify gru chiplet 2")
Signed-off-by: Zheng Wang <zyytlz.wz@163.com>
Acked-by: Dimitri Sivanich <sivanich@hpe.com>
Link: https://lore.kernel.org/r/20221110035033.19498-1-zyytlz.wz@163.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/sgi-gru/grufault.c  | 13 +++++++++++--
 drivers/misc/sgi-gru/grumain.c   | 22 ++++++++++++++++++----
 drivers/misc/sgi-gru/grutables.h |  2 +-
 3 files changed, 30 insertions(+), 7 deletions(-)

diff --git a/drivers/misc/sgi-gru/grufault.c b/drivers/misc/sgi-gru/grufault.c
index 6fb773dbcd0c..a43a496ca9b9 100644
--- a/drivers/misc/sgi-gru/grufault.c
+++ b/drivers/misc/sgi-gru/grufault.c
@@ -656,6 +656,7 @@ int gru_handle_user_call_os(unsigned long cb)
 	if ((cb & (GRU_HANDLE_STRIDE - 1)) || ucbnum >= GRU_NUM_CB)
 		return -EINVAL;
 
+again:
 	gts = gru_find_lock_gts(cb);
 	if (!gts)
 		return -EINVAL;
@@ -664,7 +665,11 @@ int gru_handle_user_call_os(unsigned long cb)
 	if (ucbnum >= gts->ts_cbr_au_count * GRU_CBR_AU_SIZE)
 		goto exit;
 
-	gru_check_context_placement(gts);
+	if (gru_check_context_placement(gts)) {
+		gru_unlock_gts(gts);
+		gru_unload_context(gts, 1);
+		goto again;
+	}
 
 	/*
 	 * CCH may contain stale data if ts_force_cch_reload is set.
@@ -882,7 +887,11 @@ int gru_set_context_option(unsigned long arg)
 		} else {
 			gts->ts_user_blade_id = req.val1;
 			gts->ts_user_chiplet_id = req.val0;
-			gru_check_context_placement(gts);
+			if (gru_check_context_placement(gts)) {
+				gru_unlock_gts(gts);
+				gru_unload_context(gts, 1);
+				return ret;
+			}
 		}
 		break;
 	case sco_gseg_owner:
diff --git a/drivers/misc/sgi-gru/grumain.c b/drivers/misc/sgi-gru/grumain.c
index 33741ad4a74a..bc2d5233660c 100644
--- a/drivers/misc/sgi-gru/grumain.c
+++ b/drivers/misc/sgi-gru/grumain.c
@@ -729,9 +729,10 @@ static int gru_check_chiplet_assignment(struct gru_state *gru,
  * chiplet. Misassignment can occur if the process migrates to a different
  * blade or if the user changes the selected blade/chiplet.
  */
-void gru_check_context_placement(struct gru_thread_state *gts)
+int gru_check_context_placement(struct gru_thread_state *gts)
 {
 	struct gru_state *gru;
+	int ret = 0;
 
 	/*
 	 * If the current task is the context owner, verify that the
@@ -739,15 +740,23 @@ void gru_check_context_placement(struct gru_thread_state *gts)
 	 * references. Pthread apps use non-owner references to the CBRs.
 	 */
 	gru = gts->ts_gru;
+	/*
+	 * If gru or gts->ts_tgid_owner isn't initialized properly, return
+	 * success to indicate that the caller does not need to unload the
+	 * gru context.The caller is responsible for their inspection and
+	 * reinitialization if needed.
+	 */
 	if (!gru || gts->ts_tgid_owner != current->tgid)
-		return;
+		return ret;
 
 	if (!gru_check_chiplet_assignment(gru, gts)) {
 		STAT(check_context_unload);
-		gru_unload_context(gts, 1);
+		ret = -EINVAL;
 	} else if (gru_retarget_intr(gts)) {
 		STAT(check_context_retarget_intr);
 	}
+
+	return ret;
 }
 
 
@@ -946,7 +955,12 @@ int gru_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 	mutex_lock(&gts->ts_ctxlock);
 	preempt_disable();
 
-	gru_check_context_placement(gts);
+	if (gru_check_context_placement(gts)) {
+		preempt_enable();
+		mutex_unlock(&gts->ts_ctxlock);
+		gru_unload_context(gts, 1);
+		return VM_FAULT_NOPAGE;
+	}
 
 	if (!gts->ts_gru) {
 		STAT(load_user_context);
diff --git a/drivers/misc/sgi-gru/grutables.h b/drivers/misc/sgi-gru/grutables.h
index 5c3ce2459675..a1dfca557fc3 100644
--- a/drivers/misc/sgi-gru/grutables.h
+++ b/drivers/misc/sgi-gru/grutables.h
@@ -651,7 +651,7 @@ extern int gru_user_flush_tlb(unsigned long arg);
 extern int gru_user_unload_context(unsigned long arg);
 extern int gru_get_exception_detail(unsigned long arg);
 extern int gru_set_context_option(unsigned long address);
-extern void gru_check_context_placement(struct gru_thread_state *gts);
+extern int gru_check_context_placement(struct gru_thread_state *gts);
 extern int gru_cpu_fault_map_id(void);
 extern struct vm_area_struct *gru_find_vma(unsigned long vaddr);
 extern void gru_flush_all_tlb(struct gru_state *gru);
-- 
2.35.1



