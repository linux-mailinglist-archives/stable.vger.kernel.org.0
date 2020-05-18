Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FA2A1D82F0
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:01:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732315AbgERSAk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 14:00:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:42328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732313AbgERSAj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 14:00:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B87AF20715;
        Mon, 18 May 2020 18:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824839;
        bh=LJUH6SI1WM2SUCEX/8syheNDQeQu0nGxG/o/Bs3whsA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y9guND0wTaEYePROwKTtPjnUmnwgV+9di3Fxlmy1HHMl7GJ7ViE4u+PLPbsR5Wf+g
         kC48NOJcqAF6P1BzHP6Ee9rf3xVpct7lp2xo4qmdeTGOc49kRAmiOZyJuc3yBN6wIB
         qQxe8nSIAGHmHGBj89fswfpQn35dvbWpxR5uKu3A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 024/194] net: stmmac: gmac5+: fix potential integer overflow on 32 bit multiply
Date:   Mon, 18 May 2020 19:35:14 +0200
Message-Id: <20200518173533.549851591@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173531.455604187@linuxfoundation.org>
References: <20200518173531.455604187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit 44d95cc6b10ff7439d45839c96c581cb4368c088 ]

The multiplication of cfg->ctr[1] by 1000000000 is performed using a
32 bit multiplication (since cfg->ctr[1] is a u32) and this can lead
to a potential overflow. Fix this by making the constant a ULL to
ensure a 64 bit multiply occurs.

Fixes: 504723af0d85 ("net: stmmac: Add basic EST support for GMAC5+")
Addresses-Coverity: ("Unintentional integer overflow")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac5.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac5.c b/drivers/net/ethernet/stmicro/stmmac/dwmac5.c
index 494c859b4ade8..67ba67ed0cb99 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac5.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac5.c
@@ -624,7 +624,7 @@ int dwmac5_est_configure(void __iomem *ioaddr, struct stmmac_est *cfg,
 		total_offset += offset;
 	}
 
-	total_ctr = cfg->ctr[0] + cfg->ctr[1] * 1000000000;
+	total_ctr = cfg->ctr[0] + cfg->ctr[1] * 1000000000ULL;
 	total_ctr += total_offset;
 
 	ctr_low = do_div(total_ctr, 1000000000);
-- 
2.20.1



