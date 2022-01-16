Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A08948FA27
	for <lists+stable@lfdr.de>; Sun, 16 Jan 2022 02:27:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234038AbiAPB1G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Jan 2022 20:27:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234022AbiAPB1F (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 Jan 2022 20:27:05 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E1D0C061574;
        Sat, 15 Jan 2022 17:27:05 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id s1so6283692pga.5;
        Sat, 15 Jan 2022 17:27:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IE08dElDmlHUPhw3R/GrBHRzR5Ck/dmE1DAV6Ub7Q7g=;
        b=lvlXEJF5sMMhiX7TkrYX/oC5jQXFpsUax5UMz9HBCTGNamiiMhQQRGY46sxI56SbL8
         wUOYm6S/xpvr+3GOnVdgjdZiKLB9ElJZGOa85+QGTun5/LmBHAZ6LGkJrWi34v4Gn984
         eXefVpWGbGVKe5CnES1bjR8Z1tgcPYId/JsygfJfFxeayS8V7l4FrdQjMDVlWDtQ6yQ5
         ILuqS1pXJMRZZ0LmBYHA6rcKkaAGCPguUv1svof02IfIkC4wn2u7ECuXn+mMgpbAQI95
         qQFBBxL2VNkzxBYJeqmH/Hrgdnge8JYevE57Wjj0qrP650cJZI9LUkU8pNES4sc8eiKs
         jw6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IE08dElDmlHUPhw3R/GrBHRzR5Ck/dmE1DAV6Ub7Q7g=;
        b=c/ZWzGddk37II7niPlUCjoBMUtaTxshLip3jOLqRt/rqQx8Y5DtPHIM26xwYhz306X
         iqw4P05RyWY+KFrqq7tW432mMRQ5em6vPn/QpwPo+pbKaOEODdFUbfZLxgMoon1lbNGc
         YMfWG4YFHBzZPor0sXTYka93KFFOEkBBDpzDme4g6/xR5X01BdI5FQKvC7IMXxq407yg
         6pcexVc0i4MMLVMU90wJAVFN/T0vPTXU+TJ68qNOzLcDULg8eS9IPsMwcdol+wVQ0Wi8
         7lCoMt1cy0q2MJ/A9my7P+Xe/6j/2g/JZE8nRdTdRavLgSikW0x1PY20hKvsAWT8UwVa
         wWBw==
X-Gm-Message-State: AOAM533FVZ/IIn75++xglQ1tiB/UGY7BiCvcuuJzGE852/dP88vdqzY9
        GbAZT2H0NzeWouH8/9owkUQ=
X-Google-Smtp-Source: ABdhPJxy87QcqyZ5PHT0Mq04bC1wqX63VRAl34uo3Obtyrii+BRb1XMNXeyBebBD7br3N9kdUnDEjw==
X-Received: by 2002:a63:b00a:: with SMTP id h10mr13663956pgf.400.1642296424828;
        Sat, 15 Jan 2022 17:27:04 -0800 (PST)
Received: from localhost.localdomain ([50.39.160.154])
        by smtp.gmail.com with ESMTPSA id ot18sm9478939pjb.8.2022.01.15.17.27.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Jan 2022 17:27:04 -0800 (PST)
From:   Tadeusz Struk <tstruk@gmail.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     Tadeusz Struk <tstruk@gmail.com>, Jason Gunthorpe <jgg@ziepe.ca>,
        linux-integrity@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 1/2] tpm: Fix error handling in async work
Date:   Sat, 15 Jan 2022 17:26:26 -0800
Message-Id: <20220116012627.2031-1-tstruk@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When an invalid (non existing) handle is used in a TPM command,
that uses the resource manager interface (/dev/tpmrm0) the resource
manager tries to load it from its internal cache, but fails and
the tpm_dev_transmit returns an -EINVAL error to the caller.
The existing async handler doesn't handle these error cases
currently and the condition in the poll handler never returns
mask with EPOLLIN set.
The result is that the poll call blocks and the application gets stuck
until the user_read_timer wakes it up after 120 sec.
Change the tpm_dev_async_work function to handle error conditions
returned from tpm_dev_transmit they are also reflected in the poll mask
and a correct error code could passed back to the caller.

Cc: Jarkko Sakkinen <jarkko@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: <linux-integrity@vger.kernel.org>
Cc: <stable@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>

Fixes: 9e1b74a63f77 ("tpm: add support for nonblocking operation")
Tested-by: Jarkko Sakkinen<jarkko@kernel.org>
Signed-off-by: Tadeusz Struk <tstruk@gmail.com>
---
Changed in v2:
- Updated commit message with better problem description
- Fixed typeos.
Changed in v3:
- Added a comment to tpm_dev_async_work.
- Updated commit message.
Changed in v4:
- Fixed a typo in the comment.
---
 drivers/char/tpm/tpm-dev-common.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/char/tpm/tpm-dev-common.c b/drivers/char/tpm/tpm-dev-common.c
index c08cbb306636..dc4c0a0a5129 100644
--- a/drivers/char/tpm/tpm-dev-common.c
+++ b/drivers/char/tpm/tpm-dev-common.c
@@ -69,7 +69,13 @@ static void tpm_dev_async_work(struct work_struct *work)
 	ret = tpm_dev_transmit(priv->chip, priv->space, priv->data_buffer,
 			       sizeof(priv->data_buffer));
 	tpm_put_ops(priv->chip);
-	if (ret > 0) {
+
+	/*
+	 * If ret is > 0 then tpm_dev_transmit returned the size of the
+	 * response. If ret is < 0 then tpm_dev_transmit failed and
+	 * returned an error code.
+	 */
+	if (ret != 0) {
 		priv->response_length = ret;
 		mod_timer(&priv->user_read_timer, jiffies + (120 * HZ));
 	}
-- 
2.30.2

