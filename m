Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8243839001A
	for <lists+stable@lfdr.de>; Tue, 25 May 2021 13:36:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231465AbhEYLiO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 May 2021 07:38:14 -0400
Received: from mail-wm1-f53.google.com ([209.85.128.53]:36519 "EHLO
        mail-wm1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231127AbhEYLiN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 May 2021 07:38:13 -0400
Received: by mail-wm1-f53.google.com with SMTP id n17-20020a7bc5d10000b0290169edfadac9so3408860wmk.1;
        Tue, 25 May 2021 04:36:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=e7M7J9ueTHYRqRSdos1354dv+7ox/fMvVKVag0BPtGI=;
        b=DImA08/yxCYtagAn98bhvOplsPcCJeHTLNocOjywSlgWZ+XIzEMShhuHGnLzQDJRPk
         G5OltvqNPgSJ1y9VNWKtHfX0TuJCKJ0mQhRj8nuRmSKANSuzX7FECq40e4yzaPPVZUTu
         ONdrkqr9kugMvxPuo3i/vJ+bZ7XSxygG7HAvcTHfQVTPTw6RjFqxG8m4mp9McVK9czSI
         R5U1Nq/m4Qd+H1ZsY3XE8xC26oDqxWios0jluedAoBNTKOdsLhBMR12RsOht0g1oa2+K
         uThKC/uI+jlryYUVbCCicsbRbLBvA0he7KyvWrcFT9ypZHChDb2kVgJj17IfmsH2XluS
         BlpQ==
X-Gm-Message-State: AOAM532T1dr3cr8rKL8CCsZ018ik+F0yfMaKhmsJOzq/roS2RZRWftfk
        BlOBdPKqSihrA+TQzGMOrw1QXaovatoBnw==
X-Google-Smtp-Source: ABdhPJw7Wv8hVLwEvwm/jP3QbzIjEbvXVWClAzHv3sRmCjXWwjpYAUxMSVuFJt6HK74dejNTogM5PA==
X-Received: by 2002:a1c:a9ca:: with SMTP id s193mr23839395wme.132.1621942601785;
        Tue, 25 May 2021 04:36:41 -0700 (PDT)
Received: from iss.Home ([82.213.255.93])
        by smtp.gmail.com with ESMTPSA id z3sm2471300wmi.31.2021.05.25.04.36.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 May 2021 04:36:41 -0700 (PDT)
From:   Andrew Zaborowski <andrew.zaborowski@intel.com>
To:     keyrings@vger.kernel.org
Cc:     Jarkko Sakkinen <jarkko@kernel.org>, stable@vger.kernel.org
Subject: [RESEND][PATCH 1/2] keys: crypto: Replace BUG_ON() with WARN() in find_asymmetric_key()
Date:   Tue, 25 May 2021 13:36:27 +0200
Message-Id: <20210525113628.2682248-1-andrew.zaborowski@intel.com>
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

