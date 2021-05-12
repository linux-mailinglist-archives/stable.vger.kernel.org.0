Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06B1E37CA81
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:54:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240559AbhELQak (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:30:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:41570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236958AbhELQXh (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:23:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7909961D9A;
        Wed, 12 May 2021 15:47:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834459;
        bh=kL0SoY78/Ia2wiBtVrHuK92g/GpWUYRL3KVqgA3sy9Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vckcxqbgLqPyL//zrrpeP1Qxz7KdMkZ+v0OH6R4WqdB1O+C5pL1cJXppoqPL1M0H6
         qjb3zjBV9h1ZTWDHhK0vIctTpiEQnjJfC3QmPpn01Q65kTgCzvftAFf4Oe2LTsFmiN
         KtCeBc/oDI6dQ7tAGAw/VByL6K2Lkaly+LVAXpEE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Frank Zago <frank.zago@hpe.com>,
        Bob Pearson <rpearson@hpe.com>,
        Zhu Yanjun <zyjzyj2000@gmail.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 551/601] RDMA/rxe: Fix a bug in rxe_fill_ip_info()
Date:   Wed, 12 May 2021 16:50:28 +0200
Message-Id: <20210512144846.005530593@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
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



