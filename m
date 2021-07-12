Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C46093C4904
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:31:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238644AbhGLGlj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:41:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:34600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238423AbhGLGkM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:40:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EFEEE6112D;
        Mon, 12 Jul 2021 06:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071837;
        bh=TYvHY0Nd+78uOboMF2XfNFz13DUaUYEErLtDj5rRiI0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qx5LIvknVunR1frBCCGivC7NbXQND4vTUkso/YAM6isreolhesk0XJn3eeZbwu1jh
         p7JOhaymhrezORJL6GprbQ4v3+/8Njtqh8QHRUMv4UT56c6qrvvoxIWANf39SJPBS7
         3gyUExAaUEtdyp1CZ7ylSK0Hs1vcX+dqwtxsqHIE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Axel Lin <axel.lin@ingics.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 239/593] regulator: fan53880: Fix vsel_mask setting for FAN53880_BUCK
Date:   Mon, 12 Jul 2021 08:06:39 +0200
Message-Id: <20210712060909.182577776@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Axel Lin <axel.lin@ingics.com>

[ Upstream commit 2e11737a772b95c6587df73f216eec1762431432 ]

According to the datasheet:
REGISTER DETAILS − 0x02 BUCK, BUCK_OUT is BIT0 ~ BIT7.

So vsel_mask for FAN53880_BUCK should be 0xFF.

Fixes: e6dea51e2d41 ("regulator: fan53880: Add initial support")
Signed-off-by: Axel Lin <axel.lin@ingics.com>
Link: https://lore.kernel.org/r/20210607142907.1599905-1-axel.lin@ingics.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/fan53880.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/fan53880.c b/drivers/regulator/fan53880.c
index 1684faf82ed2..94f02f3099dd 100644
--- a/drivers/regulator/fan53880.c
+++ b/drivers/regulator/fan53880.c
@@ -79,7 +79,7 @@ static const struct regulator_desc fan53880_regulators[] = {
 		.n_linear_ranges = 2,
 		.n_voltages =	   0xf8,
 		.vsel_reg =	   FAN53880_BUCKVOUT,
-		.vsel_mask =	   0x7f,
+		.vsel_mask =	   0xff,
 		.enable_reg =	   FAN53880_ENABLE,
 		.enable_mask =	   0x10,
 		.enable_time =	   480,
-- 
2.30.2



