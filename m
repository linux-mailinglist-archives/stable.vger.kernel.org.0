Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0386F140013
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:48:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730182AbgAPXU3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:20:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:47042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389723AbgAPXU3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:20:29 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5DC452073A;
        Thu, 16 Jan 2020 23:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579216828;
        bh=3yWjoeEIMnBoOIZGVRv9iSKJUBempfyyrqd4UN/dPGk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T90L4dTvc397uotyF516T3CBssoKKijqyZoWKLh2ZXP4DkrbBAlzxDdXmbSYpXz03
         y4CqMFlO8hzgCgE/S03qnqFKTgmNVntN20FH0kGWqgrx7+fRN8/C/0gbPa3LEYTnwN
         NgB9fI4veRyeUah5PZ8EBnAUlScGmAeEJUXkrxNQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qianggui Song <qianggui.song@amlogic.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.4 019/203] pinctrl: meson: Fix wrong shift value when get drive-strength
Date:   Fri, 17 Jan 2020 00:15:36 +0100
Message-Id: <20200116231746.325188044@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231745.218684830@linuxfoundation.org>
References: <20200116231745.218684830@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qianggui Song <qianggui.song@amlogic.com>

commit 35c60be220572de7d6605c4318f640d133982040 upstream.

In meson_pinconf_get_drive_strength, variable bit is calculated by
meson_calc_reg_and_bit, this value is the offset from the first pin of a
certain bank to current pin, while Meson SoCs use two bits for each pin
to depict drive-strength. So a left shift by 1 should be done or node
pinconf-pins shows wrong message.

Fixes: 6ea3e3bbef37 ("pinctrl: meson: add support of drive-strength-microamp")

Signed-off-by: Qianggui Song <qianggui.song@amlogic.com>
Link: https://lore.kernel.org/r/20191226023734.9631-1-qianggui.song@amlogic.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pinctrl/meson/pinctrl-meson.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/pinctrl/meson/pinctrl-meson.c
+++ b/drivers/pinctrl/meson/pinctrl-meson.c
@@ -441,6 +441,7 @@ static int meson_pinconf_get_drive_stren
 		return ret;
 
 	meson_calc_reg_and_bit(bank, pin, REG_DS, &reg, &bit);
+	bit = bit << 1;
 
 	ret = regmap_read(pc->reg_ds, reg, &val);
 	if (ret)


