Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 771303CE372
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:19:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343893AbhGSPi3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:38:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:59814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348572AbhGSPf0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:35:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EAB0361874;
        Mon, 19 Jul 2021 16:14:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711249;
        bh=AKVM094S9hETqyUbQn8sr7ctprk28CH6Lm3lAlLO+U4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H+7dDrhoHm0HkAdJwtFM/KOGJQ8xCwOvaj4/lvvb09y24/+6ewwj4DA01oAPXRmd3
         BmSb+tM1Zy6MHfrow96CJzvP3MwdKHFcaiKQVdU681zvZWkTFnAOTtcXjzm/lsg621
         JDtpRJEI6z2XR9WUO9NPe/Uzy/qA7Xi6CcrDdgI4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 284/351] memory: pl353: Fix error return code in pl353_smc_probe()
Date:   Mon, 19 Jul 2021 16:53:50 +0200
Message-Id: <20210719144954.431396224@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
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
index 9c0a28416777..b0b251bb207f 100644
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



