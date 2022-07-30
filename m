Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74F8C585B56
	for <lists+stable@lfdr.de>; Sat, 30 Jul 2022 19:04:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235120AbiG3REs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 30 Jul 2022 13:04:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230120AbiG3REq (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 30 Jul 2022 13:04:46 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECCBF13F13
        for <stable@vger.kernel.org>; Sat, 30 Jul 2022 10:04:45 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id b16so1605092edd.4
        for <stable@vger.kernel.org>; Sat, 30 Jul 2022 10:04:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=73BSQVay/oOgbxj9GFjZVedjv3mTgiPAUQ4L5HdSw5Q=;
        b=II2dxVlLLwcjGmFyXgnGjVo1ex01TZQ9IltOX7CMTaISnmDizqUZ9WuXX+s1wxEq8k
         SesnDzv/VRtnXQnY5hfLt6InYFevEaLbsYZOIFmilo2dAuu2+T1DcOxyGwtd9MuvyXhx
         ul2lK3fm9qXN0gMw9Zy+ax+pBwulRuYnquooidq8zWIS8cn1OlBfT7NAT6fVSeEHBrLM
         XGfIOqWsYNenumf4doQlZNYVxo7Av02YA+uYvJfdkCZSFeJUA3nWC5XnVRN898yBYgMy
         ySXpBcVs0COFIAb+CvLl2rS7BdkzCQJErthwaL5scI0GBcrYzdUKoNubO1arWRYHTnud
         JJMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=73BSQVay/oOgbxj9GFjZVedjv3mTgiPAUQ4L5HdSw5Q=;
        b=Tg001ArYBFRjCZDwX486xH0maWvmyHkwOf7is+tW+qD5ps6BdihAiNPKgGmsWz7r6W
         L278wIi+mApilH6Q431uvL0NLj1XPqkKSqyOFPDLhCSG4YQMZV+J5g2fpYVU71viDGcu
         cznFa4Dii/4v/rgvO1lAFm+Ov7DzpoWhwagpE987pAIzGcXgeBMgChuPcGdYJ3tkiuyO
         0oOj8N0M6imhIvAuTkFMUm06qKYncF3IwAkN/cTJXZxWtK8hEkvNaHBJpmb27YE7LpK9
         9/E31m6VV/MT5JxTh93KgPF3Y5PGa3HOaSIqsW+kXY31CBqFMOHMSCbnETPZOEWn35k7
         G/HQ==
X-Gm-Message-State: AJIora8ZfLaQtZf66bSInkfvdMs8BvD2ZRKgRQycIT8A0fKibPGubIP1
        cBRu4m3XhhQ7Nv/oC/RpRERDTWGMA3cvKA==
X-Google-Smtp-Source: AGRyM1uS4lwWBz8/ro0CbDsaIQYz3dE94HSDQMFe7IFAGh97dXAoFL2hCCaWhOJmvL4rsw2mf/kr0w==
X-Received: by 2002:a05:6402:3807:b0:435:20fb:318d with SMTP id es7-20020a056402380700b0043520fb318dmr8266536edb.272.1659200684469;
        Sat, 30 Jul 2022 10:04:44 -0700 (PDT)
Received: from alex-Mint.fritz.box (p200300f6af2fc300f82d90934ef08f18.dip0.t-ipconnect.de. [2003:f6:af2f:c300:f82d:9093:4ef0:8f18])
        by smtp.googlemail.com with ESMTPSA id b8-20020aa7c908000000b0043af8007e7fsm4101868edt.3.2022.07.30.10.04.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Jul 2022 10:04:44 -0700 (PDT)
From:   Alexander Grund <theflamefire89@gmail.com>
To:     stable@vger.kernel.org
Cc:     Andreas Gruenbacher <agruenba@redhat.com>,
        Alexander Grund <theflamefire89@gmail.com>
Subject: [PATCH 4.9 3/6] selinux: Clean up initialization of isec->sclass
Date:   Sat, 30 Jul 2022 19:03:40 +0200
Message-Id: <20220730170343.11477-4-theflamefire89@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220730170343.11477-1-theflamefire89@gmail.com>
References: <20220730170343.11477-1-theflamefire89@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Gruenbacher <agruenba@redhat.com>

commit 13457d073c29da92001f6ee809075eaa8757fb96 upstream.

Now that isec->initialized == LABEL_INITIALIZED implies that
isec->sclass is valid, skip such inodes immediately in
inode_doinit_with_dentry.

For the remaining inodes, initialize isec->sclass at the beginning of
inode_doinit_with_dentry to simplify the code.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Alexander Grund <theflamefire89@gmail.com>
---
 security/selinux/hooks.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 1997d87b35d5..d21b95a848b8 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -1395,12 +1395,15 @@ static int inode_doinit_with_dentry(struct inode *inode, struct dentry *opt_dent
 	int rc = 0;
 
 	if (isec->initialized == LABEL_INITIALIZED)
-		goto out;
+		return 0;
 
 	mutex_lock(&isec->lock);
 	if (isec->initialized == LABEL_INITIALIZED)
 		goto out_unlock;
 
+	if (isec->sclass == SECCLASS_FILE)
+		isec->sclass = inode_mode_to_security_class(inode->i_mode);
+
 	sbsec = inode->i_sb->s_security;
 	if (!(sbsec->flags & SE_SBINITIALIZED)) {
 		/* Defer initialization until selinux_complete_init,
@@ -1518,7 +1521,6 @@ static int inode_doinit_with_dentry(struct inode *inode, struct dentry *opt_dent
 		isec->sid = sbsec->sid;
 
 		/* Try to obtain a transition SID. */
-		isec->sclass = inode_mode_to_security_class(inode->i_mode);
 		rc = security_transition_sid(isec->task_sid, sbsec->sid,
 					     isec->sclass, NULL, &sid);
 		if (rc)
@@ -1554,7 +1556,6 @@ static int inode_doinit_with_dentry(struct inode *inode, struct dentry *opt_dent
 			 */
 			if (!dentry)
 				goto out_unlock;
-			isec->sclass = inode_mode_to_security_class(inode->i_mode);
 			rc = selinux_genfs_get_sid(dentry, isec->sclass,
 						   sbsec->flags, &sid);
 			dput(dentry);
@@ -1569,9 +1570,6 @@ static int inode_doinit_with_dentry(struct inode *inode, struct dentry *opt_dent
 
 out_unlock:
 	mutex_unlock(&isec->lock);
-out:
-	if (isec->sclass == SECCLASS_FILE)
-		isec->sclass = inode_mode_to_security_class(inode->i_mode);
 	return rc;
 }
 
-- 
2.25.1

