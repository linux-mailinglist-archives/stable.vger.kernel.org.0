Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7DD11CABA5
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:45:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728940AbgEHMpe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:45:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:45286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728686AbgEHMpd (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:45:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 68D63208D6;
        Fri,  8 May 2020 12:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941932;
        bh=pYyn1sYWrtiRt37rxMZle5l0sYm/BxNM/I+kmoLRHVw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=su0/FNyeg5jPz/X44T6IKPPNBuxY91/lYlzEg2DljS2Vk5zQCd4VsARO/JL325TvQ
         T+E+R4AdSHx+DalGLvHqr9GfGy71l5mzmhOJv2tJHGBanMQ18J8frwV3P3av1PF9ed
         ysxQ53r45DiLbz2AFAiHS3WTxzZvkYMR8GqTCpoo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Francesco Fusco <ffusco@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 191/312] ipv4: accept u8 in IP_TOS ancillary data
Date:   Fri,  8 May 2020 14:33:02 +0200
Message-Id: <20200508123137.893496235@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

commit e895cdce683161081e3626c4f5a5c55cb72089f8 upstream.

In commit f02db315b8d8 ("ipv4: IP_TOS and IP_TTL can be specified as
ancillary data") Francesco added IP_TOS values specified as integer.

However, kernel sends to userspace (at recvmsg() time) an IP_TOS value
in a single byte, when IP_RECVTOS is set on the socket.

It can be very useful to reflect all ancillary options as given by the
kernel in a subsequent sendmsg(), instead of aborting the sendmsg() with
EINVAL after Francesco patch.

So this patch extends IP_TOS ancillary to accept an u8, so that an UDP
server can simply reuse same ancillary block without having to mangle
it.

Jesper can then augment
https://github.com/netoptimizer/network-testing/blob/master/src/udp_example02.c
to add TOS reflection ;)

Fixes: f02db315b8d8 ("ipv4: IP_TOS and IP_TTL can be specified as ancillary data")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Francesco Fusco <ffusco@redhat.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/ipv4/ip_sockglue.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/net/ipv4/ip_sockglue.c
+++ b/net/ipv4/ip_sockglue.c
@@ -279,9 +279,12 @@ int ip_cmsg_send(struct net *net, struct
 			ipc->ttl = val;
 			break;
 		case IP_TOS:
-			if (cmsg->cmsg_len != CMSG_LEN(sizeof(int)))
+			if (cmsg->cmsg_len == CMSG_LEN(sizeof(int)))
+				val = *(int *)CMSG_DATA(cmsg);
+			else if (cmsg->cmsg_len == CMSG_LEN(sizeof(u8)))
+				val = *(u8 *)CMSG_DATA(cmsg);
+			else
 				return -EINVAL;
-			val = *(int *)CMSG_DATA(cmsg);
 			if (val < 0 || val > 255)
 				return -EINVAL;
 			ipc->tos = val;


