Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6763B2268FA
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:24:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732916AbgGTQE5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:04:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:40098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732910AbgGTQE4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:04:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 78CFC22CBE;
        Mon, 20 Jul 2020 16:04:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595261096;
        bh=WP5AtASwU0kQrBj0WPv56t+yCx5g4xhn/ockerlPQxU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fTZimy1DeuOMXmXJy0iss6/wIvo7gXiTP6o4FhLD32Itz3FM0HNIW7iqOHghcoDms
         jITnV5qLvhuQhlfQWHxqHdSQtWXwIAYa0pIhbsSkO55KmsTCQgFgu2dNhRx9FJoP0H
         RDOR1fxRZU4sYB3eZmvYTHsmgXAGzMAmck2QC670=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Christoph Hellwig <hch@lst.de>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.4 208/215] block: fix get_max_segment_size() overflow on 32bit arch
Date:   Mon, 20 Jul 2020 17:38:10 +0200
Message-Id: <20200720152830.052638631@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152820.122442056@linuxfoundation.org>
References: <20200720152820.122442056@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

commit 4a2f704eb2d831a2d73d7f4cdd54f45c49c3c353 upstream.

Commit 429120f3df2d starts to take account of segment's start dma address
when computing max segment size, and data type of 'unsigned long'
is used to do that. However, the segment mask may be 0xffffffff, so
the figured out segment size may be overflowed in case of zero physical
address on 32bit arch.

Fix the issue by returning queue_max_segment_size() directly when that
happens.

Fixes: 429120f3df2d ("block: fix splitting segments on boundary masks")
Reported-by: Guenter Roeck <linux@roeck-us.net>
Tested-by: Guenter Roeck <linux@roeck-us.net>
Cc: Christoph Hellwig <hch@lst.de>
Tested-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 block/blk-merge.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -164,8 +164,13 @@ static inline unsigned get_max_segment_s
 	unsigned long mask = queue_segment_boundary(q);
 
 	offset = mask & (page_to_phys(start_page) + offset);
-	return min_t(unsigned long, mask - offset + 1,
-		     queue_max_segment_size(q));
+
+	/*
+	 * overflow may be triggered in case of zero page physical address
+	 * on 32bit arch, use queue's max segment size when that happens.
+	 */
+	return min_not_zero(mask - offset + 1,
+			(unsigned long)queue_max_segment_size(q));
 }
 
 /**


