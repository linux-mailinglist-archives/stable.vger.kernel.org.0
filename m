Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 023C737860B
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:30:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233353AbhEJLDY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:03:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:52164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234841AbhEJK5K (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:57:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4D5976194F;
        Mon, 10 May 2021 10:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620643789;
        bh=hFJ4e1Trr9DHNcMpjLkrcuRY5tumV4fL07Gqx5LGkak=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OTCf0QNXxhWBxy1BYiyBtfjXVJk2RHRJMk5VShyBxhxn4OkAE+nOgPMX/V1shxXn0
         7yHxdaxwkxqoPAhwuypxnEhvc4v6eRTQ4PdYHdTMyk1Skyr2qf+T77q5+3vGkzPLgU
         Q3paPQG7iKk9qIxXkcQJn/vOpr1yOb9tjaV30jv8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 159/342] extcon: arizona: Fix some issues when HPDET IRQ fires after the jack has been unplugged
Date:   Mon, 10 May 2021 12:19:09 +0200
Message-Id: <20210510102015.349857851@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102010.096403571@linuxfoundation.org>
References: <20210510102010.096403571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit c309a3e8793f7e01c4a4ec7960658380572cb576 ]

When the jack is partially inserted and then removed again it may be
removed while the hpdet code is running. In this case the following
may happen:

1. The "JACKDET rise" or ""JACKDET fall" IRQ triggers
2. arizona_jackdet runs and takes info->lock
3. The "HPDET" IRQ triggers
4. arizona_hpdet_irq runs, blocks on info->lock
5. arizona_jackdet calls arizona_stop_mic() and clears info->hpdet_done
6. arizona_jackdet releases info->lock
7. arizona_hpdet_irq now can continue running and:
7.1 Calls arizona_start_mic() (if a mic was detected)
7.2 sets info->hpdet_done

Step 7 is undesirable / a bug:
7.1 causes the device to stay in a high power-state (with MICVDD enabled)
7.2 causes hpdet to not run on the next jack insertion, which in turn
    causes the EXTCON_JACK_HEADPHONE state to never get set

This fixes both issues by skipping these 2 steps when arizona_hpdet_irq
runs after the jack has been unplugged.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Acked-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Tested-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Acked-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/extcon/extcon-arizona.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
index aae82db542a5..f7ef247de46a 100644
--- a/drivers/extcon/extcon-arizona.c
+++ b/drivers/extcon/extcon-arizona.c
@@ -601,7 +601,7 @@ static irqreturn_t arizona_hpdet_irq(int irq, void *data)
 	struct arizona *arizona = info->arizona;
 	int id_gpio = arizona->pdata.hpdet_id_gpio;
 	unsigned int report = EXTCON_JACK_HEADPHONE;
-	int ret, reading;
+	int ret, reading, state;
 	bool mic = false;
 
 	mutex_lock(&info->lock);
@@ -614,12 +614,11 @@ static irqreturn_t arizona_hpdet_irq(int irq, void *data)
 	}
 
 	/* If the cable was removed while measuring ignore the result */
-	ret = extcon_get_state(info->edev, EXTCON_MECHANICAL);
-	if (ret < 0) {
-		dev_err(arizona->dev, "Failed to check cable state: %d\n",
-			ret);
+	state = extcon_get_state(info->edev, EXTCON_MECHANICAL);
+	if (state < 0) {
+		dev_err(arizona->dev, "Failed to check cable state: %d\n", state);
 		goto out;
-	} else if (!ret) {
+	} else if (!state) {
 		dev_dbg(arizona->dev, "Ignoring HPDET for removed cable\n");
 		goto done;
 	}
@@ -667,7 +666,7 @@ done:
 		gpio_set_value_cansleep(id_gpio, 0);
 
 	/* If we have a mic then reenable MICDET */
-	if (mic || info->mic)
+	if (state && (mic || info->mic))
 		arizona_start_mic(info);
 
 	if (info->hpdet_active) {
@@ -675,7 +674,9 @@ done:
 		info->hpdet_active = false;
 	}
 
-	info->hpdet_done = true;
+	/* Do not set hp_det done when the cable has been unplugged */
+	if (state)
+		info->hpdet_done = true;
 
 out:
 	mutex_unlock(&info->lock);
-- 
2.30.2



