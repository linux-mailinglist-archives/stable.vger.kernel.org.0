Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19D7645130A
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:43:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244974AbhKOTpD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:45:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:44602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245293AbhKOTT6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:19:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A830B63215;
        Mon, 15 Nov 2021 18:32:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001124;
        bh=D3v0+mxK57xKnC0wg3ABahybZT2joCCHOzqiptJBP1s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RiVHmy4E17qde3enf2RBGv17G0N30uYE6meoQ1Wqm+RGd0NCaKgUiuKC+RqpWr2t2
         lKhXRTSx2GZpG9h3WSxdDeZn5jA1L85UFbY26PTmVCgLMCwhKyaJNeLcUGlXS+w3yZ
         Wmv82elUUFChY51zMetGvWbon6Wq5U6m8/G6T7Mw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Stutte <jens@chianterastutte.eu>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Song Liu <songliubraving@fb.com>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.15 071/917] md/raid1: only allocate write behind bio for WriteMostly device
Date:   Mon, 15 Nov 2021 17:52:46 +0100
Message-Id: <20211115165431.170196266@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guoqing Jiang <guoqing.jiang@linux.dev>

commit fd3b6975e9c11c4fa00965f82a0bfbb3b7b44101 upstream.

Commit 6607cd319b6b91bff94e90f798a61c031650b514 ("raid1: ensure write
behind bio has less than BIO_MAX_VECS sectors") tried to guarantee the
size of behind bio is not bigger than BIO_MAX_VECS sectors.

Unfortunately the same calltrace still could happen since an array could
enable write-behind without write mostly device.

To match the manpage of mdadm (which says "write-behind is only attempted
on drives marked as write-mostly"), we need to check WriteMostly flag to
avoid such unexpected behavior.

[1]. https://bugzilla.kernel.org/show_bug.cgi?id=213181#c25

Cc: stable@vger.kernel.org # v5.12+
Cc: Jens Stutte <jens@chianterastutte.eu>
Reported-by: Jens Stutte <jens@chianterastutte.eu>
Signed-off-by: Guoqing Jiang <guoqing.jiang@linux.dev>
Signed-off-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/raid1.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1496,7 +1496,7 @@ static void raid1_write_request(struct m
 		if (!r1_bio->bios[i])
 			continue;
 
-		if (first_clone) {
+		if (first_clone && test_bit(WriteMostly, &rdev->flags)) {
 			/* do behind I/O ?
 			 * Not if there are too many, or cannot
 			 * allocate memory, or a reader on WriteMostly


