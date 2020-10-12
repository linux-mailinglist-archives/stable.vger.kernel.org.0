Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1699328B6D8
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:38:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731112AbgJLNiL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:38:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:40454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731075AbgJLNh3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:37:29 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 421DA2087E;
        Mon, 12 Oct 2020 13:37:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602509846;
        bh=LkZZCHlybjPnZTp1wDgjaho81eMJAMmwVqqYco40hfU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d34oQB0BHl8fSdIiO/haXUiIKwIZHQMHTMxu7YWMD3YEc35858P1Fvitc1jCyDUp7
         0zzuc31/qTaI7Ew5WnnRddqgk3P8JuQniK0TMl+mlj5WQ8qvgjTwenyJtWquYeEaE/
         OqBtHggqKIqlc3AhLqI0zLIJLjV6nFG67SnJdNzg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Willy Tarreau <w@1wt.eu>,
        Emese Revfy <re.emese@gmail.com>,
        Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 24/70] random32: Restore __latent_entropy attribute on net_rand_state
Date:   Mon, 12 Oct 2020 15:26:40 +0200
Message-Id: <20201012132631.384954236@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012132630.201442517@linuxfoundation.org>
References: <20201012132630.201442517@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>

[ Upstream commit 09a6b0bc3be793ca8cba580b7992d73e9f68f15d ]

Commit f227e3ec3b5c ("random32: update the net random state on interrupt
and activity") broke compilation and was temporarily fixed by Linus in
83bdc7275e62 ("random32: remove net_rand_state from the latent entropy
gcc plugin") by entirely moving net_rand_state out of the things handled
by the latent_entropy GCC plugin.

>From what I understand when reading the plugin code, using the
__latent_entropy attribute on a declaration was the wrong part and
simply keeping the __latent_entropy attribute on the variable definition
was the correct fix.

Fixes: 83bdc7275e62 ("random32: remove net_rand_state from the latent entropy gcc plugin")
Acked-by: Willy Tarreau <w@1wt.eu>
Cc: Emese Revfy <re.emese@gmail.com>
Signed-off-by: Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/random32.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/random32.c b/lib/random32.c
index 6e2c48ab80722..eb54663e9e941 100644
--- a/lib/random32.c
+++ b/lib/random32.c
@@ -48,7 +48,7 @@ static inline void prandom_state_selftest(void)
 }
 #endif
 
-DEFINE_PER_CPU(struct rnd_state, net_rand_state);
+DEFINE_PER_CPU(struct rnd_state, net_rand_state)  __latent_entropy;
 
 /**
  *	prandom_u32_state - seeded pseudo-random number generator.
-- 
2.25.1



