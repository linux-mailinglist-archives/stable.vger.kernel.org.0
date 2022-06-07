Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DCB154062E
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:34:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347117AbiFGRd1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:33:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347890AbiFGRbV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:31:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8309411CA10;
        Tue,  7 Jun 2022 10:28:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0E1996136A;
        Tue,  7 Jun 2022 17:28:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A25FC36AFE;
        Tue,  7 Jun 2022 17:28:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654622922;
        bh=s94htJ+M2rQ9fz/7PNsv5MdmwHrUarKl5BJQXtRmP80=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lPMGI/YwZk0o5cHDOeIMUdebUW30j2pG9eqeelT4FI6+y4YBUoVRXhW+OnBuuPqak
         ImLUbJtNPs3KgG+5v5AZFulzKztJ8LDjny/9/u9T54Y+HyQM0ZvuQOiARCBO9f2J5c
         F0a5xeVsn2Y0m/GdN5Qr7CLaL68GNlKTOqfblMyg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Sebastian Fricke <sebastian.fricke@collabora.com>,
        Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 230/452] media: rkvdec: Stop overclocking the decoder
Date:   Tue,  7 Jun 2022 19:01:27 +0200
Message-Id: <20220607164915.416375047@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164908.521895282@linuxfoundation.org>
References: <20220607164908.521895282@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Dufresne <nicolas.dufresne@collabora.com>

[ Upstream commit 9998943f6dfc5d5472bfab2e38527fb6ba5e9da7 ]

While this overclock hack seems to work on some implementations
(some ChromeBooks, RockPi4) it also causes instability on other
implementations (notably LibreComputer Renegade, but there were more
reports in the LibreELEC project, where this has been removed). While
performance is indeed affected (tested with GStreamer), 4K playback
still works as long as you don't operate in lock step and keep at
least 1 frame ahead of time in the decode queue.

After discussion with ChromeOS members, it would seem that their
implementation indeed used to synchronously decode each frame, so
this hack was simply compensating for their code being less
efficient. In my opinion, this hack should not have been included
upstream.

Fixes: cd33c830448ba ("media: rkvdec: Add the rkvdec driver")
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Reviewed-by: Sebastian Fricke <sebastian.fricke@collabora.com>
Reviewed-by: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/rkvdec/rkvdec.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/staging/media/rkvdec/rkvdec.c b/drivers/staging/media/rkvdec/rkvdec.c
index e384ea8d7280..617d06b8f597 100644
--- a/drivers/staging/media/rkvdec/rkvdec.c
+++ b/drivers/staging/media/rkvdec/rkvdec.c
@@ -1025,12 +1025,6 @@ static int rkvdec_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	/*
-	 * Bump ACLK to max. possible freq. (500 MHz) to improve performance
-	 * When 4k video playback.
-	 */
-	clk_set_rate(rkvdec->clocks[0].clk, 500 * 1000 * 1000);
-
 	rkvdec->regs = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(rkvdec->regs))
 		return PTR_ERR(rkvdec->regs);
-- 
2.35.1



