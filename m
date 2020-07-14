Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F7BB21F4AD
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 16:41:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729500AbgGNOlM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 10:41:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:56262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729359AbgGNOk0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 10:40:26 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1FC7D22203;
        Tue, 14 Jul 2020 14:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594737625;
        bh=vheu8TZzVr7b5aGc1BoYKgMa8Ibhc2js0kaeO/WqSb8=;
        h=From:To:Cc:Subject:Date:From;
        b=IYCs9JeiUnPnqawPQi+AbOF8cCHB9SOfCQdq9GRiP60uUpYTn9QAssMzKE0LaOkcA
         bz0SBsOSjMCmkSGHKtFWFzckGsI2HUhzqRFCr2fM9UJYEt1CcOlPBCh5uRYaCKR81J
         Q/XPxP6vYdkGe5oh9LukAHryJe14ANdWE3iDQaaQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jacky Hu <hengqing.hu@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 1/9] pinctrl: amd: fix npins for uart0 in kerncz_groups
Date:   Tue, 14 Jul 2020 10:40:15 -0400
Message-Id: <20200714144024.4036118-1-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jacky Hu <hengqing.hu@gmail.com>

[ Upstream commit 69339d083dfb7786b0e0b3fc19eaddcf11fabdfb ]

uart0_pins is defined as:
static const unsigned uart0_pins[] = {135, 136, 137, 138, 139};

which npins is wronly specified as 9 later
	{
		.name = "uart0",
		.pins = uart0_pins,
		.npins = 9,
	},

npins should be 5 instead of 9 according to the definition.

Signed-off-by: Jacky Hu <hengqing.hu@gmail.com>
Link: https://lore.kernel.org/r/20200616015024.287683-1-hengqing.hu@gmail.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-amd.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-amd.h b/drivers/pinctrl/pinctrl-amd.h
index 7bfea47dbb472..f63417197a62f 100644
--- a/drivers/pinctrl/pinctrl-amd.h
+++ b/drivers/pinctrl/pinctrl-amd.h
@@ -249,7 +249,7 @@ static const struct amd_pingroup kerncz_groups[] = {
 	{
 		.name = "uart0",
 		.pins = uart0_pins,
-		.npins = 9,
+		.npins = 5,
 	},
 	{
 		.name = "uart1",
-- 
2.25.1

