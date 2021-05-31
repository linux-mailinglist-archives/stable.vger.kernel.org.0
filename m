Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3ED72395C3C
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:28:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231370AbhEaNaG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:30:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:60152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232294AbhEaN2E (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:28:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2615561376;
        Mon, 31 May 2021 13:22:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622467324;
        bh=oRToud7KoChH4nC6fVZXtwAHXTLxa9slLHXrdvWlHGY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=alpzgHdRKSzX96djwcXPGKg5PvK7DeEphiTG/qAq5+wxq/G1/5/u3NmGSkAAwf32J
         tkf9F0jiM8IZkVZ02rW6I5rtl+weo5xdU/9Rwcfkr00ZjbAG0We0q6+phgQt1RAj/h
         K0ybCjn+U5/X+I0+DKVjBKW5H77tCDI5ca0bkYz0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 4.19 022/116] dm snapshot: properly fix a crash when an origin has no snapshots
Date:   Mon, 31 May 2021 15:13:18 +0200
Message-Id: <20210531130640.904356684@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130640.131924542@linuxfoundation.org>
References: <20210531130640.131924542@linuxfoundation.org>
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
@@ -794,7 +794,7 @@ static int dm_add_exception(void *contex
 static uint32_t __minimum_chunk_size(struct origin *o)
 {
 	struct dm_snapshot *snap;
-	unsigned chunk_size = 0;
+	unsigned chunk_size = rounddown_pow_of_two(UINT_MAX);
 
 	if (o)
 		list_for_each_entry(snap, &o->snapshots, list)


