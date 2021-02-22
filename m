Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E76A32114B
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 08:19:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229918AbhBVHTA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 02:19:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229903AbhBVHS6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Feb 2021 02:18:58 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51E11C061574
        for <stable@vger.kernel.org>; Sun, 21 Feb 2021 23:18:18 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id w18so6036909pfu.9
        for <stable@vger.kernel.org>; Sun, 21 Feb 2021 23:18:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3UOgKlDVOG5kqOX15z3IzWPBnhLk5GJdo2Ieqqhp5XQ=;
        b=pezG7+BLq4uqCXqnxuJ4ZyWD3SZNOvXRUw+K13RNw9kasHVxAFf7Gd64Mf86Ed1deC
         /bTbTQ95zEMysR7n5FH0NsCH4q1ZbL7j3HMGzzzTIZJkPK2umICx/DCVvIQfy0CbVUmb
         hj53bWIqoyuBBhbEDI/F2efWPr4vyzS5asmH32y32Nl9Vzf2VwLNAiz9goDNPRWvNN6A
         ZQLG6MF7jNjrzvODnfDJDviRzKkofCQXXAM2Dno6nfu9VEBX0Q+CcJkqALhVTj50GnV5
         E0cL1imwtMov/OFFrw6c133f8BT7BUs6PXHVIk0oTgENcLYGUZ4oYqw9ik2gHT4SBnsc
         MOMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3UOgKlDVOG5kqOX15z3IzWPBnhLk5GJdo2Ieqqhp5XQ=;
        b=BMFCxrFRjWBQdugVTp+2ajAZTwckETuGepJL7T0uxQaAxia/jd9oOSzJN4G2CjV4lo
         vVhxtnhxtx+dBkibnqzNkPPdyqJt1gdOjadN4GQM6MQ5OtBv/s1p2Y5vk/zFdoRWnrj9
         XxL3BTxTGEKDwATmQ6fwcoMpDYtDE9BoHvK2xballASIuONgI2KlG6/M8qhqMPfC7q6o
         P5LHuANFMEcPl0iM/UzniqaLUZZP5r3q4k31NYt22rmeNhP1NDMGYw8fOnVYhvkrpcuL
         LZM3lDpEx0tQyvRjZeerSgcSUMX2KlYxZEJNtNSNXC17pv2uTTKJLyKvUpedj4vlOfaY
         ZAIA==
X-Gm-Message-State: AOAM53300XGxAaRCvxzO+RdEP54dSrmo6vjqOET0lDWKNqoUWcilTZZj
        ZiZSsupEQMoYJPLrLjzsBDwMDw==
X-Google-Smtp-Source: ABdhPJzYUww2cIHg+V5AkriNmEFSPq+LJ6YMztGRnwUTjrNvlN1Hq4O343+IT8ptfcv9XEQ1HKEP4A==
X-Received: by 2002:a63:154b:: with SMTP id 11mr18469428pgv.307.1613978297894;
        Sun, 21 Feb 2021 23:18:17 -0800 (PST)
Received: from localhost ([122.172.59.240])
        by smtp.gmail.com with ESMTPSA id p1sm5320057pjf.2.2021.02.21.23.18.16
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 21 Feb 2021 23:18:17 -0800 (PST)
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     Viresh Kumar <viresh.kumar@linaro.org>,
        Tushar Khandelwal <Tushar.Khandelwal@arm.com>,
        Jassi Brar <jassisinghbrar@gmail.com>
Cc:     Vincent Guittot <vincent.guittot@linaro.org>,
        "v5 . 11" <stable@vger.kernel.org>,
        kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Tushar Khandelwal <tushar.khandelwal@arm.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] mailbox: arm_mhuv2: Skip calling kfree() with invalid pointer
Date:   Mon, 22 Feb 2021 12:48:06 +0530
Message-Id: <0a3813079e349d4871c85d0015b9cf16fdbb0dea.1613978176.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.25.0.rc1.19.g042ed3e048af
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

It is possible that 'data' passed to kfree() is set to a error value
instead of allocated space. Make sure it doesn't get called with invalid
pointer.

Fixes: 5a6338cce9f4 ("mailbox: arm_mhuv2: Add driver")
Cc: v5.11 <stable@vger.kernel.org> # v5.11
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/mailbox/arm_mhuv2.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/mailbox/arm_mhuv2.c b/drivers/mailbox/arm_mhuv2.c
index cdfb1939fabf..d997f8ebfa98 100644
--- a/drivers/mailbox/arm_mhuv2.c
+++ b/drivers/mailbox/arm_mhuv2.c
@@ -699,7 +699,9 @@ static irqreturn_t mhuv2_receiver_interrupt(int irq, void *arg)
 		ret = IRQ_HANDLED;
 	}
 
-	kfree(data);
+	if (!IS_ERR(data))
+		kfree(data);
+
 	return ret;
 }
 
-- 
2.25.0.rc1.19.g042ed3e048af

