Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9245AB2104
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:49:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388270AbfIMNbW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:31:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:41038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389074AbfIMNO7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:14:59 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 93214206BB;
        Fri, 13 Sep 2019 13:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380498;
        bh=F1LQPQ4943RvaxStbHaOxpfq/L5t+tyLc3hDL/XQhyE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wSeRaVlf/Q1RJjDz1uo0ikdhXuCy9D8QAeKVLr8UwUFZE6hLwfWJAcahgZ6iAnJhV
         fTXTrBDmwDtfxcnCucUNorMV0o1jIBKkUeRpz8Tfl9oxtl4SoDoGSrdQpKtZ8qtVZb
         VcUxGVFCpBWmcMlW9j19RGfyyiOicKTq6ty9GO+4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Coly Li <colyli@suse.de>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 085/190] bcache: replace hard coded number with BUCKET_GC_GEN_MAX
Date:   Fri, 13 Sep 2019 14:05:40 +0100
Message-Id: <20190913130606.345944203@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130559.669563815@linuxfoundation.org>
References: <20190913130559.669563815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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



