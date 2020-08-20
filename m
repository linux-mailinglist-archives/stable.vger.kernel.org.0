Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3531824BA6E
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 14:09:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729203AbgHTMII (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 08:08:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:42082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730163AbgHTJ6G (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:58:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 35A302173E;
        Thu, 20 Aug 2020 09:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597917485;
        bh=Frf3AzWuRJQozZws9o6kjeBXM3xmVVQymRkBBKU2Zdg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YujGKb5rWGSxAOvwrnFqoDc538DTuAdrjW3ubG7ZHSXsO5xP9z8TDP/+rzQNQGg/Y
         ndBTPDNb5JNSlsgUxffiutZ40BY5eneDixmbF45zCsvSlhSXRM8/butwReHYpZ7XEb
         N5Lj3KnsZIYt1MjvbUyJYxlLyXEpAJNOq0a8smiI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        Emese Revfy <re.emese@gmail.com>,
        Kees Cook <keescook@chromium.org>, Willy Tarreau <w@1wt.eu>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.9 048/212] random32: remove net_rand_state from the latent entropy gcc plugin
Date:   Thu, 20 Aug 2020 11:20:21 +0200
Message-Id: <20200820091604.793802868@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091602.251285210@linuxfoundation.org>
References: <20200820091602.251285210@linuxfoundation.org>
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
@@ -56,7 +56,7 @@ struct rnd_state {
 	__u32 s1, s2, s3, s4;
 };
 
-DECLARE_PER_CPU(struct rnd_state, net_rand_state) __latent_entropy;
+DECLARE_PER_CPU(struct rnd_state, net_rand_state);
 
 u32 prandom_u32_state(struct rnd_state *state);
 void prandom_bytes_state(struct rnd_state *state, void *buf, size_t nbytes);
--- a/lib/random32.c
+++ b/lib/random32.c
@@ -47,7 +47,7 @@ static inline void prandom_state_selftes
 }
 #endif
 
-DEFINE_PER_CPU(struct rnd_state, net_rand_state) __latent_entropy;
+DEFINE_PER_CPU(struct rnd_state, net_rand_state);
 
 /**
  *	prandom_u32_state - seeded pseudo-random number generator.


