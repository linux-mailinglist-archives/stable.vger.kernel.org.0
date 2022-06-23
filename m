Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7F75558062
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 18:52:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232465AbiFWQqo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 12:46:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232525AbiFWQqW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 12:46:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6FEB49B48;
        Thu, 23 Jun 2022 09:46:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7640B61F8B;
        Thu, 23 Jun 2022 16:46:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38A5CC3411B;
        Thu, 23 Jun 2022 16:46:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656002780;
        bh=yB7EFq7zmujwtMOqpM9csnu5bZuf8C3k9kLxj+uqSNM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pwVexN0P7wwzkhhntSh58dc3wJI+CTuJl0Ya/Xaqv/T9Dmh/NS7bRhcCdRI1R/Zzl
         wfNh521A5L3ThhTpZe3jlb3f3GxX/hQV6nLpbv/Alc87Iy91O4v5m4GUczxzNkDvVt
         e+o/0FM8l9iV+HF4LJXrWPP2FWUh2wR39iIAIKPs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
        Qian Cai <cai@lca.pw>, Theodore Tso <tytso@mit.edu>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 023/264] Revert "char/random: silence a lockdep splat with printk()"
Date:   Thu, 23 Jun 2022 18:40:16 +0200
Message-Id: <20220623164344.722356710@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623164344.053938039@linuxfoundation.org>
References: <20220623164344.053938039@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1638,9 +1638,8 @@ static void _warn_unseeded_randomness(co
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


