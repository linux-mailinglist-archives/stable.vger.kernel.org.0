Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F67C157C6F
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:37:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731330AbgBJNh0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:37:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:51228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727618AbgBJMfC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:35:02 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 800D8208C4;
        Mon, 10 Feb 2020 12:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338102;
        bh=F4AfoG+UT0oFK6SmvLrrn1HbOnp8qiEbFk9g7UvFoLw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jr5rRbz/4SBK0R9yLCfPbs9dXMJ5BnnC8BTpvitsxBRaAs5rmFNlU6neL12Ck5Yq7
         rvM5OIZ0x2FP8GtKQ5aBrTi8qmcQXEt7nr7gZ5fbi3pd8epejfp1SzMouxsUv1L7cB
         FUmQb/hn54KL4JZP3xDQmQoSThc2PNisOlCsb95E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Yuchung Cheng <ycheng@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.19 020/195] tcp: clear tp->data_segs{in|out} in tcp_disconnect()
Date:   Mon, 10 Feb 2020 04:31:18 -0800
Message-Id: <20200210122307.843883179@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122305.731206734@linuxfoundation.org>
References: <20200210122305.731206734@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit db7ffee6f3eb3683cdcaeddecc0a630a14546fe3 ]

tp->data_segs_in and tp->data_segs_out need to be cleared
in tcp_disconnect().

tcp_disconnect() is rarely used, but it is worth fixing it.

Fixes: a44d6eacdaf5 ("tcp: Add RFC4898 tcpEStatsPerfDataSegsOut/In")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Martin KaFai Lau <kafai@fb.com>
Cc: Yuchung Cheng <ycheng@google.com>
Cc: Neal Cardwell <ncardwell@google.com>
Acked-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2609,6 +2609,8 @@ int tcp_disconnect(struct sock *sk, int
 	tp->bytes_acked = 0;
 	tp->bytes_received = 0;
 	tp->bytes_retrans = 0;
+	tp->data_segs_in = 0;
+	tp->data_segs_out = 0;
 	tp->dsack_dups = 0;
 	tp->reord_seen = 0;
 


