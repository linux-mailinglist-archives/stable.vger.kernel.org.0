Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C4DD5F29FF
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:29:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231186AbiJCH3Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:29:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231345AbiJCH2t (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:28:49 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6697AF587;
        Mon,  3 Oct 2022 00:19:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 1566BCE0B1C;
        Mon,  3 Oct 2022 07:18:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 262D9C433C1;
        Mon,  3 Oct 2022 07:17:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781480;
        bh=2UHdbvEr9lqpstgtuyNn+47IaQkePd+H6y1WP7Yv+1o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MrhClt9KX4TV62GmRhnRv/loQ8y7hehAZXwMgo1YMSwkvjoCa1SedFgzFhlX+8R0R
         ZGG/UbTcFuRvO/gKRC8/nD5tSuGKmASLtLe5+BTx4MwKlxzjY+36SQeNNyh6xdSbat
         QtgeOT9Gx1nSp0X5lQWNIh+e7fgDohzOLRjMjPSk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wenchao Chen <wenchao.chen@unisoc.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.15 28/83] mmc: hsq: Fix data stomping during mmc recovery
Date:   Mon,  3 Oct 2022 09:10:53 +0200
Message-Id: <20221003070722.704036470@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221003070721.971297651@linuxfoundation.org>
References: <20221003070721.971297651@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wenchao Chen <wenchao.chen@unisoc.com>

commit e7afa79a3b35a27a046a2139f8b20bd6b98155c2 upstream.

The block device uses multiple queues to access emmc. There will be up to 3
requests in the hsq of the host. The current code will check whether there
is a request doing recovery before entering the queue, but it will not check
whether there is a request when the lock is issued. The request is in recovery
mode. If there is a request in recovery, then a read and write request is
initiated at this time, and the conflict between the request and the recovery
request will cause the data to be trampled.

Signed-off-by: Wenchao Chen <wenchao.chen@unisoc.com>
Fixes: 511ce378e16f ("mmc: Add MMC host software queue support")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20220916090506.10662-1-wenchao.chen666@gmail.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/mmc_hsq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mmc/host/mmc_hsq.c
+++ b/drivers/mmc/host/mmc_hsq.c
@@ -34,7 +34,7 @@ static void mmc_hsq_pump_requests(struct
 	spin_lock_irqsave(&hsq->lock, flags);
 
 	/* Make sure we are not already running a request now */
-	if (hsq->mrq) {
+	if (hsq->mrq || hsq->recovery_halt) {
 		spin_unlock_irqrestore(&hsq->lock, flags);
 		return;
 	}


