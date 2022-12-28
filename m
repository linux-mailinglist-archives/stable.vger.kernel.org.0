Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD70A6579AB
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:03:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233437AbiL1PDf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:03:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233461AbiL1PDd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:03:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 245E611C18
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:03:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CF3D5B81707
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:03:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 260F8C433EF;
        Wed, 28 Dec 2022 15:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672239809;
        bh=CQKpZh96KJ/iON2QTN4/3/iYUmRNwQLrTn4JUlgSRqw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U8QqVJP3sbXFNlt36CvCvdi+kY6PpoBZW33Y3P9R+BB35mNQreqgbyII30AmvtDDd
         4edCjydlg+6XzG9aT/QtbP5g3PN+iG3tzKkCZOcRTinl5I79BshcHPmf//i4+KCdTF
         kO+7fjBcMeqIFCuOCAUTAI9TWSrAwOHwthXs6Jcc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, kernel test robot <lkp@intel.com>,
        Sven Peter <sven@svenpeter.dev>,
        Hector Martin <marcan@marcan.st>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0081/1073] soc: apple: rtkit: Stop casting function pointer signatures
Date:   Wed, 28 Dec 2022 15:27:49 +0100
Message-Id: <20221228144330.266066295@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

From: Sven Peter <sven@svenpeter.dev>

[ Upstream commit 5acf07ff25f0c1c44105e6b8ebf88c55a0a04d2f ]

Fixes: 9bd1d9a0d8bb ("soc: apple: Add RTKit IPC library")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Sven Peter <sven@svenpeter.dev>
Signed-off-by: Hector Martin <marcan@marcan.st>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/apple/rtkit.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/soc/apple/rtkit.c b/drivers/soc/apple/rtkit.c
index cf1129e9f76b..d9329b4d8e1b 100644
--- a/drivers/soc/apple/rtkit.c
+++ b/drivers/soc/apple/rtkit.c
@@ -920,8 +920,10 @@ int apple_rtkit_wake(struct apple_rtkit *rtk)
 }
 EXPORT_SYMBOL_GPL(apple_rtkit_wake);
 
-static void apple_rtkit_free(struct apple_rtkit *rtk)
+static void apple_rtkit_free(void *data)
 {
+	struct apple_rtkit *rtk = data;
+
 	mbox_free_channel(rtk->mbox_chan);
 	destroy_workqueue(rtk->wq);
 
@@ -944,8 +946,7 @@ struct apple_rtkit *devm_apple_rtkit_init(struct device *dev, void *cookie,
 	if (IS_ERR(rtk))
 		return rtk;
 
-	ret = devm_add_action_or_reset(dev, (void (*)(void *))apple_rtkit_free,
-				       rtk);
+	ret = devm_add_action_or_reset(dev, apple_rtkit_free, rtk);
 	if (ret)
 		return ERR_PTR(ret);
 
-- 
2.35.1



