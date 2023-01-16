Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B671866C7BA
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:34:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233262AbjAPQeD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:34:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233357AbjAPQdT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:33:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 540F5252B7
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:21:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D0B87B80DC7
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:21:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25865C433F0;
        Mon, 16 Jan 2023 16:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673886080;
        bh=TMxhKFrXqUF3HEV1YnV6M8gBMc+QwYFUjpXua3wevuM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m5sq4LhZJt2w+PLWD1iV98Dy5lDIGw4/kABEfyv8PjICmS0S5vL3574vy2YJRBpkF
         HevRKWvnx5wjUe/pkfY9hfhkb1Bo4GajrEQZo6+c4lNvQ6ryz8cAn7PREG0GIAeQlI
         TOndePlFoiU0eTDvqQ6xdJXjicuig/lRbOQ9i040=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zheng Wang <zyytlz.wz@163.com>,
        Dimitri Sivanich <sivanich@hpe.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 295/658] misc: sgi-gru: fix use-after-free error in gru_set_context_option, gru_fault and gru_handle_user_call_os
Date:   Mon, 16 Jan 2023 16:46:23 +0100
Message-Id: <20230116154923.102183604@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
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
index 4b713a80b572..7f26a78bb403 100644
--- a/drivers/misc/sgi-gru/grufault.c
+++ b/drivers/misc/sgi-gru/grufault.c
@@ -648,6 +648,7 @@ int gru_handle_user_call_os(unsigned long cb)
 	if ((cb & (GRU_HANDLE_STRIDE - 1)) || ucbnum >= GRU_NUM_CB)
 		return -EINVAL;
 
+again:
 	gts = gru_find_lock_gts(cb);
 	if (!gts)
 		return -EINVAL;
@@ -656,7 +657,11 @@ int gru_handle_user_call_os(unsigned long cb)
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
@@ -874,7 +879,11 @@ int gru_set_context_option(unsigned long arg)
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
index 40ac59dd018c..e2325e3d077e 100644
--- a/drivers/misc/sgi-gru/grumain.c
+++ b/drivers/misc/sgi-gru/grumain.c
@@ -716,9 +716,10 @@ static int gru_check_chiplet_assignment(struct gru_state *gru,
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
@@ -726,15 +727,23 @@ void gru_check_context_placement(struct gru_thread_state *gts)
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
 
 
@@ -934,7 +943,12 @@ vm_fault_t gru_fault(struct vm_fault *vmf)
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
index a7e44b2eb413..6cebec4dd316 100644
--- a/drivers/misc/sgi-gru/grutables.h
+++ b/drivers/misc/sgi-gru/grutables.h
@@ -637,7 +637,7 @@ extern int gru_user_flush_tlb(unsigned long arg);
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



