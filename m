Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 229EE2076B8
	for <lists+stable@lfdr.de>; Wed, 24 Jun 2020 17:10:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404259AbgFXPHY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jun 2020 11:07:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404216AbgFXPHW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Jun 2020 11:07:22 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBDBDC061573
        for <stable@vger.kernel.org>; Wed, 24 Jun 2020 08:07:21 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id k6so2656141wrn.3
        for <stable@vger.kernel.org>; Wed, 24 Jun 2020 08:07:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZDwUiot6YU8OgX3Hsb4EAg8793UTa9837ZvsB3Ajb68=;
        b=DPUhRWgBdf4z6Kq3oWU8vrFS/EIgLp6T1Rjiov9INnODXro+UNi8yI8adJRwBb0utU
         7Pm3vem2rv8I4QJIpGeXDr5oIFYw7N0HnH07oS/h/x/xgKsH1rkfR+v4BHlP/y+79eyw
         p6ClIinjeu01EHHr/ntpl6Pu1CqJm9076Dt52/rKxDXw28C8Wg23+Uys/DJw4//G0Lg2
         kJJo4eSujafjVkZdQcjpwrnR+NUQRGh5WdZkKoFRB0OTACrZ5/h0jEZisLqxQCBOZ9YB
         084H5InBZNTRYzrTu+pYo+r5TQXYYBL7tywwHul7NsS26H2HBonPPvirVNEOc7UAiv21
         3n2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZDwUiot6YU8OgX3Hsb4EAg8793UTa9837ZvsB3Ajb68=;
        b=r5al+Kg9Tcc0mV1Dr1kCIVgWAWT21PEXLw+EMq15Rq7ZebvMlDHZhU/zNiqZcKiV5l
         CfytCL42l3H7+F5EI8kRaaF3uNRT+985cLgc8bQUOLC//fJIO+E4Qsfbd3ZG1C90kZjf
         NePrL7E44qQILFL5Zm5Txm//y9mhaYmXU5NuCAZsJRt8MB5DybxUDUk7QAmwaeN+a/kU
         d+ZVzrxfhx57qun0jgFPCiXmzV7p3O7NLpZ/C/NR/6FMvsk8WkgwalfNY9iIzYlEOEui
         sdBG79ZNHYHRWA8b3HdQDOIvwhQd6t9sYOAtp+DP4kTXP8A7Lq/E1RSe7Yihrc4/ipDi
         7nCA==
X-Gm-Message-State: AOAM533Y0BFCNFtRDWXCWhr1ARBnzcDpLbsypseyDIkTLx2qTQZV9hsN
        z3Wfztdd31P+D/FuASXvLE+axw==
X-Google-Smtp-Source: ABdhPJwRg+dd0nV6QlWORkWed0heqJcLSegy+1eW8ToYmwLs3DPPatue04iD98sXOOpgScYdnnXdiw==
X-Received: by 2002:adf:a514:: with SMTP id i20mr31153581wrb.112.1593011240649;
        Wed, 24 Jun 2020 08:07:20 -0700 (PDT)
Received: from localhost.localdomain ([2.27.35.144])
        by smtp.gmail.com with ESMTPSA id h14sm11543361wrt.36.2020.06.24.08.07.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2020 08:07:19 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 07/10] mfd: ab8500-debugfs: Fix incompatible types in comparison expression issue
Date:   Wed, 24 Jun 2020 16:07:01 +0100
Message-Id: <20200624150704.2729736-8-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200624150704.2729736-1-lee.jones@linaro.org>
References: <20200624150704.2729736-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Smatch reports:

 drivers/mfd/ab8500-debugfs.c:1804:20: error: incompatible types in comparison expression (different type sizes):
 drivers/mfd/ab8500-debugfs.c:1804:20:    unsigned int *
 drivers/mfd/ab8500-debugfs.c:1804:20:    unsigned long *

This is due to mixed types being compared in a min() comparison.  Fix
this by treating values as signed and casting them to the same type
as the receiving variable.

Cc: <stable@vger.kernel.org>
Cc: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/ab8500-debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/ab8500-debugfs.c b/drivers/mfd/ab8500-debugfs.c
index 1a9a3414d4fa8..6d1bf7c3ca3b1 100644
--- a/drivers/mfd/ab8500-debugfs.c
+++ b/drivers/mfd/ab8500-debugfs.c
@@ -1801,7 +1801,7 @@ static ssize_t ab8500_hwreg_write(struct file *file,
 	int buf_size, ret;
 
 	/* Get userspace string and assure termination */
-	buf_size = min(count, (sizeof(buf)-1));
+	buf_size = min((int)count, (int)(sizeof(buf)-1));
 	if (copy_from_user(buf, user_buf, buf_size))
 		return -EFAULT;
 	buf[buf_size] = 0;
-- 
2.25.1

