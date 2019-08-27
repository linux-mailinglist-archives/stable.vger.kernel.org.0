Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96C3F9E06C
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 10:05:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732320AbfH0IDj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 04:03:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:32864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730492AbfH0IDj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 04:03:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 31477206BA;
        Tue, 27 Aug 2019 08:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566893018;
        bh=WNAYaTCm/DuIV/YTw8PphHpZoUionmMISLX3azyMnY4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hB2s1o6CldP7yDIIp80VbAjiUqwJDSqqg+3hCo1fC3soXzxqNFN6iPOTlJ3+ULGk6
         zwREovTXK0n6j+9INB9iqu6B9rRFE1/0QAaFvXe7fh/VXjBy0HF44nlE2/9EwClON/
         pODvRFTpfMGP767lIFlWfrBaiDV7EiPexpJnYwkM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 091/162] net: stmmac: tc: Do not return a fragment entry
Date:   Tue, 27 Aug 2019 09:50:19 +0200
Message-Id: <20190827072741.339002943@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190827072738.093683223@linuxfoundation.org>
References: <20190827072738.093683223@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 4a6a1385a4db5f42258a40fcd497cbfd22075968 ]

Do not try to return a fragment entry from TC list. Otherwise we may not
clean properly allocated entries.

Signed-off-by: Jose Abreu <joabreu@synopsys.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
index 58ea18af9813a..37c0bc699cd9c 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
@@ -37,7 +37,7 @@ static struct stmmac_tc_entry *tc_find_entry(struct stmmac_priv *priv,
 		entry = &priv->tc_entries[i];
 		if (!entry->in_use && !first && free)
 			first = entry;
-		if (entry->handle == loc && !free)
+		if ((entry->handle == loc) && !free && !entry->is_frag)
 			dup = entry;
 	}
 
-- 
2.20.1



