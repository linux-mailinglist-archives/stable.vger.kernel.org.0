Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7737401B9B
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 14:57:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242854AbhIFM6Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Sep 2021 08:58:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:34572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242623AbhIFM57 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 Sep 2021 08:57:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D298D60238;
        Mon,  6 Sep 2021 12:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630933014;
        bh=ZXG+VKsM9XqzTKhgPugdaWA+lv5D3YVSh++888oPZwk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g8IMr4WRnKBjx4u2WWB8aqrA//e7wSqrYfLAoq8jHSS7duNMYjYzAeEK9OEz8dsXL
         peErzN0Ysh0By6dqdu5L8Ki3tKKt6l1Zttcw+5S7J2eXwbjq9YGnFmmui22ET7+59i
         dFyudidIFuL9+P40wbZzeWIJQpEhrsDd4hAqfdXg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 5.10 09/29] static_call: Fix unused variable warn w/o MODULE
Date:   Mon,  6 Sep 2021 14:55:24 +0200
Message-Id: <20210906125450.091158526@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210906125449.756437409@linuxfoundation.org>
References: <20210906125449.756437409@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthieu Baerts <matthieu.baerts@tessares.net>

commit 7d95f22798ecea513f37b792b39fec4bcf20fec3 upstream.

Here is the warning converted as error and reported by GCC:

  kernel/static_call.c: In function ‘__static_call_update’:
  kernel/static_call.c:153:18: error: unused variable ‘mod’ [-Werror=unused-variable]
    153 |   struct module *mod = site_mod->mod;
        |                  ^~~
  cc1: all warnings being treated as errors
  make[1]: *** [scripts/Makefile.build:271: kernel/static_call.o] Error 1

This is simply because since recently, we no longer use 'mod' variable
elsewhere if MODULE is unset.

When using 'make tinyconfig' to generate the default kconfig, MODULE is
unset.

There are different ways to fix this warning. Here I tried to minimised
the number of modified lines and not add more #ifdef. We could also move
the declaration of the 'mod' variable inside the if-statement or
directly use site_mod->mod.

Fixes: 698bacefe993 ("static_call: Align static_call_is_init() patching condition")
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20210326105023.2058860-1-matthieu.baerts@tessares.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/static_call.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/static_call.c
+++ b/kernel/static_call.c
@@ -165,13 +165,13 @@ void __static_call_update(struct static_
 
 		stop = __stop_static_call_sites;
 
-#ifdef CONFIG_MODULES
 		if (mod) {
+#ifdef CONFIG_MODULES
 			stop = mod->static_call_sites +
 			       mod->num_static_call_sites;
 			init = mod->state == MODULE_STATE_COMING;
-		}
 #endif
+		}
 
 		for (site = site_mod->sites;
 		     site < stop && static_call_key(site) == key; site++) {


