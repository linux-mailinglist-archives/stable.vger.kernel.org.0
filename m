Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BDBD303394
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 05:59:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730257AbhAZE7R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 23:59:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:36812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731077AbhAYSuX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:50:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C8F542083E;
        Mon, 25 Jan 2021 18:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600607;
        bh=7Nbgq+nNg8Nwj+uVPGdpx2XmQoMU6tLYpClwhrtmfTc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0ecn9rjMPBB5Zze4DUY6Yna0DUbMW+ApPycOIsg0tetXQe3wJQV2ap+AKZYsO7Oa7
         MU/ev1w3O+wClIXwmD9qqLPy2OrgBC7amxD/HyPFXf8iztUh6I4NkUn3F8vjjzSOwU
         lLMBWY6uByC1mrYjqBeGNL3M4/5Emvb5Krh1tDok=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hsin-Yi Wang <hsinyi@chromium.org>,
        Sean Wang <sean.wang@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 080/199] pinctrl: mediatek: Fix fallback call path
Date:   Mon, 25 Jan 2021 19:38:22 +0100
Message-Id: <20210125183219.641220959@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hsin-Yi Wang <hsinyi@chromium.org>

[ Upstream commit 81bd1579b43e0e285cba667399f1b063f1ce7672 ]

Some SoCs, eg. mt8183, are using a pinconfig operation bias_set_combo.
The fallback path in mtk_pinconf_adv_pull_set() should also try this
operation.

Fixes: cafe19db7751 ("pinctrl: mediatek: Backward compatible to previous Mediatek's bias-pull usage")
Signed-off-by: Hsin-Yi Wang <hsinyi@chromium.org>
Acked-by: Sean Wang <sean.wang@kernel.org>
Link: https://lore.kernel.org/r/20201228090425.2130569-1-hsinyi@chromium.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.c b/drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.c
index 7e950f5d62d0f..7815426e7aeaa 100644
--- a/drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.c
+++ b/drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.c
@@ -926,6 +926,10 @@ int mtk_pinconf_adv_pull_set(struct mtk_pinctrl *hw,
 			err = hw->soc->bias_set(hw, desc, pullup);
 			if (err)
 				return err;
+		} else if (hw->soc->bias_set_combo) {
+			err = hw->soc->bias_set_combo(hw, desc, pullup, arg);
+			if (err)
+				return err;
 		} else {
 			return -ENOTSUPP;
 		}
-- 
2.27.0



