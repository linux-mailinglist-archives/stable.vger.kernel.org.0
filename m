Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A488399E14
	for <lists+stable@lfdr.de>; Thu,  3 Jun 2021 11:50:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229719AbhFCJvu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Jun 2021 05:51:50 -0400
Received: from mail-qv1-f73.google.com ([209.85.219.73]:42937 "EHLO
        mail-qv1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbhFCJvu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Jun 2021 05:51:50 -0400
Received: by mail-qv1-f73.google.com with SMTP id if5-20020a0562141c45b029021fee105740so39162qvb.9
        for <stable@vger.kernel.org>; Thu, 03 Jun 2021 02:49:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=vmZCbqngTpm7tAp2K8sNJMCUQyvM+b4ETSTvf8bhdN0=;
        b=I7wdB9K8vmtF6uC4zn9AcunlOO/tAjuLKc1fWLguyixo+evPcpqGbTf6imz6wCbgoF
         FO4xknowcBjYgFodM6oHda646Ppe2+0/fTlP6bqHyN0Obmdda2M9FGpwZ/2alTEK0zFu
         jdSHK3AclAKFA0HdpMvGVTLbLdk7cz4TJlTUKLTrApjp5xAfu85QwmzUD72GMzW0pu09
         u8DKcHBLr7dogtgFbOmt6VKaBg3PXkE9jDFGlG3/Ml3xmueXd44MFN7ta8TMcWpEo++I
         62CUt6+ivNQehaxdDNklwLHk+su3nveYgviTr47LdeUepqOhpz8cCw9U1ENvAEt04M+n
         Al0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=vmZCbqngTpm7tAp2K8sNJMCUQyvM+b4ETSTvf8bhdN0=;
        b=gSHf+EZVPNRb0D5biIDm09EomEGD2juj+SZIdrgOYDRcuI1s0JBOUO+M7WopkgtBYm
         w6Yhh/fPiSDtEnyXxYs0gCgkbBqUyqu/3cXbyHdL1foxuUU+wbSIVvdQcI1qFxLviWtz
         b+KV9yEj9eRG0ZY6HGKFU9NBQJqZzemfsJ6l3/BI2CD7DyyxMsp/z0xVdm7QB3j+A+vq
         jU6PB9ZIRpqGY+EYO/+GZ6SfvrHjbJHkP44kS+LlpuV/mJH5PoJbFOYKylwUBbdsLLPS
         dB/PbfrNbrDkqyygr3n5VeDlZvi17cC3bPpQygMdB4vXPBvZStt4Zo8gg8gsLNvg2B23
         aNtg==
X-Gm-Message-State: AOAM5327Z01yFZWNWZ12dNLNmm05OlOBMCwhAzdluFLPufoo+1eRXD3C
        EqU/LlqCGlCJ06z9qFiQWmzijcZ2FeA=
X-Google-Smtp-Source: ABdhPJzQPM//koouAcGyOQfMwmc6RaUBZhppCtAOxPKFOiL6nD4RMfqevmtLMtegRNt5ClQAwmTec0eXbU8=
X-Received: from drosen.c.googlers.com ([fda3:e722:ac3:10:24:72f4:c0a8:4e6f])
 (user=drosen job=sendgmr) by 2002:ad4:4c0c:: with SMTP id bz12mr21689604qvb.21.1622713733247;
 Thu, 03 Jun 2021 02:48:53 -0700 (PDT)
Date:   Thu,  3 Jun 2021 09:48:49 +0000
Message-Id: <20210603094849.314342-1-drosen@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.rc0.204.g9fa02ecfa5-goog
Subject: [PATCH v2] ext4: Correct encrypted_casefolding sysfs entry
From:   Daniel Rosenberg <drosen@google.com>
To:     "Theodore Y . Ts'o" <tytso@mit.edu>,
        Eric Biggers <ebiggers@kernel.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        kernel-team@android.com, Daniel Rosenberg <drosen@google.com>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Encrypted casefolding is only supported when both encryption and
casefolding are both enabled in the config.

Fixes: 471fbbea7ff7 ("ext4: handle casefolding with encryption")
Cc: stable@vger.kernel.org # 5.13+
Signed-off-by: Daniel Rosenberg <drosen@google.com>
---
 fs/ext4/sysfs.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/ext4/sysfs.c b/fs/ext4/sysfs.c
index 6f825dedc3d4..55fcab60a59a 100644
--- a/fs/ext4/sysfs.c
+++ b/fs/ext4/sysfs.c
@@ -315,7 +315,9 @@ EXT4_ATTR_FEATURE(verity);
 #endif
 EXT4_ATTR_FEATURE(metadata_csum_seed);
 EXT4_ATTR_FEATURE(fast_commit);
+#if defined(CONFIG_UNICODE) && defined(CONFIG_FS_ENCRYPTION)
 EXT4_ATTR_FEATURE(encrypted_casefold);
+#endif
 
 static struct attribute *ext4_feat_attrs[] = {
 	ATTR_LIST(lazy_itable_init),
@@ -333,7 +335,9 @@ static struct attribute *ext4_feat_attrs[] = {
 #endif
 	ATTR_LIST(metadata_csum_seed),
 	ATTR_LIST(fast_commit),
+#if defined(CONFIG_UNICODE) && defined(CONFIG_FS_ENCRYPTION)
 	ATTR_LIST(encrypted_casefold),
+#endif
 	NULL,
 };
 ATTRIBUTE_GROUPS(ext4_feat);
-- 
2.32.0.rc0.204.g9fa02ecfa5-goog

