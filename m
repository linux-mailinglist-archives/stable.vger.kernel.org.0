Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDACF1FE623
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:31:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728563AbgFRCbg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 22:31:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:45522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729467AbgFRBP1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:15:27 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 58DAB21BE5;
        Thu, 18 Jun 2020 01:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442927;
        bh=FHvIHZBvsYki0huCJSRxURfvcYjTpSIGvmOyauW/84w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=efbA0itkZ7lLQJgF1Ah81aWgyL6mikWKxgQ05DFTLafMepOChgkxde3eLBLxONFni
         LJIFwzA7KnuGudlEHLktQl4xFlbggZ7Je/6SyWsfYpx5qWmjpwkl37MYFvMvc5o1Pl
         3YvGJVf6Vv2/eXtNZrbjKxYURZTcFWr52RG7DgeY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 341/388] blktrace: fix endianness for blk_log_remap()
Date:   Wed, 17 Jun 2020 21:07:18 -0400
Message-Id: <20200618010805.600873-341-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>

[ Upstream commit 5aec598c456fe3c1b71a1202cbb42bdc2a643277 ]

The function blk_log_remap() can be simplified by removing the
call to get_pdu_remap() that copies the values into extra variable to
print the data, which also fixes the endiannness warning reported by
sparse.

Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/blktrace.c | 19 ++++---------------
 1 file changed, 4 insertions(+), 15 deletions(-)

diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index cba2093edee2..35610a4be4a9 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -1260,17 +1260,6 @@ static __u64 get_pdu_int(const struct trace_entry *ent, bool has_cg)
 	return be64_to_cpu(*val);
 }
 
-static void get_pdu_remap(const struct trace_entry *ent,
-			  struct blk_io_trace_remap *r, bool has_cg)
-{
-	const struct blk_io_trace_remap *__r = pdu_start(ent, has_cg);
-	__u64 sector_from = __r->sector_from;
-
-	r->device_from = be32_to_cpu(__r->device_from);
-	r->device_to   = be32_to_cpu(__r->device_to);
-	r->sector_from = be64_to_cpu(sector_from);
-}
-
 typedef void (blk_log_action_t) (struct trace_iterator *iter, const char *act,
 	bool has_cg);
 
@@ -1410,13 +1399,13 @@ static void blk_log_with_error(struct trace_seq *s,
 
 static void blk_log_remap(struct trace_seq *s, const struct trace_entry *ent, bool has_cg)
 {
-	struct blk_io_trace_remap r = { .device_from = 0, };
+	const struct blk_io_trace_remap *__r = pdu_start(ent, has_cg);
 
-	get_pdu_remap(ent, &r, has_cg);
 	trace_seq_printf(s, "%llu + %u <- (%d,%d) %llu\n",
 			 t_sector(ent), t_sec(ent),
-			 MAJOR(r.device_from), MINOR(r.device_from),
-			 (unsigned long long)r.sector_from);
+			 MAJOR(be32_to_cpu(__r->device_from)),
+			 MINOR(be32_to_cpu(__r->device_from)),
+			 be64_to_cpu(__r->sector_from));
 }
 
 static void blk_log_plug(struct trace_seq *s, const struct trace_entry *ent, bool has_cg)
-- 
2.25.1

