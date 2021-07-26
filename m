Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 337CD3D61D4
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:14:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233905AbhGZPdE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:33:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:47148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231857AbhGZPbL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:31:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A578C6056B;
        Mon, 26 Jul 2021 16:11:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315892;
        bh=Cl5oLDt5QMIGemzODAKQT4rc3eoK/WI4qT8fbR7l+4s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s0GbID4qcRaqXBgDBvzInIc1YzbZXudYrmlZdg/0Q5NclkRyTjM6VDxjMoY8uZve5
         JLrLtU1v+Km/1ReiFFnPP9bKiYIcrhcnt1Nxt+OXaNpzUdWwuc/2QkYzOowmmCb987
         0XeG/1pAUARmRaFaU41Exl8ZMa201UpZDTkR0Wmg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Schwalm <maxim.schwalm@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 072/223] ASoC: rt5631: Fix regcache sync errors on resume
Date:   Mon, 26 Jul 2021 17:37:44 +0200
Message-Id: <20210726153848.614390996@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153846.245305071@linuxfoundation.org>
References: <20210726153846.245305071@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxim Schwalm <maxim.schwalm@gmail.com>

[ Upstream commit c71f78a662611fe2c67f3155da19b0eff0f29762 ]

The ALC5631 does not like multi-write accesses, avoid them. This fixes:

rt5631 4-001a: Unable to sync registers 0x3a-0x3c. -121

errors on resume from suspend (and all registers after the registers in
the error not being synced).

Inspired by commit 2d30e9494f1e ("ASoC: rt5651: Fix regcache sync errors
on resume") from Hans de Geode, which fixed the same errors on ALC5651.

Signed-off-by: Maxim Schwalm <maxim.schwalm@gmail.com>
Link: https://lore.kernel.org/r/20210712005011.28536-1-digetx@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt5631.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/codecs/rt5631.c b/sound/soc/codecs/rt5631.c
index 3000bc128b5b..38356ea2bd6e 100644
--- a/sound/soc/codecs/rt5631.c
+++ b/sound/soc/codecs/rt5631.c
@@ -1695,6 +1695,8 @@ static const struct regmap_config rt5631_regmap_config = {
 	.reg_defaults = rt5631_reg,
 	.num_reg_defaults = ARRAY_SIZE(rt5631_reg),
 	.cache_type = REGCACHE_RBTREE,
+	.use_single_read = true,
+	.use_single_write = true,
 };
 
 static int rt5631_i2c_probe(struct i2c_client *i2c,
-- 
2.30.2



