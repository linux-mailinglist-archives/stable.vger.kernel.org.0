Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20DA215C151
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:22:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727935AbgBMPW2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:22:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:59570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727881AbgBMPW2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:22:28 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D46DD246C0;
        Thu, 13 Feb 2020 15:22:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607347;
        bh=iKkF4Zgp5sijlwm9Zs8L9gBFzpXfEG5kjg4D6f2fOpU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=itzSjE4L2L8Z3pC80UQO3nSKQdXNKirAHrTY856mCDrEebVQpno45O8xVkbYx23we
         EMW5bTMOKJcUeEsWE4efB6yYIFMUmHsP2F6Gm/r77q5EYDUgv8u/JzXDjNRLqAhIJ4
         h6abm3fjyEljS9XpmldGwpcVBAD36ArYQqIgLFQ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        SeongJae Park <sjpark@amazon.de>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.4 08/91] tcp: clear tp->total_retrans in tcp_disconnect()
Date:   Thu, 13 Feb 2020 07:19:25 -0800
Message-Id: <20200213151824.663369407@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151821.384445454@linuxfoundation.org>
References: <20200213151821.384445454@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit c13c48c00a6bc1febc73902505bdec0967bd7095 ]

total_retrans needs to be cleared in tcp_disconnect().

tcp_disconnect() is rarely used, but it is worth fixing it.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: SeongJae Park <sjpark@amazon.de>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2261,6 +2261,7 @@ int tcp_disconnect(struct sock *sk, int
 	tp->window_clamp = 0;
 	tcp_set_ca_state(sk, TCP_CA_Open);
 	tcp_clear_retrans(tp);
+	tp->total_retrans = 0;
 	inet_csk_delack_init(sk);
 	/* Initialize rcv_mss to TCP_MIN_MSS to avoid division by 0
 	 * issue in __tcp_select_window()


