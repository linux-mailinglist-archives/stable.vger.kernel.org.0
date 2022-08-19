Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D66459A099
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:33:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351675AbiHSQJc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:09:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351482AbiHSQHx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:07:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13260BEF;
        Fri, 19 Aug 2022 08:56:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A2F3C614FE;
        Fri, 19 Aug 2022 15:56:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD22AC433D6;
        Fri, 19 Aug 2022 15:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660924584;
        bh=d8j1nbTfp0PG1P5kmBufL+4eKxvimt3iX2/2y6CVSSQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zaM5OKe7Mm+ILZ98D0W5MIA0YxybTUmeMSGMgJLhus/R9m6JWx2r5En8JPny2S+79
         8ri2wKE4WXT4/SoTg+5fjQo4iHvqQW0itUmVYkN7RX1jQwoDd5JavnC/pTlGAsOZI6
         tdv8pZeUTySq2ljGgBT2p/RTQmgBsVGm/ciowfy4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ming Qian <ming.qian@nxp.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 187/545] media: v4l2-mem2mem: prevent pollerr when last_buffer_dequeued is set
Date:   Fri, 19 Aug 2022 17:39:17 +0200
Message-Id: <20220819153837.735940347@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Qian <ming.qian@nxp.com>

[ Upstream commit d4de27a9b1eadd33a2e40de87a646d1bf5fef756 ]

If the last buffer was dequeued from the capture queue,
signal userspace. DQBUF(CAPTURE) will return -EPIPE.

But if output queue is empty and capture queue is empty,
v4l2_m2m_poll_for_data will return EPOLLERR,
This is very easy to happen in drain.

When last_buffer_dequeued is set, we shouldn't return EPOLLERR,
but return EPOLLIN | EPOLLRDNORM.

Fixes: 1698a7f151126 ("media: v4l2-mem2mem: simplify poll logic")
Signed-off-by: Ming Qian <ming.qian@nxp.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/v4l2-core/v4l2-mem2mem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/v4l2-mem2mem.c b/drivers/media/v4l2-core/v4l2-mem2mem.c
index 73190652c267..ad14d5214106 100644
--- a/drivers/media/v4l2-core/v4l2-mem2mem.c
+++ b/drivers/media/v4l2-core/v4l2-mem2mem.c
@@ -927,7 +927,7 @@ static __poll_t v4l2_m2m_poll_for_data(struct file *file,
 	if ((!src_q->streaming || src_q->error ||
 	     list_empty(&src_q->queued_list)) &&
 	    (!dst_q->streaming || dst_q->error ||
-	     list_empty(&dst_q->queued_list)))
+	     (list_empty(&dst_q->queued_list) && !dst_q->last_buffer_dequeued)))
 		return EPOLLERR;
 
 	spin_lock_irqsave(&src_q->done_lock, flags);
-- 
2.35.1



