Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C90B333E9D
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 14:36:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233670AbhCJN01 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 08:26:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:48260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233337AbhCJNZY (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Mar 2021 08:25:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 50B3164FFB;
        Wed, 10 Mar 2021 13:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615382722;
        bh=m9ikSDjxS0/DHXNlAIK+OXpht2KBs3JnAENiSljRLZc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p5t9sE1pMCH1SCy/9R0JCymqVbLunU+L5ZSiwFSJGm/DHzW8XDdSmPyaRgER+XTtN
         JET6UHE36btbUPivj5loy8RMmMuA9fGh2fD74prYlnxeigJVCwP2Qp+vkJ6I2R+Qme
         fW9FxIiSqL7To65dCecev+/2gjc8OhfnVIoRh4wE=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julian Braha <julianbraha@gmail.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 17/39] RDMA/rxe: Fix missing kconfig dependency on CRYPTO
Date:   Wed, 10 Mar 2021 14:24:25 +0100
Message-Id: <20210310132320.268513994@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210310132319.708237392@linuxfoundation.org>
References: <20210310132319.708237392@linuxfoundation.org>
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
index 67ae960ab523..1fa19a77583e 100644
--- a/drivers/infiniband/sw/rxe/Kconfig
+++ b/drivers/infiniband/sw/rxe/Kconfig
@@ -3,6 +3,7 @@ config RDMA_RXE
 	depends on INET && PCI && INFINIBAND
 	depends on !64BIT || ARCH_DMA_ADDR_T_64BIT
 	select NET_UDP_TUNNEL
+	select CRYPTO
 	select CRYPTO_CRC32
 	select DMA_VIRT_OPS
 	---help---
-- 
2.30.1



