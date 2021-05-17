Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 951B1383543
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:24:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243274AbhEQPQk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:16:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:37252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243720AbhEQPOh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:14:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 294BB61C54;
        Mon, 17 May 2021 14:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261927;
        bh=LqtVh2TskELa7OZUg8e/js2vJVq/HScFCwiEFT/ovzI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vTyFIf18wnRMvp2jf1aHyQ5xtvSZqnIFHtm7r21KATA+zJb9LI4L6pyc4jqP+TrLc
         oztw5N82oTRTpX868wXM/wWcf15wDaDhSjjIXYLAFXCu3FkExars0PQHUf8Us5MXeA
         JjSmVH40X7y+6gP294SwFhFTYInHtm/wCfHlFV0I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Md Haris Iqbal <haris.iqbal@ionos.com>,
        Guoqing Jiang <guoqing.jiang@ionos.com>,
        Gioh Kim <gi-oh.kim@ionos.com>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 188/329] block/rnbd-clt: Change queue_depth type in rnbd_clt_session to size_t
Date:   Mon, 17 May 2021 16:01:39 +0200
Message-Id: <20210517140308.485689707@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.043055203@linuxfoundation.org>
References: <20210517140302.043055203@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Md Haris Iqbal <haris.iqbal@cloud.ionos.com>

[ Upstream commit 80d43cbd46155744ee450d2476ee4fcf2917ae9b ]

The member queue_depth in the structure rnbd_clt_session is read from the
rtrs client side using the function rtrs_clt_query, which in turn is read
from the rtrs_clt structure. It should really be of type size_t.

Fixes: 90426e89f54db ("block/rnbd: client: private header with client structs and functions")
Signed-off-by: Md Haris Iqbal <haris.iqbal@ionos.com>
Reviewed-by: Guoqing Jiang <guoqing.jiang@ionos.com>
Signed-off-by: Gioh Kim <gi-oh.kim@ionos.com>
Link: https://lore.kernel.org/r/20210428061359.206794-2-gi-oh.kim@ionos.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/rnbd/rnbd-clt.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/rnbd/rnbd-clt.h b/drivers/block/rnbd/rnbd-clt.h
index 537d499dad3b..73d980840531 100644
--- a/drivers/block/rnbd/rnbd-clt.h
+++ b/drivers/block/rnbd/rnbd-clt.h
@@ -87,7 +87,7 @@ struct rnbd_clt_session {
 	DECLARE_BITMAP(cpu_queues_bm, NR_CPUS);
 	int	__percpu	*cpu_rr; /* per-cpu var for CPU round-robin */
 	atomic_t		busy;
-	int			queue_depth;
+	size_t			queue_depth;
 	u32			max_io_size;
 	struct blk_mq_tag_set	tag_set;
 	struct mutex		lock; /* protects state and devs_list */
-- 
2.30.2



