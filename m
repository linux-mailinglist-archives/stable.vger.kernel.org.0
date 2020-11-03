Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE8DE2A5537
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:21:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387868AbgKCVGo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:06:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:45680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388199AbgKCVGm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 16:06:42 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B985420658;
        Tue,  3 Nov 2020 21:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437601;
        bh=gtGJRTeE1GYtV8jUwiVQZ1nLMsjyOwDDWUZtwMSjvA4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FMoA6m/8TWVxnqVQnd2nTIwy1UEtbBA1GhHmf3fbRQZkTP2o7AH+/PHBQTNVCA7hP
         fJNsx6UazW07JQSzxlvYa8GQ0+NwNhwoFHU7g8bUh5Fct7IQwtephvUx/dlGXEDhPH
         8mcYaxZQHyExuMdXszxDeYwn1RJjQTxYpwqdPV7A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Gerecke <jason.gerecke@wacom.com>,
        Ping Cheng <ping.cheng@wacom.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 4.19 146/191] HID: wacom: Avoid entering wacom_wac_pen_report for pad / battery
Date:   Tue,  3 Nov 2020 21:37:18 +0100
Message-Id: <20201103203246.442871831@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203232.656475008@linuxfoundation.org>
References: <20201103203232.656475008@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gerecke <jason.gerecke@wacom.com>

commit d9216d753b2b1406b801243b12aaf00a5ce5b861 upstream.

It has recently been reported that the "heartbeat" report from devices
like the 2nd-gen Intuos Pro (PTH-460, PTH-660, PTH-860) or the 2nd-gen
Bluetooth-enabled Intuos tablets (CTL-4100WL, CTL-6100WL) can cause the
driver to send a spurious BTN_TOUCH=0 once per second in the middle of
drawing. This can result in broken lines while drawing on Chrome OS.

The source of the issue has been traced back to a change which modified
the driver to only call `wacom_wac_pad_report()` once per report instead
of once per collection. As part of this change, pad-handling code was
removed from `wacom_wac_collection()` under the assumption that the
`WACOM_PEN_FIELD` and `WACOM_TOUCH_FIELD` checks would not be satisfied
when a pad or battery collection was being processed.

To be clear, the macros `WACOM_PAD_FIELD` and `WACOM_PEN_FIELD` do not
currently check exclusive conditions. In fact, most "pad" fields will
also appear to be "pen" fields simply due to their presence inside of
a Digitizer application collection. Because of this, the removal of
the check from `wacom_wac_collection()` just causes pad / battery
collections to instead trigger a call to `wacom_wac_pen_report()`
instead. The pen report function in turn resets the tip switch state
just prior to exiting, resulting in the observed BTN_TOUCH=0 symptom.

To correct this, we restore a version of the `WACOM_PAD_FIELD` check
in `wacom_wac_collection()` and return early. This effectively prevents
pad / battery collections from being reported until the very end of the
report as originally intended.

Fixes: d4b8efeb46d9 ("HID: wacom: generic: Correct pad syncing")
Cc: stable@vger.kernel.org # v4.17+
Signed-off-by: Jason Gerecke <jason.gerecke@wacom.com>
Reviewed-by: Ping Cheng <ping.cheng@wacom.com>
Tested-by: Ping Cheng <ping.cheng@wacom.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/wacom_wac.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -2729,7 +2729,9 @@ static int wacom_wac_collection(struct h
 	if (report->type != HID_INPUT_REPORT)
 		return -1;
 
-	if (WACOM_PEN_FIELD(field) && wacom->wacom_wac.pen_input)
+	if (WACOM_PAD_FIELD(field))
+		return 0;
+	else if (WACOM_PEN_FIELD(field) && wacom->wacom_wac.pen_input)
 		wacom_wac_pen_report(hdev, report);
 	else if (WACOM_FINGER_FIELD(field) && wacom->wacom_wac.touch_input)
 		wacom_wac_finger_report(hdev, report);


