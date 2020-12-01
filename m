Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6CF12C9D0D
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:39:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389664AbgLAJKS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:10:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:47802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389662AbgLAJKR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:10:17 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 89BEC2223F;
        Tue,  1 Dec 2020 09:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813777;
        bh=PF4DyltYMiXeqtX1ZkatjLYdcckflbeLZAslTMDY33M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EStAEcUrTF9cua+BALXgPzk6UHa63wPMnbUWlWs07BjgPeDuJ/05uTL4QmY3JXnhJ
         d0PIt28EP5jxjs6A6eNN7YDca3o8NuzOZMVweSEOLJV1Xy9eDSdp6Q4OubZoGL50fW
         eUxSqGISyBdT13eiYfLVtRPmFs+gqfEv4oX3uAgE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Laurent Vivier <lvivier@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH 5.9 056/152] vdpasim: fix "mac_pton" undefined error
Date:   Tue,  1 Dec 2020 09:52:51 +0100
Message-Id: <20201201084719.287455147@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084711.707195422@linuxfoundation.org>
References: <20201201084711.707195422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



