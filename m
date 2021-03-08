Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCA93330E6B
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 13:37:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231410AbhCHMg7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 07:36:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:46502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231458AbhCHMgh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Mar 2021 07:36:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0E7C265204;
        Mon,  8 Mar 2021 12:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615206996;
        bh=w40hNDJC+2GzAC0sWjMhv6rPNUM6OCGyOVLghG0ICc0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yuXI8jdR43OS7PI5BGvzP5+VCkPlC1xFDIooiT4nTfmOEjenFbhr7XiISKwRFEyVl
         vStlKRB+PLfr2RYjLtLRp6elE8oQlfIK4Y5bDMqqVWtXCa/emUjYMkfLI4CAQd8m63
         FoRxDgvj+CUn+C87IeWW+fOaA6OEuLqW39Uoa41U=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julian Braha <julianbraha@gmail.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 33/44] RDMA/rxe: Fix missing kconfig dependency on CRYPTO
Date:   Mon,  8 Mar 2021 13:35:11 +0100
Message-Id: <20210308122720.173972607@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210308122718.586629218@linuxfoundation.org>
References: <20210308122718.586629218@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Julian Braha <julianbraha@gmail.com>

[ Upstream commit 475f23b8c66d2892ad6acbf90ed757cafab13de7 ]

When RDMA_RXE is enabled and CRYPTO is disabled, Kbuild gives the
following warning:

 WARNING: unmet direct dependencies detected for CRYPTO_CRC32
   Depends on [n]: CRYPTO [=n]
   Selected by [y]:
   - RDMA_RXE [=y] && (INFINIBAND_USER_ACCESS [=y] || !INFINIBAND_USER_ACCESS [=y]) && INET [=y] && PCI [=y] && INFINIBAND [=y] && INFINIBAND_VIRT_DMA [=y]

This is because RDMA_RXE selects CRYPTO_CRC32, without depending on or
selecting CRYPTO, despite that config option being subordinate to CRYPTO.

Fixes: cee2688e3cd6 ("IB/rxe: Offload CRC calculation when possible")
Signed-off-by: Julian Braha <julianbraha@gmail.com>
Link: https://lore.kernel.org/r/21525878.NYvzQUHefP@ubuntu-mate-laptop
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/sw/rxe/Kconfig b/drivers/infiniband/sw/rxe/Kconfig
index 452149066792..06b8dc5093f7 100644
--- a/drivers/infiniband/sw/rxe/Kconfig
+++ b/drivers/infiniband/sw/rxe/Kconfig
@@ -4,6 +4,7 @@ config RDMA_RXE
 	depends on INET && PCI && INFINIBAND
 	depends on INFINIBAND_VIRT_DMA
 	select NET_UDP_TUNNEL
+	select CRYPTO
 	select CRYPTO_CRC32
 	help
 	This driver implements the InfiniBand RDMA transport over
-- 
2.30.1



