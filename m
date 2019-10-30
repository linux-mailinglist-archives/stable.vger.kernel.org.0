Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64C64EA0D7
	for <lists+stable@lfdr.de>; Wed, 30 Oct 2019 17:09:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728404AbfJ3Pyh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Oct 2019 11:54:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:56098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728398AbfJ3Pyh (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Oct 2019 11:54:37 -0400
Received: from sasha-vm.mshome.net (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 231102087E;
        Wed, 30 Oct 2019 15:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572450876;
        bh=MEbPA6Qcubxag4Ew2M//KXeX4cegr3py9JHVD7ZNsRI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z/P4/aSpQPd90TyWRkdQztriyfD/1OJ9EW+j/rK+UOm04xQSeuurPQDnxPQetJ7i+
         QrW0FKnt1T0TORQn2yMMi5MBtD2P0tjgSwhuo+in5d6nBLvNcdt/TzjqckS/dyeA7M
         5n0UpCxTCeFClNneUuFtTmP73UXmh1cEAILUPYjc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Scott Branden <scott.branden@broadcom.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 12/38] pinctrl: ns2: Fix off by one bugs in ns2_pinmux_enable()
Date:   Wed, 30 Oct 2019 11:53:40 -0400
Message-Id: <20191030155406.10109-12-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191030155406.10109-1-sashal@kernel.org>
References: <20191030155406.10109-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 39b65fbb813089e366b376bd8acc300b6fd646dc ]

The pinctrl->functions[] array has pinctrl->num_functions elements and
the pinctrl->groups[] array is the same way.  These are set in
ns2_pinmux_probe().  So the > comparisons should be >= so that we don't
read one element beyond the end of the array.

Fixes: b5aa1006e4a9 ("pinctrl: ns2: add pinmux driver support for Broadcom NS2 SoC")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/20190926081426.GB2332@mwanda
Acked-by: Scott Branden <scott.branden@broadcom.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/bcm/pinctrl-ns2-mux.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/bcm/pinctrl-ns2-mux.c b/drivers/pinctrl/bcm/pinctrl-ns2-mux.c
index 4b5cf0e0f16e2..951090faa6a91 100644
--- a/drivers/pinctrl/bcm/pinctrl-ns2-mux.c
+++ b/drivers/pinctrl/bcm/pinctrl-ns2-mux.c
@@ -640,8 +640,8 @@ static int ns2_pinmux_enable(struct pinctrl_dev *pctrl_dev,
 	const struct ns2_pin_function *func;
 	const struct ns2_pin_group *grp;
 
-	if (grp_select > pinctrl->num_groups ||
-		func_select > pinctrl->num_functions)
+	if (grp_select >= pinctrl->num_groups ||
+		func_select >= pinctrl->num_functions)
 		return -EINVAL;
 
 	func = &pinctrl->functions[func_select];
-- 
2.20.1

