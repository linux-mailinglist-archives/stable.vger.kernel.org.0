Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9C6724BF1A
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 15:40:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727828AbgHTNjl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 09:39:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:42046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728180AbgHTJap (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:30:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD11920724;
        Thu, 20 Aug 2020 09:30:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597915845;
        bh=Mbyu94M5Ib3Jy3y7GVySoutrnyeR4/0pRXPAij6sL4o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LKazDKGCafaNUVDgBNfyEV8cVeKSznq4Y0awl/uYofqKIrdSM6nB3rvyoGPiARFta
         T7P3EqwoQkgJqZFMSSAAHTCSsu2xNWHi09ayOah3DnwE44vjZeFrFOWcLUFDbJ+fo9
         5J2Qrxj5cw3166OBhCbb23sXyXVM1Ii7L7Onc6A4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dafna Hirschfeld <dafna.hirschfeld@collabora.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Helen Koike <helen.koike@collabora.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 126/232] media: staging: rkisp1: rsz: set default format if the given format is not RKISP1_ISP_SD_SRC
Date:   Thu, 20 Aug 2020 11:19:37 +0200
Message-Id: <20200820091618.918297764@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091612.692383444@linuxfoundation.org>
References: <20200820091612.692383444@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dafna Hirschfeld <dafna.hirschfeld@collabora.com>

[ Upstream commit 206003b18bb264521607440752814ccff59f91f3 ]

When setting the sink format of the 'rkisp1_resizer'
the format should be supported by 'rkisp1_isp' on
the video source pad. This patch checks this condition
and sets the format to default if the condition is false.

Fixes: 56e3b29f9f6b "media: staging: rkisp1: add streaming paths"
Signed-off-by: Dafna Hirschfeld <dafna.hirschfeld@collabora.com>
Reviewed-by: Tomasz Figa <tfiga@chromium.org>
Acked-by: Helen Koike <helen.koike@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/rkisp1/rkisp1-common.h  | 3 +++
 drivers/staging/media/rkisp1/rkisp1-isp.c     | 3 ---
 drivers/staging/media/rkisp1/rkisp1-resizer.c | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/media/rkisp1/rkisp1-common.h b/drivers/staging/media/rkisp1/rkisp1-common.h
index 0c4fe503adc90..12bd9d05050db 100644
--- a/drivers/staging/media/rkisp1/rkisp1-common.h
+++ b/drivers/staging/media/rkisp1/rkisp1-common.h
@@ -22,6 +22,9 @@
 #include "rkisp1-regs.h"
 #include "uapi/rkisp1-config.h"
 
+#define RKISP1_ISP_SD_SRC BIT(0)
+#define RKISP1_ISP_SD_SINK BIT(1)
+
 #define RKISP1_ISP_MAX_WIDTH		4032
 #define RKISP1_ISP_MAX_HEIGHT		3024
 #define RKISP1_ISP_MIN_WIDTH		32
diff --git a/drivers/staging/media/rkisp1/rkisp1-isp.c b/drivers/staging/media/rkisp1/rkisp1-isp.c
index abfedb604303f..b21a67aea433c 100644
--- a/drivers/staging/media/rkisp1/rkisp1-isp.c
+++ b/drivers/staging/media/rkisp1/rkisp1-isp.c
@@ -23,9 +23,6 @@
 
 #define RKISP1_ISP_DEV_NAME	RKISP1_DRIVER_NAME "_isp"
 
-#define RKISP1_ISP_SD_SRC BIT(0)
-#define RKISP1_ISP_SD_SINK BIT(1)
-
 /*
  * NOTE: MIPI controller and input MUX are also configured in this file.
  * This is because ISP Subdev describes not only ISP submodule (input size,
diff --git a/drivers/staging/media/rkisp1/rkisp1-resizer.c b/drivers/staging/media/rkisp1/rkisp1-resizer.c
index e188944941b58..a2b35961bc8b7 100644
--- a/drivers/staging/media/rkisp1/rkisp1-resizer.c
+++ b/drivers/staging/media/rkisp1/rkisp1-resizer.c
@@ -542,7 +542,7 @@ static void rkisp1_rsz_set_sink_fmt(struct rkisp1_resizer *rsz,
 					    which);
 	sink_fmt->code = format->code;
 	mbus_info = rkisp1_isp_mbus_info_get(sink_fmt->code);
-	if (!mbus_info) {
+	if (!mbus_info || !(mbus_info->direction & RKISP1_ISP_SD_SRC)) {
 		sink_fmt->code = RKISP1_DEF_FMT;
 		mbus_info = rkisp1_isp_mbus_info_get(sink_fmt->code);
 	}
-- 
2.25.1



