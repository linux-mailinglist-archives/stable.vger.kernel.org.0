Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C9C36AF066
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:30:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231191AbjCGSa3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:30:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229929AbjCGS34 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:29:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7BD396C0C
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:23:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 637CDB818EB
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:23:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B643EC433D2;
        Tue,  7 Mar 2023 18:23:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678213403;
        bh=FO9ouAa5rATCJduQ6vm2USYRmIMUEfyeNf+JC8crKXs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BF5wenEcCiw2ucVDtQe0GZx/2D0glOTMZYeVbfJPg+k2qycE4Oh3pgmnnXyo/r6Eb
         HoO5lkRgpKe5ZuReJAQ/3/+T3AIimQbs873gWCRZf0aKnxLKliQWquT7/Ds9EkogJz
         uwE0OL2c3Jpk1RqzxIctfeFGHGXQsouORYiuYMrU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Gaosheng Cui <cuigaosheng1@huawei.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 495/885] media: ti: cal: fix possible memory leak in cal_ctx_create()
Date:   Tue,  7 Mar 2023 17:57:09 +0100
Message-Id: <20230307170023.958872240@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gaosheng Cui <cuigaosheng1@huawei.com>

[ Upstream commit 7acd650a0484d92985a0d6d867d980c6dd019885 ]

The memory of ctx is allocated in cal_ctx_create(), but it will
not be freed when cal_ctx_v4l2_init() fails, so add kfree() when
cal_ctx_v4l2_init() fails to fix it.

Fixes: d68a94e98a89 ("media: ti-vpe: cal: Split video device initialization and registration")
Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/ti/cal/cal.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/ti/cal/cal.c b/drivers/media/platform/ti/cal/cal.c
index 56b61c0583cf8..1236215ec70eb 100644
--- a/drivers/media/platform/ti/cal/cal.c
+++ b/drivers/media/platform/ti/cal/cal.c
@@ -1050,8 +1050,10 @@ static struct cal_ctx *cal_ctx_create(struct cal_dev *cal, int inst)
 	ctx->cport = inst;
 
 	ret = cal_ctx_v4l2_init(ctx);
-	if (ret)
+	if (ret) {
+		kfree(ctx);
 		return NULL;
+	}
 
 	return ctx;
 }
-- 
2.39.2



