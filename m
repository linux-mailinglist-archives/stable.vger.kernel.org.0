Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2881450EBC
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:17:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241216AbhKOSSs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:18:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:49940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240696AbhKOSLr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:11:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 65DE2632A5;
        Mon, 15 Nov 2021 17:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998474;
        bh=K4ERwWR4LwPt40Npf85Fkey4vTkI501PpQuA8DqkiSg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QC/HLyrCfsVmt3brOaMgGezLe5Pjdu6V3wlyUBm+I1PJYw8N6Y4PsfJBe0sDx5Qqg
         fJWg7Sc3oI8/NxewcMUPJiEnyIhgcawEmiVlwZV3GSPNiGwsfodYm2AfA8hAt384qC
         i7NWZO2mKeLeGweYqo7y7ryupYse7tkLE8rYSIRk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Minchan Kim <minchan@kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 522/575] zram: off by one in read_block_state()
Date:   Mon, 15 Nov 2021 18:04:07 +0100
Message-Id: <20211115165401.727976427@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit a88e03cf3d190cf46bc4063a9b7efe87590de5f4 ]

snprintf() returns the number of bytes it would have printed if there
were space.  But it does not count the NUL terminator.  So that means
that if "count == copied" then this has already overflowed by one
character.

This bug likely isn't super harmful in real life.

Link: https://lkml.kernel.org/r/20210916130404.GA25094@kili
Fixes: c0265342bff4 ("zram: introduce zram memory tracking")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/zram/zram_drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 7dce17fd59baa..0636df6b67db6 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -907,7 +907,7 @@ static ssize_t read_block_state(struct file *file, char __user *buf,
 			zram_test_flag(zram, index, ZRAM_HUGE) ? 'h' : '.',
 			zram_test_flag(zram, index, ZRAM_IDLE) ? 'i' : '.');
 
-		if (count < copied) {
+		if (count <= copied) {
 			zram_slot_unlock(zram, index);
 			break;
 		}
-- 
2.33.0



