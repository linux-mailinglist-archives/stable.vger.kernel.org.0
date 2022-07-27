Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 250B9582F5B
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:25:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234334AbiG0RZK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:25:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242243AbiG0RYp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:24:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A86115F9A6;
        Wed, 27 Jul 2022 09:46:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C293C60DDB;
        Wed, 27 Jul 2022 16:46:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF6EEC433D6;
        Wed, 27 Jul 2022 16:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940372;
        bh=7cxcXXPeU7k5QbBJxp1iNTuJ664l3od0idVpycl5vRg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OGFVrkB6f3JJo5Zp6bZVlArSwn85rMEegMFIKf/oZwZ7dTpfMTW1++T5ECb3m6j7I
         ywBhsEDGQbJe7r1JYwxyUqfuv9LFzirV62NMihCsD9Z7wDhDb7M/JvLM0uPTpbAJvj
         AHUV7ycPOAPxDa7kFCTyWurJcjg7aqw5/oKQ+cSg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: [PATCH 5.15 174/201] Bluetooth: Add bt_skb_sendmsg helper
Date:   Wed, 27 Jul 2022 18:11:18 +0200
Message-Id: <20220727161035.014956207@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161026.977588183@linuxfoundation.org>
References: <20220727161026.977588183@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

commit 38f64f650dc0e44c146ff88d15a7339efa325918 upstream.

bt_skb_sendmsg helps takes care of allocation the skb and copying the
the contents of msg over to the skb while checking for possible errors
so it should be safe to call it without holding lock_sock.

Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Cc: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/bluetooth/bluetooth.h |   28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

--- a/include/net/bluetooth/bluetooth.h
+++ b/include/net/bluetooth/bluetooth.h
@@ -422,6 +422,34 @@ out:
 	return NULL;
 }
 
+/* Shall not be called with lock_sock held */
+static inline struct sk_buff *bt_skb_sendmsg(struct sock *sk,
+					     struct msghdr *msg,
+					     size_t len, size_t mtu,
+					     size_t headroom, size_t tailroom)
+{
+	struct sk_buff *skb;
+	size_t size = min_t(size_t, len, mtu);
+	int err;
+
+	skb = bt_skb_send_alloc(sk, size + headroom + tailroom,
+				msg->msg_flags & MSG_DONTWAIT, &err);
+	if (!skb)
+		return ERR_PTR(err);
+
+	skb_reserve(skb, headroom);
+	skb_tailroom_reserve(skb, mtu, tailroom);
+
+	if (!copy_from_iter_full(skb_put(skb, size), size, &msg->msg_iter)) {
+		kfree_skb(skb);
+		return ERR_PTR(-EFAULT);
+	}
+
+	skb->priority = sk->sk_priority;
+
+	return skb;
+}
+
 int bt_to_errno(u16 code);
 
 void hci_sock_set_flag(struct sock *sk, int nr);


