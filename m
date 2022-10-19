Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03A6C604152
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 12:42:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231698AbiJSKmj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 06:42:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231986AbiJSKlq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 06:41:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45A5A27DEB;
        Wed, 19 Oct 2022 03:19:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 19F4DB822E1;
        Wed, 19 Oct 2022 08:51:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B977C433C1;
        Wed, 19 Oct 2022 08:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169482;
        bh=C6CwbD+x4Djmkf1hfONC+CIP9Mm3gn2aJ3WQUw0pJs4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wwmUABvmBIrj2jHgzEuKzwjTuHfGkUBB5k9K4ENhAiCc4RsTbVv10T49UqPu3Dhhh
         Edh6aRNYHRpj+k1C6/ZTDvKlDRCkAdfmzOK012dga7JWoIt2lEHryYPd+sgoTXGScQ
         hyCXYP/nCS7WgiHScdHcynufDoDELzAxwgWalUhM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 293/862] Bluetooth: RFCOMM: Fix possible deadlock on socket shutdown/release
Date:   Wed, 19 Oct 2022 10:26:20 +0200
Message-Id: <20221019083302.963385999@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 812e92b824c1db16c9519f8624d48a9901a0d38f ]

Due to change to switch to use lock_sock inside rfcomm_sk_state_change
the socket shutdown/release procedure can cause a deadlock:

    rfcomm_sock_shutdown():
      lock_sock();
      __rfcomm_sock_close():
        rfcomm_dlc_close():
          __rfcomm_dlc_close():
            rfcomm_dlc_lock();
            rfcomm_sk_state_change():
              lock_sock();

To fix this when the call __rfcomm_sock_close is now done without
holding the lock_sock since rfcomm_dlc_lock exists to protect
the dlc data there is no need to use lock_sock in that code path.

Link: https://lore.kernel.org/all/CAD+dNTsbuU4w+Y_P7o+VEN7BYCAbZuwZx2+tH+OTzCdcZF82YA@mail.gmail.com/
Fixes: b7ce436a5d79 ("Bluetooth: switch to lock_sock in RFCOMM")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/rfcomm/sock.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/bluetooth/rfcomm/sock.c b/net/bluetooth/rfcomm/sock.c
index 4bf4ea6cbb5e..21e24da4847f 100644
--- a/net/bluetooth/rfcomm/sock.c
+++ b/net/bluetooth/rfcomm/sock.c
@@ -902,7 +902,10 @@ static int rfcomm_sock_shutdown(struct socket *sock, int how)
 	lock_sock(sk);
 	if (!sk->sk_shutdown) {
 		sk->sk_shutdown = SHUTDOWN_MASK;
+
+		release_sock(sk);
 		__rfcomm_sock_close(sk);
+		lock_sock(sk);
 
 		if (sock_flag(sk, SOCK_LINGER) && sk->sk_lingertime &&
 		    !(current->flags & PF_EXITING))
-- 
2.35.1



