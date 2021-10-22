Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32E064380A2
	for <lists+stable@lfdr.de>; Sat, 23 Oct 2021 01:29:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232099AbhJVXbh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Oct 2021 19:31:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230086AbhJVXbh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Oct 2021 19:31:37 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14BCEC061764;
        Fri, 22 Oct 2021 16:29:19 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id q2-20020a17090a2e0200b001a0fd4efd49so8420353pjd.1;
        Fri, 22 Oct 2021 16:29:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3Q6iLLHmsihC44JANxHNZh042pUr1io1ZQkDcpjym1o=;
        b=Bw1b0nCs6AFh9GGZszUb0Gh1uAeSCi7J0PfpbV0e8E/LQYYMmDW7NamcjVV27jQjsq
         tT9z9OKReRoO0SxL+mK9eiOX7liHezL7oyquTU/HHAPFOFW/NktXsy7GJHTvk2sl2brz
         uIGq7VKf8fOP5mvb/DC/Q+E+jRNXNh5lYSS0qBVaxTLja45Xcgb1KQwZfLs0l7MbwCI4
         wMjcD86NdL2esw0dlnohpJK9OvnMxUPzruP7nNUCo+INCTJ1cbQ99ipZId39RAq2DY6x
         1rU5Tv+Gu/KSEyiAPh///7l+3v479CSs14FR8H0JvszeHD4dES83+Pm3tzQUYjrT9BVs
         mo9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3Q6iLLHmsihC44JANxHNZh042pUr1io1ZQkDcpjym1o=;
        b=Sg+73Wuq+nnXxHq+z0SzFxb06H4rWfp4PnqRaivv1i26gCTWa08X0heQ1SK7ZB4Qw0
         lY6EhTtzRZWsFXlFHSTk0PPXRVpTn00JhHz8vorywS1Ku5FpOIMI+FiL8VxfbhQFt4mm
         EoWSJNfbf3i5JptcOJniI+AUarL8yMDxFdHc8SKxt8oTBfZW/4qSFUQH2QHv5Opb51EA
         B8c7W4olwuJlrZRHmQ+k9Q3aqDMsw+UH8Hbe0JM+6a5JEcHjpcf+l4bJ4ucID9bj1526
         xtBlD7K5VMLvxLE0zQkqyIZPZ3tHmq+iauz9zst1/ks216XU25gRcy2TPZLkWSgpyrz2
         L6pg==
X-Gm-Message-State: AOAM5302d8XapISCMi7CTcDFt7IZ5rZOejp5p7iS45g2ix5I2nMrvBm7
        XFlvDnKNbij0yAbbLVvLt/TGc/I6ZB3emw==
X-Google-Smtp-Source: ABdhPJxwo84oTU0Xc6NMSVrp987XOoTz3aYgBIOm6jCU9LOPkiXGQ5/ueSsLmkYSGoQQ8vFLwAMuaQ==
X-Received: by 2002:a17:903:2312:b0:140:26b7:fc01 with SMTP id d18-20020a170903231200b0014026b7fc01mr2384586plh.84.1634945358602;
        Fri, 22 Oct 2021 16:29:18 -0700 (PDT)
Received: from localhost.localdomain ([2601:1c2:4f03:fea0:28f7:ecd6:6877:a8e])
        by smtp.gmail.com with ESMTPSA id b6sm12575440pfv.171.2021.10.22.16.29.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Oct 2021 16:29:18 -0700 (PDT)
From:   Ping Cheng <pinglinux@gmail.com>
X-Google-Original-From: Ping Cheng <ping.cheng@wacom.com>
To:     jikos@kernel.org
Cc:     linux-input@vger.kernel.org, Jason.Gerecke@wacom.com,
        tatsunosuke.tobita@wacom.com, Ping Cheng <ping.cheng@wacom.com>,
        stable@vger.kernel.org, Jason Gerecke <killertofu@gmail.com>,
        Tatsunosuke Tobita <junkpainting@gmail.com>
Subject: [PATCH] HID: input: fix the incorrectly reported BTN_TOOL_RUBBER/PEN tools
Date:   Fri, 22 Oct 2021 16:28:37 -0700
Message-Id: <20211022232837.18988-1-ping.cheng@wacom.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The HID_QUIRK_INVERT caused BTN_TOOL_RUBBER events were reported at the
same time as events for BTN_TOOL_PEN/PENCIL/etc, if HID_QUIRK_INVERT
was set by a stylus' sideswitch. The reality is that a pen can only be
a stylus (writing/drawing) or an eraser, but not both at the same time.
This patch makes that logic correct.

CC: stable@vger.kernel.org # 2.4+
Signed-off-by: Ping Cheng <ping.cheng@wacom.com>
Reviewed-by: Jason Gerecke <killertofu@gmail.com>
Tested-by: Tatsunosuke Tobita <junkpainting@gmail.com>
---
 drivers/hid/hid-input.c | 24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index 4b5ebeacd283..85741a2d828d 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -1344,12 +1344,28 @@ void hidinput_hid_event(struct hid_device *hid, struct hid_field *field, struct
 	}
 
 	if (usage->hid == HID_DG_INRANGE) {
+		/* when HID_QUIRK_INVERT is set by a stylus sideswitch, HID_DG_INRANGE could be
+		 * for stylus or eraser. Make sure events are only posted to the current valid tool:
+		 * BTN_TOOL_RUBBER vs BTN_TOOL_PEN/BTN_TOOL_PENCIL/BTN_TOOL_BRUSH/etc since a pen
+		 * can not be used as a stylus (to draw/write) and an erasaer at the same time
+		 */
+		static unsigned int last_code = 0;
+		unsigned int code = (*quirks & HID_QUIRK_INVERT) ? BTN_TOOL_RUBBER : usage->code;
 		if (value) {
-			input_event(input, usage->type, (*quirks & HID_QUIRK_INVERT) ? BTN_TOOL_RUBBER : usage->code, 1);
-			return;
+			if (code != last_code) {
+				/* send the last tool out before allow the new one in */
+				if (last_code)
+					input_event(input, usage->type, last_code, 0);
+				input_event(input, usage->type, code, 1);
+			}
+			last_code = code;
+		} else {
+			/* only send the last valid tool out */
+			if (last_code)
+				input_event(input, usage->type, last_code, 0);
+			/* reset tool for next cycle */
+			last_code = 0;
 		}
-		input_event(input, usage->type, usage->code, 0);
-		input_event(input, usage->type, BTN_TOOL_RUBBER, 0);
 		return;
 	}
 
-- 
2.25.1

