Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F3E22B60AD
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:12:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729283AbgKQNLo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:11:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:41132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729653AbgKQNLe (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:11:34 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6E4852225B;
        Tue, 17 Nov 2020 13:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605618694;
        bh=33t2sEFD7HiJJdi6UIdhZIYryonyPeTKXtS0onprdyw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fgwZKv6WHY/GgWlM2FIP6osJPmzCWIpoJFgxujz0ULxrXBZalkrBuKkVAStlOZq8j
         lfUAlMWxmlZm+wbKcnvT4Ef2+S9eLSAs5h5YqAcEYWmgtLCPtZtO5uZEJPIw5MvNjx
         DAHfshZqKz83mxhWCpX871fNSuBqmy1hU0DjSgy4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vasily Gorbik <gor@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.9 54/78] net/af_iucv: fix null pointer dereference on shutdown
Date:   Tue, 17 Nov 2020 14:05:20 +0100
Message-Id: <20201117122111.762419564@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122109.116890262@linuxfoundation.org>
References: <20201117122109.116890262@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ursula Braun <ubraun@linux.ibm.com>

[ Upstream commit 4031eeafa71eaf22ae40a15606a134ae86345daf ]

syzbot reported the following KASAN finding:

BUG: KASAN: nullptr-dereference in iucv_send_ctrl+0x390/0x3f0 net/iucv/af_iucv.c:385
Read of size 2 at addr 000000000000021e by task syz-executor907/519

CPU: 0 PID: 519 Comm: syz-executor907 Not tainted 5.9.0-syzkaller-07043-gbcf9877ad213 #0
Hardware name: IBM 3906 M04 701 (KVM/Linux)
Call Trace:
 [<00000000c576af60>] unwind_start arch/s390/include/asm/unwind.h:65 [inline]
 [<00000000c576af60>] show_stack+0x180/0x228 arch/s390/kernel/dumpstack.c:135
 [<00000000c9dcd1f8>] __dump_stack lib/dump_stack.c:77 [inline]
 [<00000000c9dcd1f8>] dump_stack+0x268/0x2f0 lib/dump_stack.c:118
 [<00000000c5fed016>] print_address_description.constprop.0+0x5e/0x218 mm/kasan/report.c:383
 [<00000000c5fec82a>] __kasan_report mm/kasan/report.c:517 [inline]
 [<00000000c5fec82a>] kasan_report+0x11a/0x168 mm/kasan/report.c:534
 [<00000000c98b5b60>] iucv_send_ctrl+0x390/0x3f0 net/iucv/af_iucv.c:385
 [<00000000c98b6262>] iucv_sock_shutdown+0x44a/0x4c0 net/iucv/af_iucv.c:1457
 [<00000000c89d3a54>] __sys_shutdown+0x12c/0x1c8 net/socket.c:2204
 [<00000000c89d3b70>] __do_sys_shutdown net/socket.c:2212 [inline]
 [<00000000c89d3b70>] __s390x_sys_shutdown+0x38/0x48 net/socket.c:2210
 [<00000000c9e36eac>] system_call+0xe0/0x28c arch/s390/kernel/entry.S:415

There is nothing to shutdown if a connection has never been established.
Besides that iucv->hs_dev is not yet initialized if a socket is in
IUCV_OPEN state and iucv->path is not yet initialized if socket is in
IUCV_BOUND state.
So, just skip the shutdown calls for a socket in these states.

Fixes: eac3731bd04c ("[S390]: Add AF_IUCV socket support")
Fixes: 82492a355fac ("af_iucv: add shutdown for HS transport")
Reviewed-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Ursula Braun <ubraun@linux.ibm.com>
[jwi: correct one Fixes tag]
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/iucv/af_iucv.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/iucv/af_iucv.c
+++ b/net/iucv/af_iucv.c
@@ -1542,7 +1542,8 @@ static int iucv_sock_shutdown(struct soc
 		break;
 	}
 
-	if (how == SEND_SHUTDOWN || how == SHUTDOWN_MASK) {
+	if ((how == SEND_SHUTDOWN || how == SHUTDOWN_MASK) &&
+	    sk->sk_state == IUCV_CONNECTED) {
 		if (iucv->transport == AF_IUCV_TRANS_IUCV) {
 			txmsg.class = 0;
 			txmsg.tag = 0;


