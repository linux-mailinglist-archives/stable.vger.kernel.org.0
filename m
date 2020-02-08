Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBCD315662F
	for <lists+stable@lfdr.de>; Sat,  8 Feb 2020 19:32:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727574AbgBHSck (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Feb 2020 13:32:40 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34562 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727938AbgBHS3s (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Feb 2020 13:29:48 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrO-0003jJ-2Z; Sat, 08 Feb 2020 18:29:42 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrL-000CVa-BX; Sat, 08 Feb 2020 18:29:39 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Menglong Dong" <dong.menglong@zte.com.cn>,
        "David S. Miller" <davem@davemloft.net>
Date:   Sat, 08 Feb 2020 18:21:02 +0000
Message-ID: <lsq.1581185941.238945398@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 123/148] macvlan: schedule bc_work even if error
In-Reply-To: <lsq.1581185939.857586636@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.82-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Menglong Dong <dong.menglong@zte.com.cn>

commit 1d7ea55668878bb350979c377fc72509dd6f5b21 upstream.

While enqueueing a broadcast skb to port->bc_queue, schedule_work()
is called to add port->bc_work, which processes the skbs in
bc_queue, to "events" work queue. If port->bc_queue is full, the
skb will be discarded and schedule_work(&port->bc_work) won't be
called. However, if port->bc_queue is full and port->bc_work is not
running or pending, port->bc_queue will keep full and schedule_work()
won't be called any more, and all broadcast skbs to macvlan will be
discarded. This case can happen:

macvlan_process_broadcast() is the pending function of port->bc_work,
it moves all the skbs in port->bc_queue to the queue "list", and
processes the skbs in "list". During this, new skbs will keep being
added to port->bc_queue in macvlan_broadcast_enqueue(), and
port->bc_queue may already full when macvlan_process_broadcast()
return. This may happen, especially when there are a lot of real-time
threads and the process is preempted.

Fix this by calling schedule_work(&port->bc_work) even if
port->bc_work is full in macvlan_broadcast_enqueue().

Fixes: 412ca1550cbe ("macvlan: Move broadcasts into a work queue")
Signed-off-by: Menglong Dong <dong.menglong@zte.com.cn>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/macvlan.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -262,10 +262,11 @@ static void macvlan_broadcast_enqueue(st
 	}
 	spin_unlock(&port->bc_queue.lock);
 
+	schedule_work(&port->bc_work);
+
 	if (err)
 		goto free_nskb;
 
-	schedule_work(&port->bc_work);
 	return;
 
 free_nskb:

