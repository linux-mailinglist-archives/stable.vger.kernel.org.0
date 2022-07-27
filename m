Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AA27582C4C
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 18:44:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239880AbiG0Qox (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 12:44:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240294AbiG0QoQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 12:44:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 736535E311;
        Wed, 27 Jul 2022 09:30:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AB5FB619CF;
        Wed, 27 Jul 2022 16:30:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAF2DC433C1;
        Wed, 27 Jul 2022 16:30:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939457;
        bh=Wvw7I+nGSwocAWbyQDmTKOy9jcP8+ZoXNRue2rb7Ycg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rbwxRsy+gPunKe3jkmJvyBuZjF0G9ZNUFkfBuHQbPggGNaQgXGVXQBJTlrgJM0hm9
         1mnBAw9rvoHJ8NyJ9G18+OhCeOqYYq/+lV5sGeImNrB4jouofadYtTJyFcEQxyaMGr
         PWVLqV6nah/Q63JZYdoIhksRyCP9FBrPGueXPcZs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: [PATCH 5.4 75/87] Bluetooth: Add bt_skb_sendmmsg helper
Date:   Wed, 27 Jul 2022 18:11:08 +0200
Message-Id: <20220727161012.104704033@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161008.993711844@linuxfoundation.org>
References: <20220727161008.993711844@linuxfoundation.org>
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

commit 97e4e80299844bb5f6ce5a7540742ffbffae3d97 upstream.

This works similarly to bt_skb_sendmsg but can split the msg into
multiple skb fragments which is useful for stream sockets.

Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Cc: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/bluetooth/bluetooth.h |   38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

--- a/include/net/bluetooth/bluetooth.h
+++ b/include/net/bluetooth/bluetooth.h
@@ -398,6 +398,44 @@ static inline struct sk_buff *bt_skb_sen
 	return skb;
 }
 
+/* Similar to bt_skb_sendmsg but can split the msg into multiple fragments
+ * accourding to the MTU.
+ */
+static inline struct sk_buff *bt_skb_sendmmsg(struct sock *sk,
+					      struct msghdr *msg,
+					      size_t len, size_t mtu,
+					      size_t headroom, size_t tailroom)
+{
+	struct sk_buff *skb, **frag;
+
+	skb = bt_skb_sendmsg(sk, msg, len, mtu, headroom, tailroom);
+	if (IS_ERR_OR_NULL(skb))
+		return skb;
+
+	len -= skb->len;
+	if (!len)
+		return skb;
+
+	/* Add remaining data over MTU as continuation fragments */
+	frag = &skb_shinfo(skb)->frag_list;
+	while (len) {
+		struct sk_buff *tmp;
+
+		tmp = bt_skb_sendmsg(sk, msg, len, mtu, headroom, tailroom);
+		if (IS_ERR_OR_NULL(tmp)) {
+			kfree_skb(skb);
+			return tmp;
+		}
+
+		len -= tmp->len;
+
+		*frag = tmp;
+		frag = &(*frag)->next;
+	}
+
+	return skb;
+}
+
 int bt_to_errno(u16 code);
 
 void hci_sock_set_flag(struct sock *sk, int nr);


