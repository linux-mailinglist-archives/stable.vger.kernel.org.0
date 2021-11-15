Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EC53450C50
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:34:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237958AbhKORhS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:37:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:46734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238200AbhKORdl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:33:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5902F6325A;
        Mon, 15 Nov 2021 17:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636996931;
        bh=nJh6X3XCssSTcp4OKPsg/rRGTRYKCVCYJNT0ZWm5Rxs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ds1wQdaas2of2Cj1lwcIZRLNi8aQuKK8XoVGBj+rog0cQST3dbPVuWEpc95qft3Qt
         bWqJtmOHq3VRYdT1Sm2JHjIU+LuW4W8pdsTIkSWTy5pk7i7LJ8f7mEmIMXOZ2Fz6Vb
         N2snT/tkfFnGF5IDa28BEcgHbREM2iPRnDclT9yk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Minchan Kim <minchan@kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 321/355] zram: off by one in read_block_state()
Date:   Mon, 15 Nov 2021 18:04:05 +0100
Message-Id: <20211115165324.119167068@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165313.549179499@linuxfoundation.org>
References: <20211115165313.549179499@linuxfoundation.org>
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
index 719c6b7741afa..1cc9b67e9bcaa 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -901,7 +901,7 @@ static ssize_t read_block_state(struct file *file, char __user *buf,
 			zram_test_flag(zram, index, ZRAM_HUGE) ? 'h' : '.',
 			zram_test_flag(zram, index, ZRAM_IDLE) ? 'i' : '.');
 
-		if (count < copied) {
+		if (count <= copied) {
 			zram_slot_unlock(zram, index);
 			break;
 		}
-- 
2.33.0



