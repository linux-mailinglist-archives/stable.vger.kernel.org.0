Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45ABC2061AF
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:08:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392917AbgFWUrz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:47:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:46538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392913AbgFWUrx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:47:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8B82F21548;
        Tue, 23 Jun 2020 20:47:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592945273;
        bh=JBYVL5o5bVXPE4C5POhCw8ThF92awKsuMPbXRCMMuGI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zVk9iS1pvo5FTbvAoUkwb54oQ/Nio/D6oioSLy8Neq/MOyCrTFiTwxCBXbPyeN8Wx
         6FyfhhQBu/rQbO+dfpypLkrI3IlF58N+v33/oSVYnNleBMyOyvf1cAvxCbxXWCkXfh
         do1LJzCQR4nypdSoJPC78leX3feMuQ25/5wkNPAU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 099/136] blktrace: fix endianness for blk_log_remap()
Date:   Tue, 23 Jun 2020 21:59:15 +0200
Message-Id: <20200623195308.649449252@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195303.601828702@linuxfoundation.org>
References: <20200623195303.601828702@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index be97e0b4ae7dc..304a164f5e7e7 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -1289,17 +1289,6 @@ static __u64 get_pdu_int(const struct trace_entry *ent, bool has_cg)
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
 
@@ -1425,13 +1414,13 @@ static void blk_log_with_error(struct trace_seq *s,
 
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



