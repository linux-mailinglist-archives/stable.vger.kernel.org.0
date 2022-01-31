Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F2BD4A4323
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:17:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376512AbiAaLR1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:17:27 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:48990 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376548AbiAaLP3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:15:29 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9971A611E3;
        Mon, 31 Jan 2022 11:15:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 721A5C340E8;
        Mon, 31 Jan 2022 11:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627728;
        bh=uYmonM8kWqr/zkESPNyhoZSN6/qpNngeaDY6ehuJrd8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mn0a1yG0c/jf0NTFIUPCCp0Zj/3UChpSHt4R4RujfCVrEmE+CP45I1ZPD9mli5cuC
         OH+OLsY0uc0yNlL67Gn8o17TQPKigZt4NMwvx8f1Z4HGbUd80k1hbdmeQLTZ0oSQzJ
         jPptOV6K9fKzf1pZ2Hd/uje7anHAiF/TxRKJ9sBU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+ac94ae5f68b84197f41c@syzkaller.appspotmail.com,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.15 171/171] block: Fix wrong offset in bio_truncate()
Date:   Mon, 31 Jan 2022 11:57:16 +0100
Message-Id: <20220131105235.797805988@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105229.959216821@linuxfoundation.org>
References: <20220131105229.959216821@linuxfoundation.org>
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
@@ -567,7 +567,8 @@ void bio_truncate(struct bio *bio, unsig
 				offset = new_size - done;
 			else
 				offset = 0;
-			zero_user(bv.bv_page, offset, bv.bv_len - offset);
+			zero_user(bv.bv_page, bv.bv_offset + offset,
+				  bv.bv_len - offset);
 			truncated = true;
 		}
 		done += bv.bv_len;


