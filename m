Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B5DC39F5F1
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 14:01:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232331AbhFHMDq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 08:03:46 -0400
Received: from mail-wm1-f45.google.com ([209.85.128.45]:46861 "EHLO
        mail-wm1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232054AbhFHMDq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Jun 2021 08:03:46 -0400
Received: by mail-wm1-f45.google.com with SMTP id h22-20020a05600c3516b02901a826f84095so1666632wmq.5
        for <stable@vger.kernel.org>; Tue, 08 Jun 2021 05:01:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=raspberrypi.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/2RkyiYdVFzEi0dYMRwg7jVGaGuCJuPCLDaogpfHXs8=;
        b=M6gycxNL9W524PLAt3X4yv6TWbS4ogaCXpTs+oY6s0Pr1L0mRA2OcL6y5d5EyrKeK/
         sXeK9p2xR23I2uKWxtkzcOB3eCRX/Ct5YQlr+JBNn2jN7w3HkW+BEiRGr7QGrkXNiu7/
         V7j+/BiFY7ISXNKPaFdcONe9tCakKuzeuzw8gAwuw2d2OFrkNPCr80WOz1yeEJuQxJTO
         RSbkryftIhnulSIFGMyKMbiqPguOsaoflGOzpUbyQpMPcdMFnVQJYv5UTtpZIHMLfGKq
         eLTFHnOc06mbYlJ+pEX0p5DuuzOne+s2Tgiy6cWfxgjP2NbtqHHxUDqTIOkz2OQqZMjo
         C8jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/2RkyiYdVFzEi0dYMRwg7jVGaGuCJuPCLDaogpfHXs8=;
        b=ZPS001cMrWfxLXAenVIjeZpaDV0LoPwW2+dYIiUlbPSjhdldgCdIQKCF0FJx99Uvce
         Vq5vrs/5+bSChvW1I4owNSfSjTwGBlnnZlszVrrAryVrEglb7QU96csB4YBXJ114x/38
         H9/DtTQ/hkCF9q9ulLQ3qg9jNBmWX9j02ajIJTVr5/bjFdd/VWNRAIakJhmF1rQAqbXB
         ZgHbVA+oc+Q4mVJ4ydGOUCn9Z2Ez+o8H9I5xQHzDFeBhBJYQxzp7zOQsxDkw4xUL45Yp
         VW54uhDTloFiChK5XEjkLHpvIa3yaGPY+TVHoQgjF+bII5HmOU4+lizJykCgWMUOUhCr
         EmDw==
X-Gm-Message-State: AOAM5300oiVNoG7DcLrJNgv9ABqqidb0s3AUuWWiDtXHtuJDBh2/+gc4
        W0x/GdZD61uE7kK8Rz1s2fbqhZQ3c3j852G3
X-Google-Smtp-Source: ABdhPJz9WHpzjoBCCT+XeXqMmpQwU7Ygy7gJl+gQXEaTzYIxRGLv6CDE/JUVlX+NOFs7wTD2f0lFvg==
X-Received: by 2002:a1c:c256:: with SMTP id s83mr21186675wmf.86.1623153652981;
        Tue, 08 Jun 2021 05:00:52 -0700 (PDT)
Received: from buildbot.pitowers.org ([2a00:1098:3142:14:ae1f:6bff:fedd:de54])
        by smtp.gmail.com with ESMTPSA id f5sm23090455wrf.22.2021.06.08.05.00.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jun 2021 05:00:52 -0700 (PDT)
From:   Phil Elwell <phil@raspberrypi.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     Phil Elwell <phil@raspberrypi.com>
Subject: [PATCH] usb: dwc2: Fix build in periphal-only mode
Date:   Tue,  8 Jun 2021 13:00:49 +0100
Message-Id: <20210608120049.1393123-1-phil@raspberrypi.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In branches to which [1] has been back-ported, the bus_suspended member
of struct dwc2_hsotg is only present in builds that support host-mode.
To avoid having to pull in several more non-Fix commits in order to
get it to compile, wrap the usage of the member in a macro conditional.

Fixes: 24d209dba5a3 ("usb: dwc2: Fix hibernation between host and device modes.")
Signed-off-by: Phil Elwell <phil@raspberrypi.com>
[1] 24d209dba5a3 ("usb: dwc2: Fix hibernation between host and device modes.")
---
 drivers/usb/dwc2/core_intr.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/usb/dwc2/core_intr.c b/drivers/usb/dwc2/core_intr.c
index a5ab03808da6..03d0c034cf57 100644
--- a/drivers/usb/dwc2/core_intr.c
+++ b/drivers/usb/dwc2/core_intr.c
@@ -725,7 +725,11 @@ static inline void dwc_handle_gpwrdn_disc_det(struct dwc2_hsotg *hsotg,
 	dwc2_writel(hsotg, gpwrdn_tmp, GPWRDN);
 
 	hsotg->hibernated = 0;
+
+#if IS_ENABLED(CONFIG_USB_DWC2_HOST) ||	\
+	IS_ENABLED(CONFIG_USB_DWC2_DUAL_ROLE)
 	hsotg->bus_suspended = 0;
+#endif
 
 	if (gpwrdn & GPWRDN_IDSTS) {
 		hsotg->op_state = OTG_STATE_B_PERIPHERAL;
-- 
2.25.1

