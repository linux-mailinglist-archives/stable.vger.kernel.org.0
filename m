Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C3BA1220C9
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 01:58:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726548AbfLQA6A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 19:58:00 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34874 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726773AbfLQAvj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Dec 2019 19:51:39 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15I-0003LE-5R; Tue, 17 Dec 2019 00:51:32 +0000
Received: from ben by deadeye with local (Exim 4.93-RC7)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15G-0005Uo-VR; Tue, 17 Dec 2019 00:51:30 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        syzbot+31c16aa4202dace3812e@syzkaller.appspotmail.com,
        "Jakub Kicinski" <jakub.kicinski@netronome.com>,
        syzbot+6bf095f9becf5efef645@syzkaller.appspotmail.com,
        "Eric Biggers" <ebiggers@google.com>
Date:   Tue, 17 Dec 2019 00:46:18 +0000
Message-ID: <lsq.1576543535.462168066@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 044/136] llc: fix sk_buff leak in llc_sap_state_process()
In-Reply-To: <lsq.1576543534.33060804@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.80-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Biggers <ebiggers@google.com>

commit c6ee11c39fcc1fb55130748990a8f199e76263b4 upstream.

syzbot reported:

    BUG: memory leak
    unreferenced object 0xffff888116270800 (size 224):
       comm "syz-executor641", pid 7047, jiffies 4294947360 (age 13.860s)
       hex dump (first 32 bytes):
         00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
         00 20 e1 2a 81 88 ff ff 00 40 3d 2a 81 88 ff ff  . .*.....@=*....
       backtrace:
         [<000000004d41b4cc>] kmemleak_alloc_recursive  include/linux/kmemleak.h:55 [inline]
         [<000000004d41b4cc>] slab_post_alloc_hook mm/slab.h:439 [inline]
         [<000000004d41b4cc>] slab_alloc_node mm/slab.c:3269 [inline]
         [<000000004d41b4cc>] kmem_cache_alloc_node+0x153/0x2a0 mm/slab.c:3579
         [<00000000506a5965>] __alloc_skb+0x6e/0x210 net/core/skbuff.c:198
         [<000000001ba5a161>] alloc_skb include/linux/skbuff.h:1058 [inline]
         [<000000001ba5a161>] alloc_skb_with_frags+0x5f/0x250  net/core/skbuff.c:5327
         [<0000000047d9c78b>] sock_alloc_send_pskb+0x269/0x2a0  net/core/sock.c:2225
         [<000000003828fe54>] sock_alloc_send_skb+0x32/0x40 net/core/sock.c:2242
         [<00000000e34d94f9>] llc_ui_sendmsg+0x10a/0x540 net/llc/af_llc.c:933
         [<00000000de2de3fb>] sock_sendmsg_nosec net/socket.c:652 [inline]
         [<00000000de2de3fb>] sock_sendmsg+0x54/0x70 net/socket.c:671
         [<000000008fe16e7a>] __sys_sendto+0x148/0x1f0 net/socket.c:1964
	 [...]

The bug is that llc_sap_state_process() always takes an extra reference
to the skb, but sometimes neither llc_sap_next_state() nor
llc_sap_state_process() itself drops this reference.

Fix it by changing llc_sap_next_state() to never consume a reference to
the skb, rather than sometimes do so and sometimes not.  Then remove the
extra skb_get() and kfree_skb() from llc_sap_state_process().

Reported-by: syzbot+6bf095f9becf5efef645@syzkaller.appspotmail.com
Reported-by: syzbot+31c16aa4202dace3812e@syzkaller.appspotmail.com
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/llc/llc_s_ac.c | 12 +++++++++---
 net/llc/llc_sap.c  | 23 ++++++++---------------
 2 files changed, 17 insertions(+), 18 deletions(-)

--- a/net/llc/llc_s_ac.c
+++ b/net/llc/llc_s_ac.c
@@ -58,8 +58,10 @@ int llc_sap_action_send_ui(struct llc_sa
 			    ev->daddr.lsap, LLC_PDU_CMD);
 	llc_pdu_init_as_ui_cmd(skb);
 	rc = llc_mac_hdr_init(skb, ev->saddr.mac, ev->daddr.mac);
-	if (likely(!rc))
+	if (likely(!rc)) {
+		skb_get(skb);
 		rc = dev_queue_xmit(skb);
+	}
 	return rc;
 }
 
@@ -81,8 +83,10 @@ int llc_sap_action_send_xid_c(struct llc
 			    ev->daddr.lsap, LLC_PDU_CMD);
 	llc_pdu_init_as_xid_cmd(skb, LLC_XID_NULL_CLASS_2, 0);
 	rc = llc_mac_hdr_init(skb, ev->saddr.mac, ev->daddr.mac);
-	if (likely(!rc))
+	if (likely(!rc)) {
+		skb_get(skb);
 		rc = dev_queue_xmit(skb);
+	}
 	return rc;
 }
 
@@ -135,8 +139,10 @@ int llc_sap_action_send_test_c(struct ll
 			    ev->daddr.lsap, LLC_PDU_CMD);
 	llc_pdu_init_as_test_cmd(skb);
 	rc = llc_mac_hdr_init(skb, ev->saddr.mac, ev->daddr.mac);
-	if (likely(!rc))
+	if (likely(!rc)) {
+		skb_get(skb);
 		rc = dev_queue_xmit(skb);
+	}
 	return rc;
 }
 
--- a/net/llc/llc_sap.c
+++ b/net/llc/llc_sap.c
@@ -197,29 +197,22 @@ out:
  *	After executing actions of the event, upper layer will be indicated
  *	if needed(on receiving an UI frame). sk can be null for the
  *	datalink_proto case.
+ *
+ *	This function always consumes a reference to the skb.
  */
 static void llc_sap_state_process(struct llc_sap *sap, struct sk_buff *skb)
 {
 	struct llc_sap_state_ev *ev = llc_sap_ev(skb);
 
-	/*
-	 * We have to hold the skb, because llc_sap_next_state
-	 * will kfree it in the sending path and we need to
-	 * look at the skb->cb, where we encode llc_sap_state_ev.
-	 */
-	skb_get(skb);
 	ev->ind_cfm_flag = 0;
 	llc_sap_next_state(sap, skb);
-	if (ev->ind_cfm_flag == LLC_IND) {
-		if (skb->sk->sk_state == TCP_LISTEN)
-			kfree_skb(skb);
-		else {
-			llc_save_primitive(skb->sk, skb, ev->prim);
 
-			/* queue skb to the user. */
-			if (sock_queue_rcv_skb(skb->sk, skb))
-				kfree_skb(skb);
-		}
+	if (ev->ind_cfm_flag == LLC_IND && skb->sk->sk_state != TCP_LISTEN) {
+		llc_save_primitive(skb->sk, skb, ev->prim);
+
+		/* queue skb to the user. */
+		if (sock_queue_rcv_skb(skb->sk, skb) == 0)
+			return;
 	}
 	kfree_skb(skb);
 }

