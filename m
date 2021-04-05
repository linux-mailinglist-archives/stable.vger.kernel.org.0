Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A01E9353DE4
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:32:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237513AbhDEJCx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:02:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:44840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237532AbhDEJCu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:02:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D564360238;
        Mon,  5 Apr 2021 09:02:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613363;
        bh=M2CAMc2Rsi/a7hwUtYtSmhM51e7EIuEoKYhW1/uKXkw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AY08b65TdPnO0qm4I9AZzk/PNiUQw83qJjlXEnqjiyr/Hcq7jVHuVQbgRsxuYNz9G
         5D0GsaBBwwKqLVBFK+4yRlV9A7eTrNSQD5shhSRdFUU0EYpljan7iWlAoDyjJXmsHB
         qJxAi1dg0i3Xd0ALj5LPosfFaRJeb4+k9dmDds9k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Brazdil <dbrazdil@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 01/74] selinux: vsock: Set SID for socket returned by accept()
Date:   Mon,  5 Apr 2021 10:53:25 +0200
Message-Id: <20210405085024.751624011@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085024.703004126@linuxfoundation.org>
References: <20210405085024.703004126@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Brazdil <dbrazdil@google.com>

[ Upstream commit 1f935e8e72ec28dddb2dc0650b3b6626a293d94b ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/vmw_vsock/af_vsock.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 5d323574d04f..c82e7b52ab1f 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -620,6 +620,7 @@ struct sock *__vsock_create(struct net *net,
 		vsk->trusted = psk->trusted;
 		vsk->owner = get_cred(psk->owner);
 		vsk->connect_timeout = psk->connect_timeout;
+		security_sk_clone(parent, sk);
 	} else {
 		vsk->trusted = ns_capable_noaudit(&init_user_ns, CAP_NET_ADMIN);
 		vsk->owner = get_current_cred();
-- 
2.30.1



