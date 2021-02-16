Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 708A231D116
	for <lists+stable@lfdr.de>; Tue, 16 Feb 2021 20:43:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbhBPTmq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Feb 2021 14:42:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbhBPTml (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Feb 2021 14:42:41 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36298C06174A;
        Tue, 16 Feb 2021 11:42:01 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id c19so1375426pjq.3;
        Tue, 16 Feb 2021 11:42:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xiaixDEx+40UcqF9MHu0BuJvy9P/v7Jvjumb+nWcDfQ=;
        b=OgVOSu/xzktvOu1nQj0J8A8PELQNnJ0K7kKMXjJqGcZ8wdxYIkTMl1ysWmpPwn2MJW
         w/HC91i5Vc17N2C1QYRufzPKMkJIHCMOOxYXo8HaiMsd6/xoLJ6QIW/qtwZ6Dr5cV8ha
         fuSi9p6oZbg7ZnwtwOdI6bV444wZTWJtZ0axoRVSsgmS1J7qrDVtFoDSI3yz/R9NJqe0
         mnsP2km8J9w729gaj5p26SUrxv9W3JbP7R0pnEdTiAPNrp6I0hYnUJijrwUcK4pfNnza
         xHUwgX9B0o3Gvxhs/wOf4+O8AcvorT7eqvWSf67G4YHV5mOg/GfG8AOHU2egmRqNR/DZ
         iF+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xiaixDEx+40UcqF9MHu0BuJvy9P/v7Jvjumb+nWcDfQ=;
        b=LWZzG4iExe9Qz032bZEpOSGgOooR/4wPQyfhX163w4H7oWeqY1uqP8PGXKv2Xw+6kp
         TBN5p+bnYKzJ1P5alzoLSW691zdCvbOYYo65cXd9Q3r+a4kkuMxWVgZkofq8zsHmKDUy
         wG5ZjKuUxdKpvGn1kPUCn5n8z6Fz7WlmO9PA2L0AdoZZMTnkOvDwJZrcsUTDjgLdOVpl
         jxT+uVJSpK4LC5WS20gQ98I9VGLcyfqjmgTkZhoFGRdBfiMrxZF4wmYfkOxmxrn+nFXT
         UCwC/HRks+0/rRJGGoL/y218mTmnyt8CHdzwwvnc+oYd2tom3unJcnWCkQ4fGd3/u/bu
         R+oA==
X-Gm-Message-State: AOAM53073Y6gIHQ8GlzTThY6bEJ6A2EiCrJaR71vF1pAWmZiLeOi6Kwd
        m5/6N0mg4GEoFHtuN7pysK8VZei//AX2DQ==
X-Google-Smtp-Source: ABdhPJw25kDuR+ISuKikfCP7YUyhMod9oga8bFtnUFH512/fVn6IErza9gq+onI4ib0hqNplkhjL0A==
X-Received: by 2002:a17:902:7083:b029:e2:e330:7eaf with SMTP id z3-20020a1709027083b02900e2e3307eafmr21610753plk.18.1613504520573;
        Tue, 16 Feb 2021 11:42:00 -0800 (PST)
Received: from horus.lan (71-34-88-219.ptld.qwest.net. [71.34.88.219])
        by smtp.gmail.com with ESMTPSA id x12sm21358316pfp.214.2021.02.16.11.41.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Feb 2021 11:41:59 -0800 (PST)
From:   Jason Gerecke <killertofu@gmail.com>
X-Google-Original-From: Jason Gerecke <jason.gerecke@wacom.com>
To:     linux-input@vger.kernel.org, Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     Ping Cheng <pinglinux@gmail.com>,
        Aaron Armstrong Skomra <skomra@gmail.com>,
        Jason Gerecke <jason.gerecke@wacom.com>, stable@vger.kernel.org
Subject: [PATCH] HID: wacom: Ignore attempts to overwrite the touch_max value from HID
Date:   Tue, 16 Feb 2021 11:41:54 -0800
Message-Id: <20210216194154.111950-1-jason.gerecke@wacom.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The `wacom_feature_mapping` function is careful to only set the the
touch_max value a single time, but this care does not extend to the
`wacom_wac_finger_event` function. In particular, if a device sends
multiple HID_DG_CONTACTMAX items in a single feature report, the
driver will end up retaining the value of last item.

The HID descriptor for the Cintiq Companion 2 does exactly this. It
incorrectly sets a "Report Count" of 2, which will cause the driver
to process two HID_DG_CONTACTCOUNT items. The first item has the actual
count, while the second item should have been declared as a constant
zero. The constant zero is the value the driver ends up using, however,
since it is the last HID_DG_CONTACTCOUNT in the report.

    Report ID (16),
    Usage (Contact Count Maximum),  ; Contact count maximum (55h, static value)
    Report Count (2),
    Logical Maximum (10),
    Feature (Variable),

To address this, we add a check that the touch_max is not already set
within the `wacom_wac_finger_event` function that processes the
HID_DG_TOUCHMAX item. We emit a warning if the value is set and ignore
the updated value.

This could potentially cause problems if there is a tablet which has
a similar issue but requires the last item to be used. This is unlikely,
however, since it would have to have a different non-zero value for
HID_DG_CONTACTMAX earlier in the same report, which makes no sense
except in the case of a firmware bug. Note that cases where the
HID_DG_CONTACTMAX items are in different reports is already handled
(and similarly ignored) by `wacom_feature_mapping` as mentioned above.

Link: https://github.com/linuxwacom/input-wacom/issues/223
Fixes: 184eccd40389 ("HID: wacom: generic: read HID_DG_CONTACTMAX from any feature report")
Signed-off-by: Jason Gerecke <jason.gerecke@wacom.com>
CC: stable@vger.kernel.org
---
 drivers/hid/wacom_wac.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/wacom_wac.c b/drivers/hid/wacom_wac.c
index 1bd0eb71559c..44d715c12f6a 100644
--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -2600,7 +2600,12 @@ static void wacom_wac_finger_event(struct hid_device *hdev,
 		wacom_wac->is_invalid_bt_frame = !value;
 		return;
 	case HID_DG_CONTACTMAX:
-		features->touch_max = value;
+		if (!features->touch_max) {
+			features->touch_max = value;
+		} else {
+			hid_warn(hdev, "%s: ignoring attempt to overwrite non-zero touch_max "
+				 "%d -> %d\n", __func__, features->touch_max, value);
+		}
 		return;
 	}
 
-- 
2.30.1

