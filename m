Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D93B23A5FB
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 14:44:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728522AbgHCM3Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 08:29:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:55494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728492AbgHCM3L (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 08:29:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C4B50204EC;
        Mon,  3 Aug 2020 12:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596457750;
        bh=lRGvQiX1NE9fADubZkFmjLqelZvyaGRyN7GJQ68Un9s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gjY9dRirc0EI0hGckUJ8f+ZLmbOHpAzcj1FDN4WgQiEQCd8rxR1hus8Lo69JMEuV9
         GlvpEwVxcv2F1rd/K0kqf20vYco9WM7WcK15CNTMKj3eDSCZj1HK+6sJPiM8U/rYs3
         vvq+rDBTEc8WMzlZPUJta9Yt6Sb6aDk0+hz4u9NA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        Emese Revfy <re.emese@gmail.com>,
        Kees Cook <keescook@chromium.org>, Willy Tarreau <w@1wt.eu>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.4 30/90] random32: remove net_rand_state from the latent entropy gcc plugin
Date:   Mon,  3 Aug 2020 14:18:52 +0200
Message-Id: <20200803121859.081084452@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803121857.546052424@linuxfoundation.org>
References: <20200803121857.546052424@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 83bdc7275e6206f560d247be856bceba3e1ed8f2 upstream.

It turns out that the plugin right now ends up being really unhappy
about the change from 'static' to 'extern' storage that happened in
commit f227e3ec3b5c ("random32: update the net random state on interrupt
and activity").

This is probably a trivial fix for the latent_entropy plugin, but for
now, just remove net_rand_state from the list of things the plugin
worries about.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Emese Revfy <re.emese@gmail.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Willy Tarreau <w@1wt.eu>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/random.h |    2 +-
 lib/random32.c         |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -118,7 +118,7 @@ struct rnd_state {
 	__u32 s1, s2, s3, s4;
 };
 
-DECLARE_PER_CPU(struct rnd_state, net_rand_state) __latent_entropy;
+DECLARE_PER_CPU(struct rnd_state, net_rand_state);
 
 u32 prandom_u32_state(struct rnd_state *state);
 void prandom_bytes_state(struct rnd_state *state, void *buf, size_t nbytes);
--- a/lib/random32.c
+++ b/lib/random32.c
@@ -48,7 +48,7 @@ static inline void prandom_state_selftes
 }
 #endif
 
-DEFINE_PER_CPU(struct rnd_state, net_rand_state) __latent_entropy;
+DEFINE_PER_CPU(struct rnd_state, net_rand_state);
 
 /**
  *	prandom_u32_state - seeded pseudo-random number generator.


