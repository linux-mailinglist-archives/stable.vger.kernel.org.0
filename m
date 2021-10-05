Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8032E42289F
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 15:51:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235781AbhJENxV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 09:53:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:60716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235478AbhJENwz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Oct 2021 09:52:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 76DFE619E1;
        Tue,  5 Oct 2021 13:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633441865;
        bh=yKfOqpQHcvPaJG+VeITmGy48fGASOt6hWgsw3r8Umf8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ShK7XEZ5ovXClsgSgODDOBnFIY64Agf7JKTgxZ7oIcsGpu9xqRak1YnSzGQEhxUP9
         hsUmjGksRxLDvMW8F8L5lDzfGabI6/rlGBitCvejRUEEPXjW11pKNpFyb2NC9WS7Vy
         1H6vWPEoqyAHqHcWDRze8XuzFwnuQL5Uv+BXhCC3ae6dhO4+i8Pjmd01fN97DfLp3l
         qEYxPIlllj2crYEd7WMwBV5GHMZqYzpsZZzR07R/ml0V523UR3qcps8fF94erIcV3R
         Bez8F8E5iT17Um3LoH/9Q1Za1fMpUctWQesZINmsm+s+YDX0KH9rcNjA6QmEejgtRY
         nKlHStF65KG4Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rajendra Nayak <rnayak@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>, agross@kernel.org,
        linux-arm-msm@vger.kernel.org, linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 22/40] pinctrl: qcom: sc7280: Add PM suspend callbacks
Date:   Tue,  5 Oct 2021 09:50:01 -0400
Message-Id: <20211005135020.214291-22-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211005135020.214291-1-sashal@kernel.org>
References: <20211005135020.214291-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rajendra Nayak <rnayak@codeaurora.org>

[ Upstream commit 28406a21999152ff7faa30b194f734565bdd8e0d ]

Use PM suspend callbacks from msm core, without this the hog_sleep
pins don't change state in suspend.

Signed-off-by: Rajendra Nayak <rnayak@codeaurora.org>
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/1632389487-11283-1-git-send-email-rnayak@codeaurora.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/qcom/pinctrl-sc7280.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pinctrl/qcom/pinctrl-sc7280.c b/drivers/pinctrl/qcom/pinctrl-sc7280.c
index afddf6d60dbe..9017ede409c9 100644
--- a/drivers/pinctrl/qcom/pinctrl-sc7280.c
+++ b/drivers/pinctrl/qcom/pinctrl-sc7280.c
@@ -1496,6 +1496,7 @@ static const struct of_device_id sc7280_pinctrl_of_match[] = {
 static struct platform_driver sc7280_pinctrl_driver = {
 	.driver = {
 		.name = "sc7280-pinctrl",
+		.pm = &msm_pinctrl_dev_pm_ops,
 		.of_match_table = sc7280_pinctrl_of_match,
 	},
 	.probe = sc7280_pinctrl_probe,
-- 
2.33.0

