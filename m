Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4903E3E7EE1
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:36:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233782AbhHJRfq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:35:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:37254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233163AbhHJRey (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:34:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1918E61052;
        Tue, 10 Aug 2021 17:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628616872;
        bh=vHGvWX4mxTmTmclxM8nuR3T83WBkJ9jD6C9nT6E5PsI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fL3pwXbAxTxt+dQ1AMMs5bvpIfic9oTB94y8rRSv4Bvtn5FCUR5Cbvear08J+zpa/
         F0p9mZ9bRc3z5+iRMa+NEpHVlVSSLvh/E2jL/OHJzW2zEQrMjNQhV5qFmhtcH+Qq72
         tL4xSkbJjJ4/JdjXihSj2tzekAVfTGpnNeTN/wMw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 30/85] bnx2x: fix an error code in bnx2x_nic_load()
Date:   Tue, 10 Aug 2021 19:30:03 +0200
Message-Id: <20210810172949.222683470@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810172948.192298392@linuxfoundation.org>
References: <20210810172948.192298392@linuxfoundation.org>
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
index d10b421ed1f1..9af8afd7ae89 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
@@ -2666,7 +2666,8 @@ int bnx2x_nic_load(struct bnx2x *bp, int load_mode)
 	}
 
 	/* Allocated memory for FW statistics  */
-	if (bnx2x_alloc_fw_stats_mem(bp))
+	rc = bnx2x_alloc_fw_stats_mem(bp);
+	if (rc)
 		LOAD_ERROR_EXIT(bp, load_error0);
 
 	/* request pf to initialize status blocks */
-- 
2.30.2



