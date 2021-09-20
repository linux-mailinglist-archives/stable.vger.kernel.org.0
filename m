Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 075B9411DEC
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:24:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350088AbhITR0J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:26:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:49982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349134AbhITRVx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:21:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 48D5C61A60;
        Mon, 20 Sep 2021 17:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632157261;
        bh=ogdmkl/1zREwG8055eDHUKwp8oVd2dxMKlFSQBwymz4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VlcsSKjNDokUp3fKikzVhjra4c0CEmsiSmgRizGwEExjMLr3MOslE40QDo2FgBDtY
         UF/LUB/0iLnlxYRrtCJM80q3fVaon3VjPhsVsCLKRRuBr5Z1kE0V9NVnedeToYm7qN
         kna/PvuDsE7RZj+cBxggThQax86fW+XfVdxePQA0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 127/217] pinctrl: single: Fix error return code in pcs_parse_bits_in_pinctrl_entry()
Date:   Mon, 20 Sep 2021 18:42:28 +0200
Message-Id: <20210920163928.960633200@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163924.591371269@linuxfoundation.org>
References: <20210920163924.591371269@linuxfoundation.org>
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
index f751b5c3bf7e..e33972c3a420 100644
--- a/drivers/pinctrl/pinctrl-single.c
+++ b/drivers/pinctrl/pinctrl-single.c
@@ -1161,6 +1161,7 @@ static int pcs_parse_bits_in_pinctrl_entry(struct pcs_device *pcs,
 
 	if (PCS_HAS_PINCONF) {
 		dev_err(pcs->dev, "pinconf not supported\n");
+		res = -ENOTSUPP;
 		goto free_pingroups;
 	}
 
-- 
2.30.2



