Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 784C724654D
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 13:27:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728024AbgHQL1N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 07:27:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:54456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726329AbgHQL1M (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 07:27:12 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 72A8A20786;
        Mon, 17 Aug 2020 11:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597663631;
        bh=8j9N4CPEYB/GOpxUe4purZN78rjqtRdEePl/HYb5Zq8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mevUAYtwzpMpkqnuxdGGY6kceZ7qY0NCVCJd9lWtUOfMYpH4swff5AQxmnW63N6oN
         HuiFlckOgLd7PhX+CHKGlheZsWuP4kG5li1MUZ8PQ7SXbnik2Z4bBOWR6rkaDBNh43
         XsjuMFfX8QuxTUv97wh+tdLk5a7Awo3r1iGg7nbA=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1k7dID-003Y6k-WB; Mon, 17 Aug 2020 12:27:10 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH 1/2] Input; Sanitize event code before modifying bitmaps
Date:   Mon, 17 Aug 2020 12:26:59 +0100
Message-Id: <20200817112700.468743-2-maz@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200817112700.468743-1-maz@kernel.org>
References: <20200817112700.468743-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: dmitry.torokhov@gmail.com, jikos@kernel.org, benjamin.tissoires@redhat.com, linux-input@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When calling into input_set_capability(), the passed event code is
blindly used to set a bit in a number of bitmaps, without checking
whether this actually fits the expected size of the bitmap.

This event code can come from a variety of sources, including devices
masquerading as input devices, only a bit more "programmable".

Instead of taking the raw event code, sanitize it to the actual bitmap
size and output a warning to let the user know.

These checks are, at least in spirit, in keeping with cb222aed03d7
("Input: add safety guards to input_set_keycode()").

Cc: stable@vger.kernel.org
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 drivers/input/input.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/input/input.c b/drivers/input/input.c
index 3cfd2c18eebd..1e77cf47aa44 100644
--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -1974,14 +1974,18 @@ EXPORT_SYMBOL(input_get_timestamp);
  * In addition to setting up corresponding bit in appropriate capability
  * bitmap the function also adjusts dev->evbit.
  */
-void input_set_capability(struct input_dev *dev, unsigned int type, unsigned int code)
+void input_set_capability(struct input_dev *dev, unsigned int type, unsigned int raw_code)
 {
+	unsigned int code = raw_code;
+
 	switch (type) {
 	case EV_KEY:
+		code &= KEY_MAX;
 		__set_bit(code, dev->keybit);
 		break;
 
 	case EV_REL:
+		code &= REL_MAX;
 		__set_bit(code, dev->relbit);
 		break;
 
@@ -1990,26 +1994,32 @@ void input_set_capability(struct input_dev *dev, unsigned int type, unsigned int
 		if (!dev->absinfo)
 			return;
 
+		code &= ABS_MAX;
 		__set_bit(code, dev->absbit);
 		break;
 
 	case EV_MSC:
+		code &= MSC_MAX;
 		__set_bit(code, dev->mscbit);
 		break;
 
 	case EV_SW:
+		code &= SW_MAX;
 		__set_bit(code, dev->swbit);
 		break;
 
 	case EV_LED:
+		code &= LED_MAX;
 		__set_bit(code, dev->ledbit);
 		break;
 
 	case EV_SND:
+		code &= SND_MAX;
 		__set_bit(code, dev->sndbit);
 		break;
 
 	case EV_FF:
+		code &= FF_MAX;
 		__set_bit(code, dev->ffbit);
 		break;
 
@@ -2023,6 +2033,10 @@ void input_set_capability(struct input_dev *dev, unsigned int type, unsigned int
 		return;
 	}
 
+	if (unlikely(code != raw_code))
+		pr_warn_ratelimited("%s: Truncated code %d to %d for type %d\n",
+				    dev->name, raw_code, code, type);
+
 	__set_bit(type, dev->evbit);
 }
 EXPORT_SYMBOL(input_set_capability);
-- 
2.27.0

