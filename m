Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF02F23D1A1
	for <lists+stable@lfdr.de>; Wed,  5 Aug 2020 22:04:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727951AbgHEUD5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Aug 2020 16:03:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:50660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727807AbgHEQgh (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 Aug 2020 12:36:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9663F233F8;
        Wed,  5 Aug 2020 15:53:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596642819;
        bh=szKyfdCf1Jf/SkG9ybiPLg0SInDIfcKuTeM+JmnJMz0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KdltBeSS97D5QFBcrBS7GNA9LF+6Ql3eyMCNWFFBgvh8W46mXMEinNNrePvsdjVr0
         Ilc29OfbuD4pbsH6b73FmUpEB3pVdXf4KYSKDSyb66ZakmrmU5ZGHUCUUMSJ8Q+0BV
         JGyswoe7E9fc/JzMdWtyV1Jzr9iOl+XdWuAdAjaI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        Emese Revfy <re.emese@gmail.com>,
        Kees Cook <keescook@chromium.org>, Willy Tarreau <w@1wt.eu>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.14 5/8] random32: remove net_rand_state from the latent entropy gcc plugin
Date:   Wed,  5 Aug 2020 17:53:31 +0200
Message-Id: <20200805153507.254999876@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200805153507.005753845@linuxfoundation.org>
References: <20200805153507.005753845@linuxfoundation.org>
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
@@ -117,7 +117,7 @@ struct rnd_state {
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


