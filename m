Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D2F64A45B0
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:48:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344368AbiAaLqZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:46:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235580AbiAaLkW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:40:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06EA0C03540F;
        Mon, 31 Jan 2022 03:25:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BB7DBB82A60;
        Mon, 31 Jan 2022 11:25:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D65DDC340E8;
        Mon, 31 Jan 2022 11:25:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643628341;
        bh=6EjY/S8FSs3rNCSbFDkGCHtYXxGZQOyicmF3xyyN1jI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=syuZwH11MzTePLenjgXuKn6akp43KWcRNAgvv/N72MS+d+xqEl/DJZrNPoT8uIx1H
         Rii+4ZOulyL0LEJEQan5MKvKmoEUSyjEiHtRnIiE56c2m88Fb4P2/Yo3hOgFgdC2kX
         aKxu7nyQe9NOdUs5nadReVmow1Ws01aL5olhyMIs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+ac94ae5f68b84197f41c@syzkaller.appspotmail.com,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.16 200/200] block: Fix wrong offset in bio_truncate()
Date:   Mon, 31 Jan 2022 11:57:43 +0100
Message-Id: <20220131105240.252099209@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105233.561926043@linuxfoundation.org>
References: <20220131105233.561926043@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

commit 3ee859e384d453d6ac68bfd5971f630d9fa46ad3 upstream.

bio_truncate() clears the buffer outside of last block of bdev, however
current bio_truncate() is using the wrong offset of page. So it can
return the uninitialized data.

This happened when both of truncated/corrupted FS and userspace (via
bdev) are trying to read the last of bdev.

Reported-by: syzbot+ac94ae5f68b84197f41c@syzkaller.appspotmail.com
Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/875yqt1c9g.fsf@mail.parknet.co.jp
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/bio.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/block/bio.c
+++ b/block/bio.c
@@ -569,7 +569,8 @@ static void bio_truncate(struct bio *bio
 				offset = new_size - done;
 			else
 				offset = 0;
-			zero_user(bv.bv_page, offset, bv.bv_len - offset);
+			zero_user(bv.bv_page, bv.bv_offset + offset,
+				  bv.bv_len - offset);
 			truncated = true;
 		}
 		done += bv.bv_len;


