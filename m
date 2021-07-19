Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C03333CE175
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:11:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346886AbhGSP0K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:26:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:38042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347848AbhGSPWF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:22:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E0A0961006;
        Mon, 19 Jul 2021 15:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710371;
        bh=Z6ZydqLjlMDD66kySE5xSLlnlFJ4OA8zpDyXLTtJ/IE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P/oTsHBj36S2H6fIdjctm2eRoWABDayCM40CywRYM1wDZuyf1LRgRdKOdNi5r21US
         v55aVxrDZZ1DmTzgP5eRDmZn6UIe/pgkIizj6XrLJf3dJZmuGWEBTzZKYbs3DqonkX
         JKjN4oxHLuuv73hVZ922aWduwdzYaQlYcumgeqdM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 189/243] reset: a10sr: add missing of_match_table reference
Date:   Mon, 19 Jul 2021 16:53:38 +0200
Message-Id: <20210719144947.021197330@linuxfoundation.org>
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

[ Upstream commit 466ba3c8ff4fae39e455ff8d080b3d5503302765 ]

The driver defined of_device_id table but did not use it with
of_match_table.  This prevents usual matching via devicetree and causes
a W=1 warning:

  drivers/reset/reset-a10sr.c:111:34: warning:
    ‘a10sr_reset_of_match’ defined but not used [-Wunused-const-variable=]

Reported-by: kernel test robot <lkp@intel.com>
Fixes: 627006820268 ("reset: Add Altera Arria10 SR Reset Controller")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Link: https://lore.kernel.org/r/20210507112803.20012-1-krzysztof.kozlowski@canonical.com
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/reset/reset-a10sr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/reset/reset-a10sr.c b/drivers/reset/reset-a10sr.c
index 7eacc89382f8..99b3bc8382f3 100644
--- a/drivers/reset/reset-a10sr.c
+++ b/drivers/reset/reset-a10sr.c
@@ -118,6 +118,7 @@ static struct platform_driver a10sr_reset_driver = {
 	.probe	= a10sr_reset_probe,
 	.driver = {
 		.name		= "altr_a10sr_reset",
+		.of_match_table	= a10sr_reset_of_match,
 	},
 };
 module_platform_driver(a10sr_reset_driver);
-- 
2.30.2



