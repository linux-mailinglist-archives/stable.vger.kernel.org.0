Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05A872C4328
	for <lists+stable@lfdr.de>; Wed, 25 Nov 2020 16:38:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730481AbgKYPgP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Nov 2020 10:36:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:53578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730501AbgKYPgP (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 25 Nov 2020 10:36:15 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 90B03208CA;
        Wed, 25 Nov 2020 15:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606318574;
        bh=PF4DyltYMiXeqtX1ZkatjLYdcckflbeLZAslTMDY33M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WYeD3ZGqkSZdhEIk+/cRs6e4Jf+9ZCoMFZkGU19OW1RSuvZXk4JtGkT/re0kdtNCT
         0lwPkvBqoH4smoHi/iXrou+WiPVTzt0lowmJ4hNhtKJwIx3VV9JPk8H7zt1U/KO90u
         AKx7KC7qy9E8oqLkaWSu8wRHyhZacsnvyFxCz/rQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Laurent Vivier <lvivier@redhat.com>,
        kernel test robot <lkp@intel.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Sasha Levin <sashal@kernel.org>,
        virtualization@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 5.9 18/33] vdpasim: fix "mac_pton" undefined error
Date:   Wed, 25 Nov 2020 10:35:35 -0500
Message-Id: <20201125153550.810101-18-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201125153550.810101-1-sashal@kernel.org>
References: <20201125153550.810101-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Laurent Vivier <lvivier@redhat.com>

[ Upstream commit a312db697cb05dfa781848afe8585a1e1f2a5a99 ]

   ERROR: modpost: "mac_pton" [drivers/vdpa/vdpa_sim/vdpa_sim.ko] undefined!

mac_pton() is defined in lib/net_utils.c and is not built if NET is not set.

Select GENERIC_NET_UTILS as vdpasim doesn't depend on NET.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Laurent Vivier <lvivier@redhat.com>
Link: https://lore.kernel.org/r/20201113155706.599434-1-lvivier@redhat.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Randy Dunlap <rdunlap@infradead.org> # build-tested
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/vdpa/Kconfig b/drivers/vdpa/Kconfig
index d7d32b6561021..358f6048dd3ce 100644
--- a/drivers/vdpa/Kconfig
+++ b/drivers/vdpa/Kconfig
@@ -13,6 +13,7 @@ config VDPA_SIM
 	depends on RUNTIME_TESTING_MENU && HAS_DMA
 	select DMA_OPS
 	select VHOST_RING
+	select GENERIC_NET_UTILS
 	default n
 	help
 	  vDPA networking device simulator which loop TX traffic back
-- 
2.27.0

