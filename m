Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75DB1157B0A
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:27:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731272AbgBJN07 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:26:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:56566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727877AbgBJMgk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:36:40 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F61220838;
        Mon, 10 Feb 2020 12:36:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338199;
        bh=5v64RglUFJuc4nM31dOBXF0JdWrVYkV3eh4KqTNworA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lcWq1jnWrtKxn+hH8G2NpKjdiOJZUablKbkIl64PVXmL7VfKI+/U/tCcKuTZYo7G7
         JWxG2YiMg+H8oNVwCygcAjKCcviE4bZfgH2Fv11zLEOomhG0wBC/LR4sml4VkVkdrY
         z1HJh5wCKNpDkdHbN2JUk4H7u0oyPihxMTkh8pto=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        SeongJae Park <sjpark@amazon.de>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 014/309] tcp: clear tp->total_retrans in tcp_disconnect()
Date:   Mon, 10 Feb 2020 04:29:30 -0800
Message-Id: <20200210122407.370933714@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122406.106356946@linuxfoundation.org>
References: <20200210122406.106356946@linuxfoundation.org>
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
@@ -2622,6 +2622,7 @@ int tcp_disconnect(struct sock *sk, int
 	tcp_set_ca_state(sk, TCP_CA_Open);
 	tp->is_sack_reneg = 0;
 	tcp_clear_retrans(tp);
+	tp->total_retrans = 0;
 	inet_csk_delack_init(sk);
 	/* Initialize rcv_mss to TCP_MIN_MSS to avoid division by 0
 	 * issue in __tcp_select_window()


