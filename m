Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7F8834C9F4
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:34:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233951AbhC2Ie1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:34:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:53552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234626AbhC2IdW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:33:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0E463619C8;
        Mon, 29 Mar 2021 08:32:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006758;
        bh=u1IcUxAsnR0p8HYknTE2bkyfOLNMwcdfcfjLCaR9rV0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cemd0YW0B9Q4dYa6t6VipAq7OTTRTDQzeSMVNcDBFPeFUPii2sipIzbIqtwXVSwDV
         MiriCuSrNB/sKqxbVMpXsg/GjJAe/oDEsIozkVCEaSzjGo3iuhHMjrDAmFm5F9TIrP
         lHnfwyUYRnPvXESWOn5ii7+j+B9xzbpdReVZWHfM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 048/254] drm/radeon: fix AGP dependency
Date:   Mon, 29 Mar 2021 09:56:04 +0200
Message-Id: <20210329075634.752160830@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075633.135869143@linuxfoundation.org>
References: <20210329075633.135869143@linuxfoundation.org>
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
index af6c6d214d91..f0c0ccdc8a10 100644
--- a/drivers/gpu/drm/Kconfig
+++ b/drivers/gpu/drm/Kconfig
@@ -232,6 +232,7 @@ source "drivers/gpu/drm/arm/Kconfig"
 config DRM_RADEON
 	tristate "ATI Radeon"
 	depends on DRM && PCI && MMU
+	depends on AGP || !AGP
 	select FW_LOADER
         select DRM_KMS_HELPER
         select DRM_TTM
-- 
2.30.1



