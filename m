Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A09D40E5E1
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:28:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344872AbhIPRQJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:16:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:39920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346588AbhIPROE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:14:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C985B613A7;
        Thu, 16 Sep 2021 16:39:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810363;
        bh=SPe3Atrtx8dggmwlZ7vQgSMlq1837EZK1fqXLmcadxc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zgjfx55cbYoXpfUEbh98xiNQDhK1TJCe6VEVLHO21irWBZncB5eG3JOz9R7q3nWUS
         KClVJwevj1ni1YEOFQh2cPsVa7F5DFikmAMwoSRktLn5Lgy1EiGsBvqWYqXD0ejeVz
         RS9HwudkjlcpeewglDHI2YKFc754yiqMKVbh6Rt8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 113/432] pinctrl: single: Fix error return code in pcs_parse_bits_in_pinctrl_entry()
Date:   Thu, 16 Sep 2021 17:57:42 +0200
Message-Id: <20210916155814.596471890@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
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
index e3aa64798f7d..4fcae8458359 100644
--- a/drivers/pinctrl/pinctrl-single.c
+++ b/drivers/pinctrl/pinctrl-single.c
@@ -1224,6 +1224,7 @@ static int pcs_parse_bits_in_pinctrl_entry(struct pcs_device *pcs,
 
 	if (PCS_HAS_PINCONF) {
 		dev_err(pcs->dev, "pinconf not supported\n");
+		res = -ENOTSUPP;
 		goto free_pingroups;
 	}
 
-- 
2.30.2



