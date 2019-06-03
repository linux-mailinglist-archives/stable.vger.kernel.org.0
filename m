Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7A4E32C3A
	for <lists+stable@lfdr.de>; Mon,  3 Jun 2019 11:16:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728572AbfFCJPc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jun 2019 05:15:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:34294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728417AbfFCJNu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Jun 2019 05:13:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 076F921952;
        Mon,  3 Jun 2019 09:13:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559553229;
        bh=bOkLfz4pYti8bdqfmRaH2+hbvvt225WbwlfpM02E7Qs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fANSR89BkTMxRgX/Ajnion/p6rpHHEJ8k6PIOVL46GaD+aoL1f6ZzMcjmSqayDt8u
         wY4gtkZ8CZYDcnkLHd77JO5wd1upmcUPDX2MIEa39y0GPX44niVlbbF90vTPjuEKNw
         JAp3DnD2k9qn32T6/XAConJEQYq1zFzzQAvrdtEQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>,
        David Beckett <david.beckett@netronome.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.1 30/40] net/tls: fix lowat calculation if some data came from previous record
Date:   Mon,  3 Jun 2019 11:09:23 +0200
Message-Id: <20190603090524.417109218@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190603090522.617635820@linuxfoundation.org>
References: <20190603090522.617635820@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>

[ Upstream commit 46a1695960d0600d58da7af33c65f24f3d839674 ]

If some of the data came from the previous record, i.e. from
the rx_list it had already been decrypted, so it's not counted
towards the "decrypted" variable, but the "copied" variable.
Take that into account when checking lowat.

When calculating lowat target we need to pass the original len.
E.g. if lowat is at 80, len is 100 and we had 30 bytes on rx_list
target would currently be incorrectly calculated as 70, even though
we only need 50 more bytes to make up the 80.

Fixes: 692d7b5d1f91 ("tls: Fix recvmsg() to be able to peek across multiple records")
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Tested-by: David Beckett <david.beckett@netronome.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/tls/tls_sw.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1685,13 +1685,12 @@ int tls_sw_recvmsg(struct sock *sk,
 		copied = err;
 	}
 
-	len = len - copied;
-	if (len) {
-		target = sock_rcvlowat(sk, flags & MSG_WAITALL, len);
-		timeo = sock_rcvtimeo(sk, flags & MSG_DONTWAIT);
-	} else {
+	if (len <= copied)
 		goto recv_end;
-	}
+
+	target = sock_rcvlowat(sk, flags & MSG_WAITALL, len);
+	len = len - copied;
+	timeo = sock_rcvtimeo(sk, flags & MSG_DONTWAIT);
 
 	do {
 		bool retain_skb = false;
@@ -1826,7 +1825,7 @@ pick_next_record:
 		}
 
 		/* If we have a new message from strparser, continue now. */
-		if (decrypted >= target && !ctx->recv_pkt)
+		if (decrypted + copied >= target && !ctx->recv_pkt)
 			break;
 	} while (len);
 


