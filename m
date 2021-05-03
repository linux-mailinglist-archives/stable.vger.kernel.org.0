Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 940DE371C81
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:55:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234118AbhECQxD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:53:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:60880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232889AbhECQu6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:50:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9811B6193A;
        Mon,  3 May 2021 16:41:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620060080;
        bh=5gETEaXUGkr2ZIqQj8KNWdA3PgogiPECljj7URNWD8I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WjATA4Jk7bF3PInMRj/6q+rF5pX+Lbqi2wfv+1p5/RMO4d0Ak02UPcTR4JeaRqNlR
         +NudY/rtS1/ll23aQNTdnO5VwrKJr1rNUuOAkfZPCh4PB7s5YQk7RsWbt7BPzJMgQP
         26BbKxL7CgRHEk0Kb5vX3c/f0lwtN6B+f4swWxZVm8OUAYxteija5ya+RQ5Bv3ihRB
         2B+2tUzOfbz2dM9i6GG0pym6Hhtq6ekPjPP89lxVQElTW9yIveQGd3AHGjaBzfVSn3
         WCR6S71NXaoPWfYJj+iOJlihDnUsDka63gdkAETYcpVDxxQA45l0722WWVqxjNBrZV
         2ZdSQma2h8C9A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 07/35] extcon: arizona: Fix some issues when HPDET IRQ fires after the jack has been unplugged
Date:   Mon,  3 May 2021 12:40:41 -0400
Message-Id: <20210503164109.2853838-7-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503164109.2853838-1-sashal@kernel.org>
References: <20210503164109.2853838-1-sashal@kernel.org>
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
index 9327479c719c..c857120c00d9 100644
--- a/drivers/extcon/extcon-arizona.c
+++ b/drivers/extcon/extcon-arizona.c
@@ -602,7 +602,7 @@ static irqreturn_t arizona_hpdet_irq(int irq, void *data)
 	struct arizona *arizona = info->arizona;
 	int id_gpio = arizona->pdata.hpdet_id_gpio;
 	unsigned int report = EXTCON_JACK_HEADPHONE;
-	int ret, reading;
+	int ret, reading, state;
 	bool mic = false;
 
 	mutex_lock(&info->lock);
@@ -615,12 +615,11 @@ static irqreturn_t arizona_hpdet_irq(int irq, void *data)
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
@@ -673,7 +672,7 @@ static irqreturn_t arizona_hpdet_irq(int irq, void *data)
 			   ARIZONA_ACCDET_MODE_MASK, ARIZONA_ACCDET_MODE_MIC);
 
 	/* If we have a mic then reenable MICDET */
-	if (mic || info->mic)
+	if (state && (mic || info->mic))
 		arizona_start_mic(info);
 
 	if (info->hpdet_active) {
@@ -681,7 +680,9 @@ static irqreturn_t arizona_hpdet_irq(int irq, void *data)
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

