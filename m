Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E77F60B03E
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 18:03:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232789AbiJXQDX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 12:03:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232373AbiJXQC2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 12:02:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B67E315F933;
        Mon, 24 Oct 2022 07:55:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 96387B8167C;
        Mon, 24 Oct 2022 12:25:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED1E4C433D6;
        Mon, 24 Oct 2022 12:25:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666614313;
        bh=F9QdaByYRJJaL62QU8goMier2SlNAtihGwndftq3eS0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mkMnfY2wEGj4nk8/WwD1l20F56HH+OWioR7LB1H2ksFiza8axrthcX6ls6tGVeLzA
         nOCuXB/aklNf7rIcepKavoNdiVaW0XaS75xdqGukmy1dMFEx401NEIp+MwQKjeQv6Q
         2XevV8OOvuZ5k7+Jrkeev90rF438eF6BJzNI742U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Frederic Barrat <fbarrat@linux.ibm.com>,
        Hangyu Hua <hbh25y@gmail.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 212/390] misc: ocxl: fix possible refcount leak in afu_ioctl()
Date:   Mon, 24 Oct 2022 13:30:09 +0200
Message-Id: <20221024113031.820902760@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113022.510008560@linuxfoundation.org>
References: <20221024113022.510008560@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index c742ab02ae18..e094809b54ff 100644
--- a/drivers/misc/ocxl/file.c
+++ b/drivers/misc/ocxl/file.c
@@ -259,6 +259,8 @@ static long afu_ioctl(struct file *file, unsigned int cmd,
 		if (IS_ERR(ev_ctx))
 			return PTR_ERR(ev_ctx);
 		rc = ocxl_irq_set_handler(ctx, irq_id, irq_handler, irq_free, ev_ctx);
+		if (rc)
+			eventfd_ctx_put(ev_ctx);
 		break;
 
 	case OCXL_IOCTL_GET_METADATA:
-- 
2.35.1



