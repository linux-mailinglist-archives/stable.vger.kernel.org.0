Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6A74370417
	for <lists+stable@lfdr.de>; Sat,  1 May 2021 01:28:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230508AbhD3X26 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Apr 2021 19:28:58 -0400
Received: from mail-wm1-f43.google.com ([209.85.128.43]:37472 "EHLO
        mail-wm1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232743AbhD3X26 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Apr 2021 19:28:58 -0400
Received: by mail-wm1-f43.google.com with SMTP id l189-20020a1cbbc60000b0290140319ad207so2489332wmf.2;
        Fri, 30 Apr 2021 16:28:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=e7M7J9ueTHYRqRSdos1354dv+7ox/fMvVKVag0BPtGI=;
        b=QC+q69+PwCN7LOMpwQYX0i2pft/1AtSulH7ktLjJOJbneIeTKNXTY39lMj4okkDCH8
         A5bMSxBx9YOYh/SKYCYgxtyWgtDek4jyBhzfvMs8w5WLi5wtyYdQSNV1DCf+9q2pb+51
         OqbiceNryJ37x2RlQvPzJMw3lqDmTuvUQjssrRuvalNP4RgcTFA69k9UF4sTTFQ7wUl2
         NeEaHN4jfcun2ZyuiOuZ0NKLFCm9ysVoqIgHwuXFJxCvd4rBvG5MU6DyccFMuvVxhj1A
         jieISOCvHqALoAE0xccop0pRf28mvSl0dg6upf2+Ve2+HpACmVK5LXKU8quqF6k80gT4
         +Uog==
X-Gm-Message-State: AOAM532mURp53sH238y949nuaET45WA1HrMq/k4ZNo/+QVJcrZAdZNwm
        1RL20IiMWeyGkjCOmnKQy7VqZ7aCKWvIuA==
X-Google-Smtp-Source: ABdhPJza0ln1bOMwbl3+CbiKmncgMLNYniqPu6H3H43cNxhWIs2J+qDnXMm0ftzVY7jVSwLLzzojTQ==
X-Received: by 2002:a7b:cc06:: with SMTP id f6mr18804461wmh.178.1619825287332;
        Fri, 30 Apr 2021 16:28:07 -0700 (PDT)
Received: from localhost.localdomain ([82.213.255.95])
        by smtp.gmail.com with ESMTPSA id f4sm3967378wrz.33.2021.04.30.16.28.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Apr 2021 16:28:06 -0700 (PDT)
From:   Andrew Zaborowski <andrew.zaborowski@intel.com>
To:     keyrings@vger.kernel.org
Cc:     David Howells <dhowells@redhat.com>,
        Jarkko Sakkinen <jarkko@kernel.org>, stable@vger.kernel.org
Subject: [RESEND][PATCH 1/2] keys: crypto: Replace BUG_ON() with WARN() in find_asymmetric_key()
Date:   Sat,  1 May 2021 01:27:53 +0200
Message-Id: <20210430232754.3017358-1-andrew.zaborowski@intel.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jarkko Sakkinen <jarkko@kernel.org>

BUG_ON() should not be used in the kernel code, unless there are
exceptional reasons to do so. Replace BUG_ON() with WARN() and
return.

Cc: stable@vger.kernel.org
Fixes: b3811d36a3e7 ("KEYS: checking the input id parameters before finding asymmetric key")
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
No changes from original submission by Jarkko.

 crypto/asymmetric_keys/asymmetric_type.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/crypto/asymmetric_keys/asymmetric_type.c b/crypto/asymmetric_keys/asymmetric_type.c
index ad8af3d70ac..a00bed3e04d 100644
--- a/crypto/asymmetric_keys/asymmetric_type.c
+++ b/crypto/asymmetric_keys/asymmetric_type.c
@@ -54,7 +54,10 @@ struct key *find_asymmetric_key(struct key *keyring,
 	char *req, *p;
 	int len;
 
-	BUG_ON(!id_0 && !id_1);
+	if (!id_0 && !id_1) {
+		WARN(1, "All ID's are NULL\n");
+		return ERR_PTR(-EINVAL);
+	}
 
 	if (id_0) {
 		lookup = id_0->data;
-- 
2.27.0

