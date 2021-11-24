Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C46E45C102
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:11:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346175AbhKXNOL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:14:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:52010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347887AbhKXNMC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:12:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C81F861A89;
        Wed, 24 Nov 2021 12:42:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637757735;
        bh=DDlsLqg8+tfUhd2h9Ae05lprsiz6+HYoDCa7z0KovnA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NRayowcOdzptb1LbeaLp+Pt1Q36X/zsJQjehRpSRaT/8A3Fno/BFY5/P4yIBOtcHl
         KLa6ugYTywrSnT93H4vYxctidouF7pjkVCi2/xC0jmDoFAsUkgg0pvSRmiLJ+xBp92
         v3vGMhyZ5F1OhbHU4vaAG4YKRpASLlIQC2/lPA+4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Minchan Kim <minchan@kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 226/323] zram: off by one in read_block_state()
Date:   Wed, 24 Nov 2021 12:56:56 +0100
Message-Id: <20211124115726.554164015@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.822024889@linuxfoundation.org>
References: <20211124115718.822024889@linuxfoundation.org>
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
index 104206a795015..5e05bfcecd7b7 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -699,7 +699,7 @@ static ssize_t read_block_state(struct file *file, char __user *buf,
 			zram_test_flag(zram, index, ZRAM_WB) ? 'w' : '.',
 			zram_test_flag(zram, index, ZRAM_HUGE) ? 'h' : '.');
 
-		if (count < copied) {
+		if (count <= copied) {
 			zram_slot_unlock(zram, index);
 			break;
 		}
-- 
2.33.0



