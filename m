Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9B7638A64F
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:24:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235928AbhETKZp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:25:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:55682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236605AbhETKYV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:24:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CC8C561A2B;
        Thu, 20 May 2021 09:49:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504149;
        bh=AEtUL+1aobeMG5FJpxMXI8SYQHa0ydB1YzuOROKDAUQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aePU3xjaVVdXLiSOzP92ft/vY9gk/V/Gg6q5O6NhZU/I8pbHU0GRFNGutpbuEA1Re
         /ezCh2X2I+r/nTtE3gxAMoSeNMJkCX7Noo/GLHs8thlBKhfj1qN/7TIeRoHu1J/0Hu
         25wDfHlgump0klJBAaNSPuwK4zwoJljf8K/jxiOQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Or Cohen <orcohen@paloaltonetworks.com>,
        Nadav Markus <nmarkus@paloaltonetworks.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 114/323] net/nfc: fix use-after-free llcp_sock_bind/connect
Date:   Thu, 20 May 2021 11:20:06 +0200
Message-Id: <20210520092124.004883706@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092120.115153432@linuxfoundation.org>
References: <20210520092120.115153432@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Or Cohen <orcohen@paloaltonetworks.com>

commit c61760e6940dd4039a7f5e84a6afc9cdbf4d82b6 upstream.

Commits 8a4cd82d ("nfc: fix refcount leak in llcp_sock_connect()")
and c33b1cc62 ("nfc: fix refcount leak in llcp_sock_bind()")
fixed a refcount leak bug in bind/connect but introduced a
use-after-free if the same local is assigned to 2 different sockets.

This can be triggered by the following simple program:
    int sock1 = socket( AF_NFC, SOCK_STREAM, NFC_SOCKPROTO_LLCP );
    int sock2 = socket( AF_NFC, SOCK_STREAM, NFC_SOCKPROTO_LLCP );
    memset( &addr, 0, sizeof(struct sockaddr_nfc_llcp) );
    addr.sa_family = AF_NFC;
    addr.nfc_protocol = NFC_PROTO_NFC_DEP;
    bind( sock1, (struct sockaddr*) &addr, sizeof(struct sockaddr_nfc_llcp) )
    bind( sock2, (struct sockaddr*) &addr, sizeof(struct sockaddr_nfc_llcp) )
    close(sock1);
    close(sock2);

Fix this by assigning NULL to llcp_sock->local after calling
nfc_llcp_local_put.

This addresses CVE-2021-23134.

Reported-by: Or Cohen <orcohen@paloaltonetworks.com>
Reported-by: Nadav Markus <nmarkus@paloaltonetworks.com>
Fixes: c33b1cc62 ("nfc: fix refcount leak in llcp_sock_bind()")
Signed-off-by: Or Cohen <orcohen@paloaltonetworks.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/nfc/llcp_sock.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/nfc/llcp_sock.c
+++ b/net/nfc/llcp_sock.c
@@ -121,12 +121,14 @@ static int llcp_sock_bind(struct socket
 					  GFP_KERNEL);
 	if (!llcp_sock->service_name) {
 		nfc_llcp_local_put(llcp_sock->local);
+		llcp_sock->local = NULL;
 		ret = -ENOMEM;
 		goto put_dev;
 	}
 	llcp_sock->ssap = nfc_llcp_get_sdp_ssap(local, llcp_sock);
 	if (llcp_sock->ssap == LLCP_SAP_MAX) {
 		nfc_llcp_local_put(llcp_sock->local);
+		llcp_sock->local = NULL;
 		kfree(llcp_sock->service_name);
 		llcp_sock->service_name = NULL;
 		ret = -EADDRINUSE;
@@ -722,6 +724,7 @@ static int llcp_sock_connect(struct sock
 	llcp_sock->ssap = nfc_llcp_get_local_ssap(local);
 	if (llcp_sock->ssap == LLCP_SAP_MAX) {
 		nfc_llcp_local_put(llcp_sock->local);
+		llcp_sock->local = NULL;
 		ret = -ENOMEM;
 		goto put_dev;
 	}
@@ -760,6 +763,7 @@ static int llcp_sock_connect(struct sock
 sock_unlink:
 	nfc_llcp_put_ssap(local, llcp_sock->ssap);
 	nfc_llcp_local_put(llcp_sock->local);
+	llcp_sock->local = NULL;
 
 	nfc_llcp_sock_unlink(&local->connecting_sockets, sk);
 	kfree(llcp_sock->service_name);


