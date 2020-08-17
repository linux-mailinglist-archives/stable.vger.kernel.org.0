Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E05FC2476AE
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:40:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729459AbgHQTkY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 15:40:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:60764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729749AbgHQPZp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:25:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3BA5023A5E;
        Mon, 17 Aug 2020 15:25:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597677944;
        bh=U7cUe149+oKVFDMQFypevGk4UfBFfRVuFM0ffKU6T4A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0nc6hRVp9tQI6kPeiUpTFn0g9vTpkU7tLF6U8TNE64DbRwu8PkesXphi7GeP89I39
         95Uwe8gLM7iVg5slutVWaKqTjHL7e4qvdY7CY5d0ozPunNuqin3+mOC5gdK9RB1ezE
         XsFVA2sNzPn+p0pUgG4EWBVRV4/QsgCX41+faOFk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>, Florian Fainelli <f.fainelli@gmail.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 165/464] clk: bcm63xx-gate: fix last clock availability
Date:   Mon, 17 Aug 2020 17:11:58 +0200
Message-Id: <20200817143841.716670759@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Álvaro Fernández Rojas <noltari@gmail.com>

[ Upstream commit cf8030d7035bd3e89c9e66f7193a7fc8057a9b9a ]

In order to make the last clock available, maxbit has to be set to the
highest bit value plus 1.

Fixes: 1c099779c1e2 ("clk: add BCM63XX gated clock controller driver")
Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>
Link: https://lore.kernel.org/r/20200609110846.4029620-1-noltari@gmail.com
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/bcm/clk-bcm63xx-gate.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/bcm/clk-bcm63xx-gate.c b/drivers/clk/bcm/clk-bcm63xx-gate.c
index 98e884957db87..911a29bd744ef 100644
--- a/drivers/clk/bcm/clk-bcm63xx-gate.c
+++ b/drivers/clk/bcm/clk-bcm63xx-gate.c
@@ -155,6 +155,7 @@ static int clk_bcm63xx_probe(struct platform_device *pdev)
 
 	for (entry = table; entry->name; entry++)
 		maxbit = max_t(u8, maxbit, entry->bit);
+	maxbit++;
 
 	hw = devm_kzalloc(&pdev->dev, struct_size(hw, data.hws, maxbit),
 			  GFP_KERNEL);
-- 
2.25.1



