Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6125247601
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:32:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732286AbgHQTb5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 15:31:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:56614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729374AbgHQPbi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:31:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A6CD323B1A;
        Mon, 17 Aug 2020 15:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678298;
        bh=wyke/k5vsBrPRhrkuRFm7GHoHj8TO6le21J0rUSiew8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dwK/j6LUJk33O7cr3gUyt1LEg3RTjE2+MYTEySDSo7oCuet/PeqZ6A6w691Oh4BLp
         um3YHcK4vTfwY/A4m3HopALVH3ny6qAWZKo/onNORCnO2gEosiiOSgbf5pX8HeY9bg
         V1hqbgBGmZZmObblmIAXoP5jZieiKx5q2QAA9PPw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 255/464] gpu: ipu-v3: Restore RGB32, BGR32
Date:   Mon, 17 Aug 2020 17:13:28 +0200
Message-Id: <20200817143846.008337756@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steve Longerbeam <slongerbeam@gmail.com>

[ Upstream commit 22b2cfad752d4b278ea7c38c0ee961ca50198ce8 ]

RGB32 and BGR32 formats were inadvertently removed from the switch
statement in ipu_pixelformat_to_colorspace(). Restore them.

Fixes: a59957172b0c ("gpu: ipu-v3: enable remaining 32-bit RGB V4L2 pixel formats")
Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/ipu-v3/ipu-common.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/ipu-v3/ipu-common.c b/drivers/gpu/ipu-v3/ipu-common.c
index ee2a025e54cfe..b3dae9ec1a38b 100644
--- a/drivers/gpu/ipu-v3/ipu-common.c
+++ b/drivers/gpu/ipu-v3/ipu-common.c
@@ -124,6 +124,8 @@ enum ipu_color_space ipu_pixelformat_to_colorspace(u32 pixelformat)
 	case V4L2_PIX_FMT_RGBX32:
 	case V4L2_PIX_FMT_ARGB32:
 	case V4L2_PIX_FMT_XRGB32:
+	case V4L2_PIX_FMT_RGB32:
+	case V4L2_PIX_FMT_BGR32:
 		return IPUV3_COLORSPACE_RGB;
 	default:
 		return IPUV3_COLORSPACE_UNKNOWN;
-- 
2.25.1



