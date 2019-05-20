Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C53B92364F
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 14:46:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389135AbfETMow (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:44:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:43040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389465AbfETM11 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:27:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE80521019;
        Mon, 20 May 2019 12:27:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558355247;
        bh=QKkgWnxCvEUleqodsfOqFcETT19LNPLxow/QSmRYFwM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z48OTGoI3vbJ/upBdNeZWO12W+2c1ATWjUkmxAn1vSt/0De4lHLZvBiQrSHvZPoMB
         k3H9+e2InZZTKz9lhMF/rPieiPCk9tYnNcL0w6uw30s9t7/KNjhVxvqCCaURvShw9H
         gKpNUoieNN0+0L6uaXoNZhmAFSxVJ2V11zSu1uNU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Raul E Rangel <rrangel@chromium.org>,
        Jens Axboe <axboe@kernel.dk>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.0 045/123] mmc: core: Fix tag set memory leak
Date:   Mon, 20 May 2019 14:13:45 +0200
Message-Id: <20190520115247.735630174@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115245.439864225@linuxfoundation.org>
References: <20190520115245.439864225@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Raul E Rangel <rrangel@chromium.org>

commit 43d8dabb4074cf7f3b1404bfbaeba5aa6f3e5cfc upstream.

The tag set is allocated in mmc_init_queue but never freed. This results
in a memory leak. This change makes sure we free the tag set when the
queue is also freed.

Signed-off-by: Raul E Rangel <rrangel@chromium.org>
Reviewed-by: Jens Axboe <axboe@kernel.dk>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Fixes: 81196976ed94 ("mmc: block: Add blk-mq support")
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/core/queue.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/mmc/core/queue.c
+++ b/drivers/mmc/core/queue.c
@@ -473,6 +473,7 @@ void mmc_cleanup_queue(struct mmc_queue
 		blk_mq_unquiesce_queue(q);
 
 	blk_cleanup_queue(q);
+	blk_mq_free_tag_set(&mq->tag_set);
 
 	/*
 	 * A request can be completed before the next request, potentially


