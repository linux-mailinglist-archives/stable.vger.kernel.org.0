Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EF341C458C
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 20:17:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730842AbgEDSPn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 14:15:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:52534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730727AbgEDR7N (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 May 2020 13:59:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A01E72073E;
        Mon,  4 May 2020 17:59:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588615153;
        bh=b/C2kIU9bt74o9AfGdylmVjEwEHMVCE1Rv+q8CIZhwU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LJgoyNEXYR26Y/s0b8k8RQqKFnb5pccy5pWa38WV4yDdN4Vuz2n8ElJ4zOPBJA5JB
         GgGxmpbQKZ87FHnWdGuGLoNe3vCfzpEm3qkzo66guuWJaodQC/i7AG04hZgwt2p2zF
         R1Zpt0cOfUfaPyrGioLgoBTT6FGEphlaVgNZBDy4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Olivier Matz <olivier.matz@6wind.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 17/18] ipv6: use READ_ONCE() for inet->hdrincl as in ipv4
Date:   Mon,  4 May 2020 19:57:15 +0200
Message-Id: <20200504165445.162621760@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200504165441.533160703@linuxfoundation.org>
References: <20200504165441.533160703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Olivier Matz <olivier.matz@6wind.com>

commit 59e3e4b52663a9d97efbce7307f62e4bc5c9ce91 upstream.

As it was done in commit 8f659a03a0ba ("net: ipv4: fix for a race
condition in raw_sendmsg") and commit 20b50d79974e ("net: ipv4: emulate
READ_ONCE() on ->hdrincl bit-field in raw_sendmsg()") for ipv4, copy the
value of inet->hdrincl in a local variable, to avoid introducing a race
condition in the next commit.

Signed-off-by: Olivier Matz <olivier.matz@6wind.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/ipv6/raw.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -757,6 +757,7 @@ static int rawv6_sendmsg(struct sock *sk
 	int hlimit = -1;
 	int tclass = -1;
 	int dontfrag = -1;
+	int hdrincl;
 	u16 proto;
 	int err;
 
@@ -770,6 +771,13 @@ static int rawv6_sendmsg(struct sock *sk
 	if (msg->msg_flags & MSG_OOB)
 		return -EOPNOTSUPP;
 
+	/* hdrincl should be READ_ONCE(inet->hdrincl)
+	 * but READ_ONCE() doesn't work with bit fields.
+	 * Doing this indirectly yields the same result.
+	 */
+	hdrincl = inet->hdrincl;
+	hdrincl = READ_ONCE(hdrincl);
+
 	/*
 	 *	Get and verify the address.
 	 */
@@ -878,7 +886,7 @@ static int rawv6_sendmsg(struct sock *sk
 		fl6.flowi6_oif = np->ucast_oif;
 	security_sk_classify_flow(sk, flowi6_to_flowi(&fl6));
 
-	if (inet->hdrincl)
+	if (hdrincl)
 		fl6.flowi6_flags |= FLOWI_FLAG_KNOWN_NH;
 
 	dst = ip6_dst_lookup_flow(sk, &fl6, final_p);
@@ -899,7 +907,7 @@ static int rawv6_sendmsg(struct sock *sk
 		goto do_confirm;
 
 back_from_confirm:
-	if (inet->hdrincl)
+	if (hdrincl)
 		err = rawv6_send_hdrinc(sk, msg, len, &fl6, &dst, msg->msg_flags);
 	else {
 		lock_sock(sk);


