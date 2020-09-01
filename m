Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B572E259BB2
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 19:06:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728947AbgIARFd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 13:05:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:37984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729017AbgIAPTK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:19:10 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 526AE20767;
        Tue,  1 Sep 2020 15:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598973549;
        bh=TYjF/d9WBP43ddUwwnSLpu0HAYO2mzl+WAcXHBP3BZw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=irbG+MO0EL3YdPdrxS2JxoM6Lz2obT3Wm49/zhEbOHC9T3BR+CV5amd1outRj4jtD
         xtARWhZr/9Yts3fSHsh/UT/v26HLlUD1j0DmbX1Wrf16+Ir+hWQFOAZ3gfoKDZPWS6
         LbOKgvXvZGQ3/HgmDLZD9mT2x8XXNZNH9ON1ka+M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hou Pu <houpu@bytedance.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 44/91] null_blk: fix passing of REQ_FUA flag in null_handle_rq
Date:   Tue,  1 Sep 2020 17:10:18 +0200
Message-Id: <20200901150930.328415489@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150928.096174795@linuxfoundation.org>
References: <20200901150928.096174795@linuxfoundation.org>
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
 drivers/block/null_blk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/null_blk.c b/drivers/block/null_blk.c
index b12e373aa956a..ec670a1b7e02f 100644
--- a/drivers/block/null_blk.c
+++ b/drivers/block/null_blk.c
@@ -1135,7 +1135,7 @@ static int null_handle_rq(struct nullb_cmd *cmd)
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



