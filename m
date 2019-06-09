Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5EBB3A908
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:07:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389081AbfFIRGv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 13:06:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:46782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389080AbfFIRGu (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 13:06:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 76568206C3;
        Sun,  9 Jun 2019 17:06:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560100009;
        bh=N7PZHLiWb70dpaJlXs3/4LXNRMPDUpXcsZOp8K+eHTQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mnYrssde4/dCYx2v6rlckViQoI72ubuMOnyC40X8XrfBxWJfgqIwKzWqAdryGiEnR
         wvKQ+sYGxYoxutYi+zKoM30pcsq08UQqf7/EKq4QJT3q8Kr3XtgA3TJNi72mgb/N/e
         snVhJh5oAr7eWJ/NtO4MTRe0k7ScIxYTZ7ItBNMs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Matteo Croce <mcroce@redhat.com>
Subject: [PATCH 4.4 233/241] pktgen: do not sleep with the thread lock held.
Date:   Sun,  9 Jun 2019 18:42:55 +0200
Message-Id: <20190609164155.470544630@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164147.729157653@linuxfoundation.org>
References: <20190609164147.729157653@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 720f1de4021f09898b8c8443f3b3e995991b6e3a ]

Currently, the process issuing a "start" command on the pktgen procfs
interface, acquires the pktgen thread lock and never release it, until
all pktgen threads are completed. The above can blocks indefinitely any
other pktgen command and any (even unrelated) netdevice removal - as
the pktgen netdev notifier acquires the same lock.

The issue is demonstrated by the following script, reported by Matteo:

ip -b - <<'EOF'
	link add type dummy
	link add type veth
	link set dummy0 up
EOF
modprobe pktgen
echo reset >/proc/net/pktgen/pgctrl
{
	echo rem_device_all
	echo add_device dummy0
} >/proc/net/pktgen/kpktgend_0
echo count 0 >/proc/net/pktgen/dummy0
echo start >/proc/net/pktgen/pgctrl &
sleep 1
rmmod veth

Fix the above releasing the thread lock around the sleep call.

Additionally we must prevent racing with forcefull rmmod - as the
thread lock no more protects from them. Instead, acquire a self-reference
before waiting for any thread. As a side effect, running

rmmod pktgen

while some thread is running now fails with "module in use" error,
before this patch such command hanged indefinitely.

Note: the issue predates the commit reported in the fixes tag, but
this fix can't be applied before the mentioned commit.

v1 -> v2:
 - no need to check for thread existence after flipping the lock,
   pktgen threads are freed only at net exit time
 -

Fixes: 6146e6a43b35 ("[PKTGEN]: Removes thread_{un,}lock() macros.")
Reported-and-tested-by: Matteo Croce <mcroce@redhat.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/pktgen.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/net/core/pktgen.c
+++ b/net/core/pktgen.c
@@ -3139,7 +3139,13 @@ static int pktgen_wait_thread_run(struct
 {
 	while (thread_is_running(t)) {
 
+		/* note: 't' will still be around even after the unlock/lock
+		 * cycle because pktgen_thread threads are only cleared at
+		 * net exit
+		 */
+		mutex_unlock(&pktgen_thread_lock);
 		msleep_interruptible(100);
+		mutex_lock(&pktgen_thread_lock);
 
 		if (signal_pending(current))
 			goto signal;
@@ -3154,6 +3160,10 @@ static int pktgen_wait_all_threads_run(s
 	struct pktgen_thread *t;
 	int sig = 1;
 
+	/* prevent from racing with rmmod */
+	if (!try_module_get(THIS_MODULE))
+		return sig;
+
 	mutex_lock(&pktgen_thread_lock);
 
 	list_for_each_entry(t, &pn->pktgen_threads, th_list) {
@@ -3167,6 +3177,7 @@ static int pktgen_wait_all_threads_run(s
 			t->control |= (T_STOP);
 
 	mutex_unlock(&pktgen_thread_lock);
+	module_put(THIS_MODULE);
 	return sig;
 }
 


