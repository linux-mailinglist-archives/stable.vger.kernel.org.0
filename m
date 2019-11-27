Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E51010AB0F
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 08:22:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726512AbfK0HWU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 02:22:20 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:38202 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726227AbfK0HWU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Nov 2019 02:22:20 -0500
Received: by mail-wm1-f66.google.com with SMTP id z19so6164407wmk.3
        for <stable@vger.kernel.org>; Tue, 26 Nov 2019 23:22:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=Gy06tYfgg/j4igOn88GPHku4s1HMYQmNNOQvmkqJT/M=;
        b=bo5QgBMti8HYRZf5cM9otFSJRwsKxonSGMMsJE0+XQDQdTV21UshShxcpKM+ovTz3o
         lEZ8/mV3K+1R/qwDUU70AgTGRyJNV4Gbpc4vJVU38zq1kcLVV/bfWRVFZxzPjPTDLpkd
         NprC5x4uz6dODMmaNmntnez4PI0T62CvUUSTKvHC3Kq8fY/IrJHTzCy4WymYUuZeYQc4
         lag/W635AwkQfptTQJ8QlSL08djiGXDcyHiHaZuP9My8q6NwDNVzN/pkDvtPJQUROlsk
         E6zcDIQfLkzZ9Q82pYABe3ddr//8g1PQ6KqW9ThG7ZAjsmixryNY3Niwha0adYsTtg+R
         1/5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Gy06tYfgg/j4igOn88GPHku4s1HMYQmNNOQvmkqJT/M=;
        b=Vmp2i9eti1EQczMJbKAHP76LLHAu7zdEYxryK9Nosv/yF+iOd4CPPDDwdw+qgJzwb9
         +lBWrzMIOjKUdTax9gJEHPsl+s2ecHb7yeZJ8sUPOf5UBdj/Mhe/DXdCriaadZd2tH5A
         JgeKKmQhJGgZ0AYRNjZtVjd0kioFrvAPbLL0kM0SHIcGDs9S+gXq7GVocIzngtobD0UC
         bpZ24dFXaJ3x3DlGmknOX+vQ5eoaaZs+9L07oMJQwDBxwBVkHzeEVLtSMlXLl2flSvx+
         3M3ASPZ2nLOqE9laNAmpmhyce04LOgVFPO0h87rcAeV/MjLNj3oYgSdWWyvhA+KEmN8d
         E04w==
X-Gm-Message-State: APjAAAXbsrMw17RqMEQXEUYdCRtMvNIE8g7y54EW6d8uXvZULnCyK+X8
        UB+lnjBZl7rzLuy57oxeLdNOW82xnW4=
X-Google-Smtp-Source: APXvYqzmLToi0p1RFXeCCgS5X7HZJ3ER5x679nlLdsa7hoodOhvMYpt8n+UgA9n00/7o25a934vY0Q==
X-Received: by 2002:a05:600c:1088:: with SMTP id e8mr2873864wmd.7.1574839338267;
        Tue, 26 Nov 2019 23:22:18 -0800 (PST)
Received: from localhost.localdomain ([95.149.164.101])
        by smtp.gmail.com with ESMTPSA id d20sm19406915wra.4.2019.11.26.23.22.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2019 23:22:17 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.14 2/5] media: siano: Use kmemdup instead of duplicating its function
Date:   Wed, 27 Nov 2019 07:21:59 +0000
Message-Id: <20191127072202.30625-2-lee.jones@linaro.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127072202.30625-1-lee.jones@linaro.org>
References: <20191127072202.30625-1-lee.jones@linaro.org>
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

