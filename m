Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49E2F3C4F95
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:44:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243765AbhGLH01 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:26:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:34614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343885AbhGLHYX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:24:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C65C5613EB;
        Mon, 12 Jul 2021 07:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074483;
        bh=pjgfzuIKSAXErgEX1VxWWkwHk0mgV0KIJDJUBjsg+lQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sY0RBjOrQTpJTWzmyaO1jlQGeREbKRkKYJ0GJt2aI530M/ziL5lUlQwaAdf9YVGXE
         2hYbU54KTrnVlo3KdjP0OwXh/E6Xa11CiKJ5wOzJVV+swiaLtjrXUaO+6DHcIKiLA3
         F8wRqpBt6kpvQtXSaZ1S+eNwARhmRRXwgBfpjnIc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>,
        Bard Liao <bard.liao@intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 596/700] ASoC: max98373-sdw: add missing memory allocation check
Date:   Mon, 12 Jul 2021 08:11:19 +0200
Message-Id: <20210712061039.359226556@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit 468a272ca49cc4e2f58f3c360643c3f6d313c146 ]

We forgot to test that devm_kcalloc doesn't return NULL.

Fixes: 349dd23931d1 ('ASoC: max98373: don't access volatile registers in bias level off')
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
Reviewed-by: Bard Liao <bard.liao@intel.com>
Link: https://lore.kernel.org/r/20210607222239.582139-2-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/max98373-sdw.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/codecs/max98373-sdw.c b/sound/soc/codecs/max98373-sdw.c
index f3a12205cd48..c7a3506046db 100644
--- a/sound/soc/codecs/max98373-sdw.c
+++ b/sound/soc/codecs/max98373-sdw.c
@@ -787,6 +787,8 @@ static int max98373_init(struct sdw_slave *slave, struct regmap *regmap)
 	max98373->cache = devm_kcalloc(dev, max98373->cache_num,
 				       sizeof(*max98373->cache),
 				       GFP_KERNEL);
+	if (!max98373->cache)
+		return -ENOMEM;
 
 	for (i = 0; i < max98373->cache_num; i++)
 		max98373->cache[i].reg = max98373_sdw_cache_reg[i];
-- 
2.30.2



