Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B80B86812D6
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:25:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237524AbjA3OZp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:25:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237829AbjA3OZS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:25:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59F3E36692
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:24:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 24C94B811CC
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:23:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE85AC4339B;
        Mon, 30 Jan 2023 14:23:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675088622;
        bh=13fyRSN/3eWBTNzv1YvQdDzghTiXdzCGsk3D29gof6U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FXoYMdg2qu8I6SXaGqb3691RUYXZeLIdh4H6J/V7a9jw7zYKst5tSnu/ssDspGkqL
         s3x3OtT6J7K5opV0C4HV/Zl7D1R0DdCsemrCL/sUcga1GEG5Lh66KOTgOD1VCP9NVp
         SAKi2z8GgySmMipDL3HnF0Kdf6r1JF7G6tP2HBZg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Keith Busch <kbusch@kernel.org>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 053/143] nvme-pci: fix timeout request state check
Date:   Mon, 30 Jan 2023 14:51:50 +0100
Message-Id: <20230130134309.063748715@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134306.862721518@linuxfoundation.org>
References: <20230130134306.862721518@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit 1c5842085851f786eba24a39ecd02650ad892064 ]

Polling the completion can progress the request state to IDLE, either
inline with the completion, or through softirq. Either way, the state
may not be COMPLETED, so don't check for that. We only care if the state
isn't IN_FLIGHT.

This is fixing an issue where the driver aborts an IO that we just
completed. Seeing the "aborting" message instead of "polled" is very
misleading as to where the timeout problem resides.

Fixes: bf392a5dc02a9b ("nvme-pci: Remove tag from process cq")
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 67dd68462b81..c47512da9872 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -1292,7 +1292,7 @@ static enum blk_eh_timer_return nvme_timeout(struct request *req, bool reserved)
 	else
 		nvme_poll_irqdisable(nvmeq);
 
-	if (blk_mq_request_completed(req)) {
+	if (blk_mq_rq_state(req) != MQ_RQ_IN_FLIGHT) {
 		dev_warn(dev->ctrl.device,
 			 "I/O %d QID %d timeout, completion polled\n",
 			 req->tag, nvmeq->qid);
-- 
2.39.0



