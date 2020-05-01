Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 629181C135E
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 15:33:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729717AbgEAN26 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:28:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:52304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729158AbgEAN25 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:28:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DADEC2173E;
        Fri,  1 May 2020 13:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588339736;
        bh=kVEuf2gaxCNZnPQLaEEHOFcGlNG9hxk+Tp1dBik2BeI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e+gfi278H7xodGJ6E1rTljW5Ek5TkNAE63TAZX2aeUxeGw0y7lg9UxNcjKPF4SvkM
         bK6N4SHB5CnAYfz1obPwya8JAQst7xlrdYmKs9zKavxrkLJ+Hb7O+oa9Oa9m62FHJB
         h+Yq16ZnnD1L1m/eB13cBhaSBXekx2POAv5EMWY8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 25/80] tcp: cache line align MAX_TCP_HEADER
Date:   Fri,  1 May 2020 15:21:19 +0200
Message-Id: <20200501131522.465024046@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131513.810761598@linuxfoundation.org>
References: <20200501131513.810761598@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 9bacd256f1354883d3c1402655153367982bba49 ]

TCP stack is dumb in how it cooks its output packets.

Depending on MAX_HEADER value, we might chose a bad ending point
for the headers.

If we align the end of TCP headers to cache line boundary, we
make sure to always use the smallest number of cache lines,
which always help.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Soheil Hassas Yeganeh <soheil@google.com>
Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/tcp.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -51,7 +51,7 @@ extern struct inet_hashinfo tcp_hashinfo
 extern struct percpu_counter tcp_orphan_count;
 void tcp_time_wait(struct sock *sk, int state, int timeo);
 
-#define MAX_TCP_HEADER	(128 + MAX_HEADER)
+#define MAX_TCP_HEADER	L1_CACHE_ALIGN(128 + MAX_HEADER)
 #define MAX_TCP_OPTION_SPACE 40
 #define TCP_MIN_SND_MSS		48
 #define TCP_MIN_GSO_SIZE	(TCP_MIN_SND_MSS - MAX_TCP_OPTION_SPACE)


