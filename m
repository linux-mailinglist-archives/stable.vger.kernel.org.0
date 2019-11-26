Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F1D8109F80
	for <lists+stable@lfdr.de>; Tue, 26 Nov 2019 14:48:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727783AbfKZNsF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Nov 2019 08:48:05 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:40500 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727792AbfKZNsF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Nov 2019 08:48:05 -0500
Received: by mail-wm1-f68.google.com with SMTP id y5so3375336wmi.5
        for <stable@vger.kernel.org>; Tue, 26 Nov 2019 05:48:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=FGcA+7vXxKRcx6WDSWBFCHWdIUoDEfsPZ4JhROdYid4=;
        b=VKvHmCQaqG9cbzGD/BEhjAPf+5Yd7t9LPkjwrNVr9MEv8aXUgCTJrPZROLJK5yggWG
         yqXktUtg64BjgQGJzdFZHaU+sDneHVCk/C7OMvDTZHPj65jXWRG6idKl2YXxMfiT9ZID
         r/GEnw0ITh/T8652LMgL/e2gNQQOk2OsYc/AKMZF1c750tejsvq+uIVfLyYLJe2zTzui
         na2GicsuTK0J/eCnGzE/tei9pkhlOoOAzJiF9f2o0KE4TJ0U5mkT3REMp7ue1pVOueLj
         cOf9JY0JuBeBNM1RqbZNAJ0yrVVIWQG0CHFNzk+iXS6Y59LraYgEUapJGl2GXpBhNkOS
         H94g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FGcA+7vXxKRcx6WDSWBFCHWdIUoDEfsPZ4JhROdYid4=;
        b=DBZi2pHlLwIlu+lqYJjZmg4LvcjvSe1HnmD42BqqeKNaAhaIjABs+UmuxuUCBSlxW1
         1JWa2nEDz0MtpEijeEVEdrRtTc+tCKfqnIH9FYWlpOGP/KftYU0+SLTCQfpREN2LV4Zb
         HJ6lvVCnj68sOXK5KYyIXCOlzHkGbzzTGDFBFcpNOjTo4FFqcT77VYWQdu7EsDk7erWN
         bHlDJI7AThijEpgcRcoUHlxycW7z4OnnPYUB82uW3SAtvxgZ02p8cvAWaaPW7/EK5ZbQ
         TvxxpIeMGvz8PkdDVj1zhDO/TEaIcA/KvIAse0M0zgk1uiNvH6hGppTb9IaknscNZk+d
         hy8g==
X-Gm-Message-State: APjAAAX+l+N44KPmrLdQt7Qc+9/l08EfYknWMxCAAAQj7+kl7MF/qZ6z
        gPsWkRrN43PojfJ/yggou+G0uFsaRUA=
X-Google-Smtp-Source: APXvYqwIxEXB9L3bmz/Sd/2CQlBlVH+6g0rjU4N5BChvzHWEMVyNczkC8Pav3J+r39jM4C2n1Rv6RQ==
X-Received: by 2002:a05:600c:2946:: with SMTP id n6mr4337195wmd.166.1574776082771;
        Tue, 26 Nov 2019 05:48:02 -0800 (PST)
Received: from localhost.localdomain ([95.149.164.72])
        by smtp.gmail.com with ESMTPSA id o1sm15085560wrs.50.2019.11.26.05.48.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2019 05:48:02 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.19 2/3] media: siano: Use kmemdup instead of duplicating its function
Date:   Tue, 26 Nov 2019 13:47:40 +0000
Message-Id: <20191126134741.12629-2-lee.jones@linaro.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191126134741.12629-1-lee.jones@linaro.org>
References: <20191126134741.12629-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wen Yang <wen.yang99@zte.com.cn>

[ Upstream commit d1732e9fbadf5cb1e36cc3ee1e8dd8a0b7acca91 ]

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

