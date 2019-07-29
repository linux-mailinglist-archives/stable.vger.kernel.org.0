Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5563279821
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 22:06:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389837AbfG2Tor (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:44:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:33404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389834AbfG2Tor (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:44:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 33CC9205F4;
        Mon, 29 Jul 2019 19:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564429486;
        bh=7u/+GiX78diQlZSnpnqu2l4eIo9WSrQyRAj9zKhIdHc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SeKB2/yFnql9PaOl0mnQI4OND7DqE6/OJcojsjny+oh+lZrlaG1mlNQRQw+fHsKD9
         9igqOcC3kZWjqyGM6QcDiu+WVlNfTiXrIkaeWoJhc5DvnRDTz5p8JXi4O49lB/3CSx
         6oJnq+m7Idqvu+FGP+3qZD7gsFwexRvNuD9BARPs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 076/113] block: init flush rq ref count to 1
Date:   Mon, 29 Jul 2019 21:22:43 +0200
Message-Id: <20190729190713.719362728@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190655.455345569@linuxfoundation.org>
References: <20190729190655.455345569@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit b554db147feea39617b533ab6bca247c91c6198a ]

We discovered a problem in newer kernels where a disconnect of a NBD
device while the flush request was pending would result in a hang.  This
is because the blk mq timeout handler does

        if (!refcount_inc_not_zero(&rq->ref))
                return true;

to determine if it's ok to run the timeout handler for the request.
Flush_rq's don't have a ref count set, so we'd skip running the timeout
handler for this request and it would just sit there in limbo forever.

Fix this by always setting the refcount of any request going through
blk_init_rq() to 1.  I tested this with a nbd-server that dropped flush
requests to verify that it hung, and then tested with this patch to
verify I got the timeout as expected and the error handling kicked in.
Thanks,

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/block/blk-core.c b/block/blk-core.c
index 682bc561b77b..9ca703bcfe3b 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -198,6 +198,7 @@ void blk_rq_init(struct request_queue *q, struct request *rq)
 	rq->internal_tag = -1;
 	rq->start_time_ns = ktime_get_ns();
 	rq->part = NULL;
+	refcount_set(&rq->ref, 1);
 }
 EXPORT_SYMBOL(blk_rq_init);
 
-- 
2.20.1



