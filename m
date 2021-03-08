Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49B8A330DAC
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 13:32:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230250AbhCHMbf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 07:31:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:40578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230095AbhCHMbU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Mar 2021 07:31:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E76E5651CF;
        Mon,  8 Mar 2021 12:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615206679;
        bh=FRY1A+s/qi4TM+fWp6kqQdtkZylGXehG+5bJKYi8r6k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IIVkk1a8p2bgL7gfmuzeho5S2wsLhWFVwcsOwceTKCYf+Bk6XV7QgXmk44spQeN+T
         uLJ5PAM6zmbOqkKWL0G22kQeTofaLTjW4S8OT4BP/gfDZMzbiAPkacPW5QjKfXAOuc
         wHWgQq9NsckRNBosiehthRcK2oDPN63uL+2KWYI8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julian Braha <julianbraha@gmail.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 17/22] RDMA/rxe: Fix missing kconfig dependency on CRYPTO
Date:   Mon,  8 Mar 2021 13:30:34 +0100
Message-Id: <20210308122715.229099506@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210308122714.391917404@linuxfoundation.org>
References: <20210308122714.391917404@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index 71a773f607bb..0e8f1d05dfb2 100644
--- a/drivers/infiniband/sw/rxe/Kconfig
+++ b/drivers/infiniband/sw/rxe/Kconfig
@@ -4,6 +4,7 @@ config RDMA_RXE
 	depends on INET && PCI && INFINIBAND
 	depends on INFINIBAND_VIRT_DMA
 	select NET_UDP_TUNNEL
+	select CRYPTO
 	select CRYPTO_CRC32
 	select DMA_VIRT_OPS
 	---help---
-- 
2.30.1



