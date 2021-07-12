Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A7A33C490B
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:31:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237267AbhGLGlq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:41:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:36538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238545AbhGLGkU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:40:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D8FA761004;
        Mon, 12 Jul 2021 06:37:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071851;
        bh=c3SFVdmEk6tJ/l3rcpQazKWLZA/z4lJGSSec1g2FU14=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MnLjxzreh0H5tCbak4f6nIqRRqIY9IOqV6wo98ywlJgYa6Fphze1KOVUgaDzxUpZ6
         pDXejsd6UC1afxcnchRj05gvqYeFkP+nRdKgAdsLdHDSssSvKezQf859r1GIu75HvF
         Z75maaTaUMb3IdPTMsoFdUeO3r+CsOUCUqV/0wzg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Wang Shanker <shankerwangmiao@gmail.com>,
        Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 205/593] block: fix discard request merge
Date:   Mon, 12 Jul 2021 08:06:05 +0200
Message-Id: <20210712060905.546106797@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit 2705dfb2094777e405e065105e307074af8965c1 ]

ll_new_hw_segment() is reached only in case of single range discard
merge, and we don't have max discard segment size limit actually, so
it is wrong to run the following check:

if (req->nr_phys_segments + nr_phys_segs > blk_rq_get_max_segments(req))

it may be always false since req->nr_phys_segments is initialized as
one, and bio's segment count is still 1, blk_rq_get_max_segments(reg)
is 1 too.

Fix the issue by not doing the check and bypassing the calculation of
discard request's nr_phys_segments.

Based on analysis from Wang Shanker.

Cc: Christoph Hellwig <hch@lst.de>
Reported-by: Wang Shanker <shankerwangmiao@gmail.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20210628023312.1903255-1-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-merge.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index 7cdd56696647..349cd7d3af81 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -552,10 +552,14 @@ static inline unsigned int blk_rq_get_max_segments(struct request *rq)
 static inline int ll_new_hw_segment(struct request *req, struct bio *bio,
 		unsigned int nr_phys_segs)
 {
-	if (req->nr_phys_segments + nr_phys_segs > blk_rq_get_max_segments(req))
+	if (blk_integrity_merge_bio(req->q, req, bio) == false)
 		goto no_merge;
 
-	if (blk_integrity_merge_bio(req->q, req, bio) == false)
+	/* discard request merge won't add new segment */
+	if (req_op(req) == REQ_OP_DISCARD)
+		return 1;
+
+	if (req->nr_phys_segments + nr_phys_segs > blk_rq_get_max_segments(req))
 		goto no_merge;
 
 	/*
-- 
2.30.2



