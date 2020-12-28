Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC0EA2E419C
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:10:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439588AbgL1PJP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:09:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:41626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438534AbgL1OHs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:07:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B6F18208B3;
        Mon, 28 Dec 2020 14:07:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164453;
        bh=B2qHW1c5dBIgnhi9gKVKLwS1LDNb43qomXavs767EDk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wJDjppGmRP1n6NO9TK+y9zKwkmPc2H1mRBVWqOD4kCFa9y1SQOUM37zu9/p/qYj/o
         cz5p1501Vmm9LzFJUUewixIC1Wda7lZ9VaJlr6m809t4eKCzbBAZpWOBpocTqJPfTQ
         hBiMj2NC942qrW6f6GJlrr/JHM6Rmfawtjwqoy38=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wang Hai <wanghai38@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 186/717] staging: mfd: hi6421-spmi-pmic: fix error return code in hi6421_spmi_pmic_probe()
Date:   Mon, 28 Dec 2020 13:43:04 +0100
Message-Id: <20201228125029.882112918@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wang Hai <wanghai38@huawei.com>

[ Upstream commit ba3e4a2a0b3c639d3835f2f1dce27d79576ae453 ]

Fix to return a negative error code from the error handling
case instead of 0, as done elsewhere in this function.

Fixes: 4524ac56cdca ("staging: mfd: add a PMIC driver for HiSilicon 6421 SPMI version")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Hai <wanghai38@huawei.com>
Link: https://lore.kernel.org/r/20201118103724.57451-1-wanghai38@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/hikey9xx/hi6421-spmi-pmic.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/hikey9xx/hi6421-spmi-pmic.c b/drivers/staging/hikey9xx/hi6421-spmi-pmic.c
index 64b30d263c8d0..4f34a52829700 100644
--- a/drivers/staging/hikey9xx/hi6421-spmi-pmic.c
+++ b/drivers/staging/hikey9xx/hi6421-spmi-pmic.c
@@ -262,8 +262,10 @@ static int hi6421_spmi_pmic_probe(struct spmi_device *pdev)
 	hi6421_spmi_pmic_irq_prc(pmic);
 
 	pmic->irqs = devm_kzalloc(dev, HISI_IRQ_NUM * sizeof(int), GFP_KERNEL);
-	if (!pmic->irqs)
+	if (!pmic->irqs) {
+		ret = -ENOMEM;
 		goto irq_malloc;
+	}
 
 	pmic->domain = irq_domain_add_simple(np, HISI_IRQ_NUM, 0,
 					     &hi6421_spmi_domain_ops, pmic);
-- 
2.27.0



