Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D4C14F27CB
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:08:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233715AbiDEIJC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:09:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235389AbiDEH7l (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:59:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 877D658823;
        Tue,  5 Apr 2022 00:54:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 05C87B81BB2;
        Tue,  5 Apr 2022 07:54:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0639C340EE;
        Tue,  5 Apr 2022 07:54:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145259;
        bh=4El5mLzPV5FIUFM4OPSsk5ycPZQtCJ+BCLlcToLdjSI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GOhFIfeHntqkRCPmSTHZje2GZzQsoxDjAk6RbbGWbHosdKG/a2TDXWfH+Cb1IJFdG
         U0zNZLMUSmtp84YxvAj1AD4dfhvL1BTRUus6o0A/fIGy/G6idByzARgvFFyDauelLg
         +C7i5bqh+sxc+AF92x0Lfr2SmdznkCdAKGIG+fgM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Eugen Hristev <eugen.hristev@microchip.com>,
        Jacopo Mondi <jacopo@jmondi.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0303/1126] media: atmel: atmel-sama7g5-isc: fix ispck leftover
Date:   Tue,  5 Apr 2022 09:17:30 +0200
Message-Id: <20220405070416.508429324@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Eugen Hristev <eugen.hristev@microchip.com>

[ Upstream commit 1b52ce99e9f2dcda868a1a7026bfb58d04bd6bc8 ]

The ispck is not used for sama7g5 variant of the ISC.
Calls to ispck have to be removed also from module insert/removal.

Fixes: d7f26849ed7c ("media: atmel: fix the ispck initialization")
Signed-off-by: Eugen Hristev <eugen.hristev@microchip.com>
Reviewed-by: Jacopo Mondi <jacopo@jmondi.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/atmel/atmel-sama7g5-isc.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/media/platform/atmel/atmel-sama7g5-isc.c b/drivers/media/platform/atmel/atmel-sama7g5-isc.c
index 5d1c76f680f3..2b1082295c13 100644
--- a/drivers/media/platform/atmel/atmel-sama7g5-isc.c
+++ b/drivers/media/platform/atmel/atmel-sama7g5-isc.c
@@ -556,7 +556,6 @@ static int microchip_xisc_remove(struct platform_device *pdev)
 
 	v4l2_device_unregister(&isc->v4l2_dev);
 
-	clk_disable_unprepare(isc->ispck);
 	clk_disable_unprepare(isc->hclock);
 
 	isc_clk_cleanup(isc);
@@ -568,7 +567,6 @@ static int __maybe_unused xisc_runtime_suspend(struct device *dev)
 {
 	struct isc_device *isc = dev_get_drvdata(dev);
 
-	clk_disable_unprepare(isc->ispck);
 	clk_disable_unprepare(isc->hclock);
 
 	return 0;
@@ -583,10 +581,6 @@ static int __maybe_unused xisc_runtime_resume(struct device *dev)
 	if (ret)
 		return ret;
 
-	ret = clk_prepare_enable(isc->ispck);
-	if (ret)
-		clk_disable_unprepare(isc->hclock);
-
 	return ret;
 }
 
-- 
2.34.1



