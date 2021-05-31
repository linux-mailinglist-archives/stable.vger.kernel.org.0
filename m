Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D542395E0A
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:52:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233006AbhEaNxY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:53:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:55092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232382AbhEaNvT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:51:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 35EE66162D;
        Mon, 31 May 2021 13:32:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622467940;
        bh=+AnYopkoo2JAvurKoTnNndHvZirtU9zs5Jxey1oteq0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NiLc8vFR2FUcMJRu1uB7n1h5MNZeL/J69tAXpsnjdawEmSgWBbuAiHMbUD147wh6N
         lyjQ15NPt28jaXmDUtaz8/huVAyj5+42W5FvP38tWEGvd0gKp+FcE6HMqLAAe9+YQY
         /p3BmB+j8yHXYMb3dTExSxStX34zrvd45u4vXQZc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5.10 040/252] dm snapshot: properly fix a crash when an origin has no snapshots
Date:   Mon, 31 May 2021 15:11:45 +0200
Message-Id: <20210531130659.352408377@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130657.971257589@linuxfoundation.org>
References: <20210531130657.971257589@linuxfoundation.org>
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
@@ -854,7 +854,7 @@ static int dm_add_exception(void *contex
 static uint32_t __minimum_chunk_size(struct origin *o)
 {
 	struct dm_snapshot *snap;
-	unsigned chunk_size = 0;
+	unsigned chunk_size = rounddown_pow_of_two(UINT_MAX);
 
 	if (o)
 		list_for_each_entry(snap, &o->snapshots, list)


