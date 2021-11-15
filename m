Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5614450BD8
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:27:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237302AbhKORaq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:30:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:50944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237996AbhKOR2h (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:28:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F007E6328D;
        Mon, 15 Nov 2021 17:19:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636996753;
        bh=NphQaSKv/m2goQz1nJyHp7HGSwKXPYvverc5xzA8VEg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FZuEqHWmiUsMcFOFAZktUwAMGJf3XVE96R+incvYZpRQ1sXnpIeH6hl8tYCk7CvDW
         cHTGSki2nvv6K/Pp8g5+uG0EIz0ihU90MpiJaTEpRhPZu/7L9UCrlGWLBlEPoO+iL7
         7Ety3XrLezz2bpglk6fvNryZcmK5zS0zk3JnWRzY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Junji Wei <weijunji@bytedance.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 256/355] RDMA/rxe: Fix wrong port_cap_flags
Date:   Mon, 15 Nov 2021 18:03:00 +0100
Message-Id: <20211115165322.023905262@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165313.549179499@linuxfoundation.org>
References: <20211115165313.549179499@linuxfoundation.org>
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
index fe52073867006..8d3f6d93dfb8d 100644
--- a/drivers/infiniband/sw/rxe/rxe_param.h
+++ b/drivers/infiniband/sw/rxe/rxe_param.h
@@ -140,7 +140,7 @@ enum rxe_device_param {
 /* default/initial rxe port parameters */
 enum rxe_port_param {
 	RXE_PORT_GID_TBL_LEN		= 1024,
-	RXE_PORT_PORT_CAP_FLAGS		= RDMA_CORE_CAP_PROT_ROCE_UDP_ENCAP,
+	RXE_PORT_PORT_CAP_FLAGS		= IB_PORT_CM_SUP,
 	RXE_PORT_MAX_MSG_SZ		= 0x800000,
 	RXE_PORT_BAD_PKEY_CNTR		= 0,
 	RXE_PORT_QKEY_VIOL_CNTR		= 0,
-- 
2.33.0



