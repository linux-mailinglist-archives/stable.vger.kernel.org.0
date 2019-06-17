Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78FE149284
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 23:21:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729277AbfFQVVF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 17:21:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:45534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728750AbfFQVVF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Jun 2019 17:21:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7AF5520652;
        Mon, 17 Jun 2019 21:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560806465;
        bh=hEgJyZc9Hwr8ie7GW20x125kBieP37qILr4Cyx2FG3U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CLyWcV0zypDGvbDYVT3unBQ81JMR+hMV/Y5Po5DjJjPaZsicPrrYxgUNc0hv9oFFp
         VRCUySgk0wjg0y5gyPTYSs5HfDedHXK9l3ynRqgC2WiEtwxK5cKrcVOuOFOgl99r/o
         P+Bq+hEiQvSg4fkatUVpAQmply5EILQOgZ/Vpbmo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arika Chen <eaglesora@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 061/115] bpf, tcp: correctly handle DONT_WAIT flags and timeo == 0
Date:   Mon, 17 Jun 2019 23:09:21 +0200
Message-Id: <20190617210803.364287540@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190617210759.929316339@linuxfoundation.org>
References: <20190617210759.929316339@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 5fa2ca7c4a3fc176f31b495e1a704862d8188b53 ]

The tcp_bpf_wait_data() routine needs to check timeo != 0 before
calling sk_wait_event() otherwise we may see unexpected stalls
on receiver.

Arika did all the leg work here I just formatted, posted and ran
a few tests.

Fixes: 604326b41a6fb ("bpf, sockmap: convert to generic sk_msg interface")
Reported-by: Arika Chen <eaglesora@gmail.com>
Suggested-by: Arika Chen <eaglesora@gmail.com>
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_bpf.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index 4a619c85daed..3d1e15401384 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -27,7 +27,10 @@ static int tcp_bpf_wait_data(struct sock *sk, struct sk_psock *psock,
 			     int flags, long timeo, int *err)
 {
 	DEFINE_WAIT_FUNC(wait, woken_wake_function);
-	int ret;
+	int ret = 0;
+
+	if (!timeo)
+		return ret;
 
 	add_wait_queue(sk_sleep(sk), &wait);
 	sk_set_bit(SOCKWQ_ASYNC_WAITDATA, sk);
-- 
2.20.1



