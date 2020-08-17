Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C092D24654F
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 13:27:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728061AbgHQL1O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 07:27:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:54484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726171AbgHQL1M (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 07:27:12 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E27382078D;
        Mon, 17 Aug 2020 11:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597663632;
        bh=qRbsfCdL7lmppXtjwWuzEw+EWGRHPrf8d7vcicpEOr4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XcHpToc07w835Izb2rom/U0v58VrHfz1Nzjv0T20BQW4Z6ij8FPbogY09ZwGDOXU6
         GOLBUoT7RxpP6L3j1p7g+XyPrxh4NSxzweWJ/LZh/zO3xYtDWqEtJTmROtLqYnrtDt
         8kkEhT0OrBfilLTtbfuh2NJfUay8ZGdg4+E/J/oE=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1k7dIE-003Y6k-Dl; Mon, 17 Aug 2020 12:27:10 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH 2/2] HID: core; Sanitize event code and type before mapping input
Date:   Mon, 17 Aug 2020 12:27:00 +0100
Message-Id: <20200817112700.468743-3-maz@kernel.org>
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

When calling into hid_map_usage(), the passed event code is
blindly stored as is, even if it doesn't fit in the associated bitmap.

This event code can come from a variety of sources, including devices
masquerading as input devices, only a bit more "programmable".

Instead of taking the raw event code, sanitize it to the actual bitmap
size and output a warning to let the user know.

While we're at it, sanitize the hid_usage structure if the type isn't
known, conveniently placing a NULL pointer as the bitmap in order to
catch unexpected uses.

Cc: stable@vger.kernel.org
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 include/linux/hid.h | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/include/linux/hid.h b/include/linux/hid.h
index 875f71132b14..4cd87d0ec023 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -966,9 +966,6 @@ static inline void hid_map_usage(struct hid_input *hidinput,
 {
 	struct input_dev *input = hidinput->input;
 
-	usage->type = type;
-	usage->code = c;
-
 	switch (type) {
 	case EV_ABS:
 		*bit = input->absbit;
@@ -986,7 +983,20 @@ static inline void hid_map_usage(struct hid_input *hidinput,
 		*bit = input->ledbit;
 		*max = LED_MAX;
 		break;
+	default:
+		*bit = NULL;
+		*max = 0;
+		usage->code = 0;
+		usage->type = 0;
+		return;
 	}
+
+	usage->type = type;
+	usage->code = c & *max;
+
+	if (unlikely(usage->code != c))
+		pr_warn_ratelimited("%s: Truncated code %d to %d for type %d\n",
+				    input->name, c, usage->code, type);
 }
 
 /**
@@ -1000,7 +1010,8 @@ static inline void hid_map_usage_clear(struct hid_input *hidinput,
 		__u8 type, __u16 c)
 {
 	hid_map_usage(hidinput, usage, bit, max, type, c);
-	clear_bit(c, *bit);
+	if (*bit)
+		clear_bit(usage->code, *bit);
 }
 
 /**
-- 
2.27.0

