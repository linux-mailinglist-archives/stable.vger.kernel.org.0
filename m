Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84E243874C9
	for <lists+stable@lfdr.de>; Tue, 18 May 2021 11:09:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239213AbhERJKr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 May 2021 05:10:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240635AbhERJKq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 May 2021 05:10:46 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69C6DC061573
        for <stable@vger.kernel.org>; Tue, 18 May 2021 02:09:28 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id y9so10660856ljn.6
        for <stable@vger.kernel.org>; Tue, 18 May 2021 02:09:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zDPLZY6n1fzjF1/PuV70TugjmL5LRz4hKWzApMGHl5U=;
        b=DapZIgcrYoOpwcatlFni9M5PYI5eV4rQjFml2F2E9R3cMeH9boVnlDlOmzPzlLSqdV
         gl3UUtFieKqosZKIWMjG5hC4OuC34Eu8PMJoe67JTqLaK/K0Xy/58gfmYNDAjdlnJ6XJ
         xS9cEci4hfeayNCt8dyOyBGswnmphqjsOCyttaBsQtH6Z1igSfcW44GGrlWX1Qw2vI52
         Z36IKwOs2x1TBR+QYlackh0+WglK/1uVkRS8DSC7VyZ0B6f6bZUZUbD4uoJuwPLGjkvR
         hCT1dUwK8haFxJwPqI5RJiBfd+/sMrGXaeCAp9jo7Lv+LlhwJwvydUOEg19CC3WzZQM9
         73LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zDPLZY6n1fzjF1/PuV70TugjmL5LRz4hKWzApMGHl5U=;
        b=imwGTuEqaH+/1OCHTq3bV7RqQGv47dgxgkQepzzpKWfMWnRiP8rfRaLJ7GZh9J2je6
         N9TwsQtc2zy635n0t+qOC8PciSm9D2a1ieCuyAfPjMqhUujJq75cKywUOyuVZmYhLG0k
         b9ZMRhZ+8pTT0Q5Tafp9yAWjziSvuaRKBnPs5PrCuo8ad0NDNy1HfhZCRtiwxIDLhPxO
         XaKJibQttvwUiX3uZ8r3mzL1kyL1NBZrC8FsTI6ykHhk8vTasNVreTs6fhc7BHHCsrQY
         /Mzr6BPgDPpzL8XhXhdwe+SVi27VKc7I4WYMZLs7Yv5QdUxCuZnEjH94Y9uc1G8gSWs9
         JBfw==
X-Gm-Message-State: AOAM533dkitrqbqLlWtvdkmuDS4alrmhGRQJ/mX1PGY+ikV7Kcyk9FIy
        XPwt30OH9r3epXVj/RgWKHnPB7TPHoTEycvo
X-Google-Smtp-Source: ABdhPJwd36FdQw5OjeaJNExrYMnqgMrs9WA1iin+4PQZuKnVgjNayk86ub6DZ3d0pvz+Q6NUI7DdAA==
X-Received: by 2002:a2e:9196:: with SMTP id f22mr3318140ljg.88.1621328966961;
        Tue, 18 May 2021 02:09:26 -0700 (PDT)
Received: from pdkmachine.localdomain (91-123-191-9.gigainternet.pl. [91.123.191.9])
        by smtp.gmail.com with ESMTPSA id r1sm3215559ljj.21.2021.05.18.02.09.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 May 2021 02:09:26 -0700 (PDT)
From:   Patryk Duda <pdk@semihalf.com>
To:     Benson Leung <bleung@chromium.org>
Cc:     Guenter Roeck <groeck@chromium.org>, linux-kernel@vger.kernel.org,
        upstream@semihalf.com, Patryk Duda <pdk@semihalf.com>,
        stable@vger.kernel.org
Subject: [PATCH] platform/chrome: cros_ec_proto: Send command again when timeout occurs
Date:   Tue, 18 May 2021 11:09:25 +0200
Message-Id: <20210518090925.15480-1-pdk@semihalf.com>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Sometimes kernel is trying to probe Fingerprint MCU (FPMCU) when it
hasn't initialized SPI yet. This can happen because FPMCU is restarted
during system boot and kernel can send message in short window
eg. between sysjump to RW and SPI initialization.

Cc: <stable@vger.kernel.org> # 4.4+
Signed-off-by: Patryk Duda <pdk@semihalf.com>
---
Fingerprint MCU is rebooted during system startup by AP firmware (coreboot).
During cold boot kernel can query FPMCU in a window just after jump to RW
section of firmware but before SPI is initialized. The window was
shortened to <1ms, but it can't be eliminated completly.

Communication with FPMCU (and all devices based on EC) is bi-directional.
When kernel sends message, EC will send EC_SPI* status codes. When EC is
not able to process command one of bytes will be eg. EC_SPI_NOT_READY.
This mechanism won't work when SPI is not initailized on EC side. In fact,
buffer is filled with 0xFF bytes, so from kernel perspective device is not
responding. To avoid this problem, we can query device once again. We are
already waiting EC_MSG_DEADLINE_MS for response, so we can send command
immediately.

Best regards,
Patryk
 drivers/platform/chrome/cros_ec_proto.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/platform/chrome/cros_ec_proto.c b/drivers/platform/chrome/cros_ec_proto.c
index aa7f7aa77297..3384631d21e2 100644
--- a/drivers/platform/chrome/cros_ec_proto.c
+++ b/drivers/platform/chrome/cros_ec_proto.c
@@ -279,6 +279,18 @@ static int cros_ec_host_command_proto_query(struct cros_ec_device *ec_dev,
 	msg->insize = sizeof(struct ec_response_get_protocol_info);
 
 	ret = send_command(ec_dev, msg);
+	/*
+	 * Send command once again when timeout occurred.
+	 * Fingerprint MCU (FPMCU) is restarted during system boot which
+	 * introduces small window in which FPMCU won't respond for any
+	 * messages sent by kernel. There is no need to wait before next
+	 * attempt because we waited at least EC_MSG_DEADLINE_MS.
+	 */
+	if (ret == -ETIMEDOUT) {
+		dev_warn(ec_dev->dev,
+			 "Timeout to get response from EC. Retrying.\n");
+		ret = send_command(ec_dev, msg);
+	}
 
 	if (ret < 0) {
 		dev_dbg(ec_dev->dev,
-- 
2.31.1.751.gd2f1c929bd-goog

