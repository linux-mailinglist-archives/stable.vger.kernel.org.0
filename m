Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A71449A967
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:23:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1322557AbiAYDWD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:22:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384459AbiAXU3t (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:29:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CADE2C08B4C8;
        Mon, 24 Jan 2022 11:42:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AC3F161298;
        Mon, 24 Jan 2022 19:42:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B21EC340E5;
        Mon, 24 Jan 2022 19:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053355;
        bh=DJ/cYkr8MzqT7hAfv92BLVMqYFrXoXo4x8FHMhWFLhY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t+7/CjYsdyE+YA7sG8NX6ob2ZHHpbpbKT4ZwadMqnZXDE7VoSZRwC+NTv0nN9vfT2
         WnKPr1uyPbH6EkVK4zlr/0u/FTBtVYeE603HzGN2LcH+m80D/GwbdV8qgS8WhEXAcK
         ZKKLN2hE1FKnjHSSp+OE9boTnxzwfgwvXtAK9Buk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        syzbot+7f23bcddf626e0593a39@syzkaller.appspotmail.com
Subject: [PATCH 5.10 007/563] nfc: llcp: fix NULL error pointer dereference on sendmsg() after failed bind()
Date:   Mon, 24 Jan 2022 19:36:12 +0100
Message-Id: <20220124184024.666216547@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>

commit dded08927ca3c31a5c37f8e7f95fe98770475dd4 upstream.

Syzbot detected a NULL pointer dereference of nfc_llcp_sock->dev pointer
(which is a 'struct nfc_dev *') with calls to llcp_sock_sendmsg() after
a failed llcp_sock_bind(). The message being sent is a SOCK_DGRAM.

KASAN report:

  BUG: KASAN: null-ptr-deref in nfc_alloc_send_skb+0x2d/0xc0
  Read of size 4 at addr 00000000000005c8 by task llcp_sock_nfc_a/899

  CPU: 5 PID: 899 Comm: llcp_sock_nfc_a Not tainted 5.16.0-rc6-next-20211224-00001-gc6437fbf18b0 #125
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-2 04/01/2014
  Call Trace:
   <TASK>
   dump_stack_lvl+0x45/0x59
   ? nfc_alloc_send_skb+0x2d/0xc0
   __kasan_report.cold+0x117/0x11c
   ? mark_lock+0x480/0x4f0
   ? nfc_alloc_send_skb+0x2d/0xc0
   kasan_report+0x38/0x50
   nfc_alloc_send_skb+0x2d/0xc0
   nfc_llcp_send_ui_frame+0x18c/0x2a0
   ? nfc_llcp_send_i_frame+0x230/0x230
   ? __local_bh_enable_ip+0x86/0xe0
   ? llcp_sock_connect+0x470/0x470
   ? llcp_sock_connect+0x470/0x470
   sock_sendmsg+0x8e/0xa0
   ____sys_sendmsg+0x253/0x3f0
   ...

The issue was visible only with multiple simultaneous calls to bind() and
sendmsg(), which resulted in most of the bind() calls to fail.  The
bind() was failing on checking if there is available WKS/SDP/SAP
(respective bit in 'struct nfc_llcp_local' fields).  When there was no
available WKS/SDP/SAP, the bind returned error but the sendmsg() to such
socket was able to trigger mentioned NULL pointer dereference of
nfc_llcp_sock->dev.

The code looks simply racy and currently it protects several paths
against race with checks for (!nfc_llcp_sock->local) which is NULL-ified
in error paths of bind().  The llcp_sock_sendmsg() did not have such
check but called function nfc_llcp_send_ui_frame() had, although not
protected with lock_sock().

Therefore the race could look like (same socket is used all the time):
  CPU0                                     CPU1
  ====                                     ====
  llcp_sock_bind()
  - lock_sock()
    - success
  - release_sock()
  - return 0
                                           llcp_sock_sendmsg()
                                           - lock_sock()
                                           - release_sock()
  llcp_sock_bind(), same socket
  - lock_sock()
    - error
                                           - nfc_llcp_send_ui_frame()
                                             - if (!llcp_sock->local)
    - llcp_sock->local = NULL
    - nfc_put_device(dev)
                                             - dereference llcp_sock->dev
  - release_sock()
  - return -ERRNO

The nfc_llcp_send_ui_frame() checked llcp_sock->local outside of the
lock, which is racy and ineffective check.  Instead, its caller
llcp_sock_sendmsg(), should perform the check inside lock_sock().

Reported-and-tested-by: syzbot+7f23bcddf626e0593a39@syzkaller.appspotmail.com
Fixes: b874dec21d1c ("NFC: Implement LLCP connection less Tx path")
Cc: <stable@vger.kernel.org>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/nfc/llcp_sock.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/net/nfc/llcp_sock.c
+++ b/net/nfc/llcp_sock.c
@@ -789,6 +789,11 @@ static int llcp_sock_sendmsg(struct sock
 
 	lock_sock(sk);
 
+	if (!llcp_sock->local) {
+		release_sock(sk);
+		return -ENODEV;
+	}
+
 	if (sk->sk_type == SOCK_DGRAM) {
 		DECLARE_SOCKADDR(struct sockaddr_nfc_llcp *, addr,
 				 msg->msg_name);


