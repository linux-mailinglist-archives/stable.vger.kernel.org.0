Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 249AF360CE7
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 16:55:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234309AbhDOOz1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 10:55:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:40110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234320AbhDOOyF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Apr 2021 10:54:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 246AC613DC;
        Thu, 15 Apr 2021 14:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618498362;
        bh=7LGMEXUFKP+BATG+mcTiafkkyJfkzAGms4Y68Hgopt0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p/y9zcu05Du4jcS666hU4tOb8zeSkhDL8SjNzJCjMIf0NYdATKauOMy6PCUTP5TV/
         0774Hc2Xy/s6df6a4cSZEweKK9bSwJShvVKADy54DIyeJrs3YFyMyQHZ2t6SyBw/6M
         csM2Q2cXf3vykg/k0/KXB5vbT/o4x+0yyJ/m+96k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jack Qiu <jack.qiu@huawei.com>,
        Jan Kara <jack@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.14 11/68] fs: direct-io: fix missing sdio->boundary
Date:   Thu, 15 Apr 2021 16:46:52 +0200
Message-Id: <20210415144414.837768273@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210415144414.464797272@linuxfoundation.org>
References: <20210415144414.464797272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jack Qiu <jack.qiu@huawei.com>

commit df41872b68601059dd4a84858952dcae58acd331 upstream.

I encountered a hung task issue, but not a performance one.  I run DIO
on a device (need lba continuous, for example open channel ssd), maybe
hungtask in below case:

  DIO:						Checkpoint:
  get addr A(at boundary), merge into BIO,
  no submit because boundary missing
						flush dirty data(get addr A+1), wait IO(A+1)
						writeback timeout, because DIO(A) didn't submit
  get addr A+2 fail, because checkpoint is doing

dio_send_cur_page() may clear sdio->boundary, so prevent it from missing
a boundary.

Link: https://lkml.kernel.org/r/20210322042253.38312-1-jack.qiu@huawei.com
Fixes: b1058b981272 ("direct-io: submit bio after boundary buffer is added to it")
Signed-off-by: Jack Qiu <jack.qiu@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/direct-io.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -857,6 +857,7 @@ submit_page_section(struct dio *dio, str
 		    struct buffer_head *map_bh)
 {
 	int ret = 0;
+	int boundary = sdio->boundary;	/* dio_send_cur_page may clear it */
 
 	if (dio->op == REQ_OP_WRITE) {
 		/*
@@ -895,10 +896,10 @@ submit_page_section(struct dio *dio, str
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


