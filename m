Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A3CE6AF06B
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:30:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229545AbjCGSad (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:30:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231687AbjCGS37 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:29:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6844195457
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:23:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 041D161501
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:23:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFEF3C4339B;
        Tue,  7 Mar 2023 18:23:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678213410;
        bh=NhYw4bSy6NA5eKY0nyC03eusX43PNuiWSg4HbU9hLiQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X7wMJG7tO4BxAq21x/emOaK5GaTTVr8ZCNWDxMCAdwBeJYg+n+sKC8eZKAyEFjAY0
         6NkkQtIr6lQpCaUihrqeFpMslhUtnCiqT0nEHW+zcRo9rsbGEriceYhpdUKm0/rURC
         pqxNMOY1+IbLnYCCllhTRDJw4zhSsWX+MvYbaxAQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Rui Miguel Silva <rmfrfs@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 497/885] media: imx: imx7-media-csi: fix missing clk_disable_unprepare() in imx7_csi_init()
Date:   Tue,  7 Mar 2023 17:57:11 +0100
Message-Id: <20230307170024.043406018@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit cea606d9e996a77eed57fc60709e0728341450e3 ]

Add missing clk_disable_unprepare(), if imx7_csi_dma_setup() fails
in imx7_csi_init().

Fixes: ff43ca911978 ("media: imx: imx7-media-csi: Move CSI configuration before source start")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Rui Miguel Silva <rmfrfs@gmail.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/imx/imx7-media-csi.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/media/imx/imx7-media-csi.c b/drivers/staging/media/imx/imx7-media-csi.c
index c77401f184d74..5f6376c3269ab 100644
--- a/drivers/staging/media/imx/imx7-media-csi.c
+++ b/drivers/staging/media/imx/imx7-media-csi.c
@@ -638,8 +638,10 @@ static int imx7_csi_init(struct imx7_csi *csi)
 	imx7_csi_configure(csi);
 
 	ret = imx7_csi_dma_setup(csi);
-	if (ret < 0)
+	if (ret < 0) {
+		clk_disable_unprepare(csi->mclk);
 		return ret;
+	}
 
 	return 0;
 }
-- 
2.39.2



