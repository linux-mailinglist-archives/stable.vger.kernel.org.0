Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0864371C03
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:50:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233223AbhECQvE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:51:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:32838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233395AbhECQrw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:47:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0FE62613CA;
        Mon,  3 May 2021 16:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620059996;
        bh=1EWvrNcYRMZNejusgByiFhHZ5oaQkZq+5SS5tOUEu3E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SwqbltnXEurZyIIJ/MTtZBOgvzqWtZuw8P/h8o9VXJSjy/5TdwMGrDtq1m07E39gx
         Em8DcLCq//GipQiHwSbCLgYmDjMjiof6iSgsijvrJhpNf++ZhB8GFAWrw50ccVtCqe
         8n70qHE0G5GHG5iDI90/bmuvIOUbp1UShgtCk69tiT4mHyI+eVV8n5Uu2RFdUbg1kx
         2BqxLpAZDJRHOF3Hcl+DThjGflVECzMzQS09ZRnFmRJKQpAEeO42L6QQptfnA5PUuu
         i2V1zmhQRed3jf18rnDqbJhjJwyn++6NhdJ28Mu02keVkoDUpj6ZevIODZ8OnKzyPl
         B5HFOEukwguEg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Julian Braha <julianbraha@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 09/57] media: drivers: media: pci: sta2x11: fix Kconfig dependency on GPIOLIB
Date:   Mon,  3 May 2021 12:38:53 -0400
Message-Id: <20210503163941.2853291-9-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503163941.2853291-1-sashal@kernel.org>
References: <20210503163941.2853291-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Julian Braha <julianbraha@gmail.com>

[ Upstream commit 24df8b74c8b2fb42c49ffe8585562da0c96446ff ]

When STA2X11_VIP is enabled, and GPIOLIB is disabled,
Kbuild gives the following warning:

WARNING: unmet direct dependencies detected for VIDEO_ADV7180
  Depends on [n]: MEDIA_SUPPORT [=y] && GPIOLIB [=n] && VIDEO_V4L2 [=y] && I2C [=y]
  Selected by [y]:
  - STA2X11_VIP [=y] && MEDIA_SUPPORT [=y] && MEDIA_PCI_SUPPORT [=y] && MEDIA_CAMERA_SUPPORT [=y] && PCI [=y] && VIDEO_V4L2 [=y] && VIRT_TO_BUS [=y] && I2C [=y] && (STA2X11 [=n] || COMPILE_TEST [=y]) && MEDIA_SUBDRV_AUTOSELECT [=y]

This is because STA2X11_VIP selects VIDEO_ADV7180
without selecting or depending on GPIOLIB,
despite VIDEO_ADV7180 depending on GPIOLIB.

Signed-off-by: Julian Braha <julianbraha@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/sta2x11/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/pci/sta2x11/Kconfig b/drivers/media/pci/sta2x11/Kconfig
index 011b766f0bff..d613feee8176 100644
--- a/drivers/media/pci/sta2x11/Kconfig
+++ b/drivers/media/pci/sta2x11/Kconfig
@@ -2,6 +2,7 @@
 config STA2X11_VIP
 	tristate "STA2X11 VIP Video For Linux"
 	depends on STA2X11 || COMPILE_TEST
+	select GPIOLIB if MEDIA_SUBDRV_AUTOSELECT
 	select VIDEO_ADV7180 if MEDIA_SUBDRV_AUTOSELECT
 	select VIDEOBUF2_DMA_CONTIG
 	depends on PCI && VIDEO_V4L2 && VIRT_TO_BUS
-- 
2.30.2

