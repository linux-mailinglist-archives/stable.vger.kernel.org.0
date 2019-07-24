Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31E7274684
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 07:53:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727507AbfGYFwh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 01:52:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:54692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404307AbfGYFkO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Jul 2019 01:40:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3F5F922BEF;
        Thu, 25 Jul 2019 05:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564033213;
        bh=OMIEmC5y38l87lwjmF+MWWlsfb57JJMC0HeRUrSKT10=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QAsjqo8wikRgFcSzVptP3S1cVnydOZyJePR9dmnaOUHeEqTtJB0xRHWEtW01EoYSG
         KxutNy4NcxgT4KluglhskNBSsW8zTlM8Nb/hqQk44zhwsHfDyJ3cfe/Nwn65E9FGDY
         TnjUL1BEAi7AruMJOnyozWrkVnM98UGp7W2u0nH0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Winkowski <walan@marvell.com>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 132/271] net: mvpp2: prs: Dont override the sign bit in SRAM parser shift
Date:   Wed, 24 Jul 2019 21:20:01 +0200
Message-Id: <20190724191706.545925787@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191655.268628197@linuxfoundation.org>
References: <20190724191655.268628197@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 8ec3ede559956f8ad58db7b57d25ac724bab69e9 ]

The Header Parser allows identifying various fields in the packet
headers, used for various kind of filtering and classification
steps.

This is a re-entrant process, where the offset in the packet header
depends on the previous lookup results. This offset is represented in
the SRAM results of the TCAM, as a shift to be operated.

This shift can be negative in some cases, such as in IPv6 parsing.

This commit prevents overriding the sign bit when setting the shift
value, which could cause instabilities when parsing IPv6 flows.

Fixes: 3f518509dedc ("ethernet: Add new driver for Marvell Armada 375 network unit")
Suggested-by: Alan Winkowski <walan@marvell.com>
Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c
index ae2240074d8e..5692c6087bbb 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c
@@ -312,7 +312,8 @@ static void mvpp2_prs_sram_shift_set(struct mvpp2_prs_entry *pe, int shift,
 	}
 
 	/* Set value */
-	pe->sram[MVPP2_BIT_TO_WORD(MVPP2_PRS_SRAM_SHIFT_OFFS)] = shift & MVPP2_PRS_SRAM_SHIFT_MASK;
+	pe->sram[MVPP2_BIT_TO_WORD(MVPP2_PRS_SRAM_SHIFT_OFFS)] |=
+		shift & MVPP2_PRS_SRAM_SHIFT_MASK;
 
 	/* Reset and set operation */
 	mvpp2_prs_sram_bits_clear(pe, MVPP2_PRS_SRAM_OP_SEL_SHIFT_OFFS,
-- 
2.20.1



