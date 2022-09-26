Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFE345EA23E
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:04:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237059AbiIZLEg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:04:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237422AbiIZLEI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:04:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DB515F231;
        Mon, 26 Sep 2022 03:33:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 356F2B80925;
        Mon, 26 Sep 2022 10:31:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D057C433C1;
        Mon, 26 Sep 2022 10:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188281;
        bh=STN83xp9evJqJZLuHCkw/lnhnKc/4/65pi4u/jxUtL8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S+f+p7zdiofO3qn6nLjT0UxBx33xCScsJy1FQsJnHzvMDPIso+ENwno0vLMcWBVp0
         KjH1S5FwYViUV5OubSpWw0f1ID87PJkvVW7PtU8EL99x2VmfIuNSs1bxl59JeV+9G+
         wHDoGh2xzGGYLTdvZtOVNIO81jaJzIJqptiBCUDw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Kees Cook <keescook@chromium.org>,
        syzbot+a448cda4dba2dac50de5@syzkaller.appspotmail.com,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 100/141] wireguard: netlink: avoid variable-sized memcpy on sockaddr
Date:   Mon, 26 Sep 2022 12:12:06 +0200
Message-Id: <20220926100758.051419605@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100754.639112000@linuxfoundation.org>
References: <20220926100754.639112000@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason A. Donenfeld <Jason@zx2c4.com>

[ Upstream commit 26c013108c12b94bc023bf19198a4300596c98b1 ]

Doing a variable-sized memcpy is slower, and the compiler isn't smart
enough to turn this into a constant-size assignment.

Further, Kees' latest fortified memcpy will actually bark, because the
destination pointer is type sockaddr, not explicitly sockaddr_in or
sockaddr_in6, so it thinks there's an overflow:

    memcpy: detected field-spanning write (size 28) of single field
    "&endpoint.addr" at drivers/net/wireguard/netlink.c:446 (size 16)

Fix this by just assigning by using explicit casts for each checked
case.

Fixes: e7096c131e51 ("net: WireGuard secure network tunnel")
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Reported-by: syzbot+a448cda4dba2dac50de5@syzkaller.appspotmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireguard/netlink.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireguard/netlink.c b/drivers/net/wireguard/netlink.c
index d0f3b6d7f408..5c804bcabfe6 100644
--- a/drivers/net/wireguard/netlink.c
+++ b/drivers/net/wireguard/netlink.c
@@ -436,14 +436,13 @@ static int set_peer(struct wg_device *wg, struct nlattr **attrs)
 	if (attrs[WGPEER_A_ENDPOINT]) {
 		struct sockaddr *addr = nla_data(attrs[WGPEER_A_ENDPOINT]);
 		size_t len = nla_len(attrs[WGPEER_A_ENDPOINT]);
+		struct endpoint endpoint = { { { 0 } } };
 
-		if ((len == sizeof(struct sockaddr_in) &&
-		     addr->sa_family == AF_INET) ||
-		    (len == sizeof(struct sockaddr_in6) &&
-		     addr->sa_family == AF_INET6)) {
-			struct endpoint endpoint = { { { 0 } } };
-
-			memcpy(&endpoint.addr, addr, len);
+		if (len == sizeof(struct sockaddr_in) && addr->sa_family == AF_INET) {
+			endpoint.addr4 = *(struct sockaddr_in *)addr;
+			wg_socket_set_peer_endpoint(peer, &endpoint);
+		} else if (len == sizeof(struct sockaddr_in6) && addr->sa_family == AF_INET6) {
+			endpoint.addr6 = *(struct sockaddr_in6 *)addr;
 			wg_socket_set_peer_endpoint(peer, &endpoint);
 		}
 	}
-- 
2.35.1



