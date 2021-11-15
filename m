Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DCBB451021
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:39:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232556AbhKOSlt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:41:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:46106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242592AbhKOSiw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:38:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 945A561B30;
        Mon, 15 Nov 2021 18:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999429;
        bh=VB5xkdAAIM0mjVIWLYjA/Z9u76RLExfriBPepAEIyyE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z0tkAKRw/ceC+4b0tBH+2nWwpT/A6tNaMEVVY7+PM2G8vAzRSb5RdHkQtIo5uJbc2
         TrWFbHl1SE8FcFXBj5jsGiQrUaFz1U1YfN+BDSDQmclaU7+NIxW/MfFbk9M826tATQ
         UisoXsZ3c2xSBRFEUNuatQjhRtd1E1FxS9bvi8W8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yi Zhang <yi.zhang@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 294/849] block: remove inaccurate requeue check
Date:   Mon, 15 Nov 2021 17:56:17 +0100
Message-Id: <20211115165430.208913797@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 037057a5a979c7eeb2ee5d12cf4c24b805192c75 ]

This check is meant to catch cases where a requeue is attempted on a
request that is still inserted. It's never really been useful to catch any
misuse, and now it's actively wrong. Outside of that, this should not be a
BUG_ON() to begin with.

Remove the check as it's now causing active harm, as requeue off the plug
path will trigger it even though the request state is just fine.

Reported-by: Yi Zhang <yi.zhang@redhat.com>
Link: https://lore.kernel.org/linux-block/CAHj4cs80zAUc2grnCZ015-2Rvd-=gXRfB_dFKy=RTm+wRo09HQ@mail.gmail.com/
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 9c658883020fb..5a5dbb3d08759 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -756,7 +756,6 @@ void blk_mq_requeue_request(struct request *rq, bool kick_requeue_list)
 	/* this request will be re-inserted to io scheduler queue */
 	blk_mq_sched_requeue_request(rq);
 
-	BUG_ON(!list_empty(&rq->queuelist));
 	blk_mq_add_to_requeue_list(rq, true, kick_requeue_list);
 }
 EXPORT_SYMBOL(blk_mq_requeue_request);
-- 
2.33.0



