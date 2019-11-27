Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE13D10AB16
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 08:22:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726510AbfK0HWb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 02:22:31 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:36741 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726514AbfK0HWb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Nov 2019 02:22:31 -0500
Received: by mail-wm1-f66.google.com with SMTP id p17so270184wma.1
        for <stable@vger.kernel.org>; Tue, 26 Nov 2019 23:22:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=R5s1kUXvUZFaJy5wLnwelF0UUYDE5IPYznburQcZxDg=;
        b=nGUOSLki7E1LNbEgBb23RLE4DYeXcHGmwS1UV4LdSReQvQSWoCYGJa6mZA+Zq/GWIH
         zy1Qx6SrFAYsp0dq1b0XECEEDVDV0WlBh27Y+7iJS3WW4Vaz/UlR6MPkSAFu7QgyCAlR
         nlOjLmghgT60iMT2hT/BTBf9FI9Qd4SvI24qANCY1lNuMwTnanKW3IZASdRQO4RfKsMF
         EPxmaXyTQtfWJPmxcFKgCvv07kFlkB5HYeG50T5w3omsfxV1EZW76ID0cnMgQNh9wgiH
         0+rjsflQnbD2sOtzS1z3c5nAEJD7xx56qHBI5yp0eVq3141pXICvq4Bd8746r87udaSH
         9NNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=R5s1kUXvUZFaJy5wLnwelF0UUYDE5IPYznburQcZxDg=;
        b=eZbceOq+t1q6NpIsGoH7Wo6vtWLmvY686EzUCYzEfkfq16uQkkG5E0SNZrZYvKxXc4
         PYT/XVdM1YlsnosFGy8IIVxAyTZbOJ+jt0x0aQ1CUSK/+P/GKI8xFe4R1skZ/wI3Hk/n
         ftHdoHlMJKcUXPUZfK+XrMq5p8CZY6vBdjPb3Dhydvyfw2xmVZRjmrSLOimkn55GyTr/
         sETLOKP38CnVDxf8G4EFg38xyJp4Q9p/A6s9GTRhVrg8JY5F0JM9LQjonDJdpmi9YLcs
         E53mbrkTYcaiWIW3FTnbzVoi7yLYzfJwh9Q8u3j2JpCkAaJjVZnPhQFBqQSvZ8ZhX1Mj
         sfVA==
X-Gm-Message-State: APjAAAWUEIREj2MAGYX4jBKe50mA/g+mNgN2DaMPytB/G9B1yYNLtwhE
        0GMCHd2bdsxBUnVPTdkou15117WnV8k=
X-Google-Smtp-Source: APXvYqxdnZ70o7GbseLqQTwiXUu6tS9kxVjeGAid84RyxdcWtMrFhvDe/InVfu0NW9KDImEo4fWn4g==
X-Received: by 2002:a7b:c308:: with SMTP id k8mr2693385wmj.32.1574839347122;
        Tue, 26 Nov 2019 23:22:27 -0800 (PST)
Received: from localhost.localdomain ([95.149.164.101])
        by smtp.gmail.com with ESMTPSA id c193sm5986641wma.8.2019.11.26.23.22.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2019 23:22:26 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.19 2/3] media: siano: Use kmemdup instead of duplicating its function
Date:   Wed, 27 Nov 2019 07:22:09 +0000
Message-Id: <20191127072210.30715-2-lee.jones@linaro.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127072210.30715-1-lee.jones@linaro.org>
References: <20191127072210.30715-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wen Yang <wen.yang99@zte.com.cn>

[ Upstream commit 0f4bb10857e22a657e6c8cca5d1d54b641e94628 ]

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
index 3071d9bc77f4..38ea773eac97 100644
--- a/drivers/media/usb/siano/smsusb.c
+++ b/drivers/media/usb/siano/smsusb.c
@@ -225,10 +225,9 @@ static int smsusb_sendrequest(void *context, void *buffer, size_t size)
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

