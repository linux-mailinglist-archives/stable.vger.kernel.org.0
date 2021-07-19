Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D46213CE17A
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:11:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347027AbhGSP0N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:26:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:38166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347858AbhGSPWK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:22:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C9ED613AE;
        Mon, 19 Jul 2021 15:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710391;
        bh=nXyHw/DQ+3MHnoET8dBcqqnuoyNIonAdyS8lNG25KEU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jZJyOQ0wyzZ+LKIx6TERvItNk8rs6qA4Lw8JIKBLmeYgkvzLPb8UH0xRKnNprwphj
         pHHZPviKd2kT9mfqbAwtXmBzE1k7M7wpUtbxksR8/niwUwfEA1unXNeke8QfQKwcXM
         R5crBx3BT7cwyLub+dYdT7LAHEvyblwF9or66ICg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 197/243] memory: pl353: Fix error return code in pl353_smc_probe()
Date:   Mon, 19 Jul 2021 16:53:46 +0200
Message-Id: <20210719144947.288786629@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.904087935@linuxfoundation.org>
References: <20210719144940.904087935@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhen Lei <thunder.leizhen@huawei.com>

[ Upstream commit 76e5624f3f9343a621dd3f4006f4e4d9c3f91e33 ]

When no child nodes are matched, an appropriate error code -ENODEV should
be returned. However, we currently do not explicitly assign this error
code to 'err'. As a result, 0 was incorrectly returned.

Fixes: fee10bd22678 ("memory: pl353: Add driver for arm pl353 static memory controller")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Link: https://lore.kernel.org/r/20210515040004.6983-1-thunder.leizhen@huawei.com
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/memory/pl353-smc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/memory/pl353-smc.c b/drivers/memory/pl353-smc.c
index b42804b1801e..cc01979780d8 100644
--- a/drivers/memory/pl353-smc.c
+++ b/drivers/memory/pl353-smc.c
@@ -407,6 +407,7 @@ static int pl353_smc_probe(struct amba_device *adev, const struct amba_id *id)
 		break;
 	}
 	if (!match) {
+		err = -ENODEV;
 		dev_err(&adev->dev, "no matching children\n");
 		goto out_clk_disable;
 	}
-- 
2.30.2



