Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2DAD37CD86
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:14:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240684AbhELQ4D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:56:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:33484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243985AbhELQmV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:42:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5CDDF61C75;
        Wed, 12 May 2021 16:08:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835738;
        bh=YzjQesF8e0zNx55z3EXLgMpHfJUngA6dkRiOCKBlZJo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FV9KxyggDmh8B6Hd6psUdK3oEpKvhM8ofFb7nZ0yBzddMb9ywtKCUXKhQYiLDWR6M
         uItnZlyWLDpkFcT1npRomlnZDimWDjSxTRfwaeh1llpXbidipbrYZlxOSCg6MQKEyt
         GUafTR6efkJmw+mieIofdrctAPv96P/FUep7sYJ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hanna Hawa <hhhawa@amazon.com>,
        Tony Lindgren <tony@atomide.com>,
        Drew Fustini <drew@beagleboard.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 466/677] pinctrl: pinctrl-single: remove unused parameter
Date:   Wed, 12 May 2021 16:48:32 +0200
Message-Id: <20210512144852.851180222@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hanna Hawa <hhhawa@amazon.com>

[ Upstream commit 8fa2ea202b13b6da81e26c399ff1d87488398453 ]

Remove unused parameter 'pin_pos' from pcs_add_pin().

Signed-off-by: Hanna Hawa <hhhawa@amazon.com>
Reviewed-by: Tony Lindgren <tony@atomide.com>
Reviewed-by: Drew Fustini <drew@beagleboard.org>
Link: https://lore.kernel.org/r/20210319152133.28705-3-hhhawa@amazon.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-single.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-single.c b/drivers/pinctrl/pinctrl-single.c
index 7771316dfffa..8a7922459896 100644
--- a/drivers/pinctrl/pinctrl-single.c
+++ b/drivers/pinctrl/pinctrl-single.c
@@ -656,10 +656,8 @@ static const struct pinconf_ops pcs_pinconf_ops = {
  * pcs_add_pin() - add a pin to the static per controller pin array
  * @pcs: pcs driver instance
  * @offset: register offset from base
- * @pin_pos: unused
  */
-static int pcs_add_pin(struct pcs_device *pcs, unsigned offset,
-		unsigned pin_pos)
+static int pcs_add_pin(struct pcs_device *pcs, unsigned int offset)
 {
 	struct pcs_soc_data *pcs_soc = &pcs->socdata;
 	struct pinctrl_pin_desc *pin;
@@ -729,16 +727,14 @@ static int pcs_allocate_pin_table(struct pcs_device *pcs)
 		unsigned offset;
 		int res;
 		int byte_num;
-		int pin_pos = 0;
 
 		if (pcs->bits_per_mux) {
 			byte_num = (pcs->bits_per_pin * i) / BITS_PER_BYTE;
 			offset = (byte_num / mux_bytes) * mux_bytes;
-			pin_pos = i % num_pins_in_register;
 		} else {
 			offset = i * mux_bytes;
 		}
-		res = pcs_add_pin(pcs, offset, pin_pos);
+		res = pcs_add_pin(pcs, offset);
 		if (res < 0) {
 			dev_err(pcs->dev, "error adding pins: %i\n", res);
 			return res;
-- 
2.30.2



