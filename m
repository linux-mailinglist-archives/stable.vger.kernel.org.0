Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 588A33AAA2
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:20:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730839AbfFIQrk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 12:47:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:46376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730910AbfFIQrj (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 12:47:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA409205ED;
        Sun,  9 Jun 2019 16:47:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560098859;
        bh=sdE3P7sOxxmzEGlCIbI3UmAgN/aiH7Yp1z0Sp9FfpiI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hjzID1LQGlGyzSbq4tDV68WEtk/uNsg5KycjVLMUY4cciyoxyZc6cLbjggYis7OeH
         iVnIZH+m9rNMaqTFbWuod7Khr09OcRMnEVM4oC+REIodpWNfGVCOCfnX9jqFNLyu0P
         xz7Y2iV1gwg3OGV1MTxSneXM8JnzOxTjEoBTCHMc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Olivier Matz <olivier.matz@6wind.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 15/51] ipv6: use READ_ONCE() for inet->hdrincl as in ipv4
Date:   Sun,  9 Jun 2019 18:41:56 +0200
Message-Id: <20190609164127.967317205@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164127.123076536@linuxfoundation.org>
References: <20190609164127.123076536@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Olivier Matz <olivier.matz@6wind.com>

[ Upstream commit 59e3e4b52663a9d97efbce7307f62e4bc5c9ce91 ]

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
@@ -782,6 +782,7 @@ static int rawv6_sendmsg(struct sock *sk
 	struct flowi6 fl6;
 	struct ipcm6_cookie ipc6;
 	int addr_len = msg->msg_namelen;
+	int hdrincl;
 	u16 proto;
 	int err;
 
@@ -795,6 +796,13 @@ static int rawv6_sendmsg(struct sock *sk
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
@@ -907,7 +915,7 @@ static int rawv6_sendmsg(struct sock *sk
 		fl6.flowi6_oif = np->ucast_oif;
 	security_sk_classify_flow(sk, flowi6_to_flowi(&fl6));
 
-	if (inet->hdrincl)
+	if (hdrincl)
 		fl6.flowi6_flags |= FLOWI_FLAG_KNOWN_NH;
 
 	if (ipc6.tclass < 0)
@@ -930,7 +938,7 @@ static int rawv6_sendmsg(struct sock *sk
 		goto do_confirm;
 
 back_from_confirm:
-	if (inet->hdrincl)
+	if (hdrincl)
 		err = rawv6_send_hdrinc(sk, msg, len, &fl6, &dst,
 					msg->msg_flags, &ipc6.sockc);
 	else {


