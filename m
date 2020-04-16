Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 731161AC834
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 17:05:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437640AbgDPPFC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 11:05:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:39122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2441696AbgDPNwo (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:52:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3C0E120732;
        Thu, 16 Apr 2020 13:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587045163;
        bh=0XrRqotfepK3zUNWdd8fnIccrvPnNVyNdW6GWO8JWtQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Eo7anQNB2uZtVDgRZKwhl9ytpGWg9D1YhZp+sVRQZziQF+94u5gt4pNQyCtuFSp55
         r3R13t5GErmjUBs/IDDr5sMuntopcFwJ2fmALUhK/7XkREhgiZhF+BtVgfNakDZKcW
         cBW5zHHK7XnYIOhzv1WTabE09oTqOW2cf4+gXhF8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Rui Miguel Silva <rmfrfs@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 023/254] media: imx: imx7-media-csi: Fix video field handling
Date:   Thu, 16 Apr 2020 15:21:52 +0200
Message-Id: <20200416131328.737138646@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.804095985@linuxfoundation.org>
References: <20200416131325.804095985@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index db30e2c70f2fe..f45920b3137e4 100644
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



