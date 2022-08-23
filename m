Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EBA859D6D7
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:58:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350062AbiHWJ1z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:27:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351151AbiHWJ0o (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:26:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50EBC91094;
        Tue, 23 Aug 2022 01:37:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EFA6F614C5;
        Tue, 23 Aug 2022 08:35:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3F7AC433D6;
        Tue, 23 Aug 2022 08:35:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661243745;
        bh=iJZpFLRwvDbeVZ/DqC+ffQrnPhgOnA1QgJ3ZxT8FJCc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qlUhYW5yUywWxAPe3aRgo57zi6dsA/Lkhu8eVBs39yzSROYjGIuD3bQYkuxOBnNz0
         gkitNaRcBInZU5oINYX2eRF+6oZyqXlsuOMrz0ZJ//GeOoFNmBTyFrIuSVfooCcYcu
         4WDQVcM2+5298Xu2uSNYyvYuAQ1y5ACK5NLbGA50=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 4.14 001/229] Bluetooth: L2CAP: Fix use-after-free caused by l2cap_chan_put
Date:   Tue, 23 Aug 2022 10:22:42 +0200
Message-Id: <20220823080053.272976849@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080053.202747790@linuxfoundation.org>
References: <20220823080053.202747790@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

commit d0be8347c623e0ac4202a1d4e0373882821f56b0 upstream.

This fixes the following trace which is caused by hci_rx_work starting up
*after* the final channel reference has been put() during sock_close() but
*before* the references to the channel have been destroyed, so instead
the code now rely on kref_get_unless_zero/l2cap_chan_hold_unless_zero to
prevent referencing a channel that is about to be destroyed.

  refcount_t: increment on 0; use-after-free.
  BUG: KASAN: use-after-free in refcount_dec_and_test+0x20/0xd0
  Read of size 4 at addr ffffffc114f5bf18 by task kworker/u17:14/705

  CPU: 4 PID: 705 Comm: kworker/u17:14 Tainted: G S      W
  4.14.234-00003-g1fb6d0bd49a4-dirty #28
  Hardware name: Qualcomm Technologies, Inc. SM8150 V2 PM8150
  Google Inc. MSM sm8150 Flame DVT (DT)
  Workqueue: hci0 hci_rx_work
  Call trace:
   dump_backtrace+0x0/0x378
   show_stack+0x20/0x2c
   dump_stack+0x124/0x148
   print_address_description+0x80/0x2e8
   __kasan_report+0x168/0x188
   kasan_report+0x10/0x18
   __asan_load4+0x84/0x8c
   refcount_dec_and_test+0x20/0xd0
   l2cap_chan_put+0x48/0x12c
   l2cap_recv_frame+0x4770/0x6550
   l2cap_recv_acldata+0x44c/0x7a4
   hci_acldata_packet+0x100/0x188
   hci_rx_work+0x178/0x23c
   process_one_work+0x35c/0x95c
   worker_thread+0x4cc/0x960
   kthread+0x1a8/0x1c4
   ret_from_fork+0x10/0x18

Cc: stable@kernel.org
Reported-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Tested-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/bluetooth/l2cap.h |    1 
 net/bluetooth/l2cap_core.c    |   61 +++++++++++++++++++++++++++++++++---------
 2 files changed, 49 insertions(+), 13 deletions(-)

--- a/include/net/bluetooth/l2cap.h
+++ b/include/net/bluetooth/l2cap.h
@@ -798,6 +798,7 @@ enum {
 };
 
 void l2cap_chan_hold(struct l2cap_chan *c);
+struct l2cap_chan *l2cap_chan_hold_unless_zero(struct l2cap_chan *c);
 void l2cap_chan_put(struct l2cap_chan *c);
 
 static inline void l2cap_chan_lock(struct l2cap_chan *chan)
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -113,7 +113,8 @@ static struct l2cap_chan *__l2cap_get_ch
 }
 
 /* Find channel with given SCID.
- * Returns locked channel. */
+ * Returns a reference locked channel.
+ */
 static struct l2cap_chan *l2cap_get_chan_by_scid(struct l2cap_conn *conn,
 						 u16 cid)
 {
@@ -121,15 +122,19 @@ static struct l2cap_chan *l2cap_get_chan
 
 	mutex_lock(&conn->chan_lock);
 	c = __l2cap_get_chan_by_scid(conn, cid);
-	if (c)
-		l2cap_chan_lock(c);
+	if (c) {
+		/* Only lock if chan reference is not 0 */
+		c = l2cap_chan_hold_unless_zero(c);
+		if (c)
+			l2cap_chan_lock(c);
+	}
 	mutex_unlock(&conn->chan_lock);
 
 	return c;
 }
 
 /* Find channel with given DCID.
- * Returns locked channel.
+ * Returns a reference locked channel.
  */
 static struct l2cap_chan *l2cap_get_chan_by_dcid(struct l2cap_conn *conn,
 						 u16 cid)
@@ -138,8 +143,12 @@ static struct l2cap_chan *l2cap_get_chan
 
 	mutex_lock(&conn->chan_lock);
 	c = __l2cap_get_chan_by_dcid(conn, cid);
-	if (c)
-		l2cap_chan_lock(c);
+	if (c) {
+		/* Only lock if chan reference is not 0 */
+		c = l2cap_chan_hold_unless_zero(c);
+		if (c)
+			l2cap_chan_lock(c);
+	}
 	mutex_unlock(&conn->chan_lock);
 
 	return c;
