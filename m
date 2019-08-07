Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51435854FC
	for <lists+stable@lfdr.de>; Wed,  7 Aug 2019 23:12:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730363AbfHGVMV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Aug 2019 17:12:21 -0400
Received: from mail-pf1-f177.google.com ([209.85.210.177]:38294 "EHLO
        mail-pf1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729714AbfHGVMV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Aug 2019 17:12:21 -0400
Received: by mail-pf1-f177.google.com with SMTP id y15so42807953pfn.5;
        Wed, 07 Aug 2019 14:12:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=J1+VJ4niA/UgLG1ksIGoQZvmRO/g/peOr4UQIkN8vIs=;
        b=LnRYBRS1LHJpKoI3Lw8PI9mx7Ov7TuO6NZNOOQi7L/MH3BByN2kh7Gx+AzVyp2CNh/
         6g45oDCE2xr9YtFTuUnuiyBl1xonhfdBa931cq/h7MICF4vIBZ7jbezFvYiF6e+uMBEP
         9dyB9wicWQZL7sH30LeiJLu23hMKKs8WJo1848YIC6/KQIpuY9ZXb0igKVUMTBvm7KxD
         sN6NmvM4+1e8Bjq0SCZrijls1L6bxQlFV53XCOFrGJeOMkosd2NbVFrzp7k7gbR2UmG4
         5aaSQ3JzSnMRfXAHjBXUifLSIN6Dgpa+atFKX250w1PZLunEAAqb59KZmDrE5Ecpq7WQ
         t87Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=J1+VJ4niA/UgLG1ksIGoQZvmRO/g/peOr4UQIkN8vIs=;
        b=f85maHRTtDZXPFf7wKkGY6FrYxd/Hf2ceW6wsLrw06VR9isFgxLKsYIwCVWdEhNUL7
         N5/II7CrbCKQ6yGLMsHt0PY7EdbKLJFx7c/uxItQ2J/0OmBZ6nqf1XLaYMiaRrR2F1kV
         UjBbaJGXVbxvCmbuoJP9sg367wN7sOnpvyKdLu+5oMk02wMSy3iidi5yyytD8SRH/c+K
         jaZzZII5kjrUnYzX92V9ILRe4iuWp2TrAoz/2A7uJ9p20AyuHTt2pkqhpzcVE+G+NZ9T
         ZuWj+Kn808j/j2jvXnlrZ+k2l4nA1HZI1UaZhGGk9dINR8Ng8TKrBMZtzhn5kAJH6jng
         HEHg==
X-Gm-Message-State: APjAAAU6K6cWUpzeAju3NeKJUDwR9dXhIv1QnYm5+qThUiKM8tdXjAgK
        zVsXHJ27Dv+Uk0RgAyMsYnL7gw+1
X-Google-Smtp-Source: APXvYqxi0FHFgLsJQ0OdxFKfN0IznT7yo1Pw88vEiiYOuKUVNDMtmrnecK/uDj+vORiQpjQW2U1dcQ==
X-Received: by 2002:a17:90a:bf03:: with SMTP id c3mr390067pjs.112.1565212340188;
        Wed, 07 Aug 2019 14:12:20 -0700 (PDT)
Received: from US-191-ENG0002.corp.onewacom.com ([50.225.60.4])
        by smtp.gmail.com with ESMTPSA id v63sm95562122pfv.174.2019.08.07.14.12.18
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 07 Aug 2019 14:12:18 -0700 (PDT)
From:   "Gerecke, Jason" <killertofu@gmail.com>
X-Google-Original-From: "Gerecke, Jason" <jason.gerecke@wacom.com>
To:     linux-input@vger.kernel.org, Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     Ping Cheng <pinglinux@gmail.com>,
        Aaron Armstrong Skomra <skomra@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Jason Gerecke <jason.gerecke@wacom.com>, stable@vger.kernel.org
Subject: [PATCH v2] HID: wacom: Correct distance scale for 2nd-gen Intuos devices
Date:   Wed,  7 Aug 2019 14:11:55 -0700
Message-Id: <20190807211155.4280-1-jason.gerecke@wacom.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190807051839.GA26833@kroah.com>
References: <20190807051839.GA26833@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gerecke <jason.gerecke@wacom.com>

Distance values reported by 2nd-gen Intuos tablets are on an inverted
scale (0 == far, 63 == near). We need to change them over to a normal
scale before reporting to userspace or else userspace drivers and
applications can get confused.

Ref: https://github.com/linuxwacom/input-wacom/issues/98
Fixes: eda01dab53 ("HID: wacom: Add four new Intuos devices")
Signed-off-by: Jason Gerecke <jason.gerecke@wacom.com>
Cc: <stable@vger.kernel.org> # v4.4+
---
Make checkpatch happy -- *doh!*

 drivers/hid/wacom_wac.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/hid/wacom_wac.c b/drivers/hid/wacom_wac.c
index 7a8ddc999a8e..8e5063492242 100644
--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -846,6 +846,8 @@ static int wacom_intuos_general(struct wacom_wac *wacom)
 		y >>= 1;
 		distance >>= 1;
 	}
+	if (features->type == INTUOSHT2)
+		distance = features->distance_max - distance;
 	input_report_abs(input, ABS_X, x);
 	input_report_abs(input, ABS_Y, y);
 	input_report_abs(input, ABS_DISTANCE, distance);
-- 
2.22.0

