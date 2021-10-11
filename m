Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05DB0429146
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 16:15:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242599AbhJKORE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:17:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:35058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243835AbhJKOOx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 10:14:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F3BE261354;
        Mon, 11 Oct 2021 14:04:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633961096;
        bh=VhVdJO++/fA/CrMBT1l2MTIpN+N+tBrIikvMt4s0sPs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D+7gufIDmE30GEirV3/iRZ09GxZoL0DTsjm3DgyXIF5ha/TC3YGBcLRxPfx2BvuBQ
         RqKRtkzPWT64a7XFpew7Vh+7IWzj7nqVtGIQPePiDU4mmUZOKaKFZnnWusiJh0Sjys
         AhZKlLWW26EiP2l9Z/gSdnsV9wVwuIoEYhCeBeZU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Marczykowski-G=C3=B3recki?= 
        <marmarek@invisiblethingslab.com>, Juergen Gross <jgross@suse.com>,
        Jason Andryuk <jandryuk@gmail.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: [PATCH 4.19 07/28] xen/balloon: fix cancelled balloon action
Date:   Mon, 11 Oct 2021 15:46:57 +0200
Message-Id: <20211011134640.946996802@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134640.711218469@linuxfoundation.org>
References: <20211011134640.711218469@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Juergen Gross <jgross@suse.com>

commit 319933a80fd4f07122466a77f93e5019d71be74c upstream.

In case a ballooning action is cancelled the new kernel thread handling
the ballooning might end up in a busy loop.

Fix that by handling the cancelled action gracefully.

While at it introduce a short wait for the BP_WAIT case.

Cc: stable@vger.kernel.org
Fixes: 8480ed9c2bbd56 ("xen/balloon: use a kernel thread instead a workqueue")
Reported-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Tested-by: Jason Andryuk <jandryuk@gmail.com>
Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Link: https://lore.kernel.org/r/20211005133433.32008-1-jgross@suse.com
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/xen/balloon.c |   21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

--- a/drivers/xen/balloon.c
+++ b/drivers/xen/balloon.c
@@ -508,12 +508,12 @@ static enum bp_state decrease_reservatio
 }
 
 /*
- * Stop waiting if either state is not BP_EAGAIN and ballooning action is
- * needed, or if the credit has changed while state is BP_EAGAIN.
+ * Stop waiting if either state is BP_DONE and ballooning action is
+ * needed, or if the credit has changed while state is not BP_DONE.
  */
 static bool balloon_thread_cond(enum bp_state state, long credit)
 {
-	if (state != BP_EAGAIN)
+	if (state == BP_DONE)
 		credit = 0;
 
 	return current_credit() != credit || kthread_should_stop();
@@ -533,10 +533,19 @@ static int balloon_thread(void *unused)
 
 	set_freezable();
 	for (;;) {
-		if (state == BP_EAGAIN)
-			timeout = balloon_stats.schedule_delay * HZ;
-		else
+		switch (state) {
+		case BP_DONE:
+		case BP_ECANCELED:
 			timeout = 3600 * HZ;
+			break;
+		case BP_EAGAIN:
+			timeout = balloon_stats.schedule_delay * HZ;
+			break;
+		case BP_WAIT:
+			timeout = HZ;
+			break;
+		}
+
 		credit = current_credit();
 
 		wait_event_freezable_timeout(balloon_thread_wq,


