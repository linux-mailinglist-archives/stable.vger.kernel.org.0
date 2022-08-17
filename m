Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C7335975C2
	for <lists+stable@lfdr.de>; Wed, 17 Aug 2022 20:35:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240742AbiHQSd6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Aug 2022 14:33:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240725AbiHQSd5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Aug 2022 14:33:57 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBDF59C225
        for <stable@vger.kernel.org>; Wed, 17 Aug 2022 11:33:54 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id s11so18590269edd.13
        for <stable@vger.kernel.org>; Wed, 17 Aug 2022 11:33:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=yngvason-is.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=6i6ayWnhR1zMJy9NyiUgI/t4FYFq0Yi0SNjOjQD6U8k=;
        b=UeiglWLhdDoCkncVHqAG/7dJLln54fFh79O2NDnU0QRQPNNJwdNaDDVBwIedzvs0S/
         FJLCdlTxr5A4QjuJ9R4yT1vcW461PIT+JomdcWu+i5sprrKdUbKbHQrpTJg9ecl4ES7Y
         tkPMzHvLA3vYmB+zdiLv8tvaz0Ev+z6PlGgnZpwQyUpjosYgZxolh2obPWAs+CdLyz8I
         NgBE67jHhwg7CB20xQ8Q3ifVWUznDWV194RNZQMbTNaUJEZgPUmE5ZeX116roa2XWEvf
         rdoDGaBEQZw9vALdq/V9ZK46UgYn+PZGfsSFmph014ByCMCwt3tFoxkr9I8CMuW6GsBJ
         e/aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=6i6ayWnhR1zMJy9NyiUgI/t4FYFq0Yi0SNjOjQD6U8k=;
        b=40vtvaMEaVMgwVwGdREq+CPARJwnCNDN9Ow5IC+bs/EygyNQpysJiLRc5AF5GvjxO0
         G4NXS9j+VMsT95ulX2/qOleMMS1IeHtthvWTQgQjKNDqfEJTvavK8N7b8Cv9JhpvLFj1
         MB8H/lZsXFG76xHbCBCKAtYyyiSQvBjHMmvQjZZ0Y84bQv2p08lPMrxWflldW748R+lf
         BmiYXklgUwRfN+RHUBCSdMkGg5ZLGqkFtoJrY9aXZnTlHV0tG1EoCJR3ZCCwwbMX4DMY
         cF96N9vJnCXhc1tpkOS3emvzv8SoRUA2bYytdoWChJAHxi2YF9MQlATcn6hwBvGjhSi7
         6eBg==
X-Gm-Message-State: ACgBeo2YePej0ApFh28MqKeTa5saCUwfdove7HAXpD9NUmKbsjnDaVVL
        mrFtOBBmk/869m53MnXDxOdNjQ==
X-Google-Smtp-Source: AA6agR44eGLlMPmRW9BkpSTxEloVBT1PXwvDJQkNK2K702uD5qAysm57U8YxkmEXJKujvxSzYryhXQ==
X-Received: by 2002:a05:6402:5249:b0:43c:cb3e:d7f8 with SMTP id t9-20020a056402524900b0043ccb3ed7f8mr24591429edd.56.1660761233337;
        Wed, 17 Aug 2022 11:33:53 -0700 (PDT)
Received: from andri-workstation.turninn.appdynamic.com ([2a01:8280:aa07:ad:7285:c2ff:fef0:4baf])
        by smtp.gmail.com with ESMTPSA id ee14-20020a056402290e00b00445b3cab975sm2826218edb.56.2022.08.17.11.33.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Aug 2022 11:33:52 -0700 (PDT)
From:   Andri Yngvason <andri@yngvason.is>
To:     Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     linux-input@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>,
        Andri Yngvason <andri@yngvason.is>, stable@vger.kernel.org
Subject: [PATCH v3] HID: multitouch: Add memory barriers
Date:   Wed, 17 Aug 2022 18:31:41 +0000
Message-Id: <20220817183140.3566170-1-andri@yngvason.is>
X-Mailer: git-send-email 2.37.1
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
2.37.1

