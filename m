Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D612F4474A3
	for <lists+stable@lfdr.de>; Sun,  7 Nov 2021 18:35:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235390AbhKGRib (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Nov 2021 12:38:31 -0500
Received: from p-impout009aa.msg.pkvw.co.charter.net ([47.43.26.140]:60880
        "EHLO p-impout009.msg.pkvw.co.charter.net" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232053AbhKGRib (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Nov 2021 12:38:31 -0500
Received: from localhost.localdomain ([24.31.246.181])
        by cmsmtp with ESMTP
        id jm54m968dE1Bbjm54mRHgi; Sun, 07 Nov 2021 17:35:47 +0000
X-Authority-Analysis: v=2.4 cv=X+2XlEfe c=1 sm=1 tr=0 ts=61880e73
 a=cAe/7qmlxnd6JlJqP68I9A==:117 a=cAe/7qmlxnd6JlJqP68I9A==:17 a=pGLkceISAAAA:8
 a=QyXUC8HyAAAA:8 a=VwQbUJbxAAAA:8 a=yQdBAQUQAAAA:8 a=0x8QZmvYvHxge1C1EjMA:9
 a=AjGcO6oz07-iQ99wixmX:22 a=SzazLyfi1tnkUD6oumHU:22
From:   Larry Finger <Larry.Finger@lwfinger.net>
To:     gregkh@linuxfoundation.org
Cc:     phil@philpotter.co.uk, linux-staging@lists.linux.dev,
        linux-kernel@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Zameer Manji <zmanji@gmail.com>,
        kernel test robot <lkp@intel.com>,
        Stable <stable@vger.kernel.org>
Subject: [PATCH v2] staging: r8188eu: Fix breakage introduced when 5G code was removed
Date:   Sun,  7 Nov 2021 11:35:43 -0600
Message-Id: <20211107173543.7486-1-Larry.Finger@lwfinger.net>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4xfIgXlh5EAJLWnNLb24r89digf751ozj5KwHrlNPHVjc8fjV60Pnfq7b9smbuGpzQbigCD5uiIOL1zwLZpWVEE+RdBw/qiO8SkA+ZumPs4wCxFAdKIoiP
 BAiGBzCau1e5290t9zkJJp7nzFow49DlDloaeb8/GUI61FhKM/dcJ8rdLVpCMk8vjiUBsHVRgTfglYuAeNGtVjxDDoeInqdq4tPVylGZanzaa7LCIVvZa78w
 5VP+QmLmbjr1Hev5973yBd4RJcgBoL9lbDX7jBB8nlR/bRurGEoXS4o6/HsbEaF+BFRZXOQzcvoGWgulyOphCaoPoelq2WLCqvruA7nPdLtFWn21sQv1QxmJ
 jWaypr+7PW9SR2yJtM4c+/3JFrryr1NdID5Vk7M0Wj86h+hTTy6R8JxTKEq68gUxSGguotmSslkDE5IFhaBhaSkjplPi1gQm99bIMT/unSQbLJzWewA=
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In commit 221abd4d478a ("staging: r8188eu: Remove no more necessary definitions
and code"), two entries were removed from RTW_ChannelPlanMap[], but not replaced
with zeros. The position within this table is important, thus the patch broke
systems operating in regulatory domains osted later than entry 0x13 in the table.
Unfortunately, the FCC entry comes before that point and most testers did not see
this problem.

Reported-and-tested-by: Zameer Manji <zmanji@gmail.com>
Reported-by: kernel test robot <lkp@intel.com>
Fixes: 221abd4d478a ("staging: r8188eu: Remove no more necessary definitions and code")
Cc: Stable <stable@vger.kernel.org> # v5.5+
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

v2 - fixed use of () rsther than {} - found by kernel test robot
---
 drivers/staging/r8188eu/core/rtw_mlme_ext.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/r8188eu/core/rtw_mlme_ext.c b/drivers/staging/r8188eu/core/rtw_mlme_ext.c
index 55c3d4a6faeb..5b60e6df5f87 100644
--- a/drivers/staging/r8188eu/core/rtw_mlme_ext.c
+++ b/drivers/staging/r8188eu/core/rtw_mlme_ext.c
@@ -107,6 +107,7 @@ static struct rt_channel_plan_map	RTW_ChannelPlanMap[RT_CHANNEL_DOMAIN_MAX] = {
 	{0x01},	/* 0x10, RT_CHANNEL_DOMAIN_JAPAN */
 	{0x02},	/* 0x11, RT_CHANNEL_DOMAIN_FCC_NO_DFS */
 	{0x01},	/* 0x12, RT_CHANNEL_DOMAIN_JAPAN_NO_DFS */
+	{0x00}, /* 0x13 */
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

