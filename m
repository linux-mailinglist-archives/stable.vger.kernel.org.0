Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 108F833FC05
	for <lists+stable@lfdr.de>; Thu, 18 Mar 2021 00:56:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229570AbhCQX4W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Mar 2021 19:56:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230050AbhCQXzx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Mar 2021 19:55:53 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD62AC06174A
        for <stable@vger.kernel.org>; Wed, 17 Mar 2021 16:55:53 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id k4so362841plk.5
        for <stable@vger.kernel.org>; Wed, 17 Mar 2021 16:55:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MfB9KBtK6Hfsa7/csuzw2HDa4yHTsCpIwhzOQVA8KI4=;
        b=lEW3Nnfk0M8OteQqbUHFxld62YNcA4d8sEGdPw7oyCPUBdr9mKs1T/e6ht2DgLvore
         4yX2TzX+P0e41KqfZhubdEMRzfDe2ktJ1B6O556WTShm78Td6Z3amBqN5UMfnaSoMF7h
         VbM8TZU+kB6CwJG2KfVHLIJHgd4eAg9nHZ1WI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MfB9KBtK6Hfsa7/csuzw2HDa4yHTsCpIwhzOQVA8KI4=;
        b=XyohWZvtwgWwsvla0EsQgSe0xIMGmjzlA5Y0KrwQqQrk9vDhLNebiam3RQ1D830Tyy
         lsvbcte9XlDlBkSDBG9VTvbYSuTJSNNs2AIfxrKfLHp7ptOx5o5M3oiSAJnAXjj7Enw0
         bZxzm7l2yVuw2sZELMpMYzsu4YMwKm9f5tyi4T6q0dlbTFnn6fFl/GexmQuGAke9JwEl
         rUvBkCUTa5534rG5PPQU3KOrz3AUhedDQQeE2sW3gnueonlbkUIr0tTzDRbNJtYS3Pgs
         8+pcT8modmyb9So7DiOMeJ/6h89GCVowA6Xh8+wKqldn62MtzFQXyy/oMtZSaiU3eNEm
         +wqg==
X-Gm-Message-State: AOAM5324SjiL+6PtmM9R+xaisNmY3RMzQ6zns2Vugi4xsGJTUR6bAf7e
        cM59Z5CpR0QJCtLVbWR7BMsyLw==
X-Google-Smtp-Source: ABdhPJyiWcJTX7HKa61vHjz02CPDxiFnlHviTnHXUc3rEVm4NWOq2Jj1jxKQ6kIJSu3PGco+JRSJEw==
X-Received: by 2002:a17:90a:ff0f:: with SMTP id ce15mr1305115pjb.15.1616025353183;
        Wed, 17 Mar 2021 16:55:53 -0700 (PDT)
Received: from localhost ([2620:15c:202:201:f97b:2fbd:4700:fb85])
        by smtp.gmail.com with UTF8SMTPSA id z4sm156785pgv.73.2021.03.17.16.55.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Mar 2021 16:55:52 -0700 (PDT)
From:   Gwendal Grignou <gwendal@chromium.org>
To:     lee.jones@linaro.org
Cc:     stable@vger.kernel.org, Gwendal Grignou <gwendal@chromium.org>,
        Olof Johansson <olof@lixom.net>
Subject: [PATCH] platform/chrome: cros_ec_dev - Fix security issue
Date:   Wed, 17 Mar 2021 16:55:22 -0700
Message-Id: <20210317235522.2497292-1-gwendal@chromium.org>
X-Mailer: git-send-email 2.31.0.rc2.261.g7f71774620-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 5d749d0bbe811c10d9048cde6dfebc761713abfd upstream.

Prevent memory scribble by checking that ioctl buffer size parameters
are sane.
Without this check, on 32 bits system, if .insize = 0xffffffff - 20 and
.outsize the amount to scribble, we would overflow, allocate a small
amounts and be able to write outside of the malloc'ed area.
Adding a hard limit allows argument checking of the ioctl. With the
current EC, it is expected .insize and .outsize to be at around 512 bytes
or less.

Signed-off-by: Olof Johansson <olof@lixom.net>
Signed-off-by: Gwendal Grignou <gwendal@chromium.org>
---
 drivers/platform/chrome/cros_ec_dev.c   | 4 ++++
 drivers/platform/chrome/cros_ec_proto.c | 4 ++--
 include/linux/mfd/cros_ec.h             | 6 ++++--
 3 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/platform/chrome/cros_ec_dev.c b/drivers/platform/chrome/cros_ec_dev.c
index 2b331d5b9e799..e16d82bb36a9d 100644
--- a/drivers/platform/chrome/cros_ec_dev.c
+++ b/drivers/platform/chrome/cros_ec_dev.c
@@ -137,6 +137,10 @@ static long ec_device_ioctl_xcmd(struct cros_ec_dev *ec, void __user *arg)
 	if (copy_from_user(&u_cmd, arg, sizeof(u_cmd)))
 		return -EFAULT;
 
+	if ((u_cmd.outsize > EC_MAX_MSG_BYTES) ||
+	    (u_cmd.insize > EC_MAX_MSG_BYTES))
+		return -EINVAL;
+
 	s_cmd = kmalloc(sizeof(*s_cmd) + max(u_cmd.outsize, u_cmd.insize),
 			GFP_KERNEL);
 	if (!s_cmd)
diff --git a/drivers/platform/chrome/cros_ec_proto.c b/drivers/platform/chrome/cros_ec_proto.c
index 5c285f2b3a650..d20190c8f0c06 100644
--- a/drivers/platform/chrome/cros_ec_proto.c
+++ b/drivers/platform/chrome/cros_ec_proto.c
@@ -311,8 +311,8 @@ int cros_ec_query_all(struct cros_ec_device *ec_dev)
 			ec_dev->max_response = EC_PROTO2_MAX_PARAM_SIZE;
 			ec_dev->max_passthru = 0;
 			ec_dev->pkt_xfer = NULL;
-			ec_dev->din_size = EC_MSG_BYTES;
-			ec_dev->dout_size = EC_MSG_BYTES;
+			ec_dev->din_size = EC_PROTO2_MSG_BYTES;
+			ec_dev->dout_size = EC_PROTO2_MSG_BYTES;
 		} else {
 			/*
 			 * It's possible for a test to occur too early when
diff --git a/include/linux/mfd/cros_ec.h b/include/linux/mfd/cros_ec.h
index 3ab3cede28eac..93c14e9df6309 100644
--- a/include/linux/mfd/cros_ec.h
+++ b/include/linux/mfd/cros_ec.h
@@ -50,9 +50,11 @@ enum {
 					EC_MSG_TX_TRAILER_BYTES,
 	EC_MSG_RX_PROTO_BYTES	= 3,
 
-	/* Max length of messages */
-	EC_MSG_BYTES		= EC_PROTO2_MAX_PARAM_SIZE +
+	/* Max length of messages for proto 2*/
+	EC_PROTO2_MSG_BYTES		= EC_PROTO2_MAX_PARAM_SIZE +
 					EC_MSG_TX_PROTO_BYTES,
+
+	EC_MAX_MSG_BYTES		= 64 * 1024,
 };
 
 /*
-- 
2.31.0.rc2.261.g7f71774620-goog

