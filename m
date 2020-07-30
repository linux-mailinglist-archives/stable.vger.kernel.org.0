Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8832232D76
	for <lists+stable@lfdr.de>; Thu, 30 Jul 2020 10:10:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729876AbgG3IKy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jul 2020 04:10:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:49970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729888AbgG3IKy (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jul 2020 04:10:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1669E2074B;
        Thu, 30 Jul 2020 08:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596096653;
        bh=vheu8TZzVr7b5aGc1BoYKgMa8Ibhc2js0kaeO/WqSb8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ageb5Wi4U14+z8Rylyw5BWG/WBRxn5UjMYAh/m2FyQqwZ4nb2bdSZFhMMhfsj2WY7
         pKqH2n8ApicPbYLa3tlekT1AT1sKOAPI4ax2JskUgqK0KDl8aXx33xtXjETZXbIHC6
         vLPFqozGNy+4CSorimeOUxCHmsnBHt4uw2BUjXwo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jacky Hu <hengqing.hu@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 01/54] pinctrl: amd: fix npins for uart0 in kerncz_groups
Date:   Thu, 30 Jul 2020 10:04:40 +0200
Message-Id: <20200730074421.283519192@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200730074421.203879987@linuxfoundation.org>
References: <20200730074421.203879987@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



