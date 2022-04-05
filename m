Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3306F4F38D4
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:37:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377291AbiDEL2f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:28:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349798AbiDEJvd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:51:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15DC01D306;
        Tue,  5 Apr 2022 02:49:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AD6C7B81B76;
        Tue,  5 Apr 2022 09:49:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08891C385A2;
        Tue,  5 Apr 2022 09:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649152172;
        bh=3KGFa6EC32xjqdgLhOOEcMv8VXMCN8d2FHi3RO5nQi4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DLK2QYhwwNEt83m+Nt59xZ8TjiqyMlohuS/D63dsr7nDUstm4iL4EAv/IMt2ebtRF
         h7LGTy6ztEa4cEdxwnlBppWQVn9ytuM/RBr3Fylmu1l/kBcZT1W6wVBn25LGsECxrU
         UOZD+k+Xxx8MKDXfuehL9ByNUIZnXf8pzn2XFm6Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fedor Pchelkin <aissur0002@gmail.com>,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Christian Brauner <brauner@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.15 681/913] fs: fix fd table size alignment properly
Date:   Tue,  5 Apr 2022 09:29:03 +0200
Message-Id: <20220405070400.247751851@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit d888c83fcec75194a8a48ccd283953bdba7b2550 ]

Jason Donenfeld reports that my commit 1c24a186398f ("fs: fd tables have
to be multiples of BITS_PER_LONG") doesn't work, and the reason is an
embarrassing brown-paper-bag bug.

Yes, we want to align the number of fds to BITS_PER_LONG, and yes, the
reason they might not be aligned is because the incoming 'max_fd'
argument might not be aligned.

But aligining the argument - while simple - will cause a "infinitely
big" maxfd (eg NR_OPEN_MAX) to just overflow to zero.  Which most
definitely isn't what we want either.

The obvious fix was always just to do the alignment last, but I had
moved it earlier just to make the patch smaller and the code look
simpler.  Duh.  It certainly made _me_ look simple.

Fixes: 1c24a186398f ("fs: fd tables have to be multiples of BITS_PER_LONG")
Reported-and-tested-by: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Fedor Pchelkin <aissur0002@gmail.com>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: Christian Brauner <brauner@kernel.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/file.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/file.c b/fs/file.c
index c01c29417ae6..ee9317346702 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -303,10 +303,9 @@ static unsigned int sane_fdtable_size(struct fdtable *fdt, unsigned int max_fds)
 	unsigned int count;
 
 	count = count_open_files(fdt);
-	max_fds = ALIGN(max_fds, BITS_PER_LONG);
 	if (max_fds < NR_OPEN_DEFAULT)
 		max_fds = NR_OPEN_DEFAULT;
-	return min(count, max_fds);
+	return ALIGN(min(count, max_fds), BITS_PER_LONG);
 }
 
 /*
-- 
2.34.1



