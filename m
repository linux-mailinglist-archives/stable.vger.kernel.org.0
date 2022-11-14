Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E1AD627EEE
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 13:53:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237467AbiKNMx3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 07:53:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236638AbiKNMx2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 07:53:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB63939B
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 04:53:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 943CCB80EBB
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 12:53:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCCD6C433D6;
        Mon, 14 Nov 2022 12:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668430404;
        bh=7VmevzrAo4k6zlaceoUDn7jawRhRqZLkXxktQl+CVhM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2oz8qizaX0oOqmvolAa06hCKhHmwUuMh4F5NGFs1XYfOjdBH2StdJ3SE0pZGeoq6F
         erTwPG2Lbx38Xc0pIsQADDZimHFLeAjN21QdY+HA/DfQjapIYGdtr0UTBULNLQoR6f
         BBeOvltfgztm+xZYrhMmnM5PBCk4LMN73tTOaCoc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        syzbot+140186ceba0c496183bc@syzkaller.appspotmail.com,
        Hillf Danton <hdanton@sina.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Wang Yufen <wangyufen@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 019/131] bpf: Fix sockmap calling sleepable function in teardown path
Date:   Mon, 14 Nov 2022 13:44:48 +0100
Message-Id: <20221114124449.536112944@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124448.729235104@linuxfoundation.org>
References: <20221114124448.729235104@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Fastabend <john.fastabend@gmail.com>

[ Upstream commit 697fb80a53642be624f5121b6ca9d66769c180e0 ]

syzbot reproduced the bug ...

 BUG: sleeping function called from invalid context at kernel/workqueue.c:3010

... with the following stack trace fragment ...

 start_flush_work kernel/workqueue.c:3010 [inline]
 __flush_work+0x109/0xb10 kernel/workqueue.c:3074
 __cancel_work_timer+0x3f9/0x570 kernel/workqueue.c:3162
 sk_psock_stop+0x4cb/0x630 net/core/skmsg.c:802
 sock_map_destroy+0x333/0x760 net/core/sock_map.c:1581
 inet_csk_destroy_sock+0x196/0x440 net/ipv4/inet_connection_sock.c:1130
 __tcp_close+0xd5b/0x12b0 net/ipv4/tcp.c:2897
 tcp_close+0x29/0xc0 net/ipv4/tcp.c:2909

... introduced by d8616ee2affc. Do a quick trace of the code path and the
bug is obvious:

   inet_csk_destroy_sock(sk)
     sk_prot->destroy(sk);      <--- sock_map_destroy
        sk_psock_stop(, true);   <--- true so cancel workqueue
          cancel_work_sync()     <--- splat, because *_bh_disable()

We can not call cancel_work_sync() from inside destroy path. So mark
the sk_psock_stop call to skip this cancel_work_sync(). This will avoid
the BUG, but means we may run sk_psock_backlog after or during the
destroy op. We zapped the ingress_skb queue in sk_psock_stop (safe to
do with local_bh_disable) so its empty and the sk_psock_backlog work
item will not find any pkts to process here. However, because we are
not going to wait for it or clear its ->state its possible it kicks off
or is already running. This should be 'safe' up until psock drops its
refcnt to psock->sk. The sock_put() that drops this reference is only
done at psock destroy time from sk_psock_destroy(). This is done through
workqueue when sk_psock_drop() is called on psock refnt reaches 0.
And importantly sk_psock_destroy() does a cancel_work_sync(). So trivial
fix works.

I've had hit or miss luck reproducing this caught it once or twice with
the provided reproducer when running with many runners. However, syzkaller
is very good at reproducing so relying on syzkaller to verify fix.

Fixes: d8616ee2affc ("bpf, sockmap: Fix sk->sk_forward_alloc warn_on in sk_stream_kill_queues")
Reported-by: syzbot+140186ceba0c496183bc@syzkaller.appspotmail.com
Suggested-by: Hillf Danton <hdanton@sina.com>
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Cc: Wang Yufen <wangyufen@huawei.com>
Link: https://lore.kernel.org/bpf/20220628035803.317876-1-john.fastabend@gmail.com
Stable-dep-of: 8bbabb3fddcd ("bpf, sock_map: Move cancel_work_sync() out of sock lock")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/sock_map.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index 43563d651ed0..6eef46eafb3e 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -1541,7 +1541,7 @@ void sock_map_destroy(struct sock *sk)
 	saved_destroy = psock->saved_destroy;
 	sock_map_remove_links(sk, psock);
 	rcu_read_unlock();
-	sk_psock_stop(psock, true);
+	sk_psock_stop(psock, false);
 	sk_psock_put(sk, psock);
 	saved_destroy(sk);
 }
-- 
2.35.1



