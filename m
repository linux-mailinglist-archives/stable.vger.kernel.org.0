Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C042E34D570
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 18:51:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230271AbhC2QvM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 12:51:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:44746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230226AbhC2Qun (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 12:50:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 44CEC6196E;
        Mon, 29 Mar 2021 16:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617036643;
        bh=nGbjRJPc3LENsU9Uwhq8QAKiUPu0Cg0wVKlmqA5w0Ec=;
        h=From:To:Cc:Subject:Date:From;
        b=OIMN++Kc9sjyH8pz/29nAfYKbnnN2pDCB70FFOoYKBLOccRki+1eKp5mqgHaW7d7q
         XvwTlTDHhcoB/HJB35jFg/QpWZLboMosxNxgMhJ9BdAe3WX2zUZz/1ky08sTTKrFUg
         zjoqsd+fjsmLppqpihTVXncm3JT3oheO121JecYyfRB4719xZML7mrJTSWnvrGLKdM
         Xz3NWcT8Jcg6oDD8ZKbRkiDIr70P4erNS2ESeQQIpo4A5UskzNK423FQI41Ed396oP
         I5G+cD/MWx8rPkiIXSGL5cRvB+jSDm74IqSc7kN44RdG69+WJYyHT0fV94ke4dA4+D
         PHRJJPK60Qwrg==
From:   Sasha Levin <sashal@kernel.org>
To:     stable@vger.kernel.org, dbrazdil@google.com
Cc:     "David S . Miller" <davem@davemloft.net>
Subject: FAILED: Patch "selinux: vsock: Set SID for socket returned by accept()" failed to apply to 5.4-stable tree
Date:   Mon, 29 Mar 2021 12:50:42 -0400
Message-Id: <20210329165042.2358531-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Thanks,
Sasha

------------------ original commit in Linus's tree ------------------

From 1f935e8e72ec28dddb2dc0650b3b6626a293d94b Mon Sep 17 00:00:00 2001
From: David Brazdil <dbrazdil@google.com>
Date: Fri, 19 Mar 2021 13:05:41 +0000
Subject: [PATCH] selinux: vsock: Set SID for socket returned by accept()

For AF_VSOCK, accept() currently returns sockets that are unlabelled.
Other socket families derive the child's SID from the SID of the parent
and the SID of the incoming packet. This is typically done as the
connected socket is placed in the queue that accept() removes from.

Reuse the existing 'security_sk_clone' hook to copy the SID from the
parent (server) socket to the child. There is no packet SID in this
case.

Fixes: d021c344051a ("VSOCK: Introduce VM Sockets")
Signed-off-by: David Brazdil <dbrazdil@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 net/vmw_vsock/af_vsock.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 5546710d8ac1..bc7fb9bf3351 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -755,6 +755,7 @@ static struct sock *__vsock_create(struct net *net,
 		vsk->buffer_size = psk->buffer_size;
 		vsk->buffer_min_size = psk->buffer_min_size;
 		vsk->buffer_max_size = psk->buffer_max_size;
+		security_sk_clone(parent, sk);
 	} else {
 		vsk->trusted = ns_capable_noaudit(&init_user_ns, CAP_NET_ADMIN);
 		vsk->owner = get_current_cred();
-- 
2.30.1




