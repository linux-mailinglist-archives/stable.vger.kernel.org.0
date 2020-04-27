Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A00351BB0D1
	for <lists+stable@lfdr.de>; Mon, 27 Apr 2020 23:55:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726285AbgD0Vzz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Apr 2020 17:55:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726204AbgD0Vzy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Apr 2020 17:55:54 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6467EC0610D5
        for <stable@vger.kernel.org>; Mon, 27 Apr 2020 14:55:53 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id x2so5941217pfx.7
        for <stable@vger.kernel.org>; Mon, 27 Apr 2020 14:55:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QwWrKenZ8k5J4q1qBIr58HlyfL2ByZs2Ssa6TCedrSk=;
        b=LbaJb+ki6pK6wQO0c2DyS9Atvm8JE6MKeoBDclHbQycrzujPTZPNaK6yfuGS3UUBu/
         MInl24vMoRUBTYFpBgQQbK46u9WS6P1ReSzyapOuUjnUuuNUi6RCCGHwAfTpbIGsUaQD
         pZuvHsXY0pF9NwVYLOImYaZhrERGyHEWxmM18=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QwWrKenZ8k5J4q1qBIr58HlyfL2ByZs2Ssa6TCedrSk=;
        b=bS0S0cGMlzElZn6XMWM6ALReRYtjykhui6wOXlf59CICLCKaUw+VA9EhbP+pfZFWcG
         jE61MY/hABTKdZunKGGz9EsqREBH/7SmuygtUUiLDvqamPPb9R0zDR4jz0z1Zyxywt4q
         w/b4qyIxJW2ERo9E+w4X3dVjfSEkXU4yiIF6vwMlK0UgRfMsQC+Vk7KqRSrgJ4Y9IJ7w
         nUQtHSfHu/5zOOsrQ9TEpC7ePvZ7n8NvPeHjcWW6LrK+x/fEUJlkF35+6VK0Ao+gAZV8
         nUltXLCnQ/fo1APQAQDE8uON40bT0qmY3GdNJUa3pzVTouo4ej3HvJoJ7j29LfkELzzQ
         n6UA==
X-Gm-Message-State: AGi0PuaBB9guSBpgCJ3VxGlxn357TOdPDRXm4SslYrJNBgQh3Tp1RZgY
        eoBFWa12l+e/Jhk4kmxOhU/M5Q==
X-Google-Smtp-Source: APiQypIWIg1lh3l6rgxN7SYiYVoPklma36XNRFiHNukzSWdE1PdM5v8sHQNeaE1NgWaTUlxWGHzTWw==
X-Received: by 2002:a62:c1c1:: with SMTP id i184mr27417512pfg.18.1588024552819;
        Mon, 27 Apr 2020 14:55:52 -0700 (PDT)
Received: from evgreen-glaptop.cheshire.ch ([2601:646:c780:1404:1c5a:73fa:6d5a:5a3c])
        by smtp.gmail.com with ESMTPSA id f99sm244273pjg.22.2020.04.27.14.55.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 27 Apr 2020 14:55:52 -0700 (PDT)
From:   Evan Green <evgreen@chromium.org>
To:     Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc:     Evan Green <evgreen@chromium.org>, stable@vger.kernel.org,
        Nick Desaulniers <nick.desaulniers@gmail.com>,
        Allison Randal <allison@lohutok.net>,
        Andrew Duggan <aduggan@synaptics.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Enrico Weigelt <info@metux.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Input: synaptics-rmi4 - Really fix attn_data use-after-free
Date:   Mon, 27 Apr 2020 14:55:48 -0700
Message-Id: <20200427145537.1.Ic8f898e0147beeee2c005ee7b20f1aebdef1e7eb@changeid>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Fix a use-after-free noticed by running with KASAN enabled. If
rmi_irq_fn() is run twice in a row, then rmi_f11_attention() (among
others) will end up reading from drvdata->attn_data.data, which was
freed and left dangling in rmi_irq_fn().

Commit 55edde9fff1a ("Input: synaptics-rmi4 - prevent UAF reported by
KASAN") correctly identified and analyzed this bug. However the attempted
fix only NULLed out a local variable, missing the fact that
drvdata->attn_data is a struct, not a pointer.

NULL out the correct pointer in the driver data to prevent the attention
functions from copying from it.

Fixes: 55edde9fff1a ("Input: synaptics-rmi4 - prevent UAF reported by KASAN")
Fixes: b908d3cd812a ("Input: synaptics-rmi4 - allow to add attention data")

Signed-off-by: Evan Green <evgreen@chromium.org>

Cc: stable@vger.kernel.org
Cc: Nick Desaulniers <nick.desaulniers@gmail.com>
---

 drivers/input/rmi4/rmi_driver.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/input/rmi4/rmi_driver.c b/drivers/input/rmi4/rmi_driver.c
index 190b9974526bb..c18e1a25bca6e 100644
--- a/drivers/input/rmi4/rmi_driver.c
+++ b/drivers/input/rmi4/rmi_driver.c
@@ -205,7 +205,7 @@ static irqreturn_t rmi_irq_fn(int irq, void *dev_id)
 
 	if (count) {
 		kfree(attn_data.data);
-		attn_data.data = NULL;
+		drvdata->attn_data.data = NULL;
 	}
 
 	if (!kfifo_is_empty(&drvdata->attn_fifo))
-- 
2.24.1

