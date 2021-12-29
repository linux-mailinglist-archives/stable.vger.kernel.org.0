Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73524480FCE
	for <lists+stable@lfdr.de>; Wed, 29 Dec 2021 06:07:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234253AbhL2FH2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Dec 2021 00:07:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbhL2FH1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Dec 2021 00:07:27 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAB34C061574;
        Tue, 28 Dec 2021 21:07:27 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id w24so15045728ply.12;
        Tue, 28 Dec 2021 21:07:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Y6D6kbQh7Cm8wpKn4BMX0UeN0YW2Jh8hSVkReFZ+rr0=;
        b=AnBHZiOUD8KsAoY3K1MG71EP84nDDtl4vM6ADKBTqCbqMPspmtkokR/HH2W64G/Iea
         rnLcZPFJdi4wKhjvqiJJNVvg7afGzvIvxYcKBQLI8bfKo9/Z1sVUu1+FnQshcyoRkwdL
         3jvoxuuDXsy0+JrBqLu/Ppjoo9BrXpDZ5T/zUTZv7V8KC8/DvMPR4+C9ugsLTeqlKERP
         aJcJJ4jOUduAzWlCMifNHlE97fZVFQ1JaYxinYRhThrZiUDBWfmzU6SQClmvECJBNoIs
         y2cSFiJxID9b80EHl1eBBHw3F8jPliTe+8DXM39HPkU/geUN4oKxbE0TDdEJC5X3GYLt
         /W4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Y6D6kbQh7Cm8wpKn4BMX0UeN0YW2Jh8hSVkReFZ+rr0=;
        b=2XfOfQJTNBSuSv/qQE1z4TrDwxZc70CDFyLy1KciuZnghzqUpwTukMxKYOzTMIf6p+
         zBRLVvPyHAvYNbfs166bOiurQBLYU1dU5i9jO9bnim1DrvYcHMFzFsaie6dC1PKVcS1A
         xUhsuNOS0gABbCEh+tpKafZQNEDtw6ZbnvA+DYzKZUT13QRPYdQfG3cNEAlb3O2VrYPq
         sDK/8TxzTTWpGoo1e+OU2KSDbLikU4fUXmjpAbDf+Tc8tLkX0sknsgNGFlzGNbqw/Fss
         jaZk2ZvpOU0KpkKr9pjn/U3VN/ZAeu8Dq9/LSOkbl2ysDMcLW7QN2LJTfKTWpx9ZUFYS
         M9sQ==
X-Gm-Message-State: AOAM532gFSVXJ1E3XdCma/GrNt2zUcyNn0x7xLjw6aVo67bhRUQGKjba
        0HjeyyWbul90Tn6wfZUzHDw=
X-Google-Smtp-Source: ABdhPJzk6oL9KXcJyWhxTR58cu+5MprY7TsEK+11sG9oXbwJInMenmBHGbzMASUI3wr1ajZUWg/Nkg==
X-Received: by 2002:a17:90b:1b43:: with SMTP id nv3mr18247490pjb.136.1640754447119;
        Tue, 28 Dec 2021 21:07:27 -0800 (PST)
Received: from localhost.localdomain ([50.39.160.154])
        by smtp.gmail.com with ESMTPSA id w9sm18484274pge.18.2021.12.28.21.07.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Dec 2021 21:07:26 -0800 (PST)
From:   Tadeusz Struk <tstruk@gmail.com>
To:     jarkko@kernel.org
Cc:     Tadeusz Struk <tstruk@gmail.com>, Jason Gunthorpe <jgg@ziepe.ca>,
        linux-integrity@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] tpm: Fix error handling in async work
Date:   Tue, 28 Dec 2021 21:06:54 -0800
Message-Id: <20211229050655.2030-1-tstruk@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When an invalid (non existing) handle is used in a tpm command,
that uses the resource manager interface (/dev/tpmrm0) the resource
manager tries to load it from its internal cache, but fails and
returns an -EINVAL error to the caller. The async handler doesn't
handle these error cases currently and the condition in the poll
handler never returns mask with EPOLLIN set.
The result is that the poll call blocks and the application gets stuck
until the user_read_timer wakes it up after 120 sec.
Make sure that error conditions also contribute to the poll mask
so that a correct error code could passed back to the caller.

Cc: Jarkko Sakkinen <jarkko@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: <linux-integrity@vger.kernel.org>
Cc: <stable@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Fixes: 9e1b74a63f77 ("tpm: add support for nonblocking operation")
Signed-off-by: Tadeusz Struk <tstruk@gmail.com>
---
Changes in v2:
- Updated commit message with better problem description.
- Fixed typeos.
---
 drivers/char/tpm/tpm-dev-common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/tpm/tpm-dev-common.c b/drivers/char/tpm/tpm-dev-common.c
index c08cbb306636..fe2679f84cb6 100644
--- a/drivers/char/tpm/tpm-dev-common.c
+++ b/drivers/char/tpm/tpm-dev-common.c
@@ -69,7 +69,7 @@ static void tpm_dev_async_work(struct work_struct *work)
 	ret = tpm_dev_transmit(priv->chip, priv->space, priv->data_buffer,
 			       sizeof(priv->data_buffer));
 	tpm_put_ops(priv->chip);
-	if (ret > 0) {
+	if (ret != 0) {
 		priv->response_length = ret;
 		mod_timer(&priv->user_read_timer, jiffies + (120 * HZ));
 	}
-- 
2.30.2

