Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1343C36B52D
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 16:44:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233501AbhDZOpR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 10:45:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231862AbhDZOpQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Apr 2021 10:45:16 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62117C061756
        for <stable@vger.kernel.org>; Mon, 26 Apr 2021 07:44:33 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id 124so7625094lff.5
        for <stable@vger.kernel.org>; Mon, 26 Apr 2021 07:44:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=codecoup-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iEyaa+KdKO3/TwjRJSjJ8eqEKt844NBhvTEl0BWfZcM=;
        b=J7YqrOxB45f6FqOPJ+EnPOZkPr9NP3jlbPiezx6Zi5KF0jd4ZYqpCItlvm1HBYfyLP
         Qdu0ay9LuCmb3mGXGF1Zz5H3Fb2HG6M+80ZofyZteczJkXcyz8nbn7upFXZUrrVXraXt
         fKSnc3qkF+w4G8nzxvGGCQ5yoUgiHvsZRlwlMYWwOHRP4yqEe1lTpFbNIB8hEtYLq7kp
         zpTmLH1A5ogDBdDI5soVBzb0mLKe0IwFFKCUP5025YOoZBHRRgkuMVzJN+gE0qn04jUb
         Ev0KmGHYweqpkml3zdAy8dCTTw6NoGBv//hVsrUHhqbb9DuClEY7PZBN1B/QkB3R3yiE
         RasQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iEyaa+KdKO3/TwjRJSjJ8eqEKt844NBhvTEl0BWfZcM=;
        b=khVuog2+9oQ/HAmARvKd0vzYjIUptvb5JSg9y/VC7zsig8QbrFb/4JwsNJLkvyhDSt
         X8TX8u9CzfE41Mcs18vsXgwoyvi9iMuXDwBixCsdP73Ip2Xf+7uRUcLb2cRvgbt9EzW4
         8a9UZ4IauNOL6s3HozCS1Ez1PE7Yh5hmjgm0lDeLNAcVar2dV3ml4Xz6KxY6LflH3uXw
         xuHtlFLn2TGA/S9/sLBjl1UwLwEJzVgoIG2SEhASGV7i7n1KHOrxchy0Bx/zgUsqcSts
         mtHePlTlRR6UywKxVfPA4Bg9JP2BRot/g4MBOSyIU0GFHaLiSDYk/Jg+6VsWs4BgKVGf
         6BEA==
X-Gm-Message-State: AOAM530qHbYvdtghdp0svPbEK67Mn/1xHTZS5UA/mU4+pxKiVep8k2sh
        LVQa67yjTjdFsPc37ENW90vVw9HynRB7xerJ
X-Google-Smtp-Source: ABdhPJzYnzbHgYvM7KhY2kXFkTFJ++vIkuJuCDzYHKyAtyJqIzlV46qaMJmeBJb7fCpuDs8hmJN5Uw==
X-Received: by 2002:ac2:4d10:: with SMTP id r16mr12745692lfi.643.1619448271909;
        Mon, 26 Apr 2021 07:44:31 -0700 (PDT)
Received: from localhost.localdomain (45-11-60-42.ip4.greenlan.pl. [45.11.60.42])
        by smtp.gmail.com with ESMTPSA id n10sm1421728lfu.216.2021.04.26.07.44.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Apr 2021 07:44:31 -0700 (PDT)
From:   Szymon Janc <szymon.janc@codecoup.pl>
To:     linux-bluetooth@vger.kernel.org
Cc:     Szymon Janc <szymon.janc@codecoup.pl>, stable@vger.kernel.org
Subject: [PATCH v2] Bluetooth: Make spurious error message debug
Date:   Mon, 26 Apr 2021 16:44:19 +0200
Message-Id: <20210426144419.451157-1-szymon.janc@codecoup.pl>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Even with rate limited reporting this is very spammy and since
it is remote device that is providing bogus data there is no
need to report this as error.

[72454.143336] bt_err_ratelimited: 10 callbacks suppressed
[72454.143337] Bluetooth: hci0: advertising data len corrected
[72454.296314] Bluetooth: hci0: advertising data len corrected
[72454.892329] Bluetooth: hci0: advertising data len corrected
[72455.051319] Bluetooth: hci0: advertising data len corrected
[72455.357326] Bluetooth: hci0: advertising data len corrected
[72455.663295] Bluetooth: hci0: advertising data len corrected
[72455.787278] Bluetooth: hci0: advertising data len corrected
[72455.942278] Bluetooth: hci0: advertising data len corrected
[72456.094276] Bluetooth: hci0: advertising data len corrected
[72456.249137] Bluetooth: hci0: advertising data len corrected
[72459.416333] bt_err_ratelimited: 13 callbacks suppressed
[72459.416334] Bluetooth: hci0: advertising data len corrected
[72459.721334] Bluetooth: hci0: advertising data len corrected
[72460.011317] Bluetooth: hci0: advertising data len corrected
[72460.327171] Bluetooth: hci0: advertising data len corrected
[72460.638294] Bluetooth: hci0: advertising data len corrected
[72460.946350] Bluetooth: hci0: advertising data len corrected
[72461.225320] Bluetooth: hci0: advertising data len corrected
[72461.690322] Bluetooth: hci0: advertising data len corrected
[72462.118318] Bluetooth: hci0: advertising data len corrected
[72462.427319] Bluetooth: hci0: advertising data len corrected
[72464.546319] bt_err_ratelimited: 7 callbacks suppressed
[72464.546319] Bluetooth: hci0: advertising data len corrected
[72464.857318] Bluetooth: hci0: advertising data len corrected
[72465.163332] Bluetooth: hci0: advertising data len corrected
[72465.278331] Bluetooth: hci0: advertising data len corrected
[72465.432323] Bluetooth: hci0: advertising data len corrected
[72465.891334] Bluetooth: hci0: advertising data len corrected
[72466.045334] Bluetooth: hci0: advertising data len corrected
[72466.197321] Bluetooth: hci0: advertising data len corrected
[72466.340318] Bluetooth: hci0: advertising data len corrected
[72466.498335] Bluetooth: hci0: advertising data len corrected
[72469.803299] bt_err_ratelimited: 10 callbacks suppressed

Signed-off-by: Szymon Janc <szymon.janc@codecoup.pl>
Fixes: https://bugzilla.kernel.org/show_bug.cgi?id=203753
Cc: stable@vger.kernel.org
---
 net/bluetooth/hci_event.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 5e99968939ce..2a27d5764ba0 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -5476,8 +5476,8 @@ static void process_adv_report(struct hci_dev *hdev, u8 type, bdaddr_t *bdaddr,
 
 	/* Adjust for actual length */
 	if (len != real_len) {
-		bt_dev_err_ratelimited(hdev, "advertising data len corrected %u -> %u",
-				       len, real_len);
+		bt_dev_dbg(hdev, "advertising data len corrected %u->%u",
+			   len, real_len);
 		len = real_len;
 	}
 
-- 
2.30.2

