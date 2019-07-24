Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5363873CCA
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:11:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392020AbfGXT5h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:57:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:43164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392032AbfGXT5g (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:57:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 574DD22BED;
        Wed, 24 Jul 2019 19:57:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563998255;
        bh=QtlBSosPIGx7NyC+f4ToTQU3coh+S8xMK3YXpkL+5Qc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WuA/iYWk32XlLVV2rjoFniHxiiL7sH6fIrDEGJYtIvcS7uSFkRWZPYIpOQVBJBdwn
         QPTn7o33sLjFKajSwND5/ueVPt8uplU6VioghKqz5Kt378Jk5myOXB1zjGpDrF7w1J
         V0bBdRtkMH79ZHFzYGqaB2FfQ9wq6UfSLfLnHdJs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Coly Li <colyli@suse.de>,
        Jens Axboe <axboe@kernel.dk>,
        Thorsten Knabe <linux@thorsten-knabe.de>
Subject: [PATCH 5.1 259/371] bcache: ignore read-ahead request failure on backing device
Date:   Wed, 24 Jul 2019 21:20:11 +0200
Message-Id: <20190724191743.995394816@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191724.382593077@linuxfoundation.org>
References: <20190724191724.382593077@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Coly Li <colyli@suse.de>

commit 578df99b1b0531d19af956530fe4da63d01a1604 upstream.

When md raid device (e.g. raid456) is used as backing device, read-ahead
requests on a degrading and recovering md raid device might be failured
immediately by md raid code, but indeed this md raid array can still be
read or write for normal I/O requests. Therefore such failed read-ahead
request are not real hardware failure. Further more, after degrading and
recovering accomplished, read-ahead requests will be handled by md raid
array again.

For such condition, I/O failures of read-ahead requests don't indicate
real health status (because normal I/O still be served), they should not
be counted into I/O error counter dc->io_errors.

Since there is no simple way to detect whether the backing divice is a
md raid device, this patch simply ignores I/O failures for read-ahead
bios on backing device, to avoid bogus backing device failure on a
degrading md raid array.

Suggested-and-tested-by: Thorsten Knabe <linux@thorsten-knabe.de>
Signed-off-by: Coly Li <colyli@suse.de>
Cc: stable@vger.kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/bcache/io.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/md/bcache/io.c
+++ b/drivers/md/bcache/io.c
@@ -58,6 +58,18 @@ void bch_count_backing_io_errors(struct
 
 	WARN_ONCE(!dc, "NULL pointer of struct cached_dev");
 
+	/*
+	 * Read-ahead requests on a degrading and recovering md raid
+	 * (e.g. raid6) device might be failured immediately by md
+	 * raid code, which is not a real hardware media failure. So
+	 * we shouldn't count failed REQ_RAHEAD bio to dc->io_errors.
+	 */
+	if (bio->bi_opf & REQ_RAHEAD) {
+		pr_warn_ratelimited("%s: Read-ahead I/O failed on backing device, ignore",
+				    dc->backing_dev_name);
+		return;
+	}
+
 	errors = atomic_add_return(1, &dc->io_errors);
 	if (errors < dc->error_limit)
 		pr_err("%s: IO error on backing device, unrecoverable",


