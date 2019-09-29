Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5096C152A
	for <lists+stable@lfdr.de>; Sun, 29 Sep 2019 16:01:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729427AbfI2OBd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Sep 2019 10:01:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:43800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730046AbfI2OBc (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Sep 2019 10:01:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0DAEF2082F;
        Sun, 29 Sep 2019 14:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569765691;
        bh=gsJ9MevCMoJdi7WNJxdX6xfWTX7QyQwP9gCc+FHWx0g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MXJ3nnIEMTFYOf9IMpNRgaOk0OZGZXuNWG4VNp+fEZEGwBGt0PJfVwB2hhg+VrM/X
         bqXc9RsrGWCc2Dwck0lMH/bPteBTIIuy0NMD9ClnYfcxEwOcLom2zzNlq5nMAAOGUg
         aAIN2GT5C0kBwa57BX8TMtMoAmGkjDsqx7v6k0NE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 31/45] dm zoned: fix invalid memory access
Date:   Sun, 29 Sep 2019 15:55:59 +0200
Message-Id: <20190929135032.102259596@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190929135024.387033930@linuxfoundation.org>
References: <20190929135024.387033930@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>

[ Upstream commit 0c8e9c2d668278652af028c3cc068c65f66342f4 ]

Commit 75d66ffb48efb30f2dd42f041ba8b39c5b2bd115 ("dm zoned: properly
handle backing device failure") triggers a coverity warning:

*** CID 1452808:  Memory - illegal accesses  (USE_AFTER_FREE)
/drivers/md/dm-zoned-target.c: 137 in dmz_submit_bio()
131             clone->bi_private = bioctx;
132
133             bio_advance(bio, clone->bi_iter.bi_size);
134
135             refcount_inc(&bioctx->ref);
136             generic_make_request(clone);
>>>     CID 1452808:  Memory - illegal accesses  (USE_AFTER_FREE)
>>>     Dereferencing freed pointer "clone".
137             if (clone->bi_status == BLK_STS_IOERR)
138                     return -EIO;
139
140             if (bio_op(bio) == REQ_OP_WRITE && dmz_is_seq(zone))
141                     zone->wp_block += nr_blocks;
142

The "clone" bio may be processed and freed before the check
"clone->bi_status == BLK_STS_IOERR" - so this check can access invalid
memory.

Fixes: 75d66ffb48efb3 ("dm zoned: properly handle backing device failure")
Cc: stable@vger.kernel.org
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-zoned-target.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/md/dm-zoned-target.c b/drivers/md/dm-zoned-target.c
index ff3fd011796ed..3334f5865de77 100644
--- a/drivers/md/dm-zoned-target.c
+++ b/drivers/md/dm-zoned-target.c
@@ -133,8 +133,6 @@ static int dmz_submit_bio(struct dmz_target *dmz, struct dm_zone *zone,
 
 	refcount_inc(&bioctx->ref);
 	generic_make_request(clone);
-	if (clone->bi_status == BLK_STS_IOERR)
-		return -EIO;
 
 	if (bio_op(bio) == REQ_OP_WRITE && dmz_is_seq(zone))
 		zone->wp_block += nr_blocks;
-- 
2.20.1



