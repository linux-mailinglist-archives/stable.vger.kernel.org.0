Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70EB337CD58
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:13:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238595AbhELQyd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:54:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:35488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243796AbhELQmF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:42:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 529706195D;
        Wed, 12 May 2021 16:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835621;
        bh=pvOxrufKu507MDFcsQKcJvR4f/KUBJNW3kRtyXS4k2U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tDdVhYXQcXNym5sUiEcZViBKKSz+frldzGT6+J0kBORFaStSXzPcBN9FV6XnWcHaL
         c4STu8EsOg/Mw4MKn0O4UC8qXAtzGgBh591dlWtW61KMFwLW30n3JZYHeS5t29ACNv
         hQ7MmARNZbiS1UpJUZTBv9LJYIzgS8TSt0htLI00=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Coly Li <colyli@suse.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 411/677] bcache: Use 64-bit arithmetic instead of 32-bit
Date:   Wed, 12 May 2021 16:47:37 +0200
Message-Id: <20210512144850.997155387@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gustavo A. R. Silva <gustavoars@kernel.org>

[ Upstream commit 62594f189e81caffa6a3bfa2fdb08eec2e347c76 ]

Cast multiple variables to (int64_t) in order to give the compiler
complete information about the proper arithmetic to use. Notice that
these variables are being used in contexts that expect expressions of
type int64_t  (64 bit, signed). And currently, such expressions are
being evaluated using 32-bit arithmetic.

Fixes: d0cf9503e908 ("octeontx2-pf: ethtool fec mode support")
Addresses-Coverity-ID: 1501724 ("Unintentional integer overflow")
Addresses-Coverity-ID: 1501725 ("Unintentional integer overflow")
Addresses-Coverity-ID: 1501726 ("Unintentional integer overflow")
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Signed-off-by: Coly Li <colyli@suse.de>
Link: https://lore.kernel.org/r/20210411134316.80274-7-colyli@suse.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/bcache/writeback.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index 82d4e0880a99..4fb635c0baa0 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -110,13 +110,13 @@ static void __update_writeback_rate(struct cached_dev *dc)
 		int64_t fps;
 
 		if (c->gc_stats.in_use <= BCH_WRITEBACK_FRAGMENT_THRESHOLD_MID) {
-			fp_term = dc->writeback_rate_fp_term_low *
+			fp_term = (int64_t)dc->writeback_rate_fp_term_low *
 			(c->gc_stats.in_use - BCH_WRITEBACK_FRAGMENT_THRESHOLD_LOW);
 		} else if (c->gc_stats.in_use <= BCH_WRITEBACK_FRAGMENT_THRESHOLD_HIGH) {
-			fp_term = dc->writeback_rate_fp_term_mid *
+			fp_term = (int64_t)dc->writeback_rate_fp_term_mid *
 			(c->gc_stats.in_use - BCH_WRITEBACK_FRAGMENT_THRESHOLD_MID);
 		} else {
-			fp_term = dc->writeback_rate_fp_term_high *
+			fp_term = (int64_t)dc->writeback_rate_fp_term_high *
 			(c->gc_stats.in_use - BCH_WRITEBACK_FRAGMENT_THRESHOLD_HIGH);
 		}
 		fps = div_s64(dirty, dirty_buckets) * fp_term;
-- 
2.30.2



