Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E247B41200F
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:47:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346411AbhITRsM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:48:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:49428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349706AbhITRqC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:46:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5EAE86187F;
        Mon, 20 Sep 2021 17:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632157815;
        bh=wUH26+PartknuQz2M8D0O0Av7xev4K5nYj0Hnzde4UE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BvHUhHXozNrlCQz+16F/0ZegKJQ5NqWLQZvmYTsXWmILZT562yJqtVzrAEx5A7wk0
         BBkLFEKK4cCqJ3I2EP9BAhqOXw3tyRoPR3vB0g+u82Klxstbqqb6BnD3D+TBfPcGO7
         M0tmlZFCs6zItQvbQuAwriR+BaqGGwD2zQu1X7AY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 164/293] pinctrl: single: Fix error return code in pcs_parse_bits_in_pinctrl_entry()
Date:   Mon, 20 Sep 2021 18:42:06 +0200
Message-Id: <20210920163938.895507007@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163933.258815435@linuxfoundation.org>
References: <20210920163933.258815435@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhen Lei <thunder.leizhen@huawei.com>

[ Upstream commit d789a490d32fdf0465275e3607f8a3bc87d3f3ba ]

Fix to return -ENOTSUPP instead of 0 when PCS_HAS_PINCONF is true, which
is the same as that returned in pcs_parse_pinconf().

Fixes: 4e7e8017a80e ("pinctrl: pinctrl-single: enhance to configure multiple pins of different modules")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Link: https://lore.kernel.org/r/20210722033930.4034-2-thunder.leizhen@huawei.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-single.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pinctrl/pinctrl-single.c b/drivers/pinctrl/pinctrl-single.c
index 04a4e761e9a9..c2f807bf3489 100644
--- a/drivers/pinctrl/pinctrl-single.c
+++ b/drivers/pinctrl/pinctrl-single.c
@@ -1201,6 +1201,7 @@ static int pcs_parse_bits_in_pinctrl_entry(struct pcs_device *pcs,
 
 	if (PCS_HAS_PINCONF) {
 		dev_err(pcs->dev, "pinconf not supported\n");
+		res = -ENOTSUPP;
 		goto free_pingroups;
 	}
 
-- 
2.30.2



