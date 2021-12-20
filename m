Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8329447B4F6
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 22:17:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbhLTVRe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 16:17:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbhLTVRd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 16:17:33 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 975F3C061574;
        Mon, 20 Dec 2021 13:17:33 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id w24so9034513ply.12;
        Mon, 20 Dec 2021 13:17:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=psuOqlsJGs9pG6gMEgVrjbWLFo36C86JFOb7U8gCWs8=;
        b=G26WWF2RtTLN99ou1dc9FDdsz49LsFtA8TwS/pIB04TvsrXNYMJ9G8mmAfxpyB9HeN
         ddTbMDxSMwI/Niz+Dl3FRsEGtyRpRWlr+1OFBJAcFcZNhtq2tzS1TM1IMYaAlnw8QVe8
         82vbib1bvTDoeTxUJBHlE4RjM77GT9afAud5Brrfjezr+QSc7CsJFMNFg7qhsWXKxwHv
         xAmEiYRBxHCvtxQ3QPpA2u130z2mp2rQByvBDI1Wb6bJW2dxqzzgb+KJYyf8Lw+XJTKU
         R4VMvXf8v8x0WVzV6akSqCydNW4zEV5PO+vJ6mB9tnsTAnWXL/BUokG0Bsi5dZMTGL6j
         27Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=psuOqlsJGs9pG6gMEgVrjbWLFo36C86JFOb7U8gCWs8=;
        b=iKaekvl89bGk/ipxOHJYAR1aiBYWASr5HugjJ4QPJUrJhUbzEAwRkGga3A2fY16VQ4
         PTNlj7Kn/HXSDtJXId9Ptsh/67dioCynzCkznXNPeDmoKG4tiX6zrh8IfOliycFiE49T
         PweJaHV+vOTLWdDR2vsrhEEWUQYhIAao9838G30XDmV49kBPL106DoNdRK7ShvYVH/Aw
         Oie1aCGd8BXgeTMSRRqHYlch6REPMnHfy+n6eZSxtdOrOYAcOptASgfgS8ddJrdnpm/R
         moXI0NE43vBenl9S6HdZBCvC0x+a2KOXySQ0ev+PWfx0peqqLhcc6p40Hu0AtucD6dWm
         oaTw==
X-Gm-Message-State: AOAM53094FaO5ni178uKHI1sM2ZdZIDn6BzCULudngnql72NuY38vQPF
        UVMVV40HDIUn9E3/9iz9NHNq/ED61gBIMA==
X-Google-Smtp-Source: ABdhPJyZKdrn0LUAun5zZXzDkS/CWNW+U0/A3AX8Vw9RKBlJJ56jwPPpoZ2kusokGEQs13pS9iHOmQ==
X-Received: by 2002:a17:902:eb44:b0:148:b1ed:1a33 with SMTP id i4-20020a170902eb4400b00148b1ed1a33mr21079pli.149.1640035053118;
        Mon, 20 Dec 2021 13:17:33 -0800 (PST)
Received: from localhost.localdomain ([50.39.160.154])
        by smtp.gmail.com with ESMTPSA id ot6sm301975pjb.32.2021.12.20.13.17.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Dec 2021 13:17:32 -0800 (PST)
From:   Tadeusz Struk <tstruk@gmail.com>
To:     jarkko@kernel.org
Cc:     Tadeusz Struk <tstruk@gmail.com>, Jason Gunthorpe <jgg@ziepe.ca>,
        linux-integrity@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] tpm: Fix error handling in async work
Date:   Mon, 20 Dec 2021 13:16:59 -0800
Message-Id: <20211220211700.5772-1-tstruk@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When an invalid (non exitsinting) handle is used in a tpm command,
that uses the resource manager interface (/dev/tpmrm0) the resource
manager tries to load it from its internal cache, but fails and
returns an -EINVAL error to the caller. The existing async handler
doesn't handle these error cases currently and the condition in the
poll handler never returns mask with EPOLLIN set causing the userspace
code to get stack. Make sure that error conditions also contribute
to the poll mask so that a correct error code could passed back
to the caller.

Cc: Jarkko Sakkinen <jarkko@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: <linux-integrity@vger.kernel.org>
Cc: <stable@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Fixes: 9e1b74a63f77 ("tpm: add support for nonblocking operation")
Signed-off-by: Tadeusz Struk <tstruk@gmail.com>
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

