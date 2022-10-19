Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D414603E03
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:10:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232469AbiJSJKn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:10:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232888AbiJSJJb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:09:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5CA16BCFD;
        Wed, 19 Oct 2022 02:00:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A7414617E1;
        Wed, 19 Oct 2022 09:00:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCE17C433D6;
        Wed, 19 Oct 2022 09:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170038;
        bh=Wmphf3AsPlAzcTCjF/2Rty8KRXokQysKlrzKnN12nkM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gnoIjo+kRQyb5ikQYUhGDccqruCZpw7Fgs8jEsk0wYIPf/a6jN6jzHvCio/pPZ11Y
         66S1U5bepvCf51vYUMLZ2Oef7myuyCm1YOE0DNKxq0kEgAR7np+xW7DRQdSo7g7c2p
         RuQOwMgjXLiScfZZQYyd//v7B65MAvbj8miwUWSM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Frederic Barrat <fbarrat@linux.ibm.com>,
        Hangyu Hua <hbh25y@gmail.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 503/862] misc: ocxl: fix possible refcount leak in afu_ioctl()
Date:   Wed, 19 Oct 2022 10:29:50 +0200
Message-Id: <20221019083312.212973716@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hangyu Hua <hbh25y@gmail.com>

[ Upstream commit c3b69ba5114c860d730870c03ab4ee45276e5e35 ]

eventfd_ctx_put need to be called to put the refcount that gotten by
eventfd_ctx_fdget when ocxl_irq_set_handler fails.

Fixes: 060146614643 ("ocxl: move event_fd handling to frontend")
Acked-by: Frederic Barrat <fbarrat@linux.ibm.com>
Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
Link: https://lore.kernel.org/r/20220824082600.36159-1-hbh25y@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/ocxl/file.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/misc/ocxl/file.c b/drivers/misc/ocxl/file.c
index 6777c419a8da..d46dba2df5a1 100644
--- a/drivers/misc/ocxl/file.c
+++ b/drivers/misc/ocxl/file.c
@@ -257,6 +257,8 @@ static long afu_ioctl(struct file *file, unsigned int cmd,
 		if (IS_ERR(ev_ctx))
 			return PTR_ERR(ev_ctx);
 		rc = ocxl_irq_set_handler(ctx, irq_id, irq_handler, irq_free, ev_ctx);
+		if (rc)
+			eventfd_ctx_put(ev_ctx);
 		break;
 
 	case OCXL_IOCTL_GET_METADATA:
-- 
2.35.1



