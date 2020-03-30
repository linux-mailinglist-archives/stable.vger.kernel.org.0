Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF4AB19724A
	for <lists+stable@lfdr.de>; Mon, 30 Mar 2020 04:04:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727815AbgC3CEN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Mar 2020 22:04:13 -0400
Received: from mail-pj1-f65.google.com ([209.85.216.65]:55111 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727801AbgC3CEN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 29 Mar 2020 22:04:13 -0400
Received: by mail-pj1-f65.google.com with SMTP id np9so6891472pjb.4
        for <stable@vger.kernel.org>; Sun, 29 Mar 2020 19:04:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=7gDKMMIuCNqmz3/gFIq4MvPM1PkZWROW621H1HN1ayU=;
        b=YJJOQ42obRjUghoYW825UVnnfvOqdCKDZkxvr3ldjeYbs7HRcGtW6yF5gngzV0UmqG
         4aYmhqZAjcQ+IiSthEWrCfX9hV3RYpQM7Vu2pbx+urVDPIyvVGq+Exd+n6v+1S6ZQKpX
         ruFgLZPndrkkCwS3ubZCF3PY/BRMoVIGmrPG9qd2WYHiWwXOkD/54gaL4H2XioMs0KMR
         duSW6t1hVwdCwGN82mLZyv9JSEetla7hhTRpdoC43ztw9pTKIPsdv8PrvxUU3+G49Yig
         ZvedXcOfBlKJULgZoWlTq+B9SZzdGakmwQZaBrZHCNxzTjMp7sUx2kLLJNjDg5HE18Lj
         Z0NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=7gDKMMIuCNqmz3/gFIq4MvPM1PkZWROW621H1HN1ayU=;
        b=Pj37SOHSqx0+9MzpCTs/nHJus8+cfesmb0BdC08CD+/A+/NowWF2TaMLTzOMN0Vim6
         sg5ES2iPywta1Z2mjYHnnCUkeV4COxCewsPzR0H3qkwMdsx8wkqWhVUU7FRoZymjW5oL
         XJBEE/xt7LXI//bES2k+fvOZFz5SucwL4sBMNXfhY2y+T9fVsAXOh9s58mmYotFg35J/
         LTJ4tlZsx5iTCRo91GShwR+h7csgETGGtg82jK9SGp/fSCaZNeeA4n6E6XCJE6ymh5sI
         EpjHilC+IeY9CIhTTtzaSkLXlaaZG9ZImetbsdhcE2RzuJG/HJcXfO2Q+WnrBmW02YR4
         qdbA==
X-Gm-Message-State: ANhLgQ1TaIH7kcpQ7kmhAmrGsTYd31vtK0cgT1uR9LVAQdDKkdsUdtRO
        Xiko9YEm4yq1JuoloIdGF60=
X-Google-Smtp-Source: ADFU+vtqsbUeEdwSHonlCDsKOUHraHM3bcnXAJPPFZPf2ZHwkP278wf9E4Y0HVJgNAcsVnErLpLvBQ==
X-Received: by 2002:a17:90a:7182:: with SMTP id i2mr13099104pjk.74.1585533852357;
        Sun, 29 Mar 2020 19:04:12 -0700 (PDT)
Received: from software.domain.org ([104.207.149.93])
        by smtp.gmail.com with ESMTPSA id e126sm8946089pfa.122.2020.03.29.19.04.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 29 Mar 2020 19:04:11 -0700 (PDT)
From:   Huacai Chen <chenhc@lemote.com>
To:     Dave Airlie <airlied@redhat.com>, Gerd Hoffmann <kraxel@redhat.com>
Cc:     virtualization@lists.linux-foundation.org,
        spice-devel@lists.freedesktop.org,
        Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Huacai Chen <chenhc@lemote.com>, stable@vger.kernel.org
Subject: [PATCH] drm/qxl: Use correct notify port address when creating cursor ring
Date:   Mon, 30 Mar 2020 10:12:22 +0800
Message-Id: <1585534342-889-1-git-send-email-chenhc@lemote.com>
X-Mailer: git-send-email 2.7.0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The command ring and cursor ring use different notify port addresses
definition: QXL_IO_NOTIFY_CMD and QXL_IO_NOTIFY_CURSOR. However, in
qxl_device_init() we use QXL_IO_NOTIFY_CMD to create both command ring
and cursor ring. This doesn't cause any problems now, because QEMU's
behaviors on QXL_IO_NOTIFY_CMD and QXL_IO_NOTIFY_CURSOR are the same.
However, QEMU's behavior may be change in future, so let's fix it.

P.S.: In the X.org QXL driver, the notify port address of cursor ring
      is correct.

Cc: <stable@vger.kernel.org>
Signed-off-by: Huacai Chen <chenhc@lemote.com>
---
 drivers/gpu/drm/qxl/qxl_kms.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/qxl/qxl_kms.c b/drivers/gpu/drm/qxl/qxl_kms.c
index bfc1631..9bdbe0d 100644
--- a/drivers/gpu/drm/qxl/qxl_kms.c
+++ b/drivers/gpu/drm/qxl/qxl_kms.c
@@ -218,7 +218,7 @@ int qxl_device_init(struct qxl_device *qdev,
 				&(qdev->ram_header->cursor_ring_hdr),
 				sizeof(struct qxl_command),
 				QXL_CURSOR_RING_SIZE,
-				qdev->io_base + QXL_IO_NOTIFY_CMD,
+				qdev->io_base + QXL_IO_NOTIFY_CURSOR,
 				false,
 				&qdev->cursor_event);
 
-- 
2.7.0

