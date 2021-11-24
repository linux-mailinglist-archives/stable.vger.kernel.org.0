Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF89145BC00
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:23:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243397AbhKXMZi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:25:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:38016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244451AbhKXMXe (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:23:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BE3F96109D;
        Wed, 24 Nov 2021 12:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637756047;
        bh=tFGTaT77JZFxI/VUzBar6Lpl+pYtrphfByvjZPpwnog=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jdx+D7hwq8oFGhPNLoHqIA4JqRWkHdyPgKeM10gQfnNAylVumBwGyDVH5FDd6BTUa
         MJBVSvWbAfcT2piP6+iDrwxO+xRYn02wMwenlmZwHOEeOhezKrbZWXLqs+RcgDQiPa
         Z/VzmZ04TFP5r1jH9oW2uMziNwJ/5I3uUDIjg8/w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefano Garzarella <sgarzare@redhat.com>,
        Eiichi Tsukata <eiichi.tsukata@nutanix.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 151/207] vsock: prevent unnecessary refcnt inc for nonblocking connect
Date:   Wed, 24 Nov 2021 12:57:02 +0100
Message-Id: <20211124115708.901588208@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115703.941380739@linuxfoundation.org>
References: <20211124115703.941380739@linuxfoundation.org>
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
index 2fecdfe49bae3..95470d628d34b 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1173,6 +1173,8 @@ static int vsock_stream_connect(struct socket *sock, struct sockaddr *addr,
 		 * non-blocking call.
 		 */
 		err = -EALREADY;
+		if (flags & O_NONBLOCK)
+			goto out;
 		break;
 	default:
 		if ((sk->sk_state == VSOCK_SS_LISTEN) ||
-- 
2.33.0



