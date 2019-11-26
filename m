Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41D14109F83
	for <lists+stable@lfdr.de>; Tue, 26 Nov 2019 14:48:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727795AbfKZNsw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Nov 2019 08:48:52 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:37400 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727806AbfKZNsw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Nov 2019 08:48:52 -0500
Received: by mail-wr1-f67.google.com with SMTP id g7so1845195wrw.4
        for <stable@vger.kernel.org>; Tue, 26 Nov 2019 05:48:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=ei5BLi24PVGgbBNVvFVWa2AE2YMFFRHMwxERyLs5g00=;
        b=fBQOI0IE9FPmMigwoAkv+Zu1Nyojmqg9ZgGe2HWL52ADPKWQZQvooYrZV+2hItuwL+
         sUHyJt1qtRcZ2+gZrgt92u3rf/Za9k6anYvtAAI9F1XUgFK5siKpQ8EXcZi6+buxMSMU
         aI1YGcT20iCAk8fZLyDaeDDKMVz1eYJoUK5d4h7qdQ/VwKKiEaHVTJtS1+pL+Oi/si3y
         HYMHlImmhPGhvFH2EJgoRiwcw37/mDtFF9ONA/UQGabbG7EBYcugvjp3WbYkFh+m+En0
         yqNUWHoH78rel+Df7QnvwYGAe4e57g5T1AtnkMuV0jIhhwqI8tFUWIPvcGIDzU47cdYW
         Hzcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ei5BLi24PVGgbBNVvFVWa2AE2YMFFRHMwxERyLs5g00=;
        b=fx0BU9e+bU68ZmpPmnDUG3XlHYjaAc/CKYOvcmgVkxwOOiatojLlAqi/3NHofldxYU
         qVA6HcEozkZqIgm/u+zTNETH/A2az4dwGSJ88XS/8g9JlZw057jCxmr0XhsrZ+As9BxT
         R9uzWv9AyTrnfkJw3KSU/GmAXRXR4EZ1rOguHs64dL1Ll+6z3I+jzFYN2r02j9eK3zoc
         TLTrqorx/5Db9LblyCa4RUAjxWMzY4Pu8XJiiKx+EX0UswHMeiC9L3/wHSgOggxZc1OV
         qE6DsBswvzgbbroPC7EfdrS2qcBUisMJ9lA7M6dI3wfwwTYAleuUYbCzntn7NXbKyBDd
         qD/Q==
X-Gm-Message-State: APjAAAU9DZ54EW2lF4DEjjsbo7MgMqu63k3rJSWI4dhaNPGRF4rc0png
        hzI3cYWFlzyb8lb+bDYshCELd1e66js=
X-Google-Smtp-Source: APXvYqw9HNGUaI/hiDMkHfVEkHYEXq3TOOLzVYluZysXq/J58IaWjjAUlQUqh2XOvl1MfBxPaRtVRw==
X-Received: by 2002:a5d:4e8c:: with SMTP id e12mr20301483wru.109.1574776130280;
        Tue, 26 Nov 2019 05:48:50 -0800 (PST)
Received: from localhost.localdomain ([95.149.164.72])
        by smtp.gmail.com with ESMTPSA id m9sm14374131wro.66.2019.11.26.05.48.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2019 05:48:49 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.19 2/5] media: siano: Use kmemdup instead of duplicating its function
Date:   Tue, 26 Nov 2019 13:48:27 +0000
Message-Id: <20191126134830.12747-2-lee.jones@linaro.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191126134830.12747-1-lee.jones@linaro.org>
References: <20191126134830.12747-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wen Yang <wen.yang99@zte.com.cn>

[ Upstream commit 188ba34e2bcfc9a23d301bd78e35bc1d5ad9ae5a ]

kmemdup has implemented the function that kmalloc() + memcpy().
We prefer to kmemdup rather than code opened implementation.

This issue was detected with the help of coccinelle.

Signed-off-by: Wen Yang <wen.yang99@zte.com.cn>
CC: Tomoki Sekiyama <tomoki.sekiyama@gmail.com>
CC: linux-kernel@vger.kernel.org
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/media/usb/siano/smsusb.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/usb/siano/smsusb.c b/drivers/media/usb/siano/smsusb.c
index ec759f43c634..3ab72d653737 100644
--- a/drivers/media/usb/siano/smsusb.c
+++ b/drivers/media/usb/siano/smsusb.c
@@ -226,10 +226,9 @@ static int smsusb_sendrequest(void *context, void *buffer, size_t size)
 		return -ENOENT;
 	}
 
-	phdr = kmalloc(size, GFP_KERNEL);
+	phdr = kmemdup(buffer, size, GFP_KERNEL);
 	if (!phdr)
 		return -ENOMEM;
-	memcpy(phdr, buffer, size);
 
 	pr_debug("sending %s(%d) size: %d\n",
 		  smscore_translate_msg(phdr->msg_type), phdr->msg_type,
-- 
2.24.0

