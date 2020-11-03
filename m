Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE3E02A5396
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:02:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387640AbgKCVCZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:02:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:39432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387607AbgKCVCZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 16:02:25 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1DD7820658;
        Tue,  3 Nov 2020 21:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437344;
        bh=qFx1xkdU2eva4awJW7UmW8OldpB/ylksvzIhiibh+Lo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gYrs2Yeh7meR/Mo7nLf5PEmYcayKdsq/4S9thU8ljRMFmAd6ot2r2d/Hedq8DRVPD
         XcYd9DiH11GPm5Ijm8MahSHIecVgCSD44jRAayu1lAAMISdvhkKSbI9ZhhEJLpY6YC
         VDHSNeMafwhWLJY3fq8yU4cZL/XhZ9VdLq8nVgjo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jari Ruusu <jariruusu@users.sourceforge.net>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 035/191] Revert "block: ratelimit handle_bad_sector() message"
Date:   Tue,  3 Nov 2020 21:35:27 +0100
Message-Id: <20201103203237.262082317@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203232.656475008@linuxfoundation.org>
References: <20201103203232.656475008@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit f86b9bf6228bb334fe1addcd566a658ecbd08f7e which is
commit f4ac712e4fe009635344b9af5d890fe25fcc8c0d upstream.

Jari Ruusu writes:

	Above change "block: ratelimit handle_bad_sector() message"
	upstream commit f4ac712e4fe009635344b9af5d890fe25fcc8c0d
	in 4.19.154 kernel is not completely OK.

	Removing casts from arguments 4 and 5 produces these compile warnings:

	...

	For 64 bit systems it is only compile time cosmetic warning. For 32 bit
	system + CONFIG_LBDAF=n it introduces bugs: output formats are "%llu" and
	passed parameters are 32 bits. That is not OK.

	Upstream kernels have hardcoded 64 bit sector_t. In older stable trees
	sector_t can be either 64 or 32 bit. In other words, backport of above patch
	needs to keep those original casts.

And Tetsuo Handa writes:
	Indeed, commit f4ac712e4fe00963 ("block: ratelimit handle_bad_sector() message")
	depends on commit 72deb455b5ec619f ("block: remove CONFIG_LBDAF") which was merged
	into 5.2 kernel.

So let's revert it.

Reported-by: Jari Ruusu <jariruusu@users.sourceforge.net>
Reported-by: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-core.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2127,10 +2127,11 @@ static void handle_bad_sector(struct bio
 {
 	char b[BDEVNAME_SIZE];
 
-	pr_info_ratelimited("attempt to access beyond end of device\n"
-			    "%s: rw=%d, want=%llu, limit=%llu\n",
-			    bio_devname(bio, b), bio->bi_opf,
-			    bio_end_sector(bio), maxsector);
+	printk(KERN_INFO "attempt to access beyond end of device\n");
+	printk(KERN_INFO "%s: rw=%d, want=%Lu, limit=%Lu\n",
+			bio_devname(bio, b), bio->bi_opf,
+			(unsigned long long)bio_end_sector(bio),
+			(long long)maxsector);
 }
 
 #ifdef CONFIG_FAIL_MAKE_REQUEST


