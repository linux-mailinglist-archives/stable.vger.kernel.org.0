Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97C2E2596DA
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 18:09:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728107AbgIAQHc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 12:07:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:50820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731492AbgIAPkD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:40:03 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D6888205F4;
        Tue,  1 Sep 2020 15:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974803;
        bh=hSZl6IUuzTLGJEedsrbGtxDrvr3jYEOZvmYyde0/f70=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2hk4iuLR4Kxqqi6kDO86UImeajHRGIf0iYPkiTAklQdD8jlx2GEOlk3bNnawOP9bl
         iz6pKxC08G7Ys3ny/6DvJL5LvQMbrFNCFOEqAe43WEX4nRQmqWVowUz/2ieGMoCWXw
         K5jS9s1UHg31U6lhF2wyzVa7eaZS8KAjCDs4KNBc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hou Pu <houpu@bytedance.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 097/255] null_blk: fix passing of REQ_FUA flag in null_handle_rq
Date:   Tue,  1 Sep 2020 17:09:13 +0200
Message-Id: <20200901151005.371438314@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901151000.800754757@linuxfoundation.org>
References: <20200901151000.800754757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hou Pu <houpu@bytedance.com>

[ Upstream commit 2d62e6b038e729c3e4bfbfcfbd44800ef0883680 ]

REQ_FUA should be checked using rq->cmd_flags instead of req_op().

Fixes: deb78b419dfda ("nullb: emulate cache")
Signed-off-by: Hou Pu <houpu@bytedance.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/null_blk_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/null_blk_main.c b/drivers/block/null_blk_main.c
index 87b31f9ca362e..8cf13ea11cd2c 100644
--- a/drivers/block/null_blk_main.c
+++ b/drivers/block/null_blk_main.c
@@ -1139,7 +1139,7 @@ static int null_handle_rq(struct nullb_cmd *cmd)
 		len = bvec.bv_len;
 		err = null_transfer(nullb, bvec.bv_page, len, bvec.bv_offset,
 				     op_is_write(req_op(rq)), sector,
-				     req_op(rq) & REQ_FUA);
+				     rq->cmd_flags & REQ_FUA);
 		if (err) {
 			spin_unlock_irq(&nullb->lock);
 			return err;
-- 
2.25.1



