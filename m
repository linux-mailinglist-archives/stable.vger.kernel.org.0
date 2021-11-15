Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9C36450C4A
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:34:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236842AbhKORhI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:37:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:46318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237821AbhKOReR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:34:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 88FAE6327E;
        Mon, 15 Nov 2021 17:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636996953;
        bh=6Ejb+7Z/Mh8j00qGKGv1U3V/v2/YhXlJNQKrjyjAbM4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=slXHA7tW2HkER0IiT6RX7tHMKuKzODNdpKVnVV//UlIjssDYGX3CrzbV5dg/Bt5Zu
         H1AIsrQgq7X0/FyYDeJSWMbRFIbxTt9ML42Bykbkcm/7/hiows07QzTdrJqFRoFQPi
         +FoRs1NIHmod1jTmx/23w0ZAbeP88WMKQhaL9mvo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefano Garzarella <sgarzare@redhat.com>,
        Eiichi Tsukata <eiichi.tsukata@nutanix.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 329/355] vsock: prevent unnecessary refcnt inc for nonblocking connect
Date:   Mon, 15 Nov 2021 18:04:13 +0100
Message-Id: <20211115165324.378542719@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165313.549179499@linuxfoundation.org>
References: <20211115165313.549179499@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eiichi Tsukata <eiichi.tsukata@nutanix.com>

[ Upstream commit c7cd82b90599fa10915f41e3dd9098a77d0aa7b6 ]

Currently vosck_connect() increments sock refcount for nonblocking
socket each time it's called, which can lead to memory leak if
it's called multiple times because connect timeout function decrements
sock refcount only once.

Fixes it by making vsock_connect() return -EALREADY immediately when
sock state is already SS_CONNECTING.

Fixes: d021c344051a ("VSOCK: Introduce VM Sockets")
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Eiichi Tsukata <eiichi.tsukata@nutanix.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/vmw_vsock/af_vsock.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index d4104144bab1b..bc8055f4571bc 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1151,6 +1151,8 @@ static int vsock_stream_connect(struct socket *sock, struct sockaddr *addr,
 		 * non-blocking call.
 		 */
 		err = -EALREADY;
+		if (flags & O_NONBLOCK)
+			goto out;
 		break;
 	default:
 		if ((sk->sk_state == TCP_LISTEN) ||
-- 
2.33.0



