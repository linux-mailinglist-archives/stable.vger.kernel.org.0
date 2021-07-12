Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BA003C519C
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:48:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244490AbhGLHmZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:42:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:56274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345358AbhGLHiS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:38:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5A3DA614A5;
        Mon, 12 Jul 2021 07:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075216;
        bh=A2+8fG99w7GHpWwEaqe3YyMQcIbBN3yQSNxiQ/lWZ/M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zn8EbhmtWviPNEw9NevvjDrkp8ZaNmFSvhW74vP/qj6c2s20AzCN0LqT0dYxnK/95
         eo4diaKXpVjEk6RFCxP5QTrqsUOXddbs2bOud7lG6dALBNHpDQeqipLbNbyQRMw8bY
         1tPPvJJ2RtLhPNfmuFRVXKltetccY2hxbcqsVEcg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kristian Klausen <kristian@klausen.dk>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.13 117/800] loop: Fix missing discard support when using LOOP_CONFIGURE
Date:   Mon, 12 Jul 2021 08:02:20 +0200
Message-Id: <20210712060929.416715005@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kristian Klausen <kristian@klausen.dk>

commit 2b9ac22b12a266eb4fec246a07b504dd4983b16b upstream.

Without calling loop_config_discard() the discard flag and parameters
aren't set/updated for the loop device and worst-case they could
indicate discard support when it isn't the case (ex: if the
LOOP_SET_STATUS ioctl was used with a different file prior to
LOOP_CONFIGURE).

Cc: <stable@vger.kernel.org> # 5.8.x-
Fixes: 3448914e8cc5 ("loop: Add LOOP_CONFIGURE ioctl")
Signed-off-by: Kristian Klausen <kristian@klausen.dk>
Link: https://lore.kernel.org/r/20210618115157.31452-1-kristian@klausen.dk
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/block/loop.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1154,6 +1154,7 @@ static int loop_configure(struct loop_de
 	blk_queue_physical_block_size(lo->lo_queue, bsize);
 	blk_queue_io_min(lo->lo_queue, bsize);
 
+	loop_config_discard(lo);
 	loop_update_rotational(lo);
 	loop_update_dio(lo);
 	loop_sysfs_init(lo);


