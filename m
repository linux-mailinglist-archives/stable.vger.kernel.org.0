Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CBAE47F2FA
	for <lists+stable@lfdr.de>; Sat, 25 Dec 2021 11:28:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231419AbhLYK2V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Dec 2021 05:28:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229728AbhLYK2V (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Dec 2021 05:28:21 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C106DC061401
        for <stable@vger.kernel.org>; Sat, 25 Dec 2021 02:28:20 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id n10-20020a7bc5ca000000b00345c520d38eso5660044wmk.1
        for <stable@vger.kernel.org>; Sat, 25 Dec 2021 02:28:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PPeY3hMmBKMzSXWdPdCl1j/YNVtGXhIaOr5+ojZg2Rs=;
        b=qXbNYZv5lurW/OnAFhSsNW8AQniyfhcHWPJGm0DGZ9j8rll9KAD3wWujlmS1JV6aij
         qOYSSAqlvbnH2mKnGqRGMuiP1O7U+x03tR4iBne80XQy3qzEbiNxSVucEPHeWoafu1Tz
         FcVNZopPvkt2H4vAdgeRC9uSQs/uh0rWM8t9Usr20X3EV+ODYrLDIEzVqBGX9znFy1WU
         di3jRmF9EDqzFegJzEUgLAoLTYJoZDWZEhyTxYBVxGNrVHbsxrJ9zcd0xAVbs/oCQ1a/
         6uDMAuRhqkQfWo80rOj8XH21iAZtX75SB81CtJfGWT+0jqY/Y9PT0iZpr3vgbeL+/I6C
         gYGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PPeY3hMmBKMzSXWdPdCl1j/YNVtGXhIaOr5+ojZg2Rs=;
        b=T/yC5Yr33rSeLh8hbkTBFTVehawXBGRjs/8Vmqn59V27IVrhhGX09+o/Wi91FzI6lO
         jkyb4h33thIwRBC8uaD1jbsGQsoFZvCe8i25ysTxy/8sOhPSBeDf59joD1jVzs6850KB
         oJZCErPB61cU8ZN4mxO0G+cCQQ6fQkS5uWXN+MEt1CnCDajvEbQHYo9y9GCuuJHcYSOc
         wG+OMhxokkLEi1Kkb2gvEQAa7Ehr8igv+LRYozl9h5BboZIJ6w9AfaTAgwI9xxcRwT+v
         PS040if4DHcnDhniDKUtjNmtbB8yMZSGWYkoJgcrDlf6nU+Ed8iW9REjDaZikAaWnbEM
         lDqQ==
X-Gm-Message-State: AOAM530dK6Hqqi7gMnmj+5FPBjmWljFNtm/q5OdjP8vLz03LjpebGMlU
        aoyejuAz6I8doS+3H4l8gVBF12MgChc=
X-Google-Smtp-Source: ABdhPJwe7Nzk4O33c120nzp9QV7jOG6plNRgVF+K1CQzDdRnHg/uwL54eYh8AMiFzDQrF7qjsuyr1w==
X-Received: by 2002:a05:600c:3d0f:: with SMTP id bh15mr7351567wmb.27.1640428099157;
        Sat, 25 Dec 2021 02:28:19 -0800 (PST)
Received: from localhost.localdomain ([2a00:a040:19b:101c:94ae:2d26:88cc:bae1])
        by smtp.gmail.com with ESMTPSA id o2sm9546622wru.109.2021.12.25.02.28.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Dec 2021 02:28:18 -0800 (PST)
From:   Simon Bursten <smnbursten@gmail.com>
To:     smnbursten@gmail.com
Cc:     Johan Hovold <johan@kernel.org>, stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH] platform/x86: intel_pmc_core: fix memleak on registration failure
Date:   Sat, 25 Dec 2021 12:28:07 +0200
Message-Id: <20211225102807.40888-1-smnbursten@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

In case device registration fails during module initialisation, the
platform device structure needs to be freed using platform_device_put()
to properly free all resources (e.g. the device name).

Fixes: 938835aa903a ("platform/x86: intel_pmc_core: do not create a static struct device")
Cc: stable@vger.kernel.org      # 5.9
Signed-off-by: Johan Hovold <johan@kernel.org>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://lore.kernel.org/r/20211222105023.6205-1-johan@kernel.org
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/platform/x86/intel/pmc/pltdrv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/intel/pmc/pltdrv.c b/drivers/platform/x86/intel/pmc/pltdrv.c
index 73797680b895..15ca8afdd973 100644
--- a/drivers/platform/x86/intel/pmc/pltdrv.c
+++ b/drivers/platform/x86/intel/pmc/pltdrv.c
@@ -65,7 +65,7 @@ static int __init pmc_core_platform_init(void)
 
 	retval = platform_device_register(pmc_core_device);
 	if (retval)
-		kfree(pmc_core_device);
+		platform_device_put(pmc_core_device);
 
 	return retval;
 }
-- 
2.25.1

