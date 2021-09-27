Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7F91419BCA
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:20:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237046AbhI0RWU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:22:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:35212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237061AbhI0RUT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:20:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7C7E5611ED;
        Mon, 27 Sep 2021 17:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762796;
        bh=T90exyHI9aiFbgxg1WCQ98TfT19raemB/3MQnir66/Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HzweMFvq5f/5iFQ0G8yzmY+j5kxOpQIB4DArwMpMvtbB2jjths/SmWdc+RFnSZW+R
         M9hbFkgsF5e7kw0uB2T0c4MyqdNY8Z4CZZfRHZ+NCSG+P+L1Bh74lHnefSl/zO/MtM
         R+WthzjTMxv8sDURjaop9XbgcprAe8mfnXc506AA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 053/162] regulator: max14577: Revert "regulator: max14577: Add proper module aliases strings"
Date:   Mon, 27 Sep 2021 19:01:39 +0200
Message-Id: <20210927170235.332264429@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170233.453060397@linuxfoundation.org>
References: <20210927170233.453060397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>

[ Upstream commit dc9660590d106bb58d145233fffca4efadad3655 ]

This reverts commit 0da6736ecd10b45e535b100acd58df2db4c099d8.

The MODULE_DEVICE_TABLE already creates proper alias.  Having another
MODULE_ALIAS causes the alias to be duplicated:

  $ modinfo max14577-regulator.ko

  alias:          platform:max77836-regulator
  alias:          platform:max14577-regulator
  description:    Maxim 14577/77836 regulator driver
  alias:          platform:max77836-regulator
  alias:          platform:max14577-regulator

Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Fixes: 0da6736ecd10 ("regulator: max14577: Add proper module aliases strings")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Link: https://lore.kernel.org/r/20210916144102.120980-1-krzysztof.kozlowski@canonical.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/max14577-regulator.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/regulator/max14577-regulator.c b/drivers/regulator/max14577-regulator.c
index 1d78b455cc48..e34face736f4 100644
--- a/drivers/regulator/max14577-regulator.c
+++ b/drivers/regulator/max14577-regulator.c
@@ -269,5 +269,3 @@ module_exit(max14577_regulator_exit);
 MODULE_AUTHOR("Krzysztof Kozlowski <krzk@kernel.org>");
 MODULE_DESCRIPTION("Maxim 14577/77836 regulator driver");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS("platform:max14577-regulator");
-MODULE_ALIAS("platform:max77836-regulator");
-- 
2.33.0



