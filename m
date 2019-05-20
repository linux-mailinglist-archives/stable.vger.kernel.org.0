Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A8872372D
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 15:17:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387856AbfETMWN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:22:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:36156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388355AbfETMWM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:22:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1584621019;
        Mon, 20 May 2019 12:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558354932;
        bh=BNMAL5BQel9VBIquhmcC/3N4kEa6RuB+goYw1Elgy9Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pMMRsp/GUFQ2GtV2cgMSKiUm424TeAOVfY8gc/x98r3u/NbTUTn8qf2aNlYnng4vT
         466TtlRjQ3su2dPlJ30YPWsNFJsgACgceYzZ6ipRi9+EhmNQyAIcW5q20FNjy4lzb7
         XzzOU40ioi4RBrKyp7wCAX/Fn3j2IfpPurTEYuvY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Raul E Rangel <rrangel@chromium.org>,
        Jens Axboe <axboe@kernel.dk>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 4.19 032/105] mmc: core: Fix tag set memory leak
Date:   Mon, 20 May 2019 14:13:38 +0200
Message-Id: <20190520115249.274436542@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115247.060821231@linuxfoundation.org>
References: <20190520115247.060821231@linuxfoundation.org>
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
@@ -494,6 +494,7 @@ void mmc_cleanup_queue(struct mmc_queue
 		blk_mq_unquiesce_queue(q);
 
 	blk_cleanup_queue(q);
+	blk_mq_free_tag_set(&mq->tag_set);
 
 	/*
 	 * A request can be completed before the next request, potentially


