Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54C1C1A40AF
	for <lists+stable@lfdr.de>; Fri, 10 Apr 2020 05:57:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727742AbgDJDtW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Apr 2020 23:49:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:33274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728517AbgDJDtW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Apr 2020 23:49:22 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1A70420A8B;
        Fri, 10 Apr 2020 03:49:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586490562;
        bh=cD3HNfjxwqG1X/QHqJC2nXVmCHZlJSzV9ZXuWKVzoYA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UMpHauiMSIjIWxAbN3dKrrk9e1HJ01gM98LTQ4j+xvVH2UKY2Y5Nb+gWWG0f56VeO
         28jVjayFiFXp4H+AxQhGeHG6uvvdJ9HmDJV3f2oIGwaKaiY/iCeSYWU47wZ2BDuu3Z
         xSoMPUkqIHeEqCi4/s/Wi5WsIvWrSGo/YOGb1ap8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Rui Miguel Silva <rmfrfs@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 09/46] media: imx: imx7-media-csi: Fix video field handling
Date:   Thu,  9 Apr 2020 23:48:32 -0400
Message-Id: <20200410034909.8922-9-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200410034909.8922-1-sashal@kernel.org>
References: <20200410034909.8922-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

[ Upstream commit f7b8488bd39ae8feced4dfbb41cf1431277b893f ]

Commit 4791bd7d6adc ("media: imx: Try colorimetry at both sink and
source pads") reworked the way that formats are set on the sink pad of
the CSI subdevice, and accidentally removed video field handling.
Restore it by defaulting to V4L2_FIELD_NONE if the field value isn't
supported, with the only two supported value being V4L2_FIELD_NONE and
V4L2_FIELD_INTERLACED.

Fixes: 4791bd7d6adc ("media: imx: Try colorimetry at both sink and source pads")
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Rui Miguel Silva <rmfrfs@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/imx/imx7-media-csi.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/staging/media/imx/imx7-media-csi.c b/drivers/staging/media/imx/imx7-media-csi.c
index bfd6b5fbf4841..d24897d06947f 100644
--- a/drivers/staging/media/imx/imx7-media-csi.c
+++ b/drivers/staging/media/imx/imx7-media-csi.c
@@ -1009,6 +1009,7 @@ static int imx7_csi_try_fmt(struct imx7_csi *csi,
 		sdformat->format.width = in_fmt->width;
 		sdformat->format.height = in_fmt->height;
 		sdformat->format.code = in_fmt->code;
+		sdformat->format.field = in_fmt->field;
 		*cc = in_cc;
 
 		sdformat->format.colorspace = in_fmt->colorspace;
@@ -1023,6 +1024,9 @@ static int imx7_csi_try_fmt(struct imx7_csi *csi,
 							 false);
 			sdformat->format.code = (*cc)->codes[0];
 		}
+
+		if (sdformat->format.field != V4L2_FIELD_INTERLACED)
+			sdformat->format.field = V4L2_FIELD_NONE;
 		break;
 	default:
 		return -EINVAL;
-- 
2.20.1

