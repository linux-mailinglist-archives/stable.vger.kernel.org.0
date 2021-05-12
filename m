Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91DF037CAE6
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:55:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238574AbhELQcs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:32:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:41570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241250AbhELQ05 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:26:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 02FBF61411;
        Wed, 12 May 2021 15:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834654;
        bh=XOWtBRHSuOX4EissREp2XcPj4qBiqUOKAOx7vuhzsuc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f1DpfdcLNIDfhdd+7ieslYNn4lyiXUqOinyPjj8Rrg2KADEFbs285sEi7UEmwXa+D
         9Xed6VXRvwdORffGmJlSweLTIAwiOvuoEI2WAltP01Hvue+4t+4DmQ/Xp8nynNy2+7
         IaprrMfnPDo8IoFZAPFOWOoLsZx3PSqdT1rD3dto=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Or Cohen <orcohen@paloaltonetworks.com>,
        Nadav Markus <nmarkus@paloaltonetworks.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.12 003/677] net/nfc: fix use-after-free llcp_sock_bind/connect
Date:   Wed, 12 May 2021 16:40:49 +0200
Message-Id: <20210512144837.320132899@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
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
@@ -109,12 +109,14 @@ static int llcp_sock_bind(struct socket
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
@@ -709,6 +711,7 @@ static int llcp_sock_connect(struct sock
 	llcp_sock->ssap = nfc_llcp_get_local_ssap(local);
 	if (llcp_sock->ssap == LLCP_SAP_MAX) {
 		nfc_llcp_local_put(llcp_sock->local);
+		llcp_sock->local = NULL;
 		ret = -ENOMEM;
 		goto put_dev;
 	}
@@ -756,6 +759,7 @@ sock_unlink:
 sock_llcp_release:
 	nfc_llcp_put_ssap(local, llcp_sock->ssap);
 	nfc_llcp_local_put(llcp_sock->local);
+	llcp_sock->local = NULL;
 
 put_dev:
 	nfc_put_device(dev);


