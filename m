Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB55B138030
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:27:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730946AbgAKK0u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:26:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:60006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729122AbgAKK0t (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:26:49 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3802620842;
        Sat, 11 Jan 2020 10:26:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578738409;
        bh=ASl7vaeg61VjfA/PHCSfSIa3DQSAHBoCvHj2gUv6USs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=krSYtTidBJZ4Vze+pY5F5Wob7FBUEwhSdBwhDAmsMBUieuneIraBODTILl6GqWWuV
         zcaCwzTgXakGLs5thgcm77ShxWJWubkBdM/iV/VrR7CCX11aGKft635moIVFPppWb6
         2i7ZsZHeFnwB1Cfv2JKYA2Kyy7u16vSMlnKuVJog=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexandre Torgue <alexandre.torgue@st.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 071/165] pinctrl: pinmux: fix a possible null pointer in pinmux_can_be_used_for_gpio
Date:   Sat, 11 Jan 2020 10:49:50 +0100
Message-Id: <20200111094927.093723511@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094921.347491861@linuxfoundation.org>
References: <20200111094921.347491861@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandre Torgue <alexandre.torgue@st.com>

[ Upstream commit 6ba2fd391ac58c1a26874f10c3054a1ea4aca2d0 ]

This commit adds a check on ops pointer to avoid a kernel panic when
ops->strict is used. Indeed, on some pinctrl driver (at least for
pinctrl-stmfx) the pinmux ops is not implemented. Let's assume than gpio
can be used in this case.

Fixes: 472a61e777fe ("pinctrl/gpio: Take MUX usage into account")
Signed-off-by: Alexandre Torgue <alexandre.torgue@st.com>
Link: https://lore.kernel.org/r/20191204144106.10876-1-alexandre.torgue@st.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinmux.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinmux.c b/drivers/pinctrl/pinmux.c
index e914f6efd39e..9503ddf2edc7 100644
--- a/drivers/pinctrl/pinmux.c
+++ b/drivers/pinctrl/pinmux.c
@@ -85,7 +85,7 @@ bool pinmux_can_be_used_for_gpio(struct pinctrl_dev *pctldev, unsigned pin)
 	const struct pinmux_ops *ops = pctldev->desc->pmxops;
 
 	/* Can't inspect pin, assume it can be used */
-	if (!desc)
+	if (!desc || !ops)
 		return true;
 
 	if (ops->strict && desc->mux_usecount)
-- 
2.20.1



