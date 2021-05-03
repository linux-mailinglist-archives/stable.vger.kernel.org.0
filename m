Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 868BD371D0C
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:57:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234508AbhECQ5y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:57:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:43310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235092AbhECQzr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:55:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B66346195E;
        Mon,  3 May 2021 16:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620060177;
        bh=TaVNJRY5XPIU5i6U3JYCbdC5+H8m3nQy0CqgNMCl624=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bI4VxIZ2BnUei3GWUIF2Uw8rWmtxxMXgGScxVfL4o/0bAUrhjcYrAgX6yEDhWqwAl
         h9SDQRmDBwpH/DqzJZMmsZRnmI30YUCOaRocTVqN6Ni6dimWVAXnY4l5d2UUvQal5O
         blJlmE9/UBoD1C1MK7Vz0wX+DS4GcFrP42o1cR2eQN/IdhTrZ0FwXp48GpdIwP27Ot
         DH5RhaBwlRmeJ4VfhWdXZ+WpDVaDEBR+JEaaea/tpWKUP7dYK5NXJ5GtabvkkgwuAo
         uxaJNUVzNBauLXFKbq8vFVjFbRXaWwqbb3mTnaIimMB5Pfn6HxA+MrBUioDhjMuiHf
         GBOL0Z2egzUbA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.9 03/24] extcon: arizona: Fix some issues when HPDET IRQ fires after the jack has been unplugged
Date:   Mon,  3 May 2021 12:42:31 -0400
Message-Id: <20210503164252.2854487-3-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503164252.2854487-1-sashal@kernel.org>
References: <20210503164252.2854487-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 4c0b6df8b5dd..1d06d99b8bd9 100644
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
@@ -672,7 +671,7 @@ static irqreturn_t arizona_hpdet_irq(int irq, void *data)
 			   ARIZONA_ACCDET_MODE_MASK, ARIZONA_ACCDET_MODE_MIC);
 
 	/* If we have a mic then reenable MICDET */
-	if (mic || info->mic)
+	if (state && (mic || info->mic))
 		arizona_start_mic(info);
 
 	if (info->hpdet_active) {
@@ -680,7 +679,9 @@ static irqreturn_t arizona_hpdet_irq(int irq, void *data)
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

