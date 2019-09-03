Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA29AA700A
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 18:37:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730175AbfICQga (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 12:36:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:48498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730376AbfICQ1N (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 12:27:13 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6E25423878;
        Tue,  3 Sep 2019 16:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567528033;
        bh=Hg0hl4drIwoXBc3Dnqv3bKk9iYohv7mRCHPYg3yUr8w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U7a+kNMMNynsu3WcKNDw5K68D7MHO8D0Li9UMon89+TI+u5xtUY9g+BQTGHeqG+us
         /f33zzS8Xm+4+2wfJaEwS4to9uz+/hrvcd92WBZkdEc4UkAlc/Z+qmYCumpf1v3DUF
         FfMMivLyzhBo056ucAkKP8TTvJGSOj5zzVAyOjMk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Coly Li <colyli@suse.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>, linux-bcache@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 063/167] bcache: replace hard coded number with BUCKET_GC_GEN_MAX
Date:   Tue,  3 Sep 2019 12:23:35 -0400
Message-Id: <20190903162519.7136-63-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190903162519.7136-1-sashal@kernel.org>
References: <20190903162519.7136-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Coly Li <colyli@suse.de>

[ Upstream commit 149d0efada7777ad5a5242b095692af142f533d8 ]

In extents.c:bch_extent_bad(), number 96 is used as parameter to call
btree_bug_on(). The purpose is to check whether stale gen value exceeds
BUCKET_GC_GEN_MAX, so it is better to use macro BUCKET_GC_GEN_MAX to
make the code more understandable.

Signed-off-by: Coly Li <colyli@suse.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/bcache/extents.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bcache/extents.c b/drivers/md/bcache/extents.c
index c809724e6571e..9560043666999 100644
--- a/drivers/md/bcache/extents.c
+++ b/drivers/md/bcache/extents.c
@@ -553,7 +553,7 @@ static bool bch_extent_bad(struct btree_keys *bk, const struct bkey *k)
 	for (i = 0; i < KEY_PTRS(k); i++) {
 		stale = ptr_stale(b->c, k, i);
 
-		btree_bug_on(stale > 96, b,
+		btree_bug_on(stale > BUCKET_GC_GEN_MAX, b,
 			     "key too stale: %i, need_gc %u",
 			     stale, b->c->need_gc);
 
-- 
2.20.1

