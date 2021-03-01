Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6974328B83
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:39:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239874AbhCASgV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:36:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:43170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240020AbhCAS2Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:28:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 637296534F;
        Mon,  1 Mar 2021 17:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620705;
        bh=GvD+pCt/CIV3sJKGMWi1Duu9EOg35dH4ZvSVMHmzIDk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WEL36D3X4jpQ+blqcBExuMj75FPp1Ymm71zXQFxBZPez1L67ca0IPGo5d3Dh8J2rV
         LQ9N7DJDU92rXZitFuXXmt6I7peebFvfhFGAZB2q61HUmYVkmPeizepH7NJtjhFp+D
         4/OjBz52Z9kkGuNf0r6ElT8Ikflrq6f3t0R5isPk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 250/775] ASoC: codecs: add missing max_register in regmap config
Date:   Mon,  1 Mar 2021 17:06:58 +0100
Message-Id: <20210301161213.984896645@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

[ Upstream commit e8820dbddbcad7e91daacf7d42a49d1d04a4e489 ]

For some reason setting max_register was missed from regmap_config.
Without this cat /sys/kernel/debug/regmap/sdw:0:217:2010:0:1/range
actually throws below Warning.

WARNING: CPU: 7 PID: 540 at drivers/base/regmap/regmap-debugfs.c:160
 regmap_debugfs_get_dump_start.part.10+0x1e0/0x220
...
Call trace:
 regmap_debugfs_get_dump_start.part.10+0x1e0/0x220
 regmap_reg_ranges_read_file+0xc0/0x2e0
 full_proxy_read+0x64/0x98
 vfs_read+0xa8/0x1e0
 ksys_read+0x6c/0x100
 __arm64_sys_read+0x1c/0x28
 el0_svc_common.constprop.3+0x6c/0x190
 do_el0_svc+0x24/0x90
 el0_svc+0x14/0x20
 el0_sync_handler+0x90/0xb8
 el0_sync+0x158/0x180
...

Fixes: a0aab9e1404a ("ASoC: codecs: add wsa881x amplifier support")
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20210201161429.28060-1-srinivas.kandagatla@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wsa881x.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/codecs/wsa881x.c b/sound/soc/codecs/wsa881x.c
index 4530b74f5921b..db87e07b11c94 100644
--- a/sound/soc/codecs/wsa881x.c
+++ b/sound/soc/codecs/wsa881x.c
@@ -640,6 +640,7 @@ static struct regmap_config wsa881x_regmap_config = {
 	.val_bits = 8,
 	.cache_type = REGCACHE_RBTREE,
 	.reg_defaults = wsa881x_defaults,
+	.max_register = WSA881X_SPKR_STATUS3,
 	.num_reg_defaults = ARRAY_SIZE(wsa881x_defaults),
 	.volatile_reg = wsa881x_volatile_register,
 	.readable_reg = wsa881x_readable_register,
-- 
2.27.0



