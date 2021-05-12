Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39B3937CCB8
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:06:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232756AbhELQqv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:46:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:35790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243433AbhELQlL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:41:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2042D61E41;
        Wed, 12 May 2021 16:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835449;
        bh=vqip+Pu3og34Bc/t1ROJP4nKVxKwNkevrLoEQllWJXU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bU1VbbUY+x4MdB/7HuwgfhtByg8pySY90twVVd75SAACPPi2wRuWN/8TV1zljTtGq
         ZYJLPUWPhhI0Ws+sNFIUvVV/gCjdsqE+w3JI38eXreFByBasOzzneDRE4H7RwRyOqt
         MS5vygeHqHa8fXePfxVQGRCZ5FcbRdd36HoJ8aEM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 350/677] media: mtk: fix mtk-smi dependency
Date:   Wed, 12 May 2021 16:46:36 +0200
Message-Id: <20210512144848.942248080@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 4fade8329ab2be2b902fce8db3625fd12234b873 ]

The mtk-smi driver can now be built as a loadable module, but
this leads to a build time regression when the drivers that
depend on it are built-in:

aarch64-linux-ld: drivers/media/platform/mtk-mdp/mtk_mdp_comp.o: in function `mtk_mdp_comp_clock_on':
mtk_mdp_comp.c:(.text.mtk_mdp_comp_clock_on+0x54): undefined reference to `mtk_smi_larb_get'
aarch64-linux-ld: drivers/media/platform/mtk-mdp/mtk_mdp_comp.o: in function `mtk_mdp_comp_clock_off':
mtk_mdp_comp.c:(.text.mtk_mdp_comp_clock_off+0x12c): undefined reference to `mtk_smi_larb_put'

Add a dependency on the interface, but keep allowing
compile-testing without that driver, as it was originally
intended.

Fixes: 50fc8d9232cd ("memory: mtk-smi: Allow building as module")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/Kconfig | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index fd1831e97b22..1ddb5d6354cf 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -244,6 +244,7 @@ config VIDEO_MEDIATEK_JPEG
 	depends on MTK_IOMMU_V1 || MTK_IOMMU || COMPILE_TEST
 	depends on VIDEO_DEV && VIDEO_V4L2
 	depends on ARCH_MEDIATEK || COMPILE_TEST
+	depends on MTK_SMI || (COMPILE_TEST && MTK_SMI=n)
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_MEM2MEM_DEV
 	help
@@ -271,6 +272,7 @@ config VIDEO_MEDIATEK_MDP
 	depends on MTK_IOMMU || COMPILE_TEST
 	depends on VIDEO_DEV && VIDEO_V4L2
 	depends on ARCH_MEDIATEK || COMPILE_TEST
+	depends on MTK_SMI || (COMPILE_TEST && MTK_SMI=n)
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_MEM2MEM_DEV
 	select VIDEO_MEDIATEK_VPU
@@ -291,6 +293,7 @@ config VIDEO_MEDIATEK_VCODEC
 	# our dependencies, to avoid missing symbols during link.
 	depends on VIDEO_MEDIATEK_VPU || !VIDEO_MEDIATEK_VPU
 	depends on MTK_SCP || !MTK_SCP
+	depends on MTK_SMI || (COMPILE_TEST && MTK_SMI=n)
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_MEM2MEM_DEV
 	select VIDEO_MEDIATEK_VCODEC_VPU if VIDEO_MEDIATEK_VPU
-- 
2.30.2



