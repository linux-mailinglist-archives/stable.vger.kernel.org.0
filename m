Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB5331A5194
	for <lists+stable@lfdr.de>; Sat, 11 Apr 2020 14:26:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727845AbgDKMPV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 08:15:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:49190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727709AbgDKMPU (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 08:15:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C13222084D;
        Sat, 11 Apr 2020 12:15:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586607320;
        bh=psWo3vxO9dOfTYyyLQHvRQ4yWnK9O3yBuNjwQZxqUww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ouCIqxZ5/3NGQjkgsyG9ovSsW5DPt61EYMoZcO7DxqBej5fz8GUa7bTx5HRzyybE+
         IimS6dZbpVD3tVnStQBROmxeM6+6mpakVM968x2cPVkwXnRkWmIa2plLeAYGQqL4Am
         Gk2nMoSRMvrENrv+gCWe1l++6Fpy6us2ryhOrSq4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sam Protsenko <semen.protsenko@linaro.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.19 26/54] include/linux/notifier.h: SRCU: fix ctags
Date:   Sat, 11 Apr 2020 14:09:08 +0200
Message-Id: <20200411115511.146571362@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200411115508.284500414@linuxfoundation.org>
References: <20200411115508.284500414@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sam Protsenko <semen.protsenko@linaro.org>

commit 94e297c50b529f5d01cfd1dbc808d61e95180ab7 upstream.

ctags indexing ("make tags" command) throws this warning:

    ctags: Warning: include/linux/notifier.h:125:
    null expansion of name pattern "\1"

This is the result of DEFINE_PER_CPU() macro expansion.  Fix that by
getting rid of line break.

Similar fix was already done in commit 25528213fe9f ("tags: Fix
DEFINE_PER_CPU expansions"), but this one probably wasn't noticed.

Link: http://lkml.kernel.org/r/20181030202808.28027-1-semen.protsenko@linaro.org
Fixes: 9c80172b902d ("kernel/SRCU: provide a static initializer")
Signed-off-by: Sam Protsenko <semen.protsenko@linaro.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/notifier.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/include/linux/notifier.h
+++ b/include/linux/notifier.h
@@ -122,8 +122,7 @@ extern void srcu_init_notifier_head(stru
 
 #ifdef CONFIG_TREE_SRCU
 #define _SRCU_NOTIFIER_HEAD(name, mod)				\
-	static DEFINE_PER_CPU(struct srcu_data,			\
-			name##_head_srcu_data);			\
+	static DEFINE_PER_CPU(struct srcu_data, name##_head_srcu_data); \
 	mod struct srcu_notifier_head name =			\
 			SRCU_NOTIFIER_INIT(name, name##_head_srcu_data)
 


