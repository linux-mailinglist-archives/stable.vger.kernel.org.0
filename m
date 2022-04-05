Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AE884F3079
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:27:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353994AbiDEKKV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:10:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346930AbiDEJYu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:24:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D731A147D;
        Tue,  5 Apr 2022 02:14:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 45459B81C19;
        Tue,  5 Apr 2022 09:14:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4E8CC385A9;
        Tue,  5 Apr 2022 09:14:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649150044;
        bh=UO2eg/kU3zQNVWeY1pHzVEaHjxnStJIMnFDNAI8p7yE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ex4VLcq+6y7rtXALu2BlzJUHrMNkhh7ZMxXGyJnvmUAow87ybx2YWPk+LyXaYvAdk
         NvyXevKj2M5U6xRQPAStimyNUVZzTCg9kWlkWqkqZNdc4yDl3suKD9qjdbXWklPCGO
         +Xk1Ba/dcYQXl2aDLL0EwmX58LFtJI6sOGJPCMuk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Xiaolong Huang <butterflyhuangxx@gmail.com>,
        David Howells <dhowells@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.16 0935/1017] rxrpc: fix some null-ptr-deref bugs in server_key.c
Date:   Tue,  5 Apr 2022 09:30:48 +0200
Message-Id: <20220405070421.968045401@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiaolong Huang <butterflyhuangxx@gmail.com>

commit ff8376ade4f668130385839cef586a0990f8ef87 upstream.

Some function calls are not implemented in rxrpc_no_security, there are
preparse_server_key, free_preparse_server_key and destroy_server_key.
When rxrpc security type is rxrpc_no_security, user can easily trigger a
null-ptr-deref bug via ioctl. So judgment should be added to prevent it

The crash log:
user@syzkaller:~$ ./rxrpc_preparse_s
[   37.956878][T15626] BUG: kernel NULL pointer dereference, address: 0000000000000000
[   37.957645][T15626] #PF: supervisor instruction fetch in kernel mode
[   37.958229][T15626] #PF: error_code(0x0010) - not-present page
[   37.958762][T15626] PGD 4aadf067 P4D 4aadf067 PUD 4aade067 PMD 0
[   37.959321][T15626] Oops: 0010 [#1] PREEMPT SMP
[   37.959739][T15626] CPU: 0 PID: 15626 Comm: rxrpc_preparse_ Not tainted 5.17.0-01442-gb47d5a4f6b8d #43
[   37.960588][T15626] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1ubuntu1 04/01/2014
[   37.961474][T15626] RIP: 0010:0x0
[   37.961787][T15626] Code: Unable to access opcode bytes at RIP 0xffffffffffffffd6.
[   37.962480][T15626] RSP: 0018:ffffc9000d9abdc0 EFLAGS: 00010286
[   37.963018][T15626] RAX: ffffffff84335200 RBX: ffff888012a1ce80 RCX: 0000000000000000
[   37.963727][T15626] RDX: 0000000000000000 RSI: ffffffff84a736dc RDI: ffffc9000d9abe48
[   37.964425][T15626] RBP: ffffc9000d9abe48 R08: 0000000000000000 R09: 0000000000000002
[   37.965118][T15626] R10: 000000000000000a R11: f000000000000000 R12: ffff888013145680
[   37.965836][T15626] R13: 0000000000000000 R14: ffffffffffffffec R15: ffff8880432aba80
[   37.966441][T15626] FS:  00007f2177907700(0000) GS:ffff88803ec00000(0000) knlGS:0000000000000000
[   37.966979][T15626] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   37.967384][T15626] CR2: ffffffffffffffd6 CR3: 000000004aaf1000 CR4: 00000000000006f0
[   37.967864][T15626] Call Trace:
[   37.968062][T15626]  <TASK>
[   37.968240][T15626]  rxrpc_preparse_s+0x59/0x90
[   37.968541][T15626]  key_create_or_update+0x174/0x510
[   37.968863][T15626]  __x64_sys_add_key+0x139/0x1d0
[   37.969165][T15626]  do_syscall_64+0x35/0xb0
[   37.969451][T15626]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[   37.969824][T15626] RIP: 0033:0x43a1f9

Signed-off-by: Xiaolong Huang <butterflyhuangxx@gmail.com>
Tested-by: Xiaolong Huang <butterflyhuangxx@gmail.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
Link: http://lists.infradead.org/pipermail/linux-afs/2022-March/005069.html
Fixes: 12da59fcab5a ("rxrpc: Hand server key parsing off to the security class")
Link: https://lore.kernel.org/r/164865013439.2941502.8966285221215590921.stgit@warthog.procyon.org.uk
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rxrpc/server_key.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/net/rxrpc/server_key.c
+++ b/net/rxrpc/server_key.c
@@ -84,6 +84,9 @@ static int rxrpc_preparse_s(struct key_p
 
 	prep->payload.data[1] = (struct rxrpc_security *)sec;
 
+	if (!sec->preparse_server_key)
+		return -EINVAL;
+
 	return sec->preparse_server_key(prep);
 }
 
@@ -91,7 +94,7 @@ static void rxrpc_free_preparse_s(struct
 {
 	const struct rxrpc_security *sec = prep->payload.data[1];
 
-	if (sec)
+	if (sec && sec->free_preparse_server_key)
 		sec->free_preparse_server_key(prep);
 }
 
@@ -99,7 +102,7 @@ static void rxrpc_destroy_s(struct key *
 {
 	const struct rxrpc_security *sec = key->payload.data[1];
 
-	if (sec)
+	if (sec && sec->destroy_server_key)
 		sec->destroy_server_key(key);
 }
 


