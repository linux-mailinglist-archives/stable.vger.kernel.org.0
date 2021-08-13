Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D89BC3EB828
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 17:25:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241832AbhHMPLo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 11:11:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:53968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241845AbhHMPKz (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Aug 2021 11:10:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 811E661107;
        Fri, 13 Aug 2021 15:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628867429;
        bh=/cM930ODIGBc+l9n2RzxcsB76fg20U/lhHh9sgRFGXU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wgHkPHgjEBm/hU8hxbWGyLiONM5ncMtgSHGZDIK/NQG+GvXsByHwZ9KetaVINT8IX
         9tw4aSsIDqrSW+qKDqwK+4jAVi8ktXRLDATGzSx2FEpFB2cw+m7li3LRlmsvWh4y8k
         AMQk2D3FBkExnG1druDe4PS9A/bPSPlivkF+YmNA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 10/42] bnx2x: fix an error code in bnx2x_nic_load()
Date:   Fri, 13 Aug 2021 17:06:36 +0200
Message-Id: <20210813150525.455268596@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210813150525.098817398@linuxfoundation.org>
References: <20210813150525.098817398@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit fb653827c758725b149b5c924a5eb50ab4812750 ]

Set the error code if bnx2x_alloc_fw_stats_mem() fails.  The current
code returns success.

Fixes: ad5afc89365e ("bnx2x: Separate VF and PF logic")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
index faa45491ae4d..8c111def8185 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
@@ -2667,7 +2667,8 @@ int bnx2x_nic_load(struct bnx2x *bp, int load_mode)
 	}
 
 	/* Allocated memory for FW statistics  */
-	if (bnx2x_alloc_fw_stats_mem(bp))
+	rc = bnx2x_alloc_fw_stats_mem(bp);
+	if (rc)
 		LOAD_ERROR_EXIT(bp, load_error0);
 
 	/* request pf to initialize status blocks */
-- 
2.30.2



