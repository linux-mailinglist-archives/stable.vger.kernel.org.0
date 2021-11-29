Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDCDF461F24
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:41:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380516AbhK2SoL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:44:11 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:47056 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379770AbhK2SmI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:42:08 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 97431B815CF;
        Mon, 29 Nov 2021 18:38:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8BECC53FC7;
        Mon, 29 Nov 2021 18:38:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638211128;
        bh=hZh/ZchGhZ/dP88IPfADAfRSu1xx2vs89rrHBzrzJDs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WW1j5sW9Q5oUh6AijU5hJKsFhWAxE4yH2npPb5L+mgR4KRJZ8KEFRQlXe/Kyy2Vqv
         7pLJQT7gJklkdW1P+89Limgr62WV2DVbrkkyhLTholvgnBWnP6actVfOiUOZBAVtQe
         zZJoy2K5czO+O4OG6ohcSZhDyLEnm8udUP8l7oI4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vincent Whitchurch <vincent.whitchurch@axis.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 106/179] af_unix: fix regression in read after shutdown
Date:   Mon, 29 Nov 2021 19:18:20 +0100
Message-Id: <20211129181722.434619228@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181718.913038547@linuxfoundation.org>
References: <20211129181718.913038547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vincent Whitchurch <vincent.whitchurch@axis.com>

[ Upstream commit f9390b249c90a15a4d9e69fbfb7a53c860b1fcaf ]

On kernels before v5.15, calling read() on a unix socket after
shutdown(SHUT_RD) or shutdown(SHUT_RDWR) would return the data
previously written or EOF.  But now, while read() after
shutdown(SHUT_RD) still behaves the same way, read() after
shutdown(SHUT_RDWR) always fails with -EINVAL.

This behaviour change was apparently inadvertently introduced as part of
a bug fix for a different regression caused by the commit adding sockmap
support to af_unix, commit 94531cfcbe79c359 ("af_unix: Add
unix_stream_proto for sockmap").  Those commits, for unclear reasons,
started setting the socket state to TCP_CLOSE on shutdown(SHUT_RDWR),
while this state change had previously only been done in
unix_release_sock().

Restore the original behaviour.  The sockmap tests in
tests/selftests/bpf continue to pass after this patch.

Fixes: d0c6416bd7091647f60 ("unix: Fix an issue in unix_shutdown causing the other end read/write failures")
Link: https://lore.kernel.org/lkml/20211111140000.GA10779@axis.com/
Signed-off-by: Vincent Whitchurch <vincent.whitchurch@axis.com>
Tested-by: Casey Schaufler <casey@schaufler-ca.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/unix/af_unix.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 78e08e82c08c4..b0bfc78e421ce 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -2882,9 +2882,6 @@ static int unix_shutdown(struct socket *sock, int mode)
 
 	unix_state_lock(sk);
 	sk->sk_shutdown |= mode;
-	if ((sk->sk_type == SOCK_STREAM || sk->sk_type == SOCK_SEQPACKET) &&
-	    mode == SHUTDOWN_MASK)
-		sk->sk_state = TCP_CLOSE;
 	other = unix_peer(sk);
 	if (other)
 		sock_hold(other);
-- 
2.33.0



