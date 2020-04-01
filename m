Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 737F219B784
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 23:23:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732637AbgDAVXq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 17:23:46 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:45843 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732357AbgDAVXp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Apr 2020 17:23:45 -0400
Received: by mail-pf1-f195.google.com with SMTP id r14so636229pfl.12;
        Wed, 01 Apr 2020 14:23:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=v+JmNVKhpnerqtyi8mBy4La3n5Q5nQ3lqyIBr7pcIx4=;
        b=DaIyeavSuZ3yeST1QJt+2grBgJE89cwmZD9nAzYS5dDOAWaKpd0G2bgYi3sfcfui4x
         wXt1SbGHJUZ4SoL4GDgp4qg8PLp/SxcWma6vcVSTVDT3rPqWsHUV4/0Hnuw8c2VARzZY
         5tPbvDwG9SiN4UIifdGWCzi0nDC4M6w8Fs3yJKpQ3IpaBaVY4zzPzLu0XWNPFLQcJk39
         P45VrIKmyfDSOSTc3wInoYGQllIN3a2f0c+C+EeyAAD10ejZVEyjPtKa/7tAFrFkzN1X
         P3+/vXIKInn/6kkbRoVjZGYToSLN+OSULw6BrnHiRwuw3fn+PJ+HAnWW3S0oHxdgSwOt
         tT8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=v+JmNVKhpnerqtyi8mBy4La3n5Q5nQ3lqyIBr7pcIx4=;
        b=nIE1RuO08k1qFVBocMn4EAwHLbDZdBp11qkwnH/zunrs1LnZYtGhoToI0UB5tMGHLU
         ZLiQtOR4yCnFTWcIN0P9p/HENdeQj7OJ1CpZYd/zgdDNlj2sX8F3dO4RbHKEzLSS7kxO
         oaq4STMkqxYKHcBvL169tOZ9mhjLuf/257xQGsMHuvha5lO7fWtbTUgMTqkyGwmsU1eK
         H8MOl0+SjRVtqHzySUaSns9OSu8p47StPVAn106j0zLDW0UhrKqNUl553iPYNoALVlhl
         MRNZbl9jDiYyMNfjrWAAqYyEhni88iFfEIKRbKSkOewRxnbkYibZt7hUqhNQ09+K8bEf
         H8Zw==
X-Gm-Message-State: ANhLgQ2HMSWslPKaRMPCCdXl91+2FF3JRePKfeuz/gskVKvF+LXmtAJP
        +SlUxTVQENg82ERWmxNKB/W0mnSWaVM=
X-Google-Smtp-Source: ADFU+vu+sVOiXb4CvKrhT7PgdHLFsAyVecItHB5St0Uol3GMKRq+Fp7LN6fSJ9trHkYVcpzC75PKng==
X-Received: by 2002:a62:a116:: with SMTP id b22mr26097681pff.122.1585776224556;
        Wed, 01 Apr 2020 14:23:44 -0700 (PDT)
Received: from US-191-ENG0002.lan (75-164-222-94.ptld.qwest.net. [75.164.222.94])
        by smtp.gmail.com with ESMTPSA id q22sm2248522pfn.22.2020.04.01.14.23.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Apr 2020 14:23:43 -0700 (PDT)
From:   "Gerecke, Jason" <killertofu@gmail.com>
X-Google-Original-From: "Gerecke, Jason" <jason.gerecke@wacom.com>
To:     linux-input@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Jiri Kosina <jikos@kernel.org>
Cc:     Ping Cheng <pinglinux@gmail.com>,
        Aaron Armstrong Skomra <skomra@gmail.com>,
        Jason Gerecke <jason.gerecke@wacom.com>,
        Aaron Armstrong Skomra <aaron.skomra@wacom.com>,
        stable@vger.kernel.org
Subject: [PATCH] HID: wacom: Read HID_DG_CONTACTMAX directly for non-generic devices
Date:   Wed,  1 Apr 2020 14:23:29 -0700
Message-Id: <20200401212329.23305-1-jason.gerecke@wacom.com>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gerecke <jason.gerecke@wacom.com>

We've recently switched from extracting the value of HID_DG_CONTACTMAX
at a fixed offset (which may not be correct for all tablets) to
injecting the report into the driver for the generic codepath to handle.
Unfortunately, this change was made for *all* tablets, even those which
aren't generic. Because `wacom_wac_report` ignores reports from non-
generic devices, the contact count never gets initialized. Ultimately
this results in the touch device itself failing to probe, and thus the
loss of touch input.

This commit adds back the fixed-offset extraction for non-generic devices.

Ref: https://github.com/linuxwacom/input-wacom/issues/155
Fixes: 184eccd40389 ("HID: wacom: generic: read HID_DG_CONTACTMAX from any feature report")
Signed-off-by: Jason Gerecke <jason.gerecke@wacom.com>
Reviewed-by: Aaron Armstrong Skomra <aaron.skomra@wacom.com>
CC: stable@vger.kernel.org # 5.3+
---
 drivers/hid/wacom_sys.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/wacom_sys.c b/drivers/hid/wacom_sys.c
index 5ded94b7bf68..cd71e7133944 100644
--- a/drivers/hid/wacom_sys.c
+++ b/drivers/hid/wacom_sys.c
@@ -319,9 +319,11 @@ static void wacom_feature_mapping(struct hid_device *hdev,
 			data[0] = field->report->id;
 			ret = wacom_get_report(hdev, HID_FEATURE_REPORT,
 					       data, n, WAC_CMD_RETRIES);
-			if (ret == n) {
+			if (ret == n && features->type == HID_GENERIC) {
 				ret = hid_report_raw_event(hdev,
 					HID_FEATURE_REPORT, data, n, 0);
+			} else if (ret == 2 && features->type != HID_GENERIC) {
+				features->touch_max = data[1];
 			} else {
 				features->touch_max = 16;
 				hid_warn(hdev, "wacom_feature_mapping: "
-- 
2.26.0

