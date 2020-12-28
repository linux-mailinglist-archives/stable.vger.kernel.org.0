Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E22082E6430
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:48:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404258AbgL1Nmk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:42:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:42860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404243AbgL1Nmh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:42:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7D3A3206ED;
        Mon, 28 Dec 2020 13:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162916;
        bh=EtrtNzjBt/6SdUvBKWT3J6QUlTOr5G5BUP1dzuw7Zzk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W9Hbt6CGEeRgRGC7sOEcl1fKYfm3KL6vmf27FVhWF0c/R9jciQfTzztLzPrpCYwap
         svTjROuJL2Czg8ZD8merVXid54sqMJSwCnEdwJxdQFNinamSta7+LJ+rv7gpjonnu/
         kIcuRIAUrlmicll0eE2l0e/FUAHye7rH2mwk+0/Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Joel Stanley <joel@jms.id.au>,
        Andrew Jeffery <andrew@aj.id.au>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Michal Simek <monstr@monstr.eu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Rapoport <rppt@linux.ibm.com>, linux-mm@kvack.org,
        linux-aspeed@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org,
        David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 074/453] drm/aspeed: Fix Kconfig warning & subsequent build errors
Date:   Mon, 28 Dec 2020 13:45:10 +0100
Message-Id: <20201228124940.799406977@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit bf296b35489b46780b73b74ad984d06750ed5479 ]

Kernel test robot reported build errors (undefined references)
that didn't make much sense. After reproducing them, there is also
a Kconfig warning that is the root cause of the build errors, so
fix that Kconfig problem.

Fixes this Kconfig warning:
WARNING: unmet direct dependencies detected for CMA
  Depends on [n]: MMU [=n]
  Selected by [m]:
  - DRM_ASPEED_GFX [=m] && HAS_IOMEM [=y] && DRM [=m] && OF [=y] && (COMPILE_TEST [=y] || ARCH_ASPEED) && HAVE_DMA_CONTIGUOUS [=y]

and these dependent build errors:
(.text+0x10c8c): undefined reference to `start_isolate_page_range'
microblaze-linux-ld: (.text+0x10f14): undefined reference to `test_pages_isolated'
microblaze-linux-ld: (.text+0x10fd0): undefined reference to `undo_isolate_page_range'

Fixes: 76356a966e33 ("drm: aspeed: Clean up Kconfig options")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Joel Stanley <joel@jms.id.au>
Cc: Joel Stanley <joel@jms.id.au>
Cc: Andrew Jeffery <andrew@aj.id.au>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: linux-mm@kvack.org
Cc: linux-aspeed@lists.ozlabs.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org
Signed-off-by: Joel Stanley <joel@jms.id.au>
Link: https://patchwork.freedesktop.org/patch/msgid/20201011230131.4922-1-rdunlap@infradead.org
Signed-off-by: Joel Stanley <joel@jms.id.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/aspeed/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/aspeed/Kconfig b/drivers/gpu/drm/aspeed/Kconfig
index 018383cfcfa79..5e95bcea43e92 100644
--- a/drivers/gpu/drm/aspeed/Kconfig
+++ b/drivers/gpu/drm/aspeed/Kconfig
@@ -3,6 +3,7 @@ config DRM_ASPEED_GFX
 	tristate "ASPEED BMC Display Controller"
 	depends on DRM && OF
 	depends on (COMPILE_TEST || ARCH_ASPEED)
+	depends on MMU
 	select DRM_KMS_HELPER
 	select DRM_KMS_CMA_HELPER
 	select DMA_CMA if HAVE_DMA_CONTIGUOUS
-- 
2.27.0



