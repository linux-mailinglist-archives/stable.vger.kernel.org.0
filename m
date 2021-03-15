Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F79D33BA7F
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:10:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232167AbhCOOJa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:09:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:50816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233001AbhCOOD6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:03:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7A26364E83;
        Mon, 15 Mar 2021 14:03:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615817037;
        bh=WwPBGAYBGzs6XzBbiI6mldC2Tgnb08UZi4a5Wx6imh0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ShRUOaaf2wdFZOjgrGJt8QisUa4V+0Aso6OIjElObKfS5SRu1fwpPVGQG+lB3vMus
         fkfvLtY+pv7bUr6smu/EkOAlQEmkKR4LQyQ/L4KUF8FOnP+rKpxYVnfbCw0NZprc6Y
         5pF01Swpzk7Aq26jfwERTri9tN70RJXBJUYyeuYA=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Minchan Kim <minchan@kernel.org>,
        Amos Bianchi <amosbianchi@google.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        John Dias <joaodias@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.11 270/306] zram: fix broken page writeback
Date:   Mon, 15 Mar 2021 14:55:33 +0100
Message-Id: <20210315135516.787087270@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Minchan Kim <minchan@kernel.org>

commit 2766f1821600cc7562bae2128ad0b163f744c5d9 upstream.

commit 0d8359620d9b ("zram: support page writeback") introduced two
problems.  It overwrites writeback_store's return value as kstrtol's
return value, which makes return value zero so user could see zero as
return value of write syscall even though it wrote data successfully.

It also breaks index value in the loop in that it doesn't increase the
index any longer.  It means it can write only first starting block index
so user couldn't write all idle pages in the zram so lose memory saving
chance.

This patch fixes those issues.

Link: https://lkml.kernel.org/r/20210312173949.2197662-2-minchan@kernel.org
Fixes: 0d8359620d9b("zram: support page writeback")
Signed-off-by: Minchan Kim <minchan@kernel.org>
Reported-by: Amos Bianchi <amosbianchi@google.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: John Dias <joaodias@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/zram/zram_drv.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -639,8 +639,8 @@ static ssize_t writeback_store(struct de
 		if (strncmp(buf, PAGE_WB_SIG, sizeof(PAGE_WB_SIG) - 1))
 			return -EINVAL;
 
-		ret = kstrtol(buf + sizeof(PAGE_WB_SIG) - 1, 10, &index);
-		if (ret || index >= nr_pages)
+		if (kstrtol(buf + sizeof(PAGE_WB_SIG) - 1, 10, &index) ||
+				index >= nr_pages)
 			return -EINVAL;
 
 		nr_pages = 1;
@@ -664,7 +664,7 @@ static ssize_t writeback_store(struct de
 		goto release_init_lock;
 	}
 
-	while (nr_pages--) {
+	for (; nr_pages != 0; index++, nr_pages--) {
 		struct bio_vec bvec;
 
 		bvec.bv_page = page;


