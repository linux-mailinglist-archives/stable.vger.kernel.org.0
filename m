Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5019C3CA5FE
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 20:42:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235924AbhGOSpl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 14:45:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:46434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235859AbhGOSpk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 14:45:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BE8DD613CA;
        Thu, 15 Jul 2021 18:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626374566;
        bh=mBvZYToQtkgC6df+fX3mmDN1sKeSJlBaaQtmS/9AmRk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HmwCVQrO/RCe/bYAclhzDuu19yih18oiPliKng5SzDQuBDCw/9Jmka2KbZ528QA5u
         yIVg6yBOG1DCAn1zC8uI5cDYQwSVPHogkevqUlaQ3TFyt/Wg4EeuWd4xb1X266TUw2
         umeizZjm52sRLee1gx1FFiRgnlZywQCq+ag44/QA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Andra Paraschiv <andraprs@amazon.com>,
        Colin Ian King <colin.king@canonical.com>,
        David Brazdil <dbrazdil@google.com>,
        Alexander Popov <alex.popov@linux.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        lixianming <lixianming5@huawei.com>,
        "Longpeng(Mike)" <longpeng2@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 053/122] vsock: notify server to shutdown when client has pending signal
Date:   Thu, 15 Jul 2021 20:38:20 +0200
Message-Id: <20210715182503.180492990@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182448.393443551@linuxfoundation.org>
References: <20210715182448.393443551@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Longpeng(Mike) <longpeng2@huawei.com>

[ Upstream commit c7ff9cff70601ea19245d997bb977344663434c7 ]

The client's sk_state will be set to TCP_ESTABLISHED if the server
replay the client's connect request.

However, if the client has pending signal, its sk_state will be set
to TCP_CLOSE without notify the server, so the server will hold the
corrupt connection.

            client                        server

1. sk_state=TCP_SYN_SENT         |
2. call ->connect()              |
3. wait reply                    |
                                 | 4. sk_state=TCP_ESTABLISHED
                                 | 5. insert to connected list
                                 | 6. reply to the client
7. sk_state=TCP_ESTABLISHED      |
8. insert to connected list      |
9. *signal pending* <--------------------- the user kill client
10. sk_state=TCP_CLOSE           |
client is exiting...             |
11. call ->release()             |
     virtio_transport_close
      if (!(sk->sk_state == TCP_ESTABLISHED ||
	      sk->sk_state == TCP_CLOSING))
		return true; *return at here, the server cannot notice the connection is corrupt*

So the client should notify the peer in this case.

Cc: David S. Miller <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Jorgen Hansen <jhansen@vmware.com>
Cc: Norbert Slusarek <nslusarek@gmx.net>
Cc: Andra Paraschiv <andraprs@amazon.com>
Cc: Colin Ian King <colin.king@canonical.com>
Cc: David Brazdil <dbrazdil@google.com>
Cc: Alexander Popov <alex.popov@linux.com>
Suggested-by: Stefano Garzarella <sgarzare@redhat.com>
Link: https://lkml.org/lkml/2021/5/17/418
Signed-off-by: lixianming <lixianming5@huawei.com>
Signed-off-by: Longpeng(Mike) <longpeng2@huawei.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/vmw_vsock/af_vsock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index c82e7b52ab1f..d4104144bab1 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1217,7 +1217,7 @@ static int vsock_stream_connect(struct socket *sock, struct sockaddr *addr,
 
 		if (signal_pending(current)) {
 			err = sock_intr_errno(timeout);
-			sk->sk_state = TCP_CLOSE;
+			sk->sk_state = sk->sk_state == TCP_ESTABLISHED ? TCP_CLOSING : TCP_CLOSE;
 			sock->state = SS_UNCONNECTED;
 			vsock_transport_cancel_pkt(vsk);
 			goto out_wait;
-- 
2.30.2



