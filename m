Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98CE8597532
	for <lists+stable@lfdr.de>; Wed, 17 Aug 2022 19:43:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238318AbiHQRjo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Aug 2022 13:39:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236957AbiHQRjn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Aug 2022 13:39:43 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D355551400
        for <stable@vger.kernel.org>; Wed, 17 Aug 2022 10:39:42 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id dc19so25762105ejb.12
        for <stable@vger.kernel.org>; Wed, 17 Aug 2022 10:39:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=yngvason-is.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=hKmRhzvPkxj/iylDqbWJbRrwHNFOVBo+25u4rZQjXMg=;
        b=O8gmDNqY67+531wmNzIKWoE9BQY9LZqnhiD1KayJ9GzDUDksKYYKI2P2bGENbtq9u6
         M0wiOdptQWOdtyqOo27EzAOCX3Q6T4fDhnstYn2ZPuWT9Kuk9XiC896ApqieoSylKSeS
         nl05IPRkuXb8wjXSsJ8E9rKghmmsNUPtGONX0yT+o1UqC77KWYmvDLEtEsBUSLUxjeGF
         XJhC+nkjiPmnsFbAzr6dxWjoe4kHrQXb4fEft3OFhceQFtQj6ZaLwqXWQNP7ef2FjT8i
         oaB1pS9bmru3uoTK1GdXfJEI/OzPIKTCGq3cNvSdFLwpkm3bBMOxnE2P5bu+DmHU9ncU
         acsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=hKmRhzvPkxj/iylDqbWJbRrwHNFOVBo+25u4rZQjXMg=;
        b=dFXdiWfKyihUd+KR0G5MYsEctzWhkI67Zt0v+cCvl69tlIVay3KuTrUW7pmGMMF+pI
         uIsDI6EU0Q7om4Rrvk5GcplOk1pw7JiMLHFSu3gpCKBOgZsufEuRFOeCxqB+PfTrWKU2
         vSKZ86RLpySEemO/dBxV5hdL8KVYGEy8zjjRUJRhiLiT2kRioCcykHTY71RKhVv3rgRi
         cO8mv4yiPfyR0kFqQCtROS0WTs0Cvq05LA3VWhbsIpTxNyBCkdhph4wJR7tPiTUj6p0w
         +ScuTBASSm7USAx8021zZTkD2NER9nqAr4schFyC4bzTzcTqMx9FJ+0fXnDt3teuy4nb
         XspA==
X-Gm-Message-State: ACgBeo0u49qiblerRLj/POc9lrw1opWzf0Osx6ftZqXq+SX+72PkOrHo
        3bQDAvxUOcxzean3+4DnH2RmUA==
X-Google-Smtp-Source: AA6agR4Yp3JC9R53DFOPRiJB036o3Mv6H1COoyOciEqZ7Ph9SmvnPG4aCfwNvb7SS7qvtcMaHyUu+w==
X-Received: by 2002:a17:906:8a63:b0:730:9e5c:b456 with SMTP id hy3-20020a1709068a6300b007309e5cb456mr16892514ejc.571.1660757981361;
        Wed, 17 Aug 2022 10:39:41 -0700 (PDT)
Received: from andri-workstation.turninn.appdynamic.com ([2a01:8280:aa07:ad:7285:c2ff:fef0:4baf])
        by smtp.gmail.com with ESMTPSA id gv11-20020a170906f10b00b0072af4af2f46sm6977266ejb.74.2022.08.17.10.39.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Aug 2022 10:39:40 -0700 (PDT)
From:   Andri Yngvason <andri@yngvason.is>
To:     Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     linux-input@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>,
        Andri Yngvason <andri@yngvason.is>, stable@vger.kernel.org
Subject: [PATCH v2] HID: multitouch: Add memory barriers
Date:   Wed, 17 Aug 2022 17:32:35 +0000
Message-Id: <20220817173234.3564543-1-andri@yngvason.is>
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
Fixes: 9609827458c37d7b2c37f2a9255631c603a5004c
Signed-off-by: Andri Yngvason <andri@yngvason.is>
---
 V1 -> V2: Clarified where the race is and added Fixes tag as suggested
 	   by Greg KH

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

