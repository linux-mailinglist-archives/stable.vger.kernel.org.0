Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17CB13CDFAA
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:54:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344129AbhGSPLI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:11:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:39054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346108AbhGSPKC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:10:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6F2AB60FED;
        Mon, 19 Jul 2021 15:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626709833;
        bh=Z6ZydqLjlMDD66kySE5xSLlnlFJ4OA8zpDyXLTtJ/IE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o47dLeVFN3sITqMtY9SNTjg8P7PxW+FhbyLw4SmQ+dcuwzw64jZWobfQTLKRXx9l6
         X6b6L/PvNpNZYsiI+mXqV9+j4n/rHoUP50poVSko2u9cAm7bRb7aVOIv2crq+HZPgQ
         RtOEcDUSlFtTGJDMtWjOQbpguqsclJUkHOyfrN8M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 116/149] reset: a10sr: add missing of_match_table reference
Date:   Mon, 19 Jul 2021 16:53:44 +0200
Message-Id: <20210719144928.880010531@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144901.370365147@linuxfoundation.org>
References: <20210719144901.370365147@linuxfoundation.org>
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



