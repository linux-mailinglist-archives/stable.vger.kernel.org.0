Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCD1D3C525E
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:50:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345973AbhGLHpj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:45:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:53604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343960AbhGLHnp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:43:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 079ED613CF;
        Mon, 12 Jul 2021 07:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075645;
        bh=BlDMvOZUfrvRU1LGEpsj7FcuDDoEgz3/1UaWFB0IlHQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dDZwNd9Vnu5vCvpWCfeo7EIcqxhCMLqjaK3s8L++LKOoIq0iBqO/l+LZiDGKfLFFV
         YAAtvlO4V5we1h1Y8Ba7Rb7sOJ96fiBr7NEUIQLmQ2HAUvKkH4oAOXkc1ZIp8rcyaW
         kYH8rczsLtDYArj/CJENBZKY79Dpn9bcZ3cW9Oqo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Axel Lin <axel.lin@ingics.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 304/800] regulator: fan53555: Fix missing slew_reg/mask/shift settings for FAN53526
Date:   Mon, 12 Jul 2021 08:05:27 +0200
Message-Id: <20210712060957.702607758@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Axel Lin <axel.lin@ingics.com>

[ Upstream commit 30b38b805b36c03db3703ef62397111c783b5f3b ]

The di->slew_reg/di->slew_mask/di->slew_shift was not set in current code,
fix it.

Fixes: f2a9eb975ab2 ("regulator: fan53555: Add support for FAN53526")
Signed-off-by: Axel Lin <axel.lin@ingics.com>
Link: https://lore.kernel.org/r/20210525124017.2550029-1-axel.lin@ingics.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/fan53555.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/regulator/fan53555.c b/drivers/regulator/fan53555.c
index 26f06f685b1b..b2ee38c5b573 100644
--- a/drivers/regulator/fan53555.c
+++ b/drivers/regulator/fan53555.c
@@ -293,6 +293,9 @@ static int fan53526_voltages_setup_fairchild(struct fan53555_device_info *di)
 		return -EINVAL;
 	}
 
+	di->slew_reg = FAN53555_CONTROL;
+	di->slew_mask = CTL_SLEW_MASK;
+	di->slew_shift = CTL_SLEW_SHIFT;
 	di->vsel_count = FAN53526_NVOLTAGES;
 
 	return 0;
-- 
2.30.2



