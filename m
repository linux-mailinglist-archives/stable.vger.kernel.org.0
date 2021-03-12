Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA5B6339297
	for <lists+stable@lfdr.de>; Fri, 12 Mar 2021 17:00:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232130AbhCLQAF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Mar 2021 11:00:05 -0500
Received: from mail-wr1-f48.google.com ([209.85.221.48]:37900 "EHLO
        mail-wr1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231855AbhCLP7g (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Mar 2021 10:59:36 -0500
Received: by mail-wr1-f48.google.com with SMTP id d15so5088041wrv.5;
        Fri, 12 Mar 2021 07:59:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yVOAMLQtHgH63cMZg+F/kTpWBAiKNH2of3Em41CxuKU=;
        b=b2vvexCW57KpUJYAQUdv8hMzZmIOnvprhQA5Pg0dE1SAWzbGnLUnXjIfPNkzYeSUTL
         6MJqHTbMB9eGk9tOXL+4/oYjoDATVevFjU3t0ugEa4jkcO6RCkLxDv3tDLPCQRycAEzq
         YsoITAg6uFIdY8mvbhCU8sfNzBzaJgdIsJto5VptnMhV9uyX62/L4uSC0gLJRj0+bh1o
         Dtj7gAGTYNBFT4Q6IkGJJ6lOgtjITM8q+FgbLRfoOHfcXPHqCV1JWf7L7N0x2DNdggJq
         PceemWJtJRw3ScIzrNbRZnMO5rG02E2kqC7pcrU02cHKQ8WD/DY763dEHenCEtyNaOvy
         ilzA==
X-Gm-Message-State: AOAM5309mlWncr+qmsa6q8aghH/mqddrudhDTDgAXvXoMNXJk1BwZ/2j
        mze4j4B80UVcZflD6ybrPWTnrTc5li/fGg==
X-Google-Smtp-Source: ABdhPJzASHbK/VeiZyZNA8Bh1z97CdsFy6iiLRUMjRte347xOS/zclCa96opLkbzmfiYKPUDz/tXHQ==
X-Received: by 2002:a5d:68cd:: with SMTP id p13mr15358027wrw.247.1615564774638;
        Fri, 12 Mar 2021 07:59:34 -0800 (PST)
Received: from localhost.localdomain ([82.213.216.189])
        by smtp.gmail.com with ESMTPSA id p17sm2496706wmq.47.2021.03.12.07.59.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 07:59:33 -0800 (PST)
From:   Andrew Zaborowski <andrew.zaborowski@intel.com>
To:     keyrings@vger.kernel.org
Cc:     David Howells <dhowells@redhat.com>,
        Jarkko Sakkinen <jarkko@kernel.org>, stable@vger.kernel.org
Subject: [RESEND][PATCH 1/2] keys: crypto: Replace BUG_ON() with WARN() in find_asymmetric_key()
Date:   Fri, 12 Mar 2021 16:59:12 +0100
Message-Id: <20210312155913.1024673-1-andrew.zaborowski@intel.com>
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
index 33e77d846ca..47cc88fa0fa 100644
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

