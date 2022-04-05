Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82B754F2CF9
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:34:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242050AbiDEIgb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:36:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239600AbiDEIUP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:20:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27AEC83;
        Tue,  5 Apr 2022 01:17:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C9394B81BB2;
        Tue,  5 Apr 2022 08:17:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22650C385A1;
        Tue,  5 Apr 2022 08:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146629;
        bh=3KGFa6EC32xjqdgLhOOEcMv8VXMCN8d2FHi3RO5nQi4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K30RS9orHTn9vFLpPPhw5nkiFmcumWemH7adAwikgpvgooT4380kxTgMYTdA85Bq1
         qRHvkZC6xJVtjjAd68LYLxUNIyRca+F5JV6HHg/QdqAdMFV3r+QedADyasQnSPfIqB
         z+/nNHOyNTjAWpQ0gE7K/FP7twVqap5Ftv4Tolv4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fedor Pchelkin <aissur0002@gmail.com>,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Christian Brauner <brauner@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.17 0832/1126] fs: fix fd table size alignment properly
Date:   Tue,  5 Apr 2022 09:26:19 +0200
Message-Id: <20220405070431.979689181@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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



