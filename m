Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A81D3AF052
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:45:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230329AbhFUQsD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:48:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:37574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234019AbhFUQp7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:45:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D624461410;
        Mon, 21 Jun 2021 16:33:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624293184;
        bh=DwaduLBUarpPFjUZGNZPYa6zqcD6k3NaZkMshJsPlpA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z7qaSJgD1nip61lIiNmBREGd+lFEzrYM0tT3h00y75eHRpw6aIdN69Pzkgejm8mY8
         d1wbe1sSKPKu1ZFmtaySaCxmFvsDhRk2MPfiEX5SCDdIGg8Mqh2oVbkljBJtL6py2g
         IXXnXOCiYdyWEeVBswy4GjOgQkUNVdM5S0LcK11E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, ChiYuan Huang <cy_huang@richtek.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 096/178] regulator: rtmv20: Fix to make regcache value first reading back from HW
Date:   Mon, 21 Jun 2021 18:15:10 +0200
Message-Id: <20210621154926.019075024@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154921.212599475@linuxfoundation.org>
References: <20210621154921.212599475@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: ChiYuan Huang <cy_huang@richtek.com>

[ Upstream commit 46639a5e684edd0b80ae9dff220f193feb356277 ]

- Fix to make regcache value first reading back from HW.

Signed-off-by: ChiYuan Huang <cy_huang@richtek.com>
Link: https://lore.kernel.org/r/1622542155-6373-1-git-send-email-u0084500@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/rtmv20-regulator.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/regulator/rtmv20-regulator.c b/drivers/regulator/rtmv20-regulator.c
index 5adc552dffd5..4bca64de0f67 100644
--- a/drivers/regulator/rtmv20-regulator.c
+++ b/drivers/regulator/rtmv20-regulator.c
@@ -27,6 +27,7 @@
 #define RTMV20_REG_LDIRQ	0x30
 #define RTMV20_REG_LDSTAT	0x40
 #define RTMV20_REG_LDMASK	0x50
+#define RTMV20_MAX_REGS		(RTMV20_REG_LDMASK + 1)
 
 #define RTMV20_VID_MASK		GENMASK(7, 4)
 #define RICHTEK_VID		0x80
@@ -313,6 +314,7 @@ static const struct regmap_config rtmv20_regmap_config = {
 	.val_bits = 8,
 	.cache_type = REGCACHE_RBTREE,
 	.max_register = RTMV20_REG_LDMASK,
+	.num_reg_defaults_raw = RTMV20_MAX_REGS,
 
 	.writeable_reg = rtmv20_is_accessible_reg,
 	.readable_reg = rtmv20_is_accessible_reg,
-- 
2.30.2



