Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65FD134C62C
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:08:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232166AbhC2IFf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:05:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:47768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232167AbhC2IEk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:04:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8245161959;
        Mon, 29 Mar 2021 08:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617005079;
        bh=Hu7eLsX0xzzWq8Az1HGRu3h9HNzL7mi7VCU2Z64f044=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NubtIa00RlnamXU9pdrZQVVOLPFhFeu53bEYBOVwgAbmViL4m6V3VC7EVYcqI5xl3
         6pCvVJKtzdv9SD7fnw9/L9s6epZA/iBY7eB0161BaQi99eiQvfCUEVRnUYTR6BIYan
         dWPYm47GHmNgBHYMcVPmbS4jvuIaPbzDyZ1xJ3BM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 18/59] drm/radeon: fix AGP dependency
Date:   Mon, 29 Mar 2021 09:57:58 +0200
Message-Id: <20210329075609.481151152@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075608.898173317@linuxfoundation.org>
References: <20210329075608.898173317@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian König <christian.koenig@amd.com>

[ Upstream commit cba2afb65cb05c3d197d17323fee4e3c9edef9cd ]

When AGP is compiled as module radeon must be compiled as module as
well.

Signed-off-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/Kconfig b/drivers/gpu/drm/Kconfig
index 83cb2a88c204..595d0c96ba89 100644
--- a/drivers/gpu/drm/Kconfig
+++ b/drivers/gpu/drm/Kconfig
@@ -156,6 +156,7 @@ source "drivers/gpu/drm/arm/Kconfig"
 config DRM_RADEON
 	tristate "ATI Radeon"
 	depends on DRM && PCI && MMU
+	depends on AGP || !AGP
 	select FW_LOADER
         select DRM_KMS_HELPER
         select DRM_TTM
-- 
2.30.1



