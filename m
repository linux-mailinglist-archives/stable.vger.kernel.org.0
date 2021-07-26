Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ECFC3D6050
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:10:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237213AbhGZPVs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:21:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:35992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237209AbhGZPVn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:21:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF2C660E09;
        Mon, 26 Jul 2021 16:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315331;
        bh=q0VMxnM0zP+6GtCK0Os6yDk2JT9hLndLBpZYmsFvwXw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sn9vtzwQyrooch5UAsg3pEf+g54nwcLXgrwl0R3aiw3GjiZ//6lti7mIAZ3PfTjv8
         bn2vKh4ki1XHH6KXqOsVnnpR2cca1skTj6Nk8uHC9/lxZKDlPfo0QLn4tII1czueC4
         KB1GH4gzo0gYXiSiA2ru3ED6MwtN52j7f+7PCaso=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Schwalm <maxim.schwalm@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 054/167] ASoC: rt5631: Fix regcache sync errors on resume
Date:   Mon, 26 Jul 2021 17:38:07 +0200
Message-Id: <20210726153841.231051282@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153839.371771838@linuxfoundation.org>
References: <20210726153839.371771838@linuxfoundation.org>
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
index 653da3eaf355..86d58d0df057 100644
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



