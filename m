Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54BB11D0E63
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 12:00:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387849AbgEMJww (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 05:52:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:54458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387843AbgEMJwu (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 05:52:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B8625206D6;
        Wed, 13 May 2020 09:52:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589363570;
        bh=ItZozESPkp2bU8elmQVE2Ece654ClBx1/udtUPGZTdw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=115V9sNNr9cSWrUbrsXuNl3eFoNArW1+44ElpVYWsfLo0gxe1kgHv8LPSY+FKsYxP
         yDM+wF6AmT/kBemVtp6YRsf9XgcyUE0fAdruCCxl0Rsl+c6QOgC2+aXi0EDdYriLAF
         TpPSupvs6bnr6g3NJktUdITnVhZXM/hJrvtXN03E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Arjun Roy <arjunroy@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.6 038/118] selftests: net: tcp_mmap: fix SO_RCVLOWAT setting
Date:   Wed, 13 May 2020 11:44:17 +0200
Message-Id: <20200513094420.731187269@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200513094417.618129545@linuxfoundation.org>
References: <20200513094417.618129545@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit a84724178bd7081cf3bd5b558616dd6a9a4ca63b ]

Since chunk_size is no longer an integer, we can not
use it directly as an argument of setsockopt().

This patch should fix tcp_mmap for Big Endian kernels.

Fixes: 597b01edafac ("selftests: net: avoid ptl lock contention in tcp_mmap")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Soheil Hassas Yeganeh <soheil@google.com>
Cc: Arjun Roy <arjunroy@google.com>
Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/tcp_mmap.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/net/tcp_mmap.c
+++ b/tools/testing/selftests/net/tcp_mmap.c
@@ -282,12 +282,14 @@ static void setup_sockaddr(int domain, c
 static void do_accept(int fdlisten)
 {
 	pthread_attr_t attr;
+	int rcvlowat;
 
 	pthread_attr_init(&attr);
 	pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_DETACHED);
 
+	rcvlowat = chunk_size;
 	if (setsockopt(fdlisten, SOL_SOCKET, SO_RCVLOWAT,
-		       &chunk_size, sizeof(chunk_size)) == -1) {
+		       &rcvlowat, sizeof(rcvlowat)) == -1) {
 		perror("setsockopt SO_RCVLOWAT");
 	}
 


