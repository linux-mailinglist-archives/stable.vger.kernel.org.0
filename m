Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D3CB4A426F
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:12:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349291AbiAaLLx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:11:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377159AbiAaLJp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:09:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3B2EC0604C8;
        Mon, 31 Jan 2022 03:06:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B0B68B82A5C;
        Mon, 31 Jan 2022 11:06:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F370DC340EF;
        Mon, 31 Jan 2022 11:06:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627184;
        bh=JJG8FPMAU2MXhrU12vj6pVtNxghJpIL8qz7OMrp+rNM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mjsVgmoH7vgvJnyuW+q31Ta9StpGAWD83p2KwzZZie4FfneblOsBKYP2QKSJWNXpe
         Oh7yXuXxlI1OVzdlqt4nJdu4nLKcHc3g5TAgc1y9FJnW8KX1i0k8DrvUGQ8BviCriN
         xybWx9qJ6GMeo5KySxMvLOQ496OjlPgmL482DNNk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+ac94ae5f68b84197f41c@syzkaller.appspotmail.com,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 100/100] block: Fix wrong offset in bio_truncate()
Date:   Mon, 31 Jan 2022 11:57:01 +0100
Message-Id: <20220131105223.808036007@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105220.424085452@linuxfoundation.org>
References: <20220131105220.424085452@linuxfoundation.org>
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
@@ -575,7 +575,8 @@ void bio_truncate(struct bio *bio, unsig
 				offset = new_size - done;
 			else
 				offset = 0;
-			zero_user(bv.bv_page, offset, bv.bv_len - offset);
+			zero_user(bv.bv_page, bv.bv_offset + offset,
+				  bv.bv_len - offset);
 			truncated = true;
 		}
 		done += bv.bv_len;


