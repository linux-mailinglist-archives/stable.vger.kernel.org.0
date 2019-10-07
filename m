Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A197CDB44
	for <lists+stable@lfdr.de>; Mon,  7 Oct 2019 07:13:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727243AbfJGFNE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Oct 2019 01:13:04 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:36587 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726960AbfJGFND (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Oct 2019 01:13:03 -0400
Received: by mail-pg1-f196.google.com with SMTP id 23so7469447pgk.3;
        Sun, 06 Oct 2019 22:13:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fhsJu9ifDVdBBZy6wa/6bbUe5u7/Lt7fjCQ+1zFjeMQ=;
        b=XYWQbmMTCm39EJJuv+hy/3iWRt+eK4dTvdmDdFGRx+Gm/8J+/Esp4YDIzgN0NMrbNE
         qci9e+QRJeiupiIaxasYCJKAZYIkgrZdyrzrGOvS26yrfBV0lOsLbGEZeC0smiaxKHoc
         RWPBwkY5yO1S4Fz2ZgIzsqmH9egXT3b9b/q3vvdwjcV5Slf9ednC0gol/03b4HXzMovk
         1F5kebzmmEMA0zUfkuwm/ptByCsQ8KcdV73RzI5ft1duyG664yLH/PX4zmgLg9sot/IE
         rzjuvxdJNLLvr02X9TsYKEPbfE6sYv21iSydVU5tT8WLnnw6MxVdF3oAZJDZrIZeOwfW
         d1Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fhsJu9ifDVdBBZy6wa/6bbUe5u7/Lt7fjCQ+1zFjeMQ=;
        b=mk74b35gefKJesYFnRYQq931Ob7mOm7t6uOJ8mt+Op7xkjebVfqOkMVcw+txwvckAP
         mb/W+nDqKRM56zRQAiibjocBHuNOaKX21+WcdIgetehs1tq4JizP+U3QM5QJ3nwE2eMB
         EUKOYYuBZKICT24L2fxz4S3EFX3lFvyJ3lB9SHz0KFWiHA+8FlrJNmyhdr6l8JH+j0au
         /Zh4n1qLSiCKYVHjmeyQKS5cG09EjIyfkXa6d9s76sYqEjksWpQclUs7/jD+vTSkF8Lc
         3Xpq8rtb+6exytYAYGLuNmCNbENsWzbLYwQiezE69eA27/8NgKq7yhl3VBXdJYvyAApc
         naiA==
X-Gm-Message-State: APjAAAXISwbfeTpUj5aj0inj2/RmajpsYlGzfHlJXymOPQsgbOU/zedt
        FKFmMfmjezl+Jwb3yG4T5At4lVgtQyY=
X-Google-Smtp-Source: APXvYqz3f+93cuyblxUBsA+IZs4GCKkufudySWoXOpUrhuUyfg/ARnzX7WJYHiAH2l4sZ8nJfTe5mQ==
X-Received: by 2002:a17:90a:1990:: with SMTP id 16mr31070722pji.47.1570425182270;
        Sun, 06 Oct 2019 22:13:02 -0700 (PDT)
Received: from localhost.lan (c-67-185-54-80.hsd1.wa.comcast.net. [67.185.54.80])
        by smtp.gmail.com with ESMTPSA id v133sm2209680pgb.74.2019.10.06.22.13.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Oct 2019 22:13:01 -0700 (PDT)
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
To:     linux-input@vger.kernel.org
Cc:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        Sam Bazely <sambazley@fastmail.com>,
        Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Henrik Rydberg <rydberg@bitmath.org>,
        "Pierre-Loup A . Griffais" <pgriffais@valvesoftware.com>,
        Austin Palmer <austinp@valvesoftware.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH 3/3] HID: logitech-hidpp: add G920 device validation quirk
Date:   Sun,  6 Oct 2019 22:12:40 -0700
Message-Id: <20191007051240.4410-4-andrew.smirnov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191007051240.4410-1-andrew.smirnov@gmail.com>
References: <20191007051240.4410-1-andrew.smirnov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

G920 device only advertises REPORT_ID_HIDPP_LONG and
REPORT_ID_HIDPP_VERY_LONG in its HID report descriptor, so querying
for REPORT_ID_HIDPP_SHORT with optional=false will always fail and
prevent G920 to be recognized as a valid HID++ device.

Modify hidpp_validate_device() to check only REPORT_ID_HIDPP_LONG with
optional=false on G920 to fix this.

Fixes: fe3ee1ec007b ("HID: logitech-hidpp: allow non HID++ devices to be handled by this module")
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=204191
Reported-by: Sam Bazely <sambazley@fastmail.com>
Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
Cc: Jiri Kosina <jikos@kernel.org>
Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: Henrik Rydberg <rydberg@bitmath.org>
Cc: Sam Bazely <sambazley@fastmail.com>
Cc: Pierre-Loup A. Griffais <pgriffais@valvesoftware.com>
Cc: Austin Palmer <austinp@valvesoftware.com>
Cc: linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
---
 drivers/hid/hid-logitech-hidpp.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/hid/hid-logitech-hidpp.c
index cadf36d6c6f3..f415bf398e17 100644
--- a/drivers/hid/hid-logitech-hidpp.c
+++ b/drivers/hid/hid-logitech-hidpp.c
@@ -3511,6 +3511,12 @@ static bool hidpp_validate_report(struct hid_device *hdev, int id,
 
 static bool hidpp_validate_device(struct hid_device *hdev)
 {
+	struct hidpp_device *hidpp = hid_get_drvdata(hdev);
+
+	if (hidpp->quirks & HIDPP_QUIRK_CLASS_G920)
+		return hidpp_validate_report(hdev, REPORT_ID_HIDPP_LONG,
+					     HIDPP_REPORT_SHORT_LENGTH, false);
+
 	return hidpp_validate_report(hdev, REPORT_ID_HIDPP_SHORT,
 				     HIDPP_REPORT_SHORT_LENGTH, false) &&
 	       hidpp_validate_report(hdev, REPORT_ID_HIDPP_LONG,
-- 
2.21.0

