Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87C9B3CE2A2
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:15:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346375AbhGSPbL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:31:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:60842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347860AbhGSPWL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:22:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3317B61283;
        Mon, 19 Jul 2021 15:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710383;
        bh=O/XLNs45j5AW45fZa8ttvzotd2ITvBBHqU3XmX5lFqk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ok73/GVS8tVRL/UpZJ9aWjErtlrvFXxPZySLqk/qb608/EYoAWCnF3bZ6Ph+6BueW
         vWYcM98AeFUL0ghZwQ1zSeqZzI5F3u7xdEvc/fxjuf2XS61j+qoFoQRqcV3rUb4QlJ
         HhLKtkbjp21VKPziA5n1y4+u6asX01al0Bqr3mMA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Christophe Kerello <christophe.kerello@foss.st.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 194/243] memory: stm32-fmc2-ebi: add missing of_node_put for loop iteration
Date:   Mon, 19 Jul 2021 16:53:43 +0200
Message-Id: <20210719144947.184009442@linuxfoundation.org>
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>

[ Upstream commit 2f9dc6a357ff3b82c1e54d29fb5d52b8d4a0c587 ]

Early exits from for_each_available_child_of_node() should decrement the
node reference counter.  Reported by Coccinelle:

  drivers/memory/stm32-fmc2-ebi.c:1046:1-33: WARNING:
    Function "for_each_available_child_of_node" should have of_node_put() before return around line 1051.

Fixes: 66b8173a197f ("memory: stm32-fmc2-ebi: add STM32 FMC2 EBI controller driver")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Reviewed-by: Christophe Kerello <christophe.kerello@foss.st.com>
Link: https://lore.kernel.org/r/20210423101815.119341-1-krzysztof.kozlowski@canonical.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/memory/stm32-fmc2-ebi.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/memory/stm32-fmc2-ebi.c b/drivers/memory/stm32-fmc2-ebi.c
index 4d5758c419c5..ffec26a99313 100644
--- a/drivers/memory/stm32-fmc2-ebi.c
+++ b/drivers/memory/stm32-fmc2-ebi.c
@@ -1048,16 +1048,19 @@ static int stm32_fmc2_ebi_parse_dt(struct stm32_fmc2_ebi *ebi)
 		if (ret) {
 			dev_err(dev, "could not retrieve reg property: %d\n",
 				ret);
+			of_node_put(child);
 			return ret;
 		}
 
 		if (bank >= FMC2_MAX_BANKS) {
 			dev_err(dev, "invalid reg value: %d\n", bank);
+			of_node_put(child);
 			return -EINVAL;
 		}
 
 		if (ebi->bank_assigned & BIT(bank)) {
 			dev_err(dev, "bank already assigned: %d\n", bank);
+			of_node_put(child);
 			return -EINVAL;
 		}
 
@@ -1066,6 +1069,7 @@ static int stm32_fmc2_ebi_parse_dt(struct stm32_fmc2_ebi *ebi)
 			if (ret) {
 				dev_err(dev, "setup chip select %d failed: %d\n",
 					bank, ret);
+				of_node_put(child);
 				return ret;
 			}
 		}
-- 
2.30.2



