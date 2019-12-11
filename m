Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6987011B198
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:32:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387544AbfLKP3I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:29:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:35600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387804AbfLKP3G (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:29:06 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2CE9E208C3;
        Wed, 11 Dec 2019 15:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576078145;
        bh=6wMgZwKLgEGkwTL+1Vd9LfABc3xDvEAKNMrFn8ElL7I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fh+HePk7mfpLL7kyHJlnQwSBOiNinoRGBe03h8YpaH+C2FxNDv9m/TwVpci7IgeEN
         t127DdVBiRVoaJkU08ieomCodoFZ75ijKd5SsdKRGCSAn1rYLUxtnES9g9Yd9nWZSW
         i+2Hl3fX1Dy2EZqhhyMN9Ysuh3VISIEA/ZEtgWzo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Coly Li <colyli@suse.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>, linux-bcache@vger.kernel.org,
        linux-raid@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 32/58] bcache: at least try to shrink 1 node in bch_mca_scan()
Date:   Wed, 11 Dec 2019 10:28:05 -0500
Message-Id: <20191211152831.23507-32-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191211152831.23507-1-sashal@kernel.org>
References: <20191211152831.23507-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Coly Li <colyli@suse.de>

[ Upstream commit 9fcc34b1a6dd4b8e5337e2b6ef45e428897eca6b ]

In bch_mca_scan(), the number of shrinking btree node is calculated
by code like this,
	unsigned long nr = sc->nr_to_scan;

        nr /= c->btree_pages;
        nr = min_t(unsigned long, nr, mca_can_free(c));
variable sc->nr_to_scan is number of objects (here is bcache B+tree
nodes' number) to shrink, and pointer variable sc is sent from memory
management code as parametr of a callback.

If sc->nr_to_scan is smaller than c->btree_pages, after the above
calculation, variable 'nr' will be 0 and nothing will be shrunk. It is
frequeently observed that only 1 or 2 is set to sc->nr_to_scan and make
nr to be zero. Then bch_mca_scan() will do nothing more then acquiring
and releasing mutex c->bucket_lock.

This patch checkes whether nr is 0 after the above calculation, if 0
is the result then set 1 to variable 'n'. Then at least bch_mca_scan()
will try to shrink a single B+tree node.

Signed-off-by: Coly Li <colyli@suse.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/bcache/btree.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index 9406326216f17..96a6583e7b522 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -685,6 +685,8 @@ static unsigned long bch_mca_scan(struct shrinker *shrink,
 	 * IO can always make forward progress:
 	 */
 	nr /= c->btree_pages;
+	if (nr == 0)
+		nr = 1;
 	nr = min_t(unsigned long, nr, mca_can_free(c));
 
 	i = 0;
-- 
2.20.1

