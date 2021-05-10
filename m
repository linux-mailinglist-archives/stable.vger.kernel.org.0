Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4880F3781BD
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 12:28:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231437AbhEJK3S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:29:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:59860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231458AbhEJK1w (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:27:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F36A461075;
        Mon, 10 May 2021 10:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620642403;
        bh=1EWvrNcYRMZNejusgByiFhHZ5oaQkZq+5SS5tOUEu3E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dBwMb0U68DOJXEZMOZNJOr/0t93GjtHWnQ1Svf1Kf85sup3A7L4PWkf36FohMMa4X
         T8ANMbSxTTI00VrUleNJiDQPBz0lGutsoOg0KjYvSo4CtjbrFFglLjiro+OxoJW+pl
         Ho/VyYJIx4PlgQVOIL9eIGDcN2oX46hDpDlW30M0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julian Braha <julianbraha@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 079/184] media: drivers: media: pci: sta2x11: fix Kconfig dependency on GPIOLIB
Date:   Mon, 10 May 2021 12:19:33 +0200
Message-Id: <20210510101952.772355437@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510101950.200777181@linuxfoundation.org>
References: <20210510101950.200777181@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



