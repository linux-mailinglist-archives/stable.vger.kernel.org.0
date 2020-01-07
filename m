Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C001F133136
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 21:58:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727362AbgAGU6i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 15:58:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:58198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727389AbgAGU6f (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 15:58:35 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C53CD24679;
        Tue,  7 Jan 2020 20:58:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578430715;
        bh=WDWhd5zGGRJLISsdlOzwEI0kY03uCFpBBDHuR6FeEX4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fw0K15+MEn8AyoTdQUP7i4tiA47MSzcvMfRuJGqWsCZ+lfpE85xRYaXqFne5aSlsS
         R9gC4cKjqPOwMzZs9NRIcO4/3WLbDQ5IId+OJRK5C4IDnARZ+TUlTH+zo79Hp7Nu2r
         SFTrMLbkymCSQI/11KXt0Gk/NkpXyNTT1EWvsjA4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 066/191] ALSA: ice1724: Fix sleep-in-atomic in Infrasonic Quartet support code
Date:   Tue,  7 Jan 2020 21:53:06 +0100
Message-Id: <20200107205336.523680567@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205332.984228665@linuxfoundation.org>
References: <20200107205332.984228665@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 0aec96f5897ac16ad9945f531b4bef9a2edd2ebd upstream.

Jia-Ju Bai reported a possible sleep-in-atomic scenario in the ice1724
driver with Infrasonic Quartet support code: namely, ice->set_rate
callback gets called inside ice->reg_lock spinlock, while the callback
in quartet.c holds ice->gpio_mutex.

This patch fixes the invalid call: it simply moves the calls of
ice->set_rate and ice->set_mclk callbacks outside the spinlock.

Reported-by: Jia-Ju Bai <baijiaju1990@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/5d43135e-73b9-a46a-2155-9e91d0dcdf83@gmail.com
Link: https://lore.kernel.org/r/20191218192606.12866-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/ice1712/ice1724.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/sound/pci/ice1712/ice1724.c
+++ b/sound/pci/ice1712/ice1724.c
@@ -647,6 +647,7 @@ static int snd_vt1724_set_pro_rate(struc
 	unsigned long flags;
 	unsigned char mclk_change;
 	unsigned int i, old_rate;
+	bool call_set_rate = false;
 
 	if (rate > ice->hw_rates->list[ice->hw_rates->count - 1])
 		return -EINVAL;
@@ -670,7 +671,7 @@ static int snd_vt1724_set_pro_rate(struc
 		 * setting clock rate for internal clock mode */
 		old_rate = ice->get_rate(ice);
 		if (force || (old_rate != rate))
-			ice->set_rate(ice, rate);
+			call_set_rate = true;
 		else if (rate == ice->cur_rate) {
 			spin_unlock_irqrestore(&ice->reg_lock, flags);
 			return 0;
@@ -678,12 +679,14 @@ static int snd_vt1724_set_pro_rate(struc
 	}
 
 	ice->cur_rate = rate;
+	spin_unlock_irqrestore(&ice->reg_lock, flags);
+
+	if (call_set_rate)
+		ice->set_rate(ice, rate);
 
 	/* setting master clock */
 	mclk_change = ice->set_mclk(ice, rate);
 
-	spin_unlock_irqrestore(&ice->reg_lock, flags);
-
 	if (mclk_change && ice->gpio.i2s_mclk_changed)
 		ice->gpio.i2s_mclk_changed(ice);
 	if (ice->gpio.set_pro_rate)


