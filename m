Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B36353143DF
	for <lists+stable@lfdr.de>; Tue,  9 Feb 2021 00:36:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230064AbhBHXfB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 18:35:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbhBHXe5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Feb 2021 18:34:57 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76E7AC06178B
        for <stable@vger.kernel.org>; Mon,  8 Feb 2021 15:34:17 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id 189so1707954pfy.6
        for <stable@vger.kernel.org>; Mon, 08 Feb 2021 15:34:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=M/yENEDtgXONIt11J/hGbwkaiBja4ZZ2ejCfMLokDcc=;
        b=BSQSqdC3ISTKGyuAOK+VMdPqBGQICfTNs0QKM6bTPPxeymvRgsrSton0KDrT8nmDzB
         m9/Z+3jmDv5jLh1IdOwQr94Sk0hJc5WoyMhT0V5VseNUR/6ShfhCXDG1zUheF1z9uwKk
         6MIuOdZ50GF/zgB667KGNcGe+uTvNT8ua5c0PSk45b7pgzkI2+C/Iz+/PsMjTZ5CBytH
         i6/ZOA+xFmSwt+JyYcM6TiypoHvZ9Qk9skbYQJRD+iFGDM/bdlrz/YGZHKF2bgTOGLYg
         tYu4EIMsEBA3fF0W2Vlk/9KkIF2DUEk3rChg0ABMouosEBtjhOz+ewZMNoYSLWVYsRmV
         wEvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=M/yENEDtgXONIt11J/hGbwkaiBja4ZZ2ejCfMLokDcc=;
        b=paA5fGR6opbgtANTkxcfj4negNDrarVL8lL3kMFEqFHXILSaVTlDcvp6fMlYnD8Azg
         9jZVeoqpdPcLcJVCJQPArd1R5+RCM51NU1NnMFuvjM83wqaCZDBsBWnzpJC3iV7oC+oU
         EjniRXDDjVfGX/myWfkxtVsLIydDjfUEILPtQ5zDZ7I2rVnt8PmMrkUPxzH6egSD8nQE
         YQCboTBTrtbf5q2rvNb0FO1+dyvU73neVJFhOfYrQwV7slmA+RCC7Qa9W7PbqP/GXGLQ
         4tFU99XWe5LcT3zLbms0QArft1yqitvM6TL036s/c90GNSTISNkcGo2OPwApKSoB5cYW
         VPsQ==
X-Gm-Message-State: AOAM532pXIU/4SjUPKWFo10CC7HmKc3vleixVlSeKM7mTDE6ZCmk79Q2
        GE6GUS72D9UkVSU1mqCaeoyiIXaOXtXSNg==
X-Google-Smtp-Source: ABdhPJyynjOFwS0QC1rZ3QLr7OZhsEvR/2N5MmTMp4TV5vF9OiPQXt8xc0rso5XAefH9iUgPUV3LJQ==
X-Received: by 2002:a63:e511:: with SMTP id r17mr11177276pgh.163.1612827256428;
        Mon, 08 Feb 2021 15:34:16 -0800 (PST)
Received: from sol.lan (106-69-173-149.dyn.iinet.net.au. [106.69.173.149])
        by smtp.gmail.com with ESMTPSA id y8sm11589596pfe.36.2021.02.08.15.34.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Feb 2021 15:34:15 -0800 (PST)
From:   Kent Gibson <warthog618@gmail.com>
To:     stable@vger.kernel.org, gregkh@linuxfoundation.org
Cc:     Kent Gibson <warthog618@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [BACKPORT 5.10 PATCH] gpiolib: cdev: clear debounce period if line set to output
Date:   Tue,  9 Feb 2021 07:33:25 +0800
Message-Id: <20210208233325.6087-1-warthog618@gmail.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <1612779107255191@kroah.com>
References: <1612779107255191@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 03a58ea5905fdbd93ff9e52e670d802600ba38cd upstream.

When set_config changes a line from input to output debounce is
implicitly disabled, as debounce makes no sense for outputs, but the
debounce period is not being cleared and is still reported in the
line info.

So clear the debounce period when the debouncer is stopped in
edge_detector_stop().

Fixes: 65cff7046406 ("gpiolib: cdev: support setting debounce")
Cc: stable@vger.kernel.org
Signed-off-by: Kent Gibson <warthog618@gmail.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
---
 drivers/gpio/gpiolib-cdev.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpio/gpiolib-cdev.c b/drivers/gpio/gpiolib-cdev.c
index 12b679ca552c..3551aaf5a361 100644
--- a/drivers/gpio/gpiolib-cdev.c
+++ b/drivers/gpio/gpiolib-cdev.c
@@ -756,6 +756,8 @@ static void edge_detector_stop(struct line *line)
 	cancel_delayed_work_sync(&line->work);
 	WRITE_ONCE(line->sw_debounced, 0);
 	line->eflags = 0;
+	if (line->desc)
+		WRITE_ONCE(line->desc->debounce_period_us, 0);
 	/* do not change line->level - see comment in debounced_value() */
 }
 
-- 
2.30.0

