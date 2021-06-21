Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29B1A3AF05C
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:46:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232888AbhFUQs0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:48:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:37760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231293AbhFUQq2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:46:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 95AB860231;
        Mon, 21 Jun 2021 16:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624293195;
        bh=ZZw7LqFGgfCHUlgt8fcTCe5QwulDRnNqcaBgTxopqcM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oc+wpSKLWs4Qmfgu3keL4XdD5oIciqc96zuyi8TagAsc8x4NxitA0lsJsmZ/B27wT
         OsiSaqy8thZFyFHRUMc+K3/xvqbLhe0yokXdIkVvL2tUSsk/Xt1kRi7mLFwy9kS6Y9
         1cM5MNTuG40oibYdhs5J8NzyHr/SxvtM592kKDik=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Axel Lin <axel.lin@ingics.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 100/178] regulator: hi6421v600: Fix .vsel_mask setting
Date:   Mon, 21 Jun 2021 18:15:14 +0200
Message-Id: <20210621154926.181590113@linuxfoundation.org>
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

From: Axel Lin <axel.lin@ingics.com>

[ Upstream commit 50bec7fb4cb1bcf9d387046b6dec7186590791ec ]

Take ldo3_voltages as example, the ARRAY_SIZE(ldo3_voltages) is 16.
i.e. the valid selector is 0 ~ 0xF.
But in current code the vsel_mask is "(1 << 15) - 1", i.e. 0x7FFF. Fix it.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
Link: https://lore.kernel.org/r/20210529013236.373847-1-axel.lin@ingics.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/hikey9xx/hi6421v600-regulator.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/hikey9xx/hi6421v600-regulator.c b/drivers/staging/hikey9xx/hi6421v600-regulator.c
index f6a14e9c3cbf..e10fe3058176 100644
--- a/drivers/staging/hikey9xx/hi6421v600-regulator.c
+++ b/drivers/staging/hikey9xx/hi6421v600-regulator.c
@@ -83,7 +83,7 @@ static const unsigned int ldo34_voltages[] = {
 			.owner		= THIS_MODULE,			       \
 			.volt_table	= vtable,			       \
 			.n_voltages	= ARRAY_SIZE(vtable),		       \
-			.vsel_mask	= (1 << (ARRAY_SIZE(vtable) - 1)) - 1, \
+			.vsel_mask	= ARRAY_SIZE(vtable) - 1,	       \
 			.vsel_reg	= vreg,				       \
 			.enable_reg	= ereg,				       \
 			.enable_mask	= emask,			       \
-- 
2.30.2



