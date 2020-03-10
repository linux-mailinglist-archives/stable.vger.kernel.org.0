Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDD9F17FC3F
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:20:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729349AbgCJNIK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 09:08:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:54392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730674AbgCJNIJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 09:08:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2589A2071B;
        Tue, 10 Mar 2020 13:08:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583845688;
        bh=iirXMFtrjTWqvNqFNKcyiULPcJ9awiu6iFtohtrPwao=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f//htnQxkdKZcH7ULZYHm0zlBiMvwh1cVqRzcVkawqJnAYOMQQGmuGY3Ovnh6Jkny
         i3feYKxjF/EQJrbzTmgm9Ap6bgR7/BVHmKdCj2k8416Fw9oUaDT2ZRRzT7z0xyCeQI
         NOHdArKVz0/pLT97wa87ssmT11CIX6jsIhHTNydU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
        Qian Cai <cai@lca.pw>, Theodore Tso <tytso@mit.edu>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 065/126] [PATCH] Revert "char/random: silence a lockdep splat with printk()"
Date:   Tue, 10 Mar 2020 13:41:26 +0100
Message-Id: <20200310124208.239864688@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310124203.704193207@linuxfoundation.org>
References: <20200310124203.704193207@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit 28820c5802f9f83c655ab09ccae8289103ce1490 which is
commit 1b710b1b10eff9d46666064ea25f079f70bc67a8 upstream.

It causes problems here just like it did in 4.19.y and odds are it will
be reverted upstream as well.

Reported-by: Guenter Roeck <linux@roeck-us.net>
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Cc: Qian Cai <cai@lca.pw>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1598,9 +1598,8 @@ static void _warn_unseeded_randomness(co
 	print_once = true;
 #endif
 	if (__ratelimit(&unseeded_warning))
-		printk_deferred(KERN_NOTICE "random: %s called from %pS "
-				"with crng_init=%d\n", func_name, caller,
-				crng_init);
+		pr_notice("random: %s called from %pS with crng_init=%d\n",
+			  func_name, caller, crng_init);
 }
 
 /*


