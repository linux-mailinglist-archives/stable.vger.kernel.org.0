Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CC7310E823
	for <lists+stable@lfdr.de>; Mon,  2 Dec 2019 11:03:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbfLBKDz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Dec 2019 05:03:55 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:39501 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726533AbfLBKDz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Dec 2019 05:03:55 -0500
Received: by mail-wm1-f66.google.com with SMTP id s14so15699996wmh.4
        for <stable@vger.kernel.org>; Mon, 02 Dec 2019 02:03:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=46LLwlvzE2FHY1ej4eoNV1VVJcCrkeV1UdzSpNWggRw=;
        b=c4unkz5VBCfwH3WEOXDUBx1twRep9gpMQ2tLReLevGs9lf/4zsr7hC+JMkAQtZ3kES
         CzUi1nWcZ0e+/ggi5EQN4v2YveLubZx6JdvrqDlO8JCISA518uhueItn+1OHWfvLp/p/
         tczY3pSRLr3xA6PtWXGfrBwR1fvXAQuWUWzOgzUumme4GhxeJbi7hK3yr2OWzJWsNzJt
         B+BK604CAp8gdprapc9QOnMVurKhSY1Nkh5Vs+idrsyUr4QROczMZHc14s7tSYtp+XTT
         1tFScWCeeH6Enz4hY3CSu+msa0owVjZJW/cYtZ9KIDGcVzuVAdwi+qAkmhHvBMDbYCj/
         J1qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=46LLwlvzE2FHY1ej4eoNV1VVJcCrkeV1UdzSpNWggRw=;
        b=TUaVtGC4GvF2Cj0L8E96x6XxhxpH5QGkWnALwsvi5WRTStkSAtaNNlu7DTdWp3VNjY
         LUrh0baXkCqOHD/IJ5Q10btaufV0HKpRGXC3j2e1/INbmKT7wdhJdzhXY5KUrThonR6O
         ankzgZdqqllEFd7YkxE/u1zjkbxA2qYiFKHpC8fZXnHECol5T7WmiX6n1/Q2DGJ0olqI
         3aDVrvzU63vuddizKweM4MUPZy4Sn1xbQnQXWXAMVwBfUKm1G/MIY/45M+YUQljv2s4J
         4z9VKoufwehsuPlAqx87ibAClCqln64EcD1NsKhmOCyiQH/2xcXE28TYDA9g+UOQeQCl
         wOlw==
X-Gm-Message-State: APjAAAVWOtQQbkrOcXbV+cPo3DSX6OzPpQL60f0GkR3bJivql2dR3oIa
        6vsnj/6GlGuxWQBHJ7FzG2jIJYyPWM0=
X-Google-Smtp-Source: APXvYqzb3Xf2izSdl0IibhARbc3c3OIw6g+Y7DMMPnsQ8r4yIUq2A574oeyJN1pgchGXCjGX4jiVqg==
X-Received: by 2002:a1c:9d8d:: with SMTP id g135mr24025789wme.114.1575281032564;
        Mon, 02 Dec 2019 02:03:52 -0800 (PST)
Received: from localhost.localdomain ([2.27.35.155])
        by smtp.gmail.com with ESMTPSA id h8sm22975665wrx.63.2019.12.02.02.03.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Dec 2019 02:03:51 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.14 05/14] media: v4l2-ctrl: fix flags for DO_WHITE_BALANCE
Date:   Mon,  2 Dec 2019 10:03:03 +0000
Message-Id: <20191202100312.1397-5-lee.jones@linaro.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191202100312.1397-1-lee.jones@linaro.org>
References: <20191202100312.1397-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eugen Hristev <eugen.hristev@microchip.com>

[ Upstream commit a0816e5088baab82aa738d61a55513114a673c8e ]

Control DO_WHITE_BALANCE is a button, with read only and execute-on-write flags.
Adding this control in the proper list in the fill function.

After adding it here, we can see output of v4l2-ctl -L
do_white_balance 0x0098090d (button) : flags=write-only, execute-on-write

Signed-off-by: Eugen Hristev <eugen.hristev@microchip.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/media/v4l2-core/v4l2-ctrls.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index 1ee072e939e4..34d6ae43fc45 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -1014,6 +1014,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_FLASH_STROBE_STOP:
 	case V4L2_CID_AUTO_FOCUS_START:
 	case V4L2_CID_AUTO_FOCUS_STOP:
+	case V4L2_CID_DO_WHITE_BALANCE:
 		*type = V4L2_CTRL_TYPE_BUTTON;
 		*flags |= V4L2_CTRL_FLAG_WRITE_ONLY |
 			  V4L2_CTRL_FLAG_EXECUTE_ON_WRITE;
-- 
2.24.0

