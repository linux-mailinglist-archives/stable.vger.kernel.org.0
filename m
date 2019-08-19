Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1115194B8A
	for <lists+stable@lfdr.de>; Mon, 19 Aug 2019 19:20:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727794AbfHSRU4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Aug 2019 13:20:56 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:44734 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727483AbfHSRU4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Aug 2019 13:20:56 -0400
Received: by mail-pl1-f196.google.com with SMTP id t14so1264430plr.11;
        Mon, 19 Aug 2019 10:20:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=uWdwCDtMPlF5hq0FEH+qYu81o8cFADCpXoKSQ8ivLek=;
        b=SFYJalwmyQRBvKkvlFzn8QHgdWRc6Z37eBV3BYP+8iEJbiAe2MGk0PsSV2f/WyJfcI
         HbQ0dH7fEAoxv9tHc+zxy6FKCBQ2bzlu0lK/qZAj+cHoyDDYbM+MxUTemNv0j6PAqMTA
         E9eT6fv5LIgEljpjBDF9BGTu4VQ3nDXIYvQgeKd7FC8V8UXvImpsaCdqwu/asuCv+2XK
         Zjuf5n/Mht2z2YfzS/50Mv8QQaoZANk4qq0YGV0g+HdimrSQsZCHhdcDkdI8+o3CX/IY
         st3g6JcAZ/YKueQz4js6NVYzWmTptzlA7E08RZtVOAbDv/bfy9tNkDpuQ0nGsa5C09kk
         XR1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=uWdwCDtMPlF5hq0FEH+qYu81o8cFADCpXoKSQ8ivLek=;
        b=W8kPbados6B75XDbHS4/8eKIz4XlzEIdhnAVu74/mbq0lykXyF3JZZXWp+jmPYL8rD
         IWZ8tG20StJpnuNHQ49P2hD6ZYvCkEHlUuBqg4p7CWaLix2GfK6jGpuT7VQDFTjJsIkT
         ZCVt2xHQNMb1auaafHZaaTwa4NyHjAwTHWsMUcnJSk0M5STC853yF144aECsVsc6H0ty
         FNGhQtwfQjzokk/RlGTEAmdhdyOJY/AA2gjd1TjX2bNkVjhzThEzx3fhFrB5HWJYta/+
         cxht6vQ+ub6g+NWcYEfzZkCjYPcQT1yjiKPk9NkDZGA7T1yKizmR4tCTqg1KA0Ek/oQN
         tLxg==
X-Gm-Message-State: APjAAAVSAjRySaQ1EzlhwnZNhxZ9jUbk/cpUonqptNjokCaQfMTkXusz
        CqwTcaC5DDcIbphEcauZevE=
X-Google-Smtp-Source: APXvYqy0oqizQ6Kon+/I+vQ+MA1p+hIMl6O01J1Lm6doaFsJfKyC3pT2kDX439hEyCY2ns5Nwa/NqQ==
X-Received: by 2002:a17:902:145:: with SMTP id 63mr11671732plb.55.1566235255530;
        Mon, 19 Aug 2019 10:20:55 -0700 (PDT)
Received: from west.Home ([97.115.133.135])
        by smtp.googlemail.com with ESMTPSA id f6sm14974396pga.50.2019.08.19.10.20.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 19 Aug 2019 10:20:54 -0700 (PDT)
From:   Aaron Armstrong Skomra <skomra@gmail.com>
X-Google-Original-From: Aaron Armstrong Skomra <aaron.skomra@wacom.com>
To:     sashal@kernel.org, linux-input@vger.kernel.org, jikos@kernel.org,
        benjamin.tissoires@redhat.com, ping.cheng@wacom.com,
        jason.gerecke@wacom.com
Cc:     Aaron Armstrong Skomra <aaron.skomra@wacom.com>,
        "# v4 . 3+" <stable@vger.kernel.org>
Subject: [PATCH] HID: wacom: correct misreported EKR ring values
Date:   Mon, 19 Aug 2019 10:20:30 -0700
Message-Id: <1566235230-11617-1-git-send-email-aaron.skomra@wacom.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <20190817181109.33F1B2173B@mail.kernel.org>
References: <20190817181109.33F1B2173B@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The EKR ring claims a range of 0 to 71 but actually reports
values 1 to 72. The ring is used in relative mode so this
change should not affect users.

Signed-off-by: Aaron Armstrong Skomra <aaron.skomra@wacom.com>
Fixes: 72b236d60218f ("HID: wacom: Add support for Express Key Remote.")
Cc: <stable@vger.kernel.org> # v4.3+
Reviewed-by: Ping Cheng <ping.cheng@wacom.com>
Reviewed-by: Jason Gerecke <jason.gerecke@wacom.com>
---
My first attempt at sending this 
patch specifically targeted to v4.9.189

neglected the "in-reply-to" in git send-email. My apologies.

 drivers/hid/wacom_wac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/wacom_wac.c b/drivers/hid/wacom_wac.c
index 6c3bf8846b52..949761dd29ca 100644
--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -819,7 +819,7 @@ static int wacom_remote_irq(struct wacom_wac *wacom_wac, size_t len)
 	input_report_key(input, BTN_BASE2, (data[11] & 0x02));
 
 	if (data[12] & 0x80)
-		input_report_abs(input, ABS_WHEEL, (data[12] & 0x7f));
+		input_report_abs(input, ABS_WHEEL, (data[12] & 0x7f) - 1);
 	else
 		input_report_abs(input, ABS_WHEEL, 0);
 
-- 
2.17.1

