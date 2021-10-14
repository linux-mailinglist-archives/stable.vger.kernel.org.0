Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE5BB42DCA7
	for <lists+stable@lfdr.de>; Thu, 14 Oct 2021 16:59:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232977AbhJNPAn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Oct 2021 11:00:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:45292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232702AbhJNO7d (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 Oct 2021 10:59:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E635C611C0;
        Thu, 14 Oct 2021 14:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634223448;
        bh=CAVn6nApZMlAPzuvnFchBCfEgjysVqugDsTuF4oUqC8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IksatOIcoFwW8YfT4hNEhUNDh/M83LvocY2mj3+aEejhuCD0vFKG7iw8VIoxxVEl1
         qGYAvrVXTgJZuqtRWF/qt+Ojb1PBuB3h9LWu/cnCOGAR9KjXKXHrjKiMyu8YErFSrc
         jf1bPDmuv9dvBPgQ4Hs1efBy6LgNMx2JwMkZGxP4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Marczykowski-G=C3=B3recki?= 
        <marmarek@invisiblethingslab.com>, Juergen Gross <jgross@suse.com>,
        Jason Andryuk <jandryuk@gmail.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: [PATCH 4.14 06/33] xen/balloon: fix cancelled balloon action
Date:   Thu, 14 Oct 2021 16:53:38 +0200
Message-Id: <20211014145208.988495952@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211014145208.775270267@linuxfoundation.org>
References: <20211014145208.775270267@linuxfoundation.org>
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
@@ -571,12 +571,12 @@ static enum bp_state decrease_reservatio
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
@@ -596,10 +596,19 @@ static int balloon_thread(void *unused)
 
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


