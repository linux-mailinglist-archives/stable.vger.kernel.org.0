Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F6B632889C
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:45:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238624AbhCARnL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:43:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:58248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236964AbhCARfp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:35:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DA8B564FB9;
        Mon,  1 Mar 2021 16:54:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617669;
        bh=gMS6a/ynYfkSrxA++p0MG3lvxj6gvIPafaiMJV+SRJ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uk4YRBnpM2FfcZ8c53XnxGlDwoigVcBajIQy68Y/QgnbELKWmEeIDHbtvjH+DfUSH
         ftK+EQM6djBjErzYwPR7YYtzB2udc4B6f4q0lAAaSajT3N9rc0QFpCCcCJS+yk5EvB
         5Qq5LoIasgxHUGHB4sBWF2USawud6xnRJgl/eQfI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pan Bian <bianpan2016@163.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 154/340] regulator: s5m8767: Fix reference count leak
Date:   Mon,  1 Mar 2021 17:11:38 +0100
Message-Id: <20210301161055.894725301@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161048.294656001@linuxfoundation.org>
References: <20210301161048.294656001@linuxfoundation.org>
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
index 6ca27e9d5ef7d..ee0ed538e244f 100644
--- a/drivers/regulator/s5m8767.c
+++ b/drivers/regulator/s5m8767.c
@@ -574,10 +574,13 @@ static int s5m8767_pmic_dt_parse_pdata(struct platform_device *pdev,
 			0,
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



