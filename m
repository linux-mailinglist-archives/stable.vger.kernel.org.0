Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 140582597DB
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 18:20:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731967AbgIAQUQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 12:20:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:36600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728122AbgIAPct (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:32:49 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DEE8F205F4;
        Tue,  1 Sep 2020 15:32:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974369;
        bh=qQYC96ys55bOwFktWPSHo6ffF8BCXRT989q4ofQBy+A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N0TcwFLadBNAhPx8QLv01geEb/mqRGPhPbFoGph+UOeSxJkbsau3rNNUXam+jpo7I
         sqPDofJbV2eQloJM4DGNLcMXrSqnX5g3g0dpUdChUBQRWaTEhO0TKlSh8ZEhZlVhmO
         T0JMpungUoERsrOj52waBeof/bQOMZdlqGCyK4g4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Deal <eric.deal@wdc.com>,
        Keith Busch <kbusch@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.4 149/214] block: fix get_max_io_size()
Date:   Tue,  1 Sep 2020 17:10:29 +0200
Message-Id: <20200901151000.102818813@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150952.963606936@linuxfoundation.org>
References: <20200901150952.963606936@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Keith Busch <kbusch@kernel.org>

commit e4b469c66f3cbb81c2e94d31123d7bcdf3c1dabd upstream.

A previous commit aligning splits to physical block sizes inadvertently
modified one return case such that that it now returns 0 length splits
when the number of sectors doesn't exceed the physical offset. This
later hits a BUG in bio_split(). Restore the previous working behavior.

Fixes: 9cc5169cd478b ("block: Improve physical block alignment of split bios")
Reported-by: Eric Deal <eric.deal@wdc.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Cc: Bart Van Assche <bvanassche@acm.org>
Cc: stable@vger.kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 block/blk-merge.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -154,7 +154,7 @@ static inline unsigned get_max_io_size(s
 	if (max_sectors > start_offset)
 		return max_sectors - start_offset;
 
-	return sectors & (lbs - 1);
+	return sectors & ~(lbs - 1);
 }
 
 static inline unsigned get_max_segment_size(const struct request_queue *q,


