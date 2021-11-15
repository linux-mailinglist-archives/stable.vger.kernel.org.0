Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C791B4521C4
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:04:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352489AbhKPBGm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:06:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:44610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245409AbhKOTUa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:20:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1DAC961104;
        Mon, 15 Nov 2021 18:34:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001244;
        bh=MJEqHK6HqMPcivDSNlbWsDQZ2QEeUHS3TSn0z9Dy7Co=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D06A9MEhw/L2DdyVNmN2TgP7mIX3TxOa/NSgT2PtNPObFEvqEYes7jsX4m5ksxd4M
         CoszkSVIJlsVF2avSqhMQ4AhyfbWOAa744ZeRgxA6ew4c1gd9sKBxqA+iHfyv9z55k
         0gVZpwWicTzTQg4kz7QOV1Ef+U7Eskqcn9/O+Kyo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eugene Syromiatnikov <esyr@redhat.com>,
        Jeremy Kerr <jk@codeconstruct.com.au>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 116/917] mctp: handle the struct sockaddr_mctp padding fields
Date:   Mon, 15 Nov 2021 17:53:31 +0100
Message-Id: <20211115165432.683691015@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eugene Syromiatnikov <esyr@redhat.com>

commit 1e4b50f06d970d8da3474d2a0354450416710bda upstream.

In order to have the padding fields actually usable in the future,
there have to be checks that user space doesn't supply non-zero garbage
there.  It is also worth setting these padding fields to zero, unless
it is known that they have been already zeroed.

Cc: stable@vger.kernel.org # v5.15
Fixes: 5a20dd46b8b84593 ("mctp: Be explicit about struct sockaddr_mctp padding")
Signed-off-by: Eugene Syromiatnikov <esyr@redhat.com>
Acked-by: Jeremy Kerr <jk@codeconstruct.com.au>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mctp/af_mctp.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/net/mctp/af_mctp.c
+++ b/net/mctp/af_mctp.c
@@ -30,6 +30,12 @@ static int mctp_release(struct socket *s
 	return 0;
 }
 
+/* Generic sockaddr checks, padding checks only so far */
+static bool mctp_sockaddr_is_ok(const struct sockaddr_mctp *addr)
+{
+	return !addr->__smctp_pad0 && !addr->__smctp_pad1;
+}
+
 static int mctp_bind(struct socket *sock, struct sockaddr *addr, int addrlen)
 {
 	struct sock *sk = sock->sk;
@@ -49,6 +55,9 @@ static int mctp_bind(struct socket *sock
 	/* it's a valid sockaddr for MCTP, cast and do protocol checks */
 	smctp = (struct sockaddr_mctp *)addr;
 
+	if (!mctp_sockaddr_is_ok(smctp))
+		return -EINVAL;
+
 	lock_sock(sk);
 
 	/* TODO: allow rebind */
@@ -83,6 +92,8 @@ static int mctp_sendmsg(struct socket *s
 			return -EINVAL;
 		if (addr->smctp_family != AF_MCTP)
 			return -EINVAL;
+		if (!mctp_sockaddr_is_ok(addr))
+			return -EINVAL;
 		if (addr->smctp_tag & ~(MCTP_TAG_MASK | MCTP_TAG_OWNER))
 			return -EINVAL;
 
@@ -172,11 +183,13 @@ static int mctp_recvmsg(struct socket *s
 
 		addr = msg->msg_name;
 		addr->smctp_family = AF_MCTP;
+		addr->__smctp_pad0 = 0;
 		addr->smctp_network = cb->net;
 		addr->smctp_addr.s_addr = hdr->src;
 		addr->smctp_type = type;
 		addr->smctp_tag = hdr->flags_seq_tag &
 					(MCTP_HDR_TAG_MASK | MCTP_HDR_FLAG_TO);
+		addr->__smctp_pad1 = 0;
 		msg->msg_namelen = sizeof(*addr);
 	}
 


