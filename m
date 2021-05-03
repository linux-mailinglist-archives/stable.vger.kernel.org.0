Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF8703719CD
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:37:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231805AbhECQh5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:37:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:37364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231448AbhECQhE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:37:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CED3C6137D;
        Mon,  3 May 2021 16:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620059757;
        bh=3QPNUUFwutbpp8um8I+PiqU57KH5wx8UBnfck6xHl2k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bJRz6kUBMobZhRKQhprE43kaSrwKN6CxcIVmcOd5r7j/Y+3F3GSm66rvMcNWqtRYB
         m13kyM+EHyr58teMwQuaEbKH6mdjMuFRRPW2NXc2MBdXzpNxFqu6gCWPkdudRLDLCT
         tXU3B2d4EMCy48jcoQ2oVDmSC+K2YQmhe/4rpmfpEQvr9U0DC5v7cGPEPTqFF/zKXe
         J9P3oTjPThqFLKH1WTBsLWIe5bzE8kHodkyXBx76LaIdJe129vm6CrF6Svb69/hB7A
         L8WVLww4QP4DG1H8SlpjpPu43/r42ZpXAhVZoTYOHgn8rRaB+FaQqLfUMrcRfS+uDo
         AWAPA85oBxSHw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Julian Braha <julianbraha@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 028/134] media: drivers: media: pci: sta2x11: fix Kconfig dependency on GPIOLIB
Date:   Mon,  3 May 2021 12:33:27 -0400
Message-Id: <20210503163513.2851510-28-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503163513.2851510-1-sashal@kernel.org>
References: <20210503163513.2851510-1-sashal@kernel.org>
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
index 4dd98f94a91e..27bb78513631 100644
--- a/drivers/media/pci/sta2x11/Kconfig
+++ b/drivers/media/pci/sta2x11/Kconfig
@@ -3,6 +3,7 @@ config STA2X11_VIP
 	tristate "STA2X11 VIP Video For Linux"
 	depends on PCI && VIDEO_V4L2 && VIRT_TO_BUS && I2C
 	depends on STA2X11 || COMPILE_TEST
+	select GPIOLIB if MEDIA_SUBDRV_AUTOSELECT
 	select VIDEO_ADV7180 if MEDIA_SUBDRV_AUTOSELECT
 	select VIDEOBUF2_DMA_CONTIG
 	select MEDIA_CONTROLLER
-- 
2.30.2

