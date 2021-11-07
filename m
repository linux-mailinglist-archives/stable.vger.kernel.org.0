Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 004A244712B
	for <lists+stable@lfdr.de>; Sun,  7 Nov 2021 02:38:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229996AbhKGBlS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Nov 2021 21:41:18 -0400
Received: from p-impout009aa.msg.pkvw.co.charter.net ([47.43.26.140]:40071
        "EHLO p-impout009.msg.pkvw.co.charter.net" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229566AbhKGBlS (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 6 Nov 2021 21:41:18 -0400
X-Greylist: delayed 427 seconds by postgrey-1.27 at vger.kernel.org; Sat, 06 Nov 2021 21:41:18 EDT
Received: from 2603-8090-2005-39b3-0000-0000-0000-1025.res6.spectrum.com.com ([24.31.246.181])
        by cmsmtp with ESMTP
        id jX1qm3piEE1BbjX1rmQA09; Sun, 07 Nov 2021 01:31:27 +0000
X-Authority-Analysis: v=2.4 cv=X+2XlEfe c=1 sm=1 tr=0 ts=61872c6f
 a=cAe/7qmlxnd6JlJqP68I9A==:117 a=cAe/7qmlxnd6JlJqP68I9A==:17 a=pGLkceISAAAA:8
 a=VwQbUJbxAAAA:8 a=yQdBAQUQAAAA:8 a=0x8QZmvYvHxge1C1EjMA:9
 a=AjGcO6oz07-iQ99wixmX:22 a=SzazLyfi1tnkUD6oumHU:22
From:   Larry Finger <Larry.Finger@lwfinger.net>
To:     gregkh@linuxfoundation.org
Cc:     phil@philpotter.co.uk, linux-staging@lists.linux.dev,
        linux-kernel@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Zameer Manji <zmanji@gmail.com>,
        Stable <stable@vger.kernel.org>
Subject: [PATCH] staging: r8188eu: Fix breakage introduced when 5G code was removed
Date:   Sat,  6 Nov 2021 20:31:23 -0500
Message-Id: <20211107013123.14624-1-Larry.Finger@lwfinger.net>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4xfAcj5TPV50mOcoyuoqfs9znVi4v7h8Z/+IznGBCGZrTJb9YE/8fu0sDuaDtxGXhCfWs6BRwET1Je+fB/K/dr2z0CKCz1aoNC9ynjBFejO979hGAQ3lX3
 O3ei6eAWrJhuUeRLrMVe+KY+QwDGjcHm4ejAXt5DD+qg46mRiGxwZRH5ZNL8togiIf0eFPvSljSkccqLSsOXsdtXsv4zXSsX6sCG/Ne5XxZs/sUk/ww25yb1
 6IYDOk7yO2KIuMQbNWwEsaYEeU4qaBYfblkfg2NM3Vik6xQv9TPcDyreZHvX11sapKE+RgMGbnzAjx+Us8gbF+NCv7xf2LFNNBQl2KTdTMKI+3tzLMZAG8sG
 3UG6mvlL+PJdGsxG1cHI+p27p7muq0VAx1YWGbHDcLiX87G1VPMLZPBroarZ/k+fm8W1txAfCTUCVqiGDMlRtxs7VBJ79FUtJ6rkKV3gaQGrkQpcScLfZPkV
 r8gwV0osyCfElLu1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In commit 221abd4d478a ("staging: r8188eu: Remove no more necessary definitions
and code"), two entries were removed from RTW_ChannelPlanMap[], but not replaced
with zeros. The position within this table is important, thus the patch broke
systems operating in regulatory domains listed later than entry 0x13 in the table.
Unfortunately, the FCC entry comes before that point and most testers did not see
this problem.

Reported-and-tested-by: Zameer Manji <zmanji@gmail.com>
Fixes: 221abd4d478a ("staging: r8188eu: Remove no more necessary definitions and code")
Cc: Stable <stable@vger.kernel.org> # v5.5+
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/staging/r8188eu/core/rtw_mlme_ext.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/r8188eu/core/rtw_mlme_ext.c b/drivers/staging/r8188eu/core/rtw_mlme_ext.c
index 55c3d4a6faeb..d3814174e08f 100644
--- a/drivers/staging/r8188eu/core/rtw_mlme_ext.c
+++ b/drivers/staging/r8188eu/core/rtw_mlme_ext.c
@@ -107,6 +107,7 @@ static struct rt_channel_plan_map	RTW_ChannelPlanMap[RT_CHANNEL_DOMAIN_MAX] = {
 	{0x01},	/* 0x10, RT_CHANNEL_DOMAIN_JAPAN */
 	{0x02},	/* 0x11, RT_CHANNEL_DOMAIN_FCC_NO_DFS */
 	{0x01},	/* 0x12, RT_CHANNEL_DOMAIN_JAPAN_NO_DFS */
+	(0x00), /* 0x13 */
 	{0x02},	/* 0x14, RT_CHANNEL_DOMAIN_TAIWAN_NO_DFS */
 	{0x00},	/* 0x15, RT_CHANNEL_DOMAIN_ETSI_NO_DFS */
 	{0x00},	/* 0x16, RT_CHANNEL_DOMAIN_KOREA_NO_DFS */
@@ -118,6 +119,7 @@ static struct rt_channel_plan_map	RTW_ChannelPlanMap[RT_CHANNEL_DOMAIN_MAX] = {
 	{0x00},	/* 0x1C, */
 	{0x00},	/* 0x1D, */
 	{0x00},	/* 0x1E, */
+	{0x00},	/* 0x1F, */
 	/*  0x20 ~ 0x7F , New Define ===== */
 	{0x00},	/* 0x20, RT_CHANNEL_DOMAIN_WORLD_NULL */
 	{0x01},	/* 0x21, RT_CHANNEL_DOMAIN_ETSI1_NULL */
-- 
2.33.1

