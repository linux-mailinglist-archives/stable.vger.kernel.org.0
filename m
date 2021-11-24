Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB22845BBB2
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:19:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243301AbhKXMWW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:22:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:38266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243289AbhKXMUT (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:20:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7B0C461154;
        Wed, 24 Nov 2021 12:12:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637755945;
        bh=pk0+bm9xr09aC9w5POZWfjWQfLFFWGbbOykC0qSKIGg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1rB0T3AdA1GeVF8LwlDpG55vQB2MUK3uGdI+NwWUC0wdb6vdh/L/+tTjaaG4TmA+M
         4Piutv/9BvxQgRw60EOChNKTmwygpmTpe6OhiLzhtlQ+DBubZeIBFpGenHLIJL3WMj
         9MxG017+AnNaK5E1zRoiGuJjbtfYZ+9pciOPsbVI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Junji Wei <weijunji@bytedance.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 115/207] RDMA/rxe: Fix wrong port_cap_flags
Date:   Wed, 24 Nov 2021 12:56:26 +0100
Message-Id: <20211124115707.791471875@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115703.941380739@linuxfoundation.org>
References: <20211124115703.941380739@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Junji Wei <weijunji@bytedance.com>

[ Upstream commit dcd3f985b20ffcc375f82ca0ca9f241c7025eb5e ]

The port->attr.port_cap_flags should be set to enum
ib_port_capability_mask_bits in ib_mad.h, not
RDMA_CORE_CAP_PROT_ROCE_UDP_ENCAP.

Fixes: 8700e3e7c485 ("Soft RoCE driver")
Link: https://lore.kernel.org/r/20210831083223.65797-1-weijunji@bytedance.com
Signed-off-by: Junji Wei <weijunji@bytedance.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_param.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_param.h b/drivers/infiniband/sw/rxe/rxe_param.h
index 13ed2cc6eaa2a..9f7817e12775a 100644
--- a/drivers/infiniband/sw/rxe/rxe_param.h
+++ b/drivers/infiniband/sw/rxe/rxe_param.h
@@ -144,7 +144,7 @@ enum rxe_port_param {
 	RXE_PORT_MAX_MTU		= IB_MTU_4096,
 	RXE_PORT_ACTIVE_MTU		= IB_MTU_256,
 	RXE_PORT_GID_TBL_LEN		= 1024,
-	RXE_PORT_PORT_CAP_FLAGS		= RDMA_CORE_CAP_PROT_ROCE_UDP_ENCAP,
+	RXE_PORT_PORT_CAP_FLAGS		= IB_PORT_CM_SUP,
 	RXE_PORT_MAX_MSG_SZ		= 0x800000,
 	RXE_PORT_BAD_PKEY_CNTR		= 0,
 	RXE_PORT_QKEY_VIOL_CNTR		= 0,
-- 
2.33.0



