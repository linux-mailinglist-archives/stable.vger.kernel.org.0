Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77FDC40E6AA
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:31:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348138AbhIPRX6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:23:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:43516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346889AbhIPRV5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:21:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 491C961462;
        Thu, 16 Sep 2021 16:42:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810558;
        bh=JZ9MTYb74+DaVR3kO13l/TOFbMF1Vw4Aj+rV2emckYk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JW5vP+sDGGNUhxURTozpYDPN/eG1fcdAhQezELOC3rnqRRO0+0l3jEtilkW36u7uH
         1ovqK3qDcLsFur+1s4cpQ+RAMyppnWj8yZe631L2qA/ux799gM/QR/G77JPwSHTJp2
         XOipgSmhlZxgtgebYoHVvzEbjUl8Ld7TSUPIDTpw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yonghong Song <yhs@fb.com>,
        Yajun Deng <yajun.deng@linux.dev>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 185/432] netlink: Deal with ESRCH error in nlmsg_notify()
Date:   Thu, 16 Sep 2021 17:58:54 +0200
Message-Id: <20210916155817.005670614@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yajun Deng <yajun.deng@linux.dev>

[ Upstream commit fef773fc8110d8124c73a5e6610f89e52814637d ]

Yonghong Song report:
The bpf selftest tc_bpf failed with latest bpf-next.
The following is the command to run and the result:
$ ./test_progs -n 132
[   40.947571] bpf_testmod: loading out-of-tree module taints kernel.
test_tc_bpf:PASS:test_tc_bpf__open_and_load 0 nsec
test_tc_bpf:PASS:bpf_tc_hook_create(BPF_TC_INGRESS) 0 nsec
test_tc_bpf:PASS:bpf_tc_hook_create invalid hook.attach_point 0 nsec
test_tc_bpf_basic:PASS:bpf_obj_get_info_by_fd 0 nsec
test_tc_bpf_basic:PASS:bpf_tc_attach 0 nsec
test_tc_bpf_basic:PASS:handle set 0 nsec
test_tc_bpf_basic:PASS:priority set 0 nsec
test_tc_bpf_basic:PASS:prog_id set 0 nsec
test_tc_bpf_basic:PASS:bpf_tc_attach replace mode 0 nsec
test_tc_bpf_basic:PASS:bpf_tc_query 0 nsec
test_tc_bpf_basic:PASS:handle set 0 nsec
test_tc_bpf_basic:PASS:priority set 0 nsec
test_tc_bpf_basic:PASS:prog_id set 0 nsec
libbpf: Kernel error message: Failed to send filter delete notification
test_tc_bpf_basic:FAIL:bpf_tc_detach unexpected error: -3 (errno 3)
test_tc_bpf:FAIL:test_tc_internal ingress unexpected error: -3 (errno 3)

The failure seems due to the commit
    cfdf0d9ae75b ("rtnetlink: use nlmsg_notify() in rtnetlink_send()")

Deal with ESRCH error in nlmsg_notify() even the report variable is zero.

Reported-by: Yonghong Song <yhs@fb.com>
Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
Link: https://lore.kernel.org/r/20210719051816.11762-1-yajun.deng@linux.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netlink/af_netlink.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 380f95aacdec..24b7cf447bc5 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -2545,13 +2545,15 @@ int nlmsg_notify(struct sock *sk, struct sk_buff *skb, u32 portid,
 		/* errors reported via destination sk->sk_err, but propagate
 		 * delivery errors if NETLINK_BROADCAST_ERROR flag is set */
 		err = nlmsg_multicast(sk, skb, exclude_portid, group, flags);
+		if (err == -ESRCH)
+			err = 0;
 	}
 
 	if (report) {
 		int err2;
 
 		err2 = nlmsg_unicast(sk, skb, portid);
-		if (!err || err == -ESRCH)
+		if (!err)
 			err = err2;
 	}
 
-- 
2.30.2



