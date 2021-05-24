Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1DF838EDCE
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:41:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233662AbhEXPmH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:42:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:58132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233805AbhEXPkU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:40:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 64BB661434;
        Mon, 24 May 2021 15:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621870453;
        bh=bkijXBVEuJerTV88teLlvM6UvUapCXn4lYlZn5veHJA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xzm0ZabpWyx79tKi+UA0EtoFSobflTRk3yanXRAZfQGoNTb7S5UorAPVwRCYMQn9R
         of8jvo8HrQoseOCwj6ILTW7V9qUq1XEull3BXqCS3HyjqUtKzaMQyfa8xWAIbHFkc/
         Dmh3qJvQNDuG6pOhpQLDKS9hIWhLP9Gseu7TCwUM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Tokarev <mjt@tls.msk.ru>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 4.14 14/37] dm snapshot: fix a crash when an origin has no snapshots
Date:   Mon, 24 May 2021 17:25:18 +0200
Message-Id: <20210524152324.676643600@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152324.199089755@linuxfoundation.org>
References: <20210524152324.199089755@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>

commit 7ee06ddc4038f936b0d4459d37a7d4d844fb03db upstream.

If an origin target has no snapshots, o->split_boundary is set to 0.
This causes BUG_ON(sectors <= 0) in block/bio.c:bio_split().

Fix this by initializing chunk_size, and in turn split_boundary, to
rounddown_pow_of_two(UINT_MAX) -- the largest power of two that fits
into "unsigned" type.

Reported-by: Michael Tokarev <mjt@tls.msk.ru>
Tested-by: Michael Tokarev <mjt@tls.msk.ru>
Cc: stable@vger.kernel.org
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-snap.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -793,12 +793,11 @@ static int dm_add_exception(void *contex
 static uint32_t __minimum_chunk_size(struct origin *o)
 {
 	struct dm_snapshot *snap;
-	unsigned chunk_size = 0;
+	unsigned chunk_size = rounddown_pow_of_two(UINT_MAX);
 
 	if (o)
 		list_for_each_entry(snap, &o->snapshots, list)
-			chunk_size = min_not_zero(chunk_size,
-						  snap->store->chunk_size);
+			chunk_size = min(chunk_size, snap->store->chunk_size);
 
 	return (uint32_t) chunk_size;
 }


