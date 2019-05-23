Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20C0A2887C
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:40:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390205AbfEWT0r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:26:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:38648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391407AbfEWT0n (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:26:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 883352054F;
        Thu, 23 May 2019 19:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558639603;
        bh=E8Fez+UjFAXlTw7Yz7IfL44Gcey0YmhWjuPBqO4+gB0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=slQcr1KyTVuyuiQGW74AGrVeIYg6dtpIZxbEGun4GhGdnJ0ccYDTwWIkkINqu4QRh
         SBEnaBeMIGKKYQIoW7Zrz/CM6sK5dhgqbkcn3piyKDvbmFEsxXpsw0ngByoQDAbIru
         zSPL+vRrlwIePUJcWU06L2bIwW6tZo3jFAWlTKc4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Guillaume Nault <gnault@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.1 009/122] ppp: deflate: Fix possible crash in deflate_init
Date:   Thu, 23 May 2019 21:05:31 +0200
Message-Id: <20190523181706.253522161@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181705.091418060@linuxfoundation.org>
References: <20190523181705.091418060@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit 3ebe1bca58c85325c97a22d4fc3f5b5420752e6f ]

BUG: unable to handle kernel paging request at ffffffffa018f000
PGD 3270067 P4D 3270067 PUD 3271063 PMD 2307eb067 PTE 0
Oops: 0000 [#1] PREEMPT SMP
CPU: 0 PID: 4138 Comm: modprobe Not tainted 5.1.0-rc7+ #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
rel-1.9.3-0-ge2fc41e-prebuilt.qemu-project.org 04/01/2014
RIP: 0010:ppp_register_compressor+0x3e/0xd0 [ppp_generic]
Code: 98 4a 3f e2 48 8b 15 c1 67 00 00 41 8b 0c 24 48 81 fa 40 f0 19 a0
75 0e eb 35 48 8b 12 48 81 fa 40 f0 19 a0 74
RSP: 0018:ffffc90000d93c68 EFLAGS: 00010287
RAX: ffffffffa018f000 RBX: ffffffffa01a3000 RCX: 000000000000001a
RDX: ffff888230c750a0 RSI: 0000000000000000 RDI: ffffffffa019f000
RBP: ffffc90000d93c80 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffffa0194080
R13: ffff88822ee1a700 R14: 0000000000000000 R15: ffffc90000d93e78
FS:  00007f2339557540(0000) GS:ffff888237a00000(0000)
knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffa018f000 CR3: 000000022bde4000 CR4: 00000000000006f0
Call Trace:
 ? 0xffffffffa01a3000
 deflate_init+0x11/0x1000 [ppp_deflate]
 ? 0xffffffffa01a3000
 do_one_initcall+0x6c/0x3cc
 ? kmem_cache_alloc_trace+0x248/0x3b0
 do_init_module+0x5b/0x1f1
 load_module+0x1db1/0x2690
 ? m_show+0x1d0/0x1d0
 __do_sys_finit_module+0xc5/0xd0
 __x64_sys_finit_module+0x15/0x20
 do_syscall_64+0x6b/0x1d0
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

If ppp_deflate fails to register in deflate_init,
module initialization failed out, however
ppp_deflate_draft may has been regiestred and not
unregistered before return.
Then the seconed modprobe will trigger crash like this.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Acked-by: Guillaume Nault <gnault@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ppp/ppp_deflate.c |   20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

--- a/drivers/net/ppp/ppp_deflate.c
+++ b/drivers/net/ppp/ppp_deflate.c
@@ -610,12 +610,20 @@ static struct compressor ppp_deflate_dra
 
 static int __init deflate_init(void)
 {
-        int answer = ppp_register_compressor(&ppp_deflate);
-        if (answer == 0)
-                printk(KERN_INFO
-		       "PPP Deflate Compression module registered\n");
-	ppp_register_compressor(&ppp_deflate_draft);
-        return answer;
+	int rc;
+
+	rc = ppp_register_compressor(&ppp_deflate);
+	if (rc)
+		return rc;
+
+	rc = ppp_register_compressor(&ppp_deflate_draft);
+	if (rc) {
+		ppp_unregister_compressor(&ppp_deflate);
+		return rc;
+	}
+
+	pr_info("PPP Deflate Compression module registered\n");
+	return 0;
 }
 
 static void __exit deflate_cleanup(void)


