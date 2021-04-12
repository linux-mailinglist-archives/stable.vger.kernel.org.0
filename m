Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57B6D35BF40
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:03:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239408AbhDLJDZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:03:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:50172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239907AbhDLJBd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:01:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CCBC261368;
        Mon, 12 Apr 2021 08:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217998;
        bh=xPMfY9rYYc8/wV1y5ujmto9Q6t0sP9asxpzX3X6uuyQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ybKDKP7cRq8WWVXD45W454zhCPlXbvLg+uJevm2z9ZiwGCD0R8u3GELBTTd0A+PMh
         sqXd8QSh1t1tv99ArMkwWM5eTeSVZXXBPX/i4ZUI6A52Zc9F0NByNVTMdhTLGK20m2
         wQdtf5+mhggD6s7xZ29bD/t4+aFAECLOSCiK8Prk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jack Qiu <jack.qiu@huawei.com>,
        Jan Kara <jack@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.11 033/210] fs: direct-io: fix missing sdio->boundary
Date:   Mon, 12 Apr 2021 10:38:58 +0200
Message-Id: <20210412084017.114549166@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084016.009884719@linuxfoundation.org>
References: <20210412084016.009884719@linuxfoundation.org>
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
@@ -810,6 +810,7 @@ submit_page_section(struct dio *dio, str
 		    struct buffer_head *map_bh)
 {
 	int ret = 0;
+	int boundary = sdio->boundary;	/* dio_send_cur_page may clear it */
 
 	if (dio->op == REQ_OP_WRITE) {
 		/*
@@ -848,10 +849,10 @@ submit_page_section(struct dio *dio, str
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


