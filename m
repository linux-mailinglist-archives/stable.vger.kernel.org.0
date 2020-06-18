Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6C3B1FE803
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:45:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729943AbgFRCpO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 22:45:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:38634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728686AbgFRBK6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:10:58 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2BF8821D93;
        Thu, 18 Jun 2020 01:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442658;
        bh=8hjRe8VoNic6N/Bn+lsV9IGG9UN9K+eQy3lY4cPPuu8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=istH83S1nMxoJOGsd7RlAEI2atmlruqWetwOJJhRLOxoflYwahM61oZ81hCkEDLni
         MpTCxOxciI0GvMcp+JkT3y+0PcP3QIPpvcp5qx/bA9WAjLMc7l2jCh3AfuutmAtJU3
         0F8FQtWdVRq1WBnz8gWnYuoLWbTF3BgQQTHFLLtw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jason Yan <yanaijie@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>,
        linux-renesas-soc@vger.kernel.org, linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 129/388] pinctrl: rza1: Fix wrong array assignment of rza1l_swio_entries
Date:   Wed, 17 Jun 2020 21:03:46 -0400
Message-Id: <20200618010805.600873-129-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Yan <yanaijie@huawei.com>

[ Upstream commit 4b4e8e93eccc2abc4209fe226ec89e7fbe9f3c61 ]

The rza1l_swio_entries referred to the wrong array rza1h_swio_pins,
which was intended to be rza1l_swio_pins. So let's fix it.

This is detected by the following gcc warning:

drivers/pinctrl/pinctrl-rza1.c:401:35: warning: ‘rza1l_swio_pins’
defined but not used [-Wunused-const-variable=]
 static const struct rza1_swio_pin rza1l_swio_pins[] = {
                                   ^~~~~~~~~~~~~~~

Fixes: 039bc58e73b77723 ("pinctrl: rza1: Add support for RZ/A1L")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Jason Yan <yanaijie@huawei.com>
Link: https://lore.kernel.org/r/20200417111604.19143-1-yanaijie@huawei.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-rza1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-rza1.c b/drivers/pinctrl/pinctrl-rza1.c
index da2d8365c690..ff4a7fb518bb 100644
--- a/drivers/pinctrl/pinctrl-rza1.c
+++ b/drivers/pinctrl/pinctrl-rza1.c
@@ -418,7 +418,7 @@ static const struct rza1_bidir_entry rza1l_bidir_entries[RZA1_NPORTS] = {
 };
 
 static const struct rza1_swio_entry rza1l_swio_entries[] = {
-	[0] = { ARRAY_SIZE(rza1h_swio_pins), rza1h_swio_pins },
+	[0] = { ARRAY_SIZE(rza1l_swio_pins), rza1l_swio_pins },
 };
 
 /* RZ/A1L (r7s72102x) pinmux flags table */
-- 
2.25.1

