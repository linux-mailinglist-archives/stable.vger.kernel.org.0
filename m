Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A453137D97
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:00:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729153AbgAKJ7T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 04:59:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:53762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729143AbgAKJ7T (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 04:59:19 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D1D62077C;
        Sat, 11 Jan 2020 09:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578736758;
        bh=MABIAo/8O2n9vUpWI2QDXB80LRbXfp1lWRL4aI2t6Dk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yp5cPKYqOvvjkBXoRN4vlEQpbMA4dWHkkV/qhjU09iYF1g11jnTrgSVuIK2FyZTpn
         LlJGxZ0F3HO+BW61va3t5gLGiy7f0FiPir+vbuQOUPWYXix9gOmVxWHEQi+NRhHo+X
         UdvhPXIM4Ox/QN7ViK5Cc9I6tJn+DnpEnb0BMuVg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.9 19/91] ALSA: ice1724: Fix sleep-in-atomic in Infrasonic Quartet support code
Date:   Sat, 11 Jan 2020 10:49:12 +0100
Message-Id: <20200111094850.844321090@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094844.748507863@linuxfoundation.org>
References: <20200111094844.748507863@linuxfoundation.org>
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
@@ -661,6 +661,7 @@ static int snd_vt1724_set_pro_rate(struc
 	unsigned long flags;
 	unsigned char mclk_change;
 	unsigned int i, old_rate;
+	bool call_set_rate = false;
 
 	if (rate > ice->hw_rates->list[ice->hw_rates->count - 1])
 		return -EINVAL;
@@ -684,7 +685,7 @@ static int snd_vt1724_set_pro_rate(struc
 		 * setting clock rate for internal clock mode */
 		old_rate = ice->get_rate(ice);
 		if (force || (old_rate != rate))
-			ice->set_rate(ice, rate);
+			call_set_rate = true;
 		else if (rate == ice->cur_rate) {
 			spin_unlock_irqrestore(&ice->reg_lock, flags);
 			return 0;
@@ -692,12 +693,14 @@ static int snd_vt1724_set_pro_rate(struc
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


