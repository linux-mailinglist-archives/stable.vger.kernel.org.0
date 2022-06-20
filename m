Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 075B4551B3E
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:46:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345373AbiFTNaL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:30:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347337AbiFTN3n (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:29:43 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2D1024BF6;
        Mon, 20 Jun 2022 06:12:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E6382CE13A3;
        Mon, 20 Jun 2022 13:11:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBCFFC3411B;
        Mon, 20 Jun 2022 13:11:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655730661;
        bh=169o5FPmOJtQ4Sel7cBcUBBw+qmGIUfMF/1QLJf3NIw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JyTXWqc1IPCB7PKhbzoPPwUYMVaBCker9xMJFy2j+09obFFlb9MzcqF/7+70hyaTB
         Pd9yi8IbRRRZYF/y6C9uXd3aYMoTrAWxy+4oU82UqSH4eeR/qj1sWDWN0Hi3lIeZHw
         u8WfgIhnPvJkiJjLMwx0XOn+PLeO4A2DXApDo0gg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yangtao Li <tiny.windzz@gmail.com>,
        Theodore Tso <tytso@mit.edu>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.4 017/240] random: remove unnecessary unlikely()
Date:   Mon, 20 Jun 2022 14:48:38 +0200
Message-Id: <20220620124738.310787460@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124737.799371052@linuxfoundation.org>
References: <20220620124737.799371052@linuxfoundation.org>
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

From: Yangtao Li <tiny.windzz@gmail.com>

commit 870e05b1b18814911cb2703a977f447cb974f0f9 upstream.

WARN_ON() already contains an unlikely(), so it's not necessary to use
unlikely.

Signed-off-by: Yangtao Li <tiny.windzz@gmail.com>
Link: https://lore.kernel.org/r/20190607182517.28266-1-tiny.windzz@gmail.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -737,10 +737,9 @@ retry:
 		} while (unlikely(entropy_count < pool_size-2 && pnfrac));
 	}
 
-	if (unlikely(entropy_count < 0)) {
+	if (WARN_ON(entropy_count < 0)) {
 		pr_warn("random: negative entropy/overflow: pool %s count %d\n",
 			r->name, entropy_count);
-		WARN_ON(1);
 		entropy_count = 0;
 	} else if (entropy_count > pool_size)
 		entropy_count = pool_size;
@@ -1384,10 +1383,9 @@ retry:
 	if (ibytes < min)
 		ibytes = 0;
 
-	if (unlikely(entropy_count < 0)) {
+	if (WARN_ON(entropy_count < 0)) {
 		pr_warn("random: negative entropy count: pool %s count %d\n",
 			r->name, entropy_count);
-		WARN_ON(1);
 		entropy_count = 0;
 	}
 	nfrac = ibytes << (ENTROPY_SHIFT + 3);


