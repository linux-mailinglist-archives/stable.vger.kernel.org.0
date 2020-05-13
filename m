Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C1EE1D0E67
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 12:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388124AbgEMJ7z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 05:59:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:54394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733286AbgEMJws (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 05:52:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4FB1120753;
        Wed, 13 May 2020 09:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589363567;
        bh=SOZ803+YXS9HbFLuIMPYmRKdBHR5d0s6fTcBtxPZYY0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HWvJLof4Qtar3wQRwzvojZhY5B9E10snMLjYfkbSg9wDY4VDpkURERuMy3NfWE7zA
         wz76apV/K77ce3JXVXL/gQ/jLQltI4suIHspROgU6g0sMGh9CSSGk63tugd2UrpKtR
         LoO7UkHT2S6di8D1v7/1roZTiCNwIZ/88JjltO7Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Arjun Roy <arjunroy@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.6 037/118] selftests: net: tcp_mmap: clear whole tcp_zerocopy_receive struct
Date:   Wed, 13 May 2020 11:44:16 +0200
Message-Id: <20200513094420.665827553@linuxfoundation.org>
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

[ Upstream commit bf5525f3a8e3248be5aa5defe5aaadd60e1c1ba1 ]

We added fields in tcp_zerocopy_receive structure,
so make sure to clear all fields to not pass garbage to the kernel.

We were lucky because recent additions added 'out' parameters,
still we need to clean our reference implementation, before folks
copy/paste it.

Fixes: c8856c051454 ("tcp-zerocopy: Return inq along with tcp receive zerocopy.")
Fixes: 33946518d493 ("tcp-zerocopy: Return sk_err (if set) along with tcp receive zerocopy.")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Arjun Roy <arjunroy@google.com>
Cc: Soheil Hassas Yeganeh <soheil@google.com>
Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/tcp_mmap.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/net/tcp_mmap.c
+++ b/tools/testing/selftests/net/tcp_mmap.c
@@ -165,9 +165,10 @@ void *child_thread(void *arg)
 			socklen_t zc_len = sizeof(zc);
 			int res;
 
+			memset(&zc, 0, sizeof(zc));
 			zc.address = (__u64)((unsigned long)addr);
 			zc.length = chunk_size;
-			zc.recv_skip_hint = 0;
+
 			res = getsockopt(fd, IPPROTO_TCP, TCP_ZEROCOPY_RECEIVE,
 					 &zc, &zc_len);
 			if (res == -1)


