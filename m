Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0E95328B9F
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:40:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240233AbhCASiJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:38:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:45030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238055AbhCAS33 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:29:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 24E9E651CE;
        Mon,  1 Mar 2021 17:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619036;
        bh=lSdULm81FyBmnlMVHd6n13mpjxnyYNdySW6NJ6C8cpE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bUaEODkD1EFtWruzWdFqzDk4jazVZENaRRfT/3G9Hf3aVlcpE5essG0LmhSOwxW5P
         FySciJH70ZzaYUMdC+Weas2EdGOwssFSR5xuVo1KTIETHOhXwItSkZknLZ1eWCcRmD
         KiUfzKFPNUo+TIat02q4cvcl4LvrmpLBbEM0wNbU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pan Bian <bianpan2016@163.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 309/663] regulator: s5m8767: Fix reference count leak
Date:   Mon,  1 Mar 2021 17:09:17 +0100
Message-Id: <20210301161157.132939231@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pan Bian <bianpan2016@163.com>

[ Upstream commit dea6dd2ba63f8c8532addb8f32daf7b89a368a42 ]

Call of_node_put() to drop references of regulators_np and reg_np before
returning error code.

Fixes: 9ae5cc75ceaa ("regulator: s5m8767: Pass descriptor instead of GPIO number")
Signed-off-by: Pan Bian <bianpan2016@163.com>
Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>
Link: https://lore.kernel.org/r/20210121032756.49501-1-bianpan2016@163.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/s5m8767.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/s5m8767.c b/drivers/regulator/s5m8767.c
index 3fa472127e9a1..48dd95b3ff45a 100644
--- a/drivers/regulator/s5m8767.c
+++ b/drivers/regulator/s5m8767.c
@@ -573,10 +573,13 @@ static int s5m8767_pmic_dt_parse_pdata(struct platform_device *pdev,
 			"s5m8767,pmic-ext-control",
 			GPIOD_OUT_HIGH | GPIOD_FLAGS_BIT_NONEXCLUSIVE,
 			"s5m8767");
-		if (PTR_ERR(rdata->ext_control_gpiod) == -ENOENT)
+		if (PTR_ERR(rdata->ext_control_gpiod) == -ENOENT) {
 			rdata->ext_control_gpiod = NULL;
-		else if (IS_ERR(rdata->ext_control_gpiod))
+		} else if (IS_ERR(rdata->ext_control_gpiod)) {
+			of_node_put(reg_np);
+			of_node_put(regulators_np);
 			return PTR_ERR(rdata->ext_control_gpiod);
+		}
 
 		rdata->id = i;
 		rdata->initdata = of_get_regulator_init_data(
-- 
2.27.0



