Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 466473EB80B
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 17:25:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241650AbhHMPKp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 11:10:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:53720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241652AbhHMPKY (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Aug 2021 11:10:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D40266113B;
        Fri, 13 Aug 2021 15:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628867396;
        bh=8Kq8PJidGV/fZmYd7B9fuwje5htBYajQc3q9hhqLjMY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vSKdWce/H+Zqvv0VGDbMBngzyHavyJc/YQrk/5iZ1O69l0JcGrYGoR0bukfZ0Wm6l
         XzCdukxaJ4NaujFG73C/vO4Ah2we8xmXiLG0I9cmFKIPfSaJ/ikqea3kq6xECWpyDR
         bk6kJMq8xwfLBXRVzrZo+i330ERBfcj2vnz0mEn8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 06/30] bnx2x: fix an error code in bnx2x_nic_load()
Date:   Fri, 13 Aug 2021 17:06:34 +0200
Message-Id: <20210813150522.652304555@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210813150522.445553924@linuxfoundation.org>
References: <20210813150522.445553924@linuxfoundation.org>
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
index 46a7dcf2ff4a..9d7f491931ce 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
@@ -2672,7 +2672,8 @@ int bnx2x_nic_load(struct bnx2x *bp, int load_mode)
 	}
 
 	/* Allocated memory for FW statistics  */
-	if (bnx2x_alloc_fw_stats_mem(bp))
+	rc = bnx2x_alloc_fw_stats_mem(bp);
+	if (rc)
 		LOAD_ERROR_EXIT(bp, load_error0);
 
 	/* request pf to initialize status blocks */
-- 
2.30.2



