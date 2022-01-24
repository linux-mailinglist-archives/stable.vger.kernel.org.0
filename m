Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E4704999AB
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:46:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1455949AbiAXVgx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:36:53 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:33426 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376812AbiAXVN3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:13:29 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 119ADB81257;
        Mon, 24 Jan 2022 21:13:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34B92C340E5;
        Mon, 24 Jan 2022 21:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058803;
        bh=O3sG/Btl6e9DGVuCw18nvCdoB8UchlCudc/UsJkn/Hk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0HWzAqn6K1pIXcyayX/B7nW9zHwJIC0ySKulUEKK/xDiXOjqqK4JfldH/fPXIgv28
         X3r65Yq2Ar6TnzTXGJxNuNOti8e24k/KLZ0hRzJrQL1F75bsBV93oXLkiVnkHZYrcC
         9pZmdZ130gmMyI0KokQqXE7OIi/9eDzNLuZD5j2Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+bb73e71cf4b8fd376a4f@syzkaller.appspotmail.com,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0374/1039] bpf, sockmap: Fix double bpf_prog_put on error case in map_link
Date:   Mon, 24 Jan 2022 19:36:03 +0100
Message-Id: <20220124184137.887370933@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Fastabend <john.fastabend@gmail.com>

[ Upstream commit 218d747a4142f281a256687bb513a135c905867b ]

sock_map_link() is called to update a sockmap entry with a sk. But, if the
sock_map_init_proto() call fails then we return an error to the map_update
op against the sockmap. In the error path though we need to cleanup psock
and dec the refcnt on any programs associated with the map, because we
refcnt them early in the update process to ensure they are pinned for the
psock. (This avoids a race where user deletes programs while also updating
the map with new socks.)

In current code we do the prog refcnt dec explicitely by calling
bpf_prog_put() when the program was found in the map. But, after commit
'38207a5e81230' in this error path we've already done the prog to psock
assignment so the programs have a reference from the psock as well. This
then causes the psock tear down logic, invoked by sk_psock_put() in the
error path, to similarly call bpf_prog_put on the programs there.

To be explicit this logic does the prog->psock assignment:

  if (msg_*)
    psock_set_prog(...)

Then the error path under the out_progs label does a similar check and
dec with:

  if (msg_*)
     bpf_prog_put(...)

And the teardown logic sk_psock_put() does ...

  psock_set_prog(msg_*, NULL)

... triggering another bpf_prog_put(...). Then KASAN gives us this splat,
found by syzbot because we've created an inbalance between bpf_prog_inc and
bpf_prog_put calling put twice on the program.

  BUG: KASAN: vmalloc-out-of-bounds in __bpf_prog_put kernel/bpf/syscall.c:1812 [inline]
  BUG: KASAN: vmalloc-out-of-bounds in __bpf_prog_put kernel/bpf/syscall.c:1812 [inline] kernel/bpf/syscall.c:1829
  BUG: KASAN: vmalloc-out-of-bounds in bpf_prog_put+0x8c/0x4f0 kernel/bpf/syscall.c:1829 kernel/bpf/syscall.c:1829
  Read of size 8 at addr ffffc90000e76038 by task syz-executor020/3641

To fix clean up error path so it doesn't try to do the bpf_prog_put in the
error path once progs are assigned then it relies on the normal psock
tear down logic to do complete cleanup.

For completness we also cover the case whereh sk_psock_init_strp() fails,
but this is not expected because it indicates an incorrect socket type
and should be caught earlier.

Fixes: 38207a5e8123 ("bpf, sockmap: Attach map progs to psock early for feature probes")
Reported-by: syzbot+bb73e71cf4b8fd376a4f@syzkaller.appspotmail.com
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20220104214645.290900-1-john.fastabend@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/sock_map.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index 4ca4b11f4e5ff..687c81386518c 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -292,15 +292,23 @@ static int sock_map_link(struct bpf_map *map, struct sock *sk)
 	if (skb_verdict)
 		psock_set_prog(&psock->progs.skb_verdict, skb_verdict);
 
+	/* msg_* and stream_* programs references tracked in psock after this
+	 * point. Reference dec and cleanup will occur through psock destructor
+	 */
 	ret = sock_map_init_proto(sk, psock);
-	if (ret < 0)
-		goto out_drop;
+	if (ret < 0) {
+		sk_psock_put(sk, psock);
+		goto out;
+	}
 
 	write_lock_bh(&sk->sk_callback_lock);
 	if (stream_parser && stream_verdict && !psock->saved_data_ready) {
 		ret = sk_psock_init_strp(sk, psock);
-		if (ret)
-			goto out_unlock_drop;
+		if (ret) {
+			write_unlock_bh(&sk->sk_callback_lock);
+			sk_psock_put(sk, psock);
+			goto out;
+		}
 		sk_psock_start_strp(sk, psock);
 	} else if (!stream_parser && stream_verdict && !psock->saved_data_ready) {
 		sk_psock_start_verdict(sk,psock);
@@ -309,10 +317,6 @@ static int sock_map_link(struct bpf_map *map, struct sock *sk)
 	}
 	write_unlock_bh(&sk->sk_callback_lock);
 	return 0;
-out_unlock_drop:
-	write_unlock_bh(&sk->sk_callback_lock);
-out_drop:
-	sk_psock_put(sk, psock);
 out_progs:
 	if (skb_verdict)
 		bpf_prog_put(skb_verdict);
@@ -325,6 +329,7 @@ out_put_stream_parser:
 out_put_stream_verdict:
 	if (stream_verdict)
 		bpf_prog_put(stream_verdict);
+out:
 	return ret;
 }
 
-- 
2.34.1



