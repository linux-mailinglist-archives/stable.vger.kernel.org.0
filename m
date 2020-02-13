Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C16C615C66C
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 17:12:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729677AbgBMQAe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 11:00:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:39018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728363AbgBMPYo (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:24:44 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 113F72469A;
        Thu, 13 Feb 2020 15:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607484;
        bh=qiKtVqH7kskknsEFHlUsV5nZEh42C9SLk+0ySb3j3EI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pzg21ZPRYwsKTYbCsXlmUopXrYbaKpKKyK1uGGiH2EibE863V1lylnkf2VMIFWGnz
         ouGAB2ThCK7gbo51wiCOBkanPc5Cqe7htsP8V70aLtrxZBhaoTeI0oQm0onnvC7j5W
         0skouZA5Ie9Dg6fJJimsnO/oNYr8BVTFmttdROJE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.14 013/173] tcp: clear tp->delivered in tcp_disconnect()
Date:   Thu, 13 Feb 2020 07:18:36 -0800
Message-Id: <20200213151936.076867223@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151931.677980430@linuxfoundation.org>
References: <20200213151931.677980430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 2fbdd56251b5c62f96589f39eded277260de7267 ]

tp->delivered needs to be cleared in tcp_disconnect().

tcp_disconnect() is rarely used, but it is worth fixing it.

Fixes: ddf1af6fa00e ("tcp: new delivery accounting")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Yuchung Cheng <ycheng@google.com>
Cc: Neal Cardwell <ncardwell@google.com>
Acked-by: Yuchung Cheng <ycheng@google.com>
Acked-by: Neal Cardwell <ncardwell@google.com>
Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2363,6 +2363,7 @@ int tcp_disconnect(struct sock *sk, int
 	tp->snd_ssthresh = TCP_INFINITE_SSTHRESH;
 	tp->snd_cwnd_cnt = 0;
 	tp->window_clamp = 0;
+	tp->delivered = 0;
 	tcp_set_ca_state(sk, TCP_CA_Open);
 	tp->is_sack_reneg = 0;
 	tcp_clear_retrans(tp);


