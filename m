Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1D21582B10
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 18:27:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236678AbiG0Q1R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 12:27:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236199AbiG0Q0n (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 12:26:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24E7D4F1B3;
        Wed, 27 Jul 2022 09:23:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BC1A7B821C0;
        Wed, 27 Jul 2022 16:23:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20634C43152;
        Wed, 27 Jul 2022 16:23:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939026;
        bh=ten9Uu56Thfp2v7HyMc7XRLlM5rs/z7BauP9gFsCuVY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ICVRB3g8jc6U8D0Fwa5TTIizqDx9GAILl3s5VcdDHmPQwZeKJZqomm9YSJxC/rcpV
         NguDBuZ5MdAoTWSXvW9id53qxNvr51RnszkrkJUVgs7rQWmS60BE0QFDflG4fUBbXX
         t+99WjRHpagKBhROvDNU5X51zvxsWoxgsBdqqlA4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Tedd Ho-Jeong An <tedd.an@intel.com>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: [PATCH 4.14 25/37] Bluetooth: Fix passing NULL to PTR_ERR
Date:   Wed, 27 Jul 2022 18:10:51 +0200
Message-Id: <20220727161001.868919852@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161000.822869853@linuxfoundation.org>
References: <20220727161000.822869853@linuxfoundation.org>
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

commit 266191aa8d14b84958aaeb5e96ee4e97839e3d87 upstream.

Passing NULL to PTR_ERR will result in 0 (success), also since the likes of
bt_skb_sendmsg does never return NULL it is safe to replace the instances of
IS_ERR_OR_NULL with IS_ERR when checking its return.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Tested-by: Tedd Ho-Jeong An <tedd.an@intel.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Cc: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/bluetooth/bluetooth.h |    2 +-
 net/bluetooth/rfcomm/sock.c       |    2 +-
 net/bluetooth/sco.c               |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

--- a/include/net/bluetooth/bluetooth.h
+++ b/include/net/bluetooth/bluetooth.h
@@ -419,7 +419,7 @@ static inline struct sk_buff *bt_skb_sen
 		struct sk_buff *tmp;
 
 		tmp = bt_skb_sendmsg(sk, msg, len, mtu, headroom, tailroom);
-		if (IS_ERR_OR_NULL(tmp)) {
+		if (IS_ERR(tmp)) {
 			kfree_skb(skb);
 			return tmp;
 		}
--- a/net/bluetooth/rfcomm/sock.c
+++ b/net/bluetooth/rfcomm/sock.c
@@ -586,7 +586,7 @@ static int rfcomm_sock_sendmsg(struct so
 
 	skb = bt_skb_sendmmsg(sk, msg, len, d->mtu, RFCOMM_SKB_HEAD_RESERVE,
 			      RFCOMM_SKB_TAIL_RESERVE);
-	if (IS_ERR_OR_NULL(skb))
+	if (IS_ERR(skb))
 		return PTR_ERR(skb);
 
 	sent = rfcomm_dlc_send(d, skb);
--- a/net/bluetooth/sco.c
+++ b/net/bluetooth/sco.c
@@ -721,7 +721,7 @@ static int sco_sock_sendmsg(struct socke
 		return -EOPNOTSUPP;
 
 	skb = bt_skb_sendmsg(sk, msg, len, len, 0, 0);
-	if (IS_ERR_OR_NULL(skb))
+	if (IS_ERR(skb))
 		return PTR_ERR(skb);
 
 	lock_sock(sk);


