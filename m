Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FB845B07DE
	for <lists+stable@lfdr.de>; Wed,  7 Sep 2022 17:02:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230100AbiIGPCt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Sep 2022 11:02:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230115AbiIGPCs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Sep 2022 11:02:48 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89BE3ABF21
        for <stable@vger.kernel.org>; Wed,  7 Sep 2022 08:02:46 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id r18so3783547eja.11
        for <stable@vger.kernel.org>; Wed, 07 Sep 2022 08:02:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=yngvason-is.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=WAheL4HPHNwvgOLLenXson8oVvgZbabyb428S9NGB+Q=;
        b=z2HvOtaSoOokZtlpJCwwDaEIxHqfmxUmQLeyhQ8BZkbUHoav2qYIcp+S2dMQxIsZeD
         hFnmztkJtAm9jq6PTYHkjK2izMVOV+fdaZgmu85mqlVCyIUdQEZLNyp4cDucRWN5w5qQ
         K40x1v4dkN46Gl2h1w+VXbuHCciij/WHdVLJ6hnaif615QOtBVOkWuZKoL/6Vws16tzU
         eKdK5VHr9m6kTByMrxJAgdMcdnXlQCM/rpYfmzKS7oB/fFhsfa2kq6hnr4e6aU+45U35
         3pRKpM+OZGOJRDXW7v5rTCDojTkpVuYkQhcyzP/NODFbcqS9u6TK0WQo3JzdwkB+aOGa
         po9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=WAheL4HPHNwvgOLLenXson8oVvgZbabyb428S9NGB+Q=;
        b=J+Wh9MuAuuIVhdJZN6XIWquQKDjwHjf1SDJi1VGH41/cmVd/Y7x4JVkl0RMxZStSHC
         3ZcXsihB2UkMG1RK86CvG5k+fOuvkjvQy9TIjqbRqqUq7LTRWogqNeEaL9GX8+vIgYX+
         I0dVrwB1NjJAIIN2y+jxx7L/XXxDdTypY1FA1sermmKARex/B6G5Ax1Z6XHzpmPMxlm9
         3NirmXkDLANiwVwGYN5yWeqOfQTsxxot7CHo3w/b9YtZwcnXAedgzClQ7J6Qe41SMabL
         4zKEiW75QkF2Fbn6ZcJIIbfziQHV0r1cTgL5qQVFMkekkA/6lVPie7rLegSrWJv+MM5u
         Y1+g==
X-Gm-Message-State: ACgBeo1yEzE+Rpfj2Rs2IadUp5pqKE8GYKEg1ZeKl+rMACjuH+AXmDmY
        vnQk5pli/R2l1900uxEEZYOI0w==
X-Google-Smtp-Source: AA6agR7pL/NytkbLvNQWAEJvQTicKef/lDxQePKZAJb8D3OjrBZzALblwfOUH1/xabTeg+nrmnhIkg==
X-Received: by 2002:a17:907:a422:b0:73f:18a8:4137 with SMTP id sg34-20020a170907a42200b0073f18a84137mr2734928ejc.10.1662562965027;
        Wed, 07 Sep 2022 08:02:45 -0700 (PDT)
Received: from andri-workstation.turninn.appdynamic.com ([2a01:8280:aa07:ad:7285:c2ff:fef0:4baf])
        by smtp.gmail.com with ESMTPSA id mc4-20020a170906eb4400b0073100dfa7b5sm8611654ejb.33.2022.09.07.08.02.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Sep 2022 08:02:44 -0700 (PDT)
From:   Andri Yngvason <andri@yngvason.is>
To:     Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     linux-input@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>,
        Andri Yngvason <andri@yngvason.is>, stable@vger.kernel.org
Subject: [PATCH v3 RESEND] HID: multitouch: Add memory barriers
Date:   Wed,  7 Sep 2022 15:01:59 +0000
Message-Id: <20220907150159.2285460-1-andri@yngvason.is>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This fixes broken atomic checks which cause a race between the
release-timer and processing of hid input.

I noticed that contacts were sometimes sticking, even with the "sticky
fingers" quirk enabled. This fixes that problem.

Cc: stable@vger.kernel.org
Fixes: 9609827458c3 ("HID: multitouch: optimize the sticky fingers timer")
Signed-off-by: Andri Yngvason <andri@yngvason.is>
---
 V1 -> V2: Clarified where the race is and added Fixes tag as suggested
           by Greg KH
 V2 -> V3: Fix formatting of "Fixes" tag

 drivers/hid/hid-multitouch.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 2e72922e36f5..91a4d3fc30e0 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -1186,7 +1186,7 @@ static void mt_touch_report(struct hid_device *hid,
 	int contact_count = -1;
 
 	/* sticky fingers release in progress, abort */
-	if (test_and_set_bit(MT_IO_FLAGS_RUNNING, &td->mt_io_flags))
+	if (test_and_set_bit_lock(MT_IO_FLAGS_RUNNING, &td->mt_io_flags))
 		return;
 
 	scantime = *app->scantime;
@@ -1267,7 +1267,7 @@ static void mt_touch_report(struct hid_device *hid,
 			del_timer(&td->release_timer);
 	}
 
-	clear_bit(MT_IO_FLAGS_RUNNING, &td->mt_io_flags);
+	clear_bit_unlock(MT_IO_FLAGS_RUNNING, &td->mt_io_flags);
 }
 
 static int mt_touch_input_configured(struct hid_device *hdev,
@@ -1699,11 +1699,11 @@ static void mt_expired_timeout(struct timer_list *t)
 	 * An input report came in just before we release the sticky fingers,
 	 * it will take care of the sticky fingers.
 	 */
-	if (test_and_set_bit(MT_IO_FLAGS_RUNNING, &td->mt_io_flags))
+	if (test_and_set_bit_lock(MT_IO_FLAGS_RUNNING, &td->mt_io_flags))
 		return;
 	if (test_bit(MT_IO_FLAGS_PENDING_SLOTS, &td->mt_io_flags))
 		mt_release_contacts(hdev);
-	clear_bit(MT_IO_FLAGS_RUNNING, &td->mt_io_flags);
+	clear_bit_unlock(MT_IO_FLAGS_RUNNING, &td->mt_io_flags);
 }
 
 static int mt_probe(struct hid_device *hdev, const struct hid_device_id *id)
-- 
2.37.2

