Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCCB938745A
	for <lists+stable@lfdr.de>; Tue, 18 May 2021 10:48:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241591AbhERItb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 May 2021 04:49:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347010AbhERIt2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 May 2021 04:49:28 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ABBFC061573
        for <stable@vger.kernel.org>; Tue, 18 May 2021 01:48:09 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id f12so10610094ljp.2
        for <stable@vger.kernel.org>; Tue, 18 May 2021 01:48:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zDPLZY6n1fzjF1/PuV70TugjmL5LRz4hKWzApMGHl5U=;
        b=CMxUhZU0dFCMV6EpQB3OmpGPDKhlh79B4Fl9qnprTOeU+ZufB3mIit7hjH1mT2Mmh0
         0iVOC8LsY3Nnqk1GAjRYpUbu0+nxQPqz1NZpMPBGukY7AyrzpCiAhT74GId5TIxNwRkr
         hKsOM13wYgtKzYDNYL3ZIs4dyHDazfxMGcHH+8lwpibaxqH4ewNjl/o7RUKFZ/Y9ruWa
         Nzq4YSVdn4olJcaWZllrQMVWgC7xMuUxklMVFnmNliy7OtP0yUz+4tC318wJdV7j2FeF
         dlaSx4vY6eLq9elmDwCMwfbt7M7M0tlGyiM/4EXyo6jw1OrWMBsXjYGrohmDrXL8ce26
         vrKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zDPLZY6n1fzjF1/PuV70TugjmL5LRz4hKWzApMGHl5U=;
        b=X6iXJ1qf0YheMWevx/YJl4RItYVrGN0SSqyMo8yJxdaImbytTon0h704cl8zJTp3WU
         UAVhaBFX/CPup62y5ssNoZ1AtlVqYBFuQTsETx7au+9vic13Jz6NP04A/iOYGk1m+gwD
         E1RyUGne6WDtjyp977Uj70ry70JomK6ntkwyZx0u3bAZeCIJrRqDG/OEAo5wcH1DlNYb
         QhtbULUaYQzjYSWVx7DJYVAgTEBRia1Nw7CO+II5FbszzOyQ4LmgRucv/Fz79AlS7VTn
         E1vL8oi9y65JTpKBEffQn7Cs4DRArjOwa+zznNAladcqZ5A/U7Lo1gFYSar/JVF6eTuz
         2ecA==
X-Gm-Message-State: AOAM532UWlAoRHUQka9MASlODxTNcYXdCTBN7VKplnwdj0gyK1g2Sjnm
        MKH0IeyM30pznhyXQzoaqbb+bu4vDZTSgg==
X-Google-Smtp-Source: ABdhPJyhojibN5sVFLTqNfN4AYLjqGoWvVzQB972oo9MEiWWHmIEkXBZGIOW4M2natXF5OWgl2Lqsg==
X-Received: by 2002:a2e:b8c9:: with SMTP id s9mr3275368ljp.422.1621327688027;
        Tue, 18 May 2021 01:48:08 -0700 (PDT)
Received: from pdkmachine.localdomain (91-123-191-9.gigainternet.pl. [91.123.191.9])
        by smtp.gmail.com with ESMTPSA id 4sm747322lfr.175.2021.05.18.01.48.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 May 2021 01:48:07 -0700 (PDT)
From:   Patryk Duda <pdk@semihalf.com>
To:     Patryk Duda <pdk@semihalf.com>
Cc:     stable@vger.kernel.org
Subject: [PATCH] platform/chrome: cros_ec_proto: Send command again when timeout occurs
Date:   Tue, 18 May 2021 10:48:23 +0200
Message-Id: <20210518084823.14392-1-pdk@semihalf.com>
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

