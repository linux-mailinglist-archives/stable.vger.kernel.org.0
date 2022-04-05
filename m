Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC1414F3FD9
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 23:05:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382592AbiDEMQC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:16:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243531AbiDEKgv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:36:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C323954FA9;
        Tue,  5 Apr 2022 03:22:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 519A7617CC;
        Tue,  5 Apr 2022 10:22:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66C0BC385A1;
        Tue,  5 Apr 2022 10:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649154148;
        bh=3m/KIQ3dfU4W25SXZqENH+2s+cwiIgEtA775dYS6wko=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=po2NxxiQlzd/qTf00P+HSd5b9VeHRLgwHYC0fKQNFyzw5j889sSOn11KNASkt8BeU
         5naJkC0/5Etenqc8188uUAcxIJP3EXR6sPuQK6HSqJoZ2UDku+sUbHdDCdEePDmiX2
         OIVFpMeYEop8dwI13u31OLlyalS37vIeX4pLxsG8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fedor Pchelkin <aissur0002@gmail.com>,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Christian Brauner <brauner@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.10 448/599] fs: fix fd table size alignment properly
Date:   Tue,  5 Apr 2022 09:32:22 +0200
Message-Id: <20220405070312.161043627@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
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
index a47a1edb9404..8431dfde036c 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -301,10 +301,9 @@ static unsigned int sane_fdtable_size(struct fdtable *fdt, unsigned int max_fds)
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