@@ -164,8 +173,12 @@ static struct l2cap_chan *l2cap_get_chan
 
 	mutex_lock(&conn->chan_lock);
 	c = __l2cap_get_chan_by_ident(conn, ident);
-	if (c)
-		l2cap_chan_lock(c);
+	if (c) {
+		/* Only lock if chan reference is not 0 */
+		c = l2cap_chan_hold_unless_zero(c);
+		if (c)
+			l2cap_chan_lock(c);
+	}
 	mutex_unlock(&conn->chan_lock);
 
 	return c;
@@ -491,6 +504,16 @@ void l2cap_chan_hold(struct l2cap_chan *
 	kref_get(&c->kref);
 }
 
+struct l2cap_chan *l2cap_chan_hold_unless_zero(struct l2cap_chan *c)
+{
+	BT_DBG("chan %p orig refcnt %u", c, kref_read(&c->kref));
+
+	if (!kref_get_unless_zero(&c->kref))
+		return NULL;
+
+	return c;
+}
+
 void l2cap_chan_put(struct l2cap_chan *c)
 {
 	BT_DBG("chan %p orig refcnt %d", c, kref_read(&c->kref));
@@ -1803,7 +1826,10 @@ static struct l2cap_chan *l2cap_global_c
 			src_match = !bacmp(&c->src, src);
 			dst_match = !bacmp(&c->dst, dst);
 			if (src_match && dst_match) {
-				l2cap_chan_hold(c);
+				c = l2cap_chan_hold_unless_zero(c);
+				if (!c)
+					continue;
+
 				read_unlock(&chan_list_lock);
 				return c;
 			}
@@ -1818,7 +1844,7 @@ static struct l2cap_chan *l2cap_global_c
 	}
 
 	if (c1)
-		l2cap_chan_hold(c1);
+		c1 = l2cap_chan_hold_unless_zero(c1);
 
 	read_unlock(&chan_list_lock);
 
@@ -4204,6 +4230,7 @@ static inline int l2cap_config_req(struc
 
 unlock:
 	l2cap_chan_unlock(chan);
+	l2cap_chan_put(chan);
 	return err;
 }
 
@@ -4316,6 +4343,7 @@ static inline int l2cap_config_rsp(struc
 
 done:
 	l2cap_chan_unlock(chan);
+	l2cap_chan_put(chan);
 	return err;
 }
 
@@ -5044,6 +5072,7 @@ send_move_response:
 	l2cap_send_move_chan_rsp(chan, result);
 
 	l2cap_chan_unlock(chan);
+	l2cap_chan_put(chan);
 
 	return 0;
 }
@@ -5136,6 +5165,7 @@ static void l2cap_move_continue(struct l
 	}
 
 	l2cap_chan_unlock(chan);
+	l2cap_chan_put(chan);
 }
 
 static void l2cap_move_fail(struct l2cap_conn *conn, u8 ident, u16 icid,
@@ -5165,6 +5195,7 @@ static void l2cap_move_fail(struct l2cap
 	l2cap_send_move_chan_cfm(chan, L2CAP_MC_UNCONFIRMED);
 
 	l2cap_chan_unlock(chan);
+	l2cap_chan_put(chan);
 }
 
 static int l2cap_move_channel_rsp(struct l2cap_conn *conn,
@@ -5228,6 +5259,7 @@ static int l2cap_move_channel_confirm(st
 	l2cap_send_move_chan_cfm_rsp(conn, cmd->ident, icid);
 
 	l2cap_chan_unlock(chan);
+	l2cap_chan_put(chan);
 
 	return 0;
 }
@@ -5263,6 +5295,7 @@ static inline int l2cap_move_channel_con
 	}
 
 	l2cap_chan_unlock(chan);
+	l2cap_chan_put(chan);
 
 	return 0;
 }
@@ -5635,12 +5668,11 @@ static inline int l2cap_le_credits(struc
 	if (credits > max_credits) {
 		BT_ERR("LE credits overflow");
 		l2cap_send_disconn_req(chan, ECONNRESET);
-		l2cap_chan_unlock(chan);
 
 		/* Return 0 so that we don't trigger an unnecessary
 		 * command reject packet.
 		 */
-		return 0;
+		goto unlock;
 	}
 
 	chan->tx_credits += credits;
@@ -5651,7 +5683,9 @@ static inline int l2cap_le_credits(struc
 	if (chan->tx_credits)
 		chan->ops->resume(chan);
 
+unlock:
 	l2cap_chan_unlock(chan);
+	l2cap_chan_put(chan);
 
 	return 0;
 }
@@ -6949,6 +6983,7 @@ drop:
 
 done:
 	l2cap_chan_unlock(chan);
+	l2cap_chan_put(chan);
 }
 
 static void l2cap_conless_channel(struct l2cap_conn *conn, __le16 psm,
@@ -7353,7 +7388,7 @@ static struct l2cap_chan *l2cap_global_f
 		if (src_type != c->src_type)
 			continue;
 
-		l2cap_chan_hold(c);
+		c = l2cap_chan_hold_unless_zero(c);
 		read_unlock(&chan_list_lock);
 		return c;
 	}


