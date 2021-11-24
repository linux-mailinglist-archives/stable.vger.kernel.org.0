Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25E3645BE06
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:41:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242607AbhKXMo3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:44:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:39824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344386AbhKXMkc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:40:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 64761613A9;
        Wed, 24 Nov 2021 12:24:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637756647;
        bh=d1pXj2UfwnV2m168qKxYbt6ilSFVtPpljdoweFwSOEQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JcKd8L/zHTc7nULvm21UQMpChJnKU3ZdnybQc2TgEtgdiB5ZO63MiOTXW1lpSg3pE
         q4Xz3P6JZAdwfF3UiGCNBlI67qOw8osW2nO+8jsaqTHbbIml/h3vuc33jC2O0PCjzY
         W+3kZJntXuuDEaFyn8UIWqUe7D3oVyopeIQLd+a8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Junji Wei <weijunji@bytedance.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 139/251] RDMA/rxe: Fix wrong port_cap_flags
Date:   Wed, 24 Nov 2021 12:56:21 +0100
Message-Id: <20211124115715.094979485@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115710.214900256@linuxfoundation.org>
References: <20211124115710.214900256@linuxfoundation.org>
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
index 1b596fbbe2516..77ac3fa756c25 100644
--- a/drivers/infiniband/sw/rxe/rxe_param.h
+++ b/drivers/infiniband/sw/rxe/rxe_param.h
@@ -143,7 +143,7 @@ enum rxe_port_param {
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



