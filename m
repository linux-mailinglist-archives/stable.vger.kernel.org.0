Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C80A93A038A
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:24:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236336AbhFHTSN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 15:18:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:39732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236062AbhFHTQJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 15:16:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 95CD161969;
        Tue,  8 Jun 2021 18:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623178253;
        bh=XP8RtZB5I8hcyEmuu0P6ZC+uh588io2AMGX5lGpuJJs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s513FVk3HQp7sLTYSjQl1CJpEl7f4Vad8NfutD2Au08l/ey0B7bqdVsjb60MymbjZ
         pK4wZxqcVjZJcwhBz1MjQyeaCeUkFePyJIwPSzv8bC6waVdCxjnUfkTLu8BI67+4IE
         RuLx5V73HgMK5+Bl+dTrWSkMQ8WkzUTwdIjwUY9A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+80fb126e7f7d8b1a5914@syzkaller.appspotmail.com,
        butt3rflyh4ck <butterflyhuangxx@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.12 134/161] nfc: fix NULL ptr dereference in llcp_sock_getname() after failed connect
Date:   Tue,  8 Jun 2021 20:27:44 +0200
Message-Id: <20210608175949.976605371@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175945.476074951@linuxfoundation.org>
References: <20210608175945.476074951@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>

commit 4ac06a1e013cf5fdd963317ffd3b968560f33bba upstream.

It's possible to trigger NULL pointer dereference by local unprivileged
user, when calling getsockname() after failed bind() (e.g. the bind
fails because LLCP_SAP_MAX used as SAP):

  BUG: kernel NULL pointer dereference, address: 0000000000000000
  CPU: 1 PID: 426 Comm: llcp_sock_getna Not tainted 5.13.0-rc2-next-20210521+ #9
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-1 04/01/2014
  Call Trace:
   llcp_sock_getname+0xb1/0xe0
   __sys_getpeername+0x95/0xc0
   ? lockdep_hardirqs_on_prepare+0xd5/0x180
   ? syscall_enter_from_user_mode+0x1c/0x40
   __x64_sys_getpeername+0x11/0x20
   do_syscall_64+0x36/0x70
   entry_SYSCALL_64_after_hwframe+0x44/0xae

This can be reproduced with Syzkaller C repro (bind followed by
getpeername):
https://syzkaller.appspot.com/x/repro.c?x=14def446e00000

Cc: <stable@vger.kernel.org>
Fixes: d646960f7986 ("NFC: Initial LLCP support")
Reported-by: syzbot+80fb126e7f7d8b1a5914@syzkaller.appspotmail.com
Reported-by: butt3rflyh4ck <butterflyhuangxx@gmail.com>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Link: https://lore.kernel.org/r/20210531072138.5219-1-krzysztof.kozlowski@canonical.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/nfc/llcp_sock.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/nfc/llcp_sock.c
+++ b/net/nfc/llcp_sock.c
@@ -110,6 +110,7 @@ static int llcp_sock_bind(struct socket
 	if (!llcp_sock->service_name) {
 		nfc_llcp_local_put(llcp_sock->local);
 		llcp_sock->local = NULL;
+		llcp_sock->dev = NULL;
 		ret = -ENOMEM;
 		goto put_dev;
 	}
@@ -119,6 +120,7 @@ static int llcp_sock_bind(struct socket
 		llcp_sock->local = NULL;
 		kfree(llcp_sock->service_name);
 		llcp_sock->service_name = NULL;
+		llcp_sock->dev = NULL;
 		ret = -EADDRINUSE;
 		goto put_dev;
 	}


