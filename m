Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F8B4C14E0
	for <lists+stable@lfdr.de>; Sun, 29 Sep 2019 16:00:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729584AbfI2N6r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Sep 2019 09:58:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:39650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729530AbfI2N6r (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Sep 2019 09:58:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0AE5521906;
        Sun, 29 Sep 2019 13:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569765526;
        bh=+KG8sRgP3Wm81Em5/w/DimPHknppyCnQMQyI2CmVChw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fizPgT0TZk2drue2pnIsnyKV1ZtLIeVe+kUAu7Qlkjz7WwFqBUxiIZDghnyoj2CAF
         0bnTXFZW72owr7NR34pyhGf1Mig+wzBzcqaV0wHNfs9WtfBc5PxatlA5N7qxyf8+Ey
         95r6mx221w4lSRiuq/Scrv+qWI5Pp5xo5zNKSd0U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Juha Aatrokoski <juha.aatrokoski@aalto.fi>,
        Shenghui Wang <shhuiw@foxmail.com>, Coly Li <colyli@suse.de>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 46/63] bcache: remove redundant LIST_HEAD(journal) from run_cache_set()
Date:   Sun, 29 Sep 2019 15:54:19 +0200
Message-Id: <20190929135039.656505067@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190929135031.382429403@linuxfoundation.org>
References: <20190929135031.382429403@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Coly Li <colyli@suse.de>

[ Upstream commit cdca22bcbc64fc83dadb8d927df400a8d86ddabb ]

Commit 95f18c9d1310 ("bcache: avoid potential memleak of list of
journal_replay(s) in the CACHE_SYNC branch of run_cache_set") forgets
to remove the original define of LIST_HEAD(journal), which makes
the change no take effect. This patch removes redundant variable
LIST_HEAD(journal) from run_cache_set(), to make Shenghui's fix
working.

Fixes: 95f18c9d1310 ("bcache: avoid potential memleak of list of journal_replay(s) in the CACHE_SYNC branch of run_cache_set")
Reported-by: Juha Aatrokoski <juha.aatrokoski@aalto.fi>
Cc: Shenghui Wang <shhuiw@foxmail.com>
Signed-off-by: Coly Li <colyli@suse.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/bcache/super.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index e6c7a84bb1dfd..2321643974dab 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1768,7 +1768,6 @@ static int run_cache_set(struct cache_set *c)
 	set_gc_sectors(c);
 
 	if (CACHE_SYNC(&c->sb)) {
-		LIST_HEAD(journal);
 		struct bkey *k;
 		struct jset *j;
 
-- 
2.20.1



