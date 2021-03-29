Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D20634CA85
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:41:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234100AbhC2Iit (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:38:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:53654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234785AbhC2IhV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:37:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F40E8619C4;
        Mon, 29 Mar 2021 08:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617007002;
        bh=50bq1V/OJBYTOS4GglO9HpASZA32TGS3U7ESGsOpvcc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GOBukRRkSPQc4lUFfMr6SLkDS1bSZeAKoAT2uSXjjbkNcnry4itMc+tG0naIhxMKC
         wTNsRo1SK6QzjufIHBD2hoZQcE0w0sRHVfU6N6cF73BH3Bceknq/7XrROE7tNKCHkI
         HQcIYHLAnTpI0K10OzfQIbHfkB4IRc3sy9xeGqZ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Brazdil <dbrazdil@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 184/254] selinux: vsock: Set SID for socket returned by accept()
Date:   Mon, 29 Mar 2021 09:58:20 +0200
Message-Id: <20210329075639.181254030@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075633.135869143@linuxfoundation.org>
References: <20210329075633.135869143@linuxfoundation.org>
User-Agent: quilt/0.66
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



