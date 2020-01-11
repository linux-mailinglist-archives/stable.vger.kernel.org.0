Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B030137F48
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:18:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730447AbgAKKSE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:18:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:35524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730389AbgAKKSA (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:18:00 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B34D2205F4;
        Sat, 11 Jan 2020 10:17:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578737880;
        bh=gM3O6dsowjunXfNirCRyt6JbHg0cuyl01rzYslnoa7w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zwm0C8cfxh7J7x9JLV7zIWoppj70cgi0crH3430pHU1ZK66nXJ1RhxW+OUzj3tsKA
         NvdYBI2tDhNtACGG7rDnfKNa2zHKvo9k3MRVxajcWArLePQ8Godc2BYQddV7tPy27f
         NKy5FJOVRckJXbBIIch/7zFZmqlhQdZR+lmZg30k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jose Abreu <Jose.Abreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 50/84] net: stmmac: RX buffer size must be 16 byte aligned
Date:   Sat, 11 Jan 2020 10:50:27 +0100
Message-Id: <20200111094905.319796851@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094845.328046411@linuxfoundation.org>
References: <20200111094845.328046411@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jose Abreu <Jose.Abreu@synopsys.com>

[ Upstream commit 8d558f0294fe92e04af192e221d0d0f6a180ee7b ]

We need to align the RX buffer size to at least 16 byte so that IP
doesn't mis-behave. This is required by HW.

Changes from v2:
- Align UP and not DOWN (David)

Fixes: 7ac6653a085b ("stmmac: Move the STMicroelectronics driver")
Signed-off-by: Jose Abreu <Jose.Abreu@synopsys.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index ec37ef7521e9..437b1b2b3e6b 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -54,7 +54,7 @@
 #include "dwxgmac2.h"
 #include "hwif.h"
 
-#define	STMMAC_ALIGN(x)		__ALIGN_KERNEL(x, SMP_CACHE_BYTES)
+#define	STMMAC_ALIGN(x)		ALIGN(ALIGN(x, SMP_CACHE_BYTES), 16)
 #define	TSO_MAX_BUFF_SIZE	(SZ_16K - 1)
 
 /* Module parameters */
-- 
2.20.1



