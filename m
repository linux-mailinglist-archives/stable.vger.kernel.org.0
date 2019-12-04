Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97516113408
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 19:21:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730589AbfLDSGl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 13:06:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:55362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730586AbfLDSGk (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 13:06:40 -0500
Received: from localhost (unknown [217.68.49.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF44F20674;
        Wed,  4 Dec 2019 18:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575482800;
        bh=zYB41gfG09mqdRPWxWlUgH4vOV0svqU0ru6XZw2f+fE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gvjtjrOHKhsbXhEtUj8tZiMaS1C0FZp5WMou6T3eoaXwcW5MMRZjm22R9JLw2BNqJ
         ADYUyu7VK4oH4HK2XZxuOVL3CxJMYfCoEa0dW9XDw8b10Z4BT5b97ZmBnBSuacm2vG
         K1K2aBtydycQgKC4phdVVpyeIRIoieu+LKZSwiLo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Thumshirn <jthumshirn@suse.de>,
        Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 137/209] blktrace: Show requests without sector
Date:   Wed,  4 Dec 2019 18:55:49 +0100
Message-Id: <20191204175332.699738686@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191204175321.609072813@linuxfoundation.org>
References: <20191204175321.609072813@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

[ Upstream commit 0803de78049fe1b0baf44bcddc727b036fb9139b ]

Currently, blktrace will not show requests that don't have any data as
rq->__sector is initialized to -1 which is out of device range and thus
discarded by act_log_check(). This is most notably the case for cache
flush requests sent to the device. Fix the problem by making
blk_rq_trace_sector() return 0 for requests without initialized sector.

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/blktrace_api.h | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/linux/blktrace_api.h b/include/linux/blktrace_api.h
index 8804753805ac5..7bb2d8de9f308 100644
--- a/include/linux/blktrace_api.h
+++ b/include/linux/blktrace_api.h
@@ -116,7 +116,13 @@ extern void blk_fill_rwbs(char *rwbs, unsigned int op, int bytes);
 
 static inline sector_t blk_rq_trace_sector(struct request *rq)
 {
-	return blk_rq_is_passthrough(rq) ? 0 : blk_rq_pos(rq);
+	/*
+	 * Tracing should ignore starting sector for passthrough requests and
+	 * requests where starting sector didn't get set.
+	 */
+	if (blk_rq_is_passthrough(rq) || blk_rq_pos(rq) == (sector_t)-1)
+		return 0;
+	return blk_rq_pos(rq);
 }
 
 static inline unsigned int blk_rq_trace_nr_sectors(struct request *rq)
-- 
2.20.1



