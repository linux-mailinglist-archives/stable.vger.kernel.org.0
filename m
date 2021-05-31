Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68480395B9D
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:21:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232009AbhEaNWi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:22:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:55510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232180AbhEaNUa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:20:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 935F961396;
        Mon, 31 May 2021 13:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622467125;
        bh=aYimZNDw6WufWUDW7e/OsFBW0NwYNbOrJ/BLHIG3NgI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tg3fzT5jc29peimmd7xXZrj4HRbdIpVtlY7DWbLo6c3CbNENBGgHIMqArSeI+Q/HQ
         ibS1q5PtUrVQhFKnzsWijHCclsW2IO6YHfRfJPVH4QbFyTjVtzRJyYdqiovb6zRGso
         BRJOMAHsn26uv/vVH5jbx5y+H/loMtgA1x+CvTr4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 4.9 14/66] dm snapshot: properly fix a crash when an origin has no snapshots
Date:   Mon, 31 May 2021 15:13:47 +0200
Message-Id: <20210531130636.714020527@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130636.254683895@linuxfoundation.org>
References: <20210531130636.254683895@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>

commit 7e768532b2396bcb7fbf6f82384b85c0f1d2f197 upstream.

If an origin target has no snapshots, o->split_boundary is set to 0.
This causes BUG_ON(sectors <= 0) in block/bio.c:bio_split().

Fix this by initializing chunk_size, and in turn split_boundary, to
rounddown_pow_of_two(UINT_MAX) -- the largest power of two that fits
into "unsigned" type.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-snap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -788,7 +788,7 @@ static int dm_add_exception(void *contex
 static uint32_t __minimum_chunk_size(struct origin *o)
 {
 	struct dm_snapshot *snap;
-	unsigned chunk_size = 0;
+	unsigned chunk_size = rounddown_pow_of_two(UINT_MAX);
 
 	if (o)
 		list_for_each_entry(snap, &o->snapshots, list)


