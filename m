Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF6C9C91DB
	for <lists+stable@lfdr.de>; Wed,  2 Oct 2019 21:15:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729517AbfJBTMC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Oct 2019 15:12:02 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35584 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729197AbfJBTIM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Oct 2019 15:08:12 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iFjyr-00035s-Bw; Wed, 02 Oct 2019 20:08:09 +0100
Received: from ben by deadeye with local (Exim 4.92.1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iFjyo-0003di-Fv; Wed, 02 Oct 2019 20:08:06 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Paolo Abeni" <pabeni@redhat.com>
Date:   Wed, 02 Oct 2019 20:06:51 +0100
Message-ID: <lsq.1570043211.279433365@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 48/87] pktgen: do not sleep with the thread lock held.
In-Reply-To: <lsq.1570043210.379046399@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.75-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Abeni <pabeni@redhat.com>

commit 720f1de4021f09898b8c8443f3b3e995991b6e3a upstream.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/core/pktgen.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/net/core/pktgen.c
+++ b/net/core/pktgen.c
@@ -3055,7 +3055,13 @@ static int pktgen_wait_thread_run(struct
 
 		if_unlock(t);
 
+		/* note: 't' will still be around even after the unlock/lock
+		 * cycle because pktgen_thread threads are only cleared at
+		 * net exit
+		 */
+		mutex_unlock(&pktgen_thread_lock);
 		msleep_interruptible(100);
+		mutex_lock(&pktgen_thread_lock);
 
 		if (signal_pending(current))
 			goto signal;
@@ -3072,6 +3078,10 @@ static int pktgen_wait_all_threads_run(s
 	struct pktgen_thread *t;
 	int sig = 1;
 
+	/* prevent from racing with rmmod */
+	if (!try_module_get(THIS_MODULE))
+		return sig;
+
 	mutex_lock(&pktgen_thread_lock);
 
 	list_for_each_entry(t, &pn->pktgen_threads, th_list) {
@@ -3085,6 +3095,7 @@ static int pktgen_wait_all_threads_run(s
 			t->control |= (T_STOP);
 
 	mutex_unlock(&pktgen_thread_lock);
+	module_put(THIS_MODULE);
 	return sig;
 }
 

