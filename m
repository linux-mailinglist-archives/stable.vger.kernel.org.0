Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9DDB42DD54
	for <lists+stable@lfdr.de>; Thu, 14 Oct 2021 17:04:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233595AbhJNPGS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Oct 2021 11:06:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:51950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233389AbhJNPEm (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 Oct 2021 11:04:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DDB916120D;
        Thu, 14 Oct 2021 15:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634223651;
        bh=yKfOqpQHcvPaJG+VeITmGy48fGASOt6hWgsw3r8Umf8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m95B5IptSuf5f7vWg/vBCfGW0fHyJVoqHpmqA2sjQko3ZEanQ9AclRPI5R6XXrDoS
         VZEkcXWU72D8SQuryzdiTArm7wqcSa9wt6g60G7RWuX8aq//JdZdzN4kebWHP9vGJZ
         mA8MX2/V4nBUOo+sffmPPE0+yP0GkiE9dw2uPtpo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rajendra Nayak <rnayak@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 15/30] pinctrl: qcom: sc7280: Add PM suspend callbacks
Date:   Thu, 14 Oct 2021 16:54:20 +0200
Message-Id: <20211014145210.033153366@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211014145209.520017940@linuxfoundation.org>
References: <20211014145209.520017940@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



