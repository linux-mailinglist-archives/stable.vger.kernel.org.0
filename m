Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB9ED48A775
	for <lists+stable@lfdr.de>; Tue, 11 Jan 2022 06:52:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347334AbiAKFwr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jan 2022 00:52:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347288AbiAKFwq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Jan 2022 00:52:46 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A98CC06173F;
        Mon, 10 Jan 2022 21:52:46 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id l8so13311010plt.6;
        Mon, 10 Jan 2022 21:52:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jIfH09JLImJRHA4SgBVUlZIpfJTuCTHgSeKemIfbCRg=;
        b=Q/te1YCCOtFEOLwx6H13j5toJEgwF1TWXHH8Liq8/o9KoZyG53yQX3Qq4BOTuHnrr2
         lqvXmBJBSZSw1pJWmD9GcaqKnNY4ssLEjXRDDCVJ4uzP+cWN0QLktUhRqdopvcEjKyWv
         g1X9NysdCj/V6r3NdKJia7WyR2jx6k84VUwjtLRrnFYllXe2B4ouSwQLNSzF+DvlGA1c
         I3ht8TdIysMBgQp1W5nIKlRiqxCUyb96stoSDgziDQjlF4DVxKATgvH80PcXV1//ukyn
         8nm3djvfCiGf9ch+GXiw0xJrC+sduY/6eWZ34NSDzLEXgcFSlFhVHPlJzBjPOFXMjnPd
         h6hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jIfH09JLImJRHA4SgBVUlZIpfJTuCTHgSeKemIfbCRg=;
        b=nThbzfPUW1rS46bE1W562BLa2lifPrJ46w4i2f//JEPx7V31kW2YgJNlKNY3r/uMpB
         uATZ5Ov+9QTFfq2giqzRdtGRlSFyw14hPGyARz0+UTVOeBbmPoLJ9cYCmva2euqoJqH0
         9M2LeQvuHZHQhIC0vORVlFD+LaF7N0rsTqSAIoC64tqc0hprWIOc5zDe7gLU8l0iXVOE
         Ihgnn2/BhQWhRPdDSUuU+5sWAA0yL0QrLtVcNLfcTsW8VxCzdUuWN+YTh9o0Gh614JFN
         ciLDwNj+L+twgl3Gt6L3eRJdoVcSmLQehtFerDpRc+bvnyuPOOYw+pEEnywa+OGFIRcu
         95yQ==
X-Gm-Message-State: AOAM533Epk9KYSyfnXI1w0/LUttRpTlr7NBoJHH+N7nWWBczPVsun07E
        iVBQ/VVMzpA6AqcyzUkC+GAgC7ZgdbX8Hvf0gqI=
X-Google-Smtp-Source: ABdhPJy6fG3APJEM65fde4H5vmIgSUFjPOR0m8oxa4fcMZqnTTcWVluDguIb3zsZkWUJHSxeULxxHA==
X-Received: by 2002:a63:1d7:: with SMTP id 206mr2771722pgb.111.1641880365805;
        Mon, 10 Jan 2022 21:52:45 -0800 (PST)
Received: from localhost.localdomain ([50.39.160.154])
        by smtp.gmail.com with ESMTPSA id k3sm843254pjt.39.2022.01.10.21.52.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jan 2022 21:52:45 -0800 (PST)
From:   Tadeusz Struk <tstruk@gmail.com>
To:     jarkko@kernel.org
Cc:     Tadeusz Struk <tstruk@gmail.com>, Jason Gunthorpe <jgg@ziepe.ca>,
        linux-integrity@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/2] tpm: Fix error handling in async work
Date:   Mon, 10 Jan 2022 21:52:27 -0800
Message-Id: <20220111055228.1830-1-tstruk@gmail.com>
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
Signed-off-by: Tadeusz Struk <tstruk@gmail.com>
---
Changed in v2:
- Updated commit message with better problem description
- Fixed typeos.
Changed in v3:
- Added a comment to tpm_dev_async_work.
- Updated commit message.
---
 drivers/char/tpm/tpm-dev-common.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/char/tpm/tpm-dev-common.c b/drivers/char/tpm/tpm-dev-common.c
index c08cbb306636..50df8f09ff79 100644
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
+	 * returned a return code.
+	 */
+	if (ret != 0) {
 		priv->response_length = ret;
 		mod_timer(&priv->user_read_timer, jiffies + (120 * HZ));
 	}
-- 
2.30.2

