Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AA173CE2A6
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:15:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346167AbhGSPbO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:31:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:38168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347862AbhGSPWL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:22:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 97F7D613FB;
        Mon, 19 Jul 2021 15:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710386;
        bh=jgg0uQosO6yAVi5yQtfEpZjl7nko8NRs6L7+JDAfTC4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ndYDWw1s1fxCg4YyAHUjpWpFqG/wTxyuwz10S0SQfj15Ae0R4Z0lJXABsIv8Dq5vB
         NK749pu2uer360Q91gYux4cUXWH+Zrh8H0QiiKHlqyirv9CAK0/VKcNMAAl/JCr7v+
         0VIvYILmcqlIqPLIus11DFF9Dk7ZNBQN5wenquJk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 195/243] memory: atmel-ebi: add missing of_node_put for loop iteration
Date:   Mon, 19 Jul 2021 16:53:44 +0200
Message-Id: <20210719144947.213594437@linuxfoundation.org>
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

[ Upstream commit 907c5bbb514a4676160e79764522fff56ce3448e ]

Early exits from for_each_available_child_of_node() should decrement the
node reference counter.  Reported by Coccinelle:

  drivers/memory/atmel-ebi.c:593:1-33: WARNING:
    Function "for_each_available_child_of_node" should have of_node_put() before return around line 604.

Fixes: 6a4ec4cd0888 ("memory: add Atmel EBI (External Bus Interface) driver")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Link: https://lore.kernel.org/r/20210423101815.119341-2-krzysztof.kozlowski@canonical.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/memory/atmel-ebi.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/memory/atmel-ebi.c b/drivers/memory/atmel-ebi.c
index 14386d0b5f57..c267283b01fd 100644
--- a/drivers/memory/atmel-ebi.c
+++ b/drivers/memory/atmel-ebi.c
@@ -600,8 +600,10 @@ static int atmel_ebi_probe(struct platform_device *pdev)
 				child);
 
 			ret = atmel_ebi_dev_disable(ebi, child);
-			if (ret)
+			if (ret) {
+				of_node_put(child);
 				return ret;
+			}
 		}
 	}
 
-- 
2.30.2



