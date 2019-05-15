Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46B9F1EF95
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:38:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733102AbfEOLcx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:32:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:44794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732775AbfEOLcw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:32:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB311206BF;
        Wed, 15 May 2019 11:32:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919971;
        bh=jCr5E9mYj5Y12c0OTwClqPN7fBXur6cUro7uk/3mmKk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kDA/GFS/m3PuMIcYY9aYackl/ZaYoD1GEj0YAUW4n69lxbnqKWlr5orv04Fs3DT6s
         gGkTZ95nwZJTC2hRqzwja/qMt4NZG6SzEwQJHrmxgwJ+iAezeRCVHAu8L2BjATHKpt
         AsCEl5uiwmAahelpMzIhAzA36OKNaNAc7NlGS17g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Deseyn <tdeseyn@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.1 25/46] selinux: do not report error on connect(AF_UNSPEC)
Date:   Wed, 15 May 2019 12:56:49 +0200
Message-Id: <20190515090625.114193357@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090616.670410738@linuxfoundation.org>
References: <20190515090616.670410738@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit c7e0d6cca86581092cbbf2cd868b3601495554cf ]

calling connect(AF_UNSPEC) on an already connected TCP socket is an
established way to disconnect() such socket. After commit 68741a8adab9
("selinux: Fix ltp test connect-syscall failure") it no longer works
and, in the above scenario connect() fails with EAFNOSUPPORT.

Fix the above falling back to the generic/old code when the address family
is not AF_INET{4,6}, but leave the SCTP code path untouched, as it has
specific constraints.

Fixes: 68741a8adab9 ("selinux: Fix ltp test connect-syscall failure")
Reported-by: Tom Deseyn <tdeseyn@redhat.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/selinux/hooks.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -4572,7 +4572,7 @@ static int selinux_socket_connect_helper
 		struct lsm_network_audit net = {0,};
 		struct sockaddr_in *addr4 = NULL;
 		struct sockaddr_in6 *addr6 = NULL;
-		unsigned short snum;
+		unsigned short snum = 0;
 		u32 sid, perm;
 
 		/* sctp_connectx(3) calls via selinux_sctp_bind_connect()
@@ -4595,12 +4595,12 @@ static int selinux_socket_connect_helper
 			break;
 		default:
 			/* Note that SCTP services expect -EINVAL, whereas
-			 * others expect -EAFNOSUPPORT.
+			 * others must handle this at the protocol level:
+			 * connect(AF_UNSPEC) on a connected socket is
+			 * a documented way disconnect the socket.
 			 */
 			if (sksec->sclass == SECCLASS_SCTP_SOCKET)
 				return -EINVAL;
-			else
-				return -EAFNOSUPPORT;
 		}
 
 		err = sel_netport_sid(sk->sk_protocol, snum, &sid);


