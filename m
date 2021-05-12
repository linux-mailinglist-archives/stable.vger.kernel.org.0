Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01FE637CE9A
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:22:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345047AbhELRF6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 13:05:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:42358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236498AbhELQsH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:48:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9FE5061429;
        Wed, 12 May 2021 16:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620836133;
        bh=kL0SoY78/Ia2wiBtVrHuK92g/GpWUYRL3KVqgA3sy9Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y8NVd0omCSXJgQmKKrJXK7rfijROh3+EDi8AYdPejlCXrRr3IcqV9HPlmOXATIlPu
         UxgsCx9opJ7QFk9MRnR1Bbd1wjRGRGQzInXC1ns14oGnxLxV7PW4lF9FRvJ/8MWBTH
         7RRHBu2QtQxjh8UmWNFHBeXu9O2Lf8BGPAlJ9ylU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Frank Zago <frank.zago@hpe.com>,
        Bob Pearson <rpearson@hpe.com>,
        Zhu Yanjun <zyjzyj2000@gmail.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 623/677] RDMA/rxe: Fix a bug in rxe_fill_ip_info()
Date:   Wed, 12 May 2021 16:51:09 +0200
Message-Id: <20210512144858.061525330@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bob Pearson <rpearsonhpe@gmail.com>

[ Upstream commit 45062f441590810772959d8e1f2b24ba57ce1bd9 ]

Fix a bug in rxe_fill_ip_info() which was attempting to convert from
RDMA_NETWORK_XXX to RXE_NETWORK_XXX. .._IPV6 should have mapped to .._IPV6
not .._IPV4.

Fixes: edebc8407b88 ("RDMA/rxe: Fix small problem in network_type patch")
Link: https://lore.kernel.org/r/20210421035952.4892-1-rpearson@hpe.com
Suggested-by: Frank Zago <frank.zago@hpe.com>
Signed-off-by: Bob Pearson <rpearson@hpe.com>
Acked-by: Zhu Yanjun <zyjzyj2000@gmail.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_av.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_av.c b/drivers/infiniband/sw/rxe/rxe_av.c
index df0d173d6acb..da2e867a1ed9 100644
--- a/drivers/infiniband/sw/rxe/rxe_av.c
+++ b/drivers/infiniband/sw/rxe/rxe_av.c
@@ -88,7 +88,7 @@ void rxe_av_fill_ip_info(struct rxe_av *av, struct rdma_ah_attr *attr)
 		type = RXE_NETWORK_TYPE_IPV4;
 		break;
 	case RDMA_NETWORK_IPV6:
-		type = RXE_NETWORK_TYPE_IPV4;
+		type = RXE_NETWORK_TYPE_IPV6;
 		break;
 	default:
 		/* not reached - checked in rxe_av_chk_attr */
-- 
2.30.2



