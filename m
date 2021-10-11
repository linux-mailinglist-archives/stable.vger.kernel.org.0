Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D07F4428FFD
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 16:02:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238480AbhJKODE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:03:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:50200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238484AbhJKOBC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 10:01:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 35E3761056;
        Mon, 11 Oct 2021 13:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960642;
        bh=BnucTzdgEn4MCV5ug8uOTdS2GahGemh+33cFkqVmIPg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QUfbHzf3LKs1Fj/UZuwydOmfGPddXNjn0Sz3J6AcBiqI6Su7fBv0tjmEu/3Ss1KoD
         9hb4dNtsksU5uLYZbSRW8rXsj2EdF7LyHlp3dgJ8d/a2/r2l4qWoh4C36WNvxPeU8h
         Fx/KThRfsvWxdSHCzISjtEjpAFvTwbgcOXmQh4KA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Marczykowski-G=C3=B3recki?= 
        <marmarek@invisiblethingslab.com>, Juergen Gross <jgross@suse.com>,
        Jason Andryuk <jandryuk@gmail.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: [PATCH 5.14 030/151] xen/balloon: fix cancelled balloon action
Date:   Mon, 11 Oct 2021 15:45:02 +0200
Message-Id: <20211011134518.822924917@linuxfoundation.org>
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
@@ -491,12 +491,12 @@ static enum bp_state decrease_reservatio
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
@@ -516,10 +516,19 @@ static int balloon_thread(void *unused)
 
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


