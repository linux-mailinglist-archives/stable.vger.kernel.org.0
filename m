Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 766C745252D
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:44:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352049AbhKPBrC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:47:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:56284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240836AbhKOSQh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:16:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7B167633EA;
        Mon, 15 Nov 2021 17:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998627;
        bh=a7OMn0YFCZkpcYS/A6FAT4bxPuZiIcShRV1DyD0NRis=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yVNQGU96V5ZRK8MsiSU7iImQxFdcrcNm4wKMMPTdH47aXjYt/YcmFoD+HIskJJCew
         +WcKNdKv87FqAZdSC2gU+1rDMHrmFy/L02WyQ+wX3KJU3NVLi9418N0GsF972O7q+Z
         Je2dXhGluIiYfmI+4qi7l2DWgQMIGX5CyHjYXY4c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefano Garzarella <sgarzare@redhat.com>,
        Eiichi Tsukata <eiichi.tsukata@nutanix.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 535/575] vsock: prevent unnecessary refcnt inc for nonblocking connect
Date:   Mon, 15 Nov 2021 18:04:20 +0100
Message-Id: <20211115165402.177569284@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
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
index 326250513570e..7fe36dbcbe187 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1279,6 +1279,8 @@ static int vsock_stream_connect(struct socket *sock, struct sockaddr *addr,
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



