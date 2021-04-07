Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27C7E356E68
	for <lists+stable@lfdr.de>; Wed,  7 Apr 2021 16:21:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231183AbhDGOV7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Apr 2021 10:21:59 -0400
Received: from mail-wm1-f45.google.com ([209.85.128.45]:41674 "EHLO
        mail-wm1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243693AbhDGOV6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Apr 2021 10:21:58 -0400
Received: by mail-wm1-f45.google.com with SMTP id t5-20020a1c77050000b029010e62cea9deso1292184wmi.0;
        Wed, 07 Apr 2021 07:21:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=e7M7J9ueTHYRqRSdos1354dv+7ox/fMvVKVag0BPtGI=;
        b=qLPg4AelpIf3do4Z9FFYiLyDKZtphGevH6O7dq5ymw95y0a/BztRVbMsVntwXqmHBM
         ocS+1w5+tZ3aPwyrtkkRfxPqlJxSGE1w/QH4oL3DDFwfSVnPtQzW/ZxpgmtGMOM+T9+b
         76sW9w8760ocQS7lhdCja+3a6A6/M/ZcA9ehjlp8Av7kUH1Fn0GtYG7TQlNJBS1fQjSq
         XwpiSZxEqU03nOjpSz02nzBaagUH91sqpp4GxIH7Pf3tFMHenKk0kO9pvWnDXJs6hgQC
         SNQvYxoJmcDJ6HPzpcylFBOR1/J3qrirdHgotYlatr0ApLeqNa2GAfpkEZkSHYxSWjqp
         turA==
X-Gm-Message-State: AOAM531uTZwY8xESvJi1Z57KuiLTJIP3UBs9ZUuHeCrvHHwLAeRSaF3a
        X1zCHaIUMNuqCb4XoJcoxYakn3yHLPQ4TA==
X-Google-Smtp-Source: ABdhPJzxMQp0oYYs07zABj471pglJExU5Gu6yYOvSBoeTe77t+WmPTBDtgpkRwlRhMZa8Lw03x7NUA==
X-Received: by 2002:a1c:9a02:: with SMTP id c2mr3422191wme.131.1617805306789;
        Wed, 07 Apr 2021 07:21:46 -0700 (PDT)
Received: from localhost.localdomain ([82.213.216.189])
        by smtp.gmail.com with ESMTPSA id c8sm8522458wmb.34.2021.04.07.07.21.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Apr 2021 07:21:46 -0700 (PDT)
From:   Andrew Zaborowski <andrew.zaborowski@intel.com>
To:     keyrings@vger.kernel.org
Cc:     David Howells <dhowells@redhat.com>,
        Jarkko Sakkinen <jarkko@kernel.org>, stable@vger.kernel.org
Subject: [RESEND][PATCH 1/2] keys: crypto: Replace BUG_ON() with WARN() in find_asymmetric_key()
Date:   Wed,  7 Apr 2021 16:21:32 +0200
Message-Id: <20210407142133.257582-1-andrew.zaborowski@intel.com>
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

