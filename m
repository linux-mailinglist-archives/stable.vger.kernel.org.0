Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D132533BA3D
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:10:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235231AbhCOOIj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:08:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:49380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234082AbhCOOCy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:02:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1FF7A64EEF;
        Mon, 15 Mar 2021 14:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816974;
        bh=Q1YXNqEzfzI1SCGqkqq9bYqxLhmTCfcq65w/M53JeGw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B0TsvwsUDVxUNi9az0QJmpW+fNF/c4WaT9CmEJv3q8jHkKarNbuCF3PriyTuANFvc
         94h+6F9oedqzDP7nBZdo2Uf5vCQYeDeLX/onIal4t5yJ0g81CE1QMk7AGPuS0LHLfi
         CdbD/RIcrCZ9DUvz4Qp11LkwfMJAtK365Bk+LjUM=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 239/306] sh_eth: fix TRSCER mask for R7S72100
Date:   Mon, 15 Mar 2021 14:55:02 +0100
Message-Id: <20210315135515.721541218@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Sergey Shtylyov <s.shtylyov@omprussia.ru>

[ Upstream commit 75be7fb7f978202c4c3a1a713af4485afb2ff5f6 ]

According  to  the RZ/A1H Group, RZ/A1M Group User's Manual: Hardware,
Rev. 4.00, the TRSCER register has bit 9 reserved, hence we can't use
the driver's default TRSCER mask.  Add the explicit initializer for
sh_eth_cpu_data::trscer_err_mask for R7S72100.

Fixes: db893473d313 ("sh_eth: Add support for r7s72100")
Signed-off-by: Sergey Shtylyov <s.shtylyov@omprussia.ru>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/renesas/sh_eth.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/renesas/sh_eth.c b/drivers/net/ethernet/renesas/sh_eth.c
index 1dfecfd938cf..f029c7c03804 100644
--- a/drivers/net/ethernet/renesas/sh_eth.c
+++ b/drivers/net/ethernet/renesas/sh_eth.c
@@ -560,6 +560,8 @@ static struct sh_eth_cpu_data r7s72100_data = {
 			  EESR_TDE,
 	.fdr_value	= 0x0000070f,
 
+	.trscer_err_mask = DESC_I_RINT8 | DESC_I_RINT5,
+
 	.no_psr		= 1,
 	.apr		= 1,
 	.mpr		= 1,
-- 
2.30.1



