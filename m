Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19C2461F794
	for <lists+stable@lfdr.de>; Mon,  7 Nov 2022 16:27:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231577AbiKGP1A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Nov 2022 10:27:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232881AbiKGP05 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Nov 2022 10:26:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8AC7BCA9
        for <stable@vger.kernel.org>; Mon,  7 Nov 2022 07:26:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5295F6118E
        for <stable@vger.kernel.org>; Mon,  7 Nov 2022 15:26:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DACE8C433D6;
        Mon,  7 Nov 2022 15:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667834815;
        bh=oKd7DcQjcQRLVCzH7pECOLMbcVvPNYg4TtIgq/U59Ic=;
        h=Subject:To:Cc:From:Date:From;
        b=NGTOHOwCmDJdbX0k6ot7OZmrYDap779lA59QIrz9CePnBBdz8ylkpdkGUWI0fgEnH
         EtP/GW1klaE1G8dVq3VM206fLMEsD1VH5jhVUuOMDUJ/7WBaliQthqQVr5w+eOLDxu
         fwm7SLuoz1B4vbgdlir8MuWu2mEMl3RnGUZGgnW8=
Subject: FAILED: patch "[PATCH] udp: advertise ipv6 udp support for msghdr::ubuf_info" failed to apply to 6.0-stable tree
To:     asml.silence@gmail.com, kuba@kernel.org, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 07 Nov 2022 16:26:52 +0100
Message-ID: <1667834812143139@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 6.0-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

8f279fb00bb2 ("udp: advertise ipv6 udp support for msghdr::ubuf_info")
d38afeec26ed ("tcp/udp: Call inet6_destroy_sock() in IPv6 sk->sk_destruct().")
21985f43376c ("udp: Call inet6_destroy_sock() in setsockopt(IPV6_ADDRFORM).")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 8f279fb00bb29def9ac79e28c5d6d8e07d21f3fb Mon Sep 17 00:00:00 2001
From: Pavel Begunkov <asml.silence@gmail.com>
Date: Thu, 27 Oct 2022 00:25:56 +0100
Subject: [PATCH] udp: advertise ipv6 udp support for msghdr::ubuf_info

Mark udp ipv6 as supporting msghdr::ubuf_info. In the original commit
SOCK_SUPPORT_ZC was supposed to be set by a udp_init_sock() call from
udp6_init_sock(), but
d38afeec26ed4 ("tcp/udp: Call inet6_destroy_sock() in IPv6 ...")
removed it and so ipv6 udp misses the flag.

Cc: <stable@vger.kernel.org> # 6.0
Fixes: e993ffe3da4bc ("net: flag sockets supporting msghdr originated zerocopy")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>

diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 129ec5a9b0eb..bc65e5b7195b 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -66,6 +66,7 @@ int udpv6_init_sock(struct sock *sk)
 {
 	skb_queue_head_init(&udp_sk(sk)->reader_queue);
 	sk->sk_destruct = udpv6_destruct_sock;
+	set_bit(SOCK_SUPPORT_ZC, &sk->sk_socket->flags);
 	return 0;
 }
 

