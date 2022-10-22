Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 131B66086AB
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 09:52:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231319AbiJVHwB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 03:52:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231667AbiJVHuO (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 03:50:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 283C02C2AD0;
        Sat, 22 Oct 2022 00:46:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D178FB82E18;
        Sat, 22 Oct 2022 07:45:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4028BC433D6;
        Sat, 22 Oct 2022 07:45:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424721;
        bh=C6CwbD+x4Djmkf1hfONC+CIP9Mm3gn2aJ3WQUw0pJs4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gjj5a3spyEsV/HXUtOe6l7DGX96lk2QvSf7B7wCR/KR1csSaIMaK5LuHGHzkAVfJ1
         gGp0S4qNpyPtXD9ermSl459OvJfI10KuSA50gKx1h2Pclbpm8MOkrBaVmrE5QgnYoY
         p4FceeT6sU5o0AQKbStqmbiHfvLcL9ZgcLYZXOi8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 251/717] Bluetooth: RFCOMM: Fix possible deadlock on socket shutdown/release
Date:   Sat, 22 Oct 2022 09:22:10 +0200
Message-Id: <20221022072459.267678236@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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



