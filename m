Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B749A1D0E44
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 11:59:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388020AbgEMJxx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 05:53:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:56002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388017AbgEMJxw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 05:53:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 27E08205ED;
        Wed, 13 May 2020 09:53:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589363631;
        bh=6bqyuSi7qqW5PiXT3G0qoFdiCIsMTRNnGfoFN53ZoS4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eqw34YZyF3N7XFl4BrHasG5n+xKji6x+q0ZOqQbVbo6JNXill8ucQerVxKEUuZX6+
         mF7Z0SMtMlE/QuJ9RQYKevwpHr1Tb6xTy8CKDvBZh8WyWdWpfWuxnPFuCQ3+tBFPqR
         njvQbcjsQT1kMUpZnZWkfppV3hKCtG7iwrvYzSVo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Gerecke <jason.gerecke@wacom.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 5.6 061/118] HID: wacom: Report 2nd-gen Intuos Pro S center button status over BT
Date:   Wed, 13 May 2020 11:44:40 +0200
Message-Id: <20200513094422.338397479@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200513094417.618129545@linuxfoundation.org>
References: <20200513094417.618129545@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gerecke <killertofu@gmail.com>

commit dcce8ef8f70a8e38e6c47c1bae8b312376c04420 upstream.

The state of the center button was not reported to userspace for the
2nd-gen Intuos Pro S when used over Bluetooth due to the pad handling
code not being updated to support its reduced number of buttons. This
patch uses the actual number of buttons present on the tablet to
assemble a button state bitmap.

Link: https://github.com/linuxwacom/xf86-input-wacom/issues/112
Fixes: cd47de45b855 ("HID: wacom: Add 2nd gen Intuos Pro Small support")
Signed-off-by: Jason Gerecke <jason.gerecke@wacom.com>
Cc: stable@vger.kernel.org # v5.3+
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/wacom_wac.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -1427,11 +1427,13 @@ static void wacom_intuos_pro2_bt_pad(str
 {
 	struct input_dev *pad_input = wacom->pad_input;
 	unsigned char *data = wacom->data;
+	int nbuttons = wacom->features.numbered_buttons;
 
-	int buttons = data[282] | ((data[281] & 0x40) << 2);
+	int expresskeys = data[282];
+	int center = (data[281] & 0x40) >> 6;
 	int ring = data[285] & 0x7F;
 	bool ringstatus = data[285] & 0x80;
-	bool prox = buttons || ringstatus;
+	bool prox = expresskeys || center || ringstatus;
 
 	/* Fix touchring data: userspace expects 0 at left and increasing clockwise */
 	ring = 71 - ring;
@@ -1439,7 +1441,8 @@ static void wacom_intuos_pro2_bt_pad(str
 	if (ring > 71)
 		ring -= 72;
 
-	wacom_report_numbered_buttons(pad_input, 9, buttons);
+	wacom_report_numbered_buttons(pad_input, nbuttons,
+                                      expresskeys | (center << (nbuttons - 1)));
 
 	input_report_abs(pad_input, ABS_WHEEL, ringstatus ? ring : 0);
 


