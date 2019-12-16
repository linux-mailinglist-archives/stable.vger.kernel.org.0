Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 142AE12145D
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:10:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730469AbfLPSKo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:10:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:54050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730451AbfLPSKn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:10:43 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E5E7206B7;
        Mon, 16 Dec 2019 18:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576519842;
        bh=iI/RkI3HDLfJrV5Yf7UTlFLrZGwH/B1OA9pA1U9tTXA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MHUt8+oYShuaspTfb9dLbBpokdRgNNfRShMrAxWC1f8WddnkYC5EPcpWvQCl//rDZ
         oMHVyrSdgJydSUefrIw0WE9wvRjIIGTvFjtCLBTi5uG37pJSGtCO7MkPv/ApJiv+0I
         Yr1Xf5Fwlf3iLuHcsPAFfbTvzGQ6q0OIU5hrG3S8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        "Williams, Gerald S" <gerald.s.williams@intel.com>,
        NeilBrown <neilb@suse.de>
Subject: [PATCH 5.3 074/180] workqueue: Fix pwq ref leak in rescuer_thread()
Date:   Mon, 16 Dec 2019 18:48:34 +0100
Message-Id: <20191216174830.534635482@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174806.018988360@linuxfoundation.org>
References: <20191216174806.018988360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tejun Heo <tj@kernel.org>

commit e66b39af00f426b3356b96433d620cb3367ba1ff upstream.

008847f66c3 ("workqueue: allow rescuer thread to do more work.") made
the rescuer worker requeue the pwq immediately if there may be more
work items which need rescuing instead of waiting for the next mayday
timer expiration.  Unfortunately, it doesn't check whether the pwq is
already on the mayday list and unconditionally gets the ref and moves
it onto the list.  This doesn't corrupt the list but creates an
additional reference to the pwq.  It got queued twice but will only be
removed once.

This leak later can trigger pwq refcnt warning on workqueue
destruction and prevent freeing of the workqueue.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: "Williams, Gerald S" <gerald.s.williams@intel.com>
Cc: NeilBrown <neilb@suse.de>
Cc: stable@vger.kernel.org # v3.19+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/workqueue.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2532,8 +2532,14 @@ repeat:
 			 */
 			if (need_to_create_worker(pool)) {
 				spin_lock(&wq_mayday_lock);
-				get_pwq(pwq);
-				list_move_tail(&pwq->mayday_node, &wq->maydays);
+				/*
+				 * Queue iff we aren't racing destruction
+				 * and somebody else hasn't queued it already.
+				 */
+				if (wq->rescuer && list_empty(&pwq->mayday_node)) {
+					get_pwq(pwq);
+					list_add_tail(&pwq->mayday_node, &wq->maydays);
+				}
 				spin_unlock(&wq_mayday_lock);
 			}
 		}
@@ -4643,7 +4649,8 @@ static void show_pwq(struct pool_workque
 	pr_info("  pwq %d:", pool->id);
 	pr_cont_pool_info(pool);
 
-	pr_cont(" active=%d/%d%s\n", pwq->nr_active, pwq->max_active,
+	pr_cont(" active=%d/%d refcnt=%d%s\n",
+		pwq->nr_active, pwq->max_active, pwq->refcnt,
 		!list_empty(&pwq->mayday_node) ? " MAYDAY" : "");
 
 	hash_for_each(pool->busy_hash, bkt, worker, hentry) {


