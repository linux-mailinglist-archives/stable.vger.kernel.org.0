Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84037582D7B
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 18:58:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241124AbiG0Q6b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 12:58:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236197AbiG0Q6L (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 12:58:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B90F666AF0;
        Wed, 27 Jul 2022 09:36:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7111461AA5;
        Wed, 27 Jul 2022 16:36:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E5BDC433B5;
        Wed, 27 Jul 2022 16:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939796;
        bh=S8SWVllnVkzSgkTz6JoTxKs8jyHatnSGmDp56hMozCU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G/bHrId0+3zWAs8nz5800nB/VdRM595khJhDMXoRv/r5OkxlBW/nepOICr+9hJ5/N
         TcklePfRzfVqqtO/emdZiPOFtHxT3Vo5HoXPTkCuOtDg1pb80HKiiA/GIcBtSUde8g
         +72XPpJeED1RXWIuLqMV+jUwIcKXUNOAvWWg6ylo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Tedd Ho-Jeong An <tedd.an@intel.com>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: [PATCH 5.10 091/105] Bluetooth: Fix passing NULL to PTR_ERR
Date:   Wed, 27 Jul 2022 18:11:17 +0200
Message-Id: <20220727161015.745281832@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161012.056867467@linuxfoundation.org>
References: <20220727161012.056867467@linuxfoundation.org>
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
@@ -474,7 +474,7 @@ static inline struct sk_buff *bt_skb_sen
 		struct sk_buff *tmp;
 
 		tmp = bt_skb_sendmsg(sk, msg, len, mtu, headroom, tailroom);
-		if (IS_ERR_OR_NULL(tmp)) {
+		if (IS_ERR(tmp)) {
 			kfree_skb(skb);
 			return tmp;
 		}
--- a/net/bluetooth/rfcomm/sock.c
+++ b/net/bluetooth/rfcomm/sock.c
@@ -583,7 +583,7 @@ static int rfcomm_sock_sendmsg(struct so
 
 	skb = bt_skb_sendmmsg(sk, msg, len, d->mtu, RFCOMM_SKB_HEAD_RESERVE,
 			      RFCOMM_SKB_TAIL_RESERVE);
-	if (IS_ERR_OR_NULL(skb))
+	if (IS_ERR(skb))
 		return PTR_ERR(skb);
 
 	sent = rfcomm_dlc_send(d, skb);
--- a/net/bluetooth/sco.c
+++ b/net/bluetooth/sco.c
@@ -732,7 +732,7 @@ static int sco_sock_sendmsg(struct socke
 		return -EOPNOTSUPP;
 
 	skb = bt_skb_sendmsg(sk, msg, len, len, 0, 0);
-	if (IS_ERR_OR_NULL(skb))
+	if (IS_ERR(skb))
 		return PTR_ERR(skb);
 
 	lock_sock(sk);


