Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8D7335A7D6
	for <lists+stable@lfdr.de>; Fri,  9 Apr 2021 22:27:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234191AbhDIU1t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Apr 2021 16:27:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:51778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233824AbhDIU1t (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Apr 2021 16:27:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B0E5161165;
        Fri,  9 Apr 2021 20:27:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1618000055;
        bh=BUgjFAORFhyddwQTMFLp0PUTyEbWlr9CPwdyUX2d/A8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=w7F57gf2IilrNatic5lsFfjRjsmTFEIZMASN6o7ANADgFzhivCuKEn44FM9gslQnx
         sJh1EQfsi4d7sxOGT46VZiafB8xHpOCH7wtE9lrgJ/x8D2gqrtoba3B+O1xYC3he3b
         ARuhJDO9GjksLSYg1K83Ie6CFegt1rmfY0p1BJus=
Date:   Fri, 09 Apr 2021 13:27:35 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, jack.qiu@huawei.com, jack@suse.cz,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 12/16] fs: direct-io: fix missing sdio->boundary
Message-ID: <20210409202735.f8KT72Y5i%akpm@linux-foundation.org>
In-Reply-To: <20210409132633.6855fc8fea1b3905ea1bb4be@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jack Qiu <jack.qiu@huawei.com>
Subject: fs: direct-io: fix missing sdio->boundary

I encountered a hung task issue, but not a performance one.  I run DIO
on a device (need lba continuous, for example open channel ssd), maybe
hungtask in below case:

DIO:						Checkpoint:
get addr A(at boundary), merge into BIO,
no submit because boundary missing
						flush dirty data(get addr A+1), wait IO(A+1)
						writeback timeout, because DIO(A) didn't submit
get addr A+2 fail, because checkpoint is doing


dio_send_cur_page() may clear sdio->boundary, so prevent it from
missing a boundary.

Link: https://lkml.kernel.org/r/20210322042253.38312-1-jack.qiu@huawei.com
Fixes: b1058b981272 ("direct-io: submit bio after boundary buffer is
added to it")
Signed-off-by: Jack Qiu <jack.qiu@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/direct-io.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/direct-io.c~fs-direct-io-fix-missing-sdio-boundary
+++ a/fs/direct-io.c
@@ -812,6 +812,7 @@ submit_page_section(struct dio *dio, str
 		    struct buffer_head *map_bh)
 {
 	int ret = 0;
+	int boundary = sdio->boundary;	/* dio_send_cur_page may clear it */
 
 	if (dio->op == REQ_OP_WRITE) {
 		/*
@@ -850,10 +851,10 @@ submit_page_section(struct dio *dio, str
 	sdio->cur_page_fs_offset = sdio->block_in_file << sdio->blkbits;
 out:
 	/*
-	 * If sdio->boundary then we want to schedule the IO now to
+	 * If boundary then we want to schedule the IO now to
 	 * avoid metadata seeks.
 	 */
-	if (sdio->boundary) {
+	if (boundary) {
 		ret = dio_send_cur_page(dio, sdio, map_bh);
 		if (sdio->bio)
 			dio_bio_submit(dio, sdio);
_
