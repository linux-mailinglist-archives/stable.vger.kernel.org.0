Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5934D585B59
	for <lists+stable@lfdr.de>; Sat, 30 Jul 2022 19:04:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235259AbiG3RE6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 30 Jul 2022 13:04:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230120AbiG3RE5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 30 Jul 2022 13:04:57 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B367C13F13
        for <stable@vger.kernel.org>; Sat, 30 Jul 2022 10:04:56 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id ss3so13366589ejc.11
        for <stable@vger.kernel.org>; Sat, 30 Jul 2022 10:04:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=KbOn538oUDRba/LrgHC4/uyu4v4VWZELPGa8dCyMF0Q=;
        b=L0gObiQOB5wRBEgVXO87PlYhtLhA4jsAyOowNx+UnXbojakHQWQvBLcXuKnl/bTq3c
         hb5BvH+V3ywaJZ774GOM9C7RwRSgqv1Uo2yHx8JXQoPISuHtRAeKgYBfBWSLSqx6GlZ/
         3C/4Vimm1/EikY8nlbzaTbpSmfFUuB0n/JonH+nM7JCuXY+yOH0GuH0S4fvjqeLMaMlZ
         bn6/7ZJsJJgbia1fblT60kLom2LrVbFK2Aa57B2JrLIHw/wkF5FY+bJ2U+b3em7tP9O9
         1fwmW4Fz09ZUZS0SgPJWk0a+X/wnjd7hdMJ2WRNIK60bdmVElJIW6zX0jdqU+lceFK14
         EuqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=KbOn538oUDRba/LrgHC4/uyu4v4VWZELPGa8dCyMF0Q=;
        b=JcHSJicQuejsyA3TMg5AYuidspeh1PyNaq48Yf+WqlLRhhIrxXsAYG3gvfc2eY+nz/
         lZdg7/aLqfX1dy0M2dyIHfPWAoHUUbPZmGrSbBsKUVjux9j1kFM7QZ6CyTYx5azDBEUO
         qMI9S7DoOLrRRxgwm/rO1VZXReq2vArupMDYQz9dd+EZWrtG5Jy/meOaJKR6iJfo/bLn
         p3dDpgtl8ODmDgY5fb4Uo52HRXuXIUId8Ja4IpgWnoDvVtID/s5veahx4M+oPtPxTCZs
         M2x93DwdVeNRTT1dbRzBfMcAV2IwQaZPfv2uAFpoao7/pd03ScF8EvC3QHV8akHL86LK
         Zmhg==
X-Gm-Message-State: AJIora81LNI4cTMYpWOJymMV8Ia3sQDZddxJ+kYA2hOeUW/Ya3vWY414
        ida3onONYWaSGqR61Dm9dp5JOGOt2bYG6A==
X-Google-Smtp-Source: AGRyM1u8AaHZl5PNtwPH8UtRcyHaLPuhplbatsZUAx88RHxRm3nfriMhl28rWnBUn+4mpTLkEAbCug==
X-Received: by 2002:a17:906:9bef:b0:72b:40d1:4276 with SMTP id de47-20020a1709069bef00b0072b40d14276mr6545597ejc.360.1659200695267;
        Sat, 30 Jul 2022 10:04:55 -0700 (PDT)
Received: from alex-Mint.fritz.box (p200300f6af2fc300f82d90934ef08f18.dip0.t-ipconnect.de. [2003:f6:af2f:c300:f82d:9093:4ef0:8f18])
        by smtp.googlemail.com with ESMTPSA id b8-20020aa7c908000000b0043af8007e7fsm4101868edt.3.2022.07.30.10.04.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Jul 2022 10:04:54 -0700 (PDT)
From:   Alexander Grund <theflamefire89@gmail.com>
To:     stable@vger.kernel.org
Cc:     Paul Moore <paul@paul-moore.com>,
        Alexander Grund <theflamefire89@gmail.com>
Subject: [PATCH 4.9 6/6] selinux: fix inode_doinit_with_dentry() LABEL_INVALID error handling
Date:   Sat, 30 Jul 2022 19:03:43 +0200
Message-Id: <20220730170343.11477-7-theflamefire89@gmail.com>
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

From: Paul Moore <paul@paul-moore.com>

commit 200ea5a2292dc444a818b096ae6a32ba3caa51b9 upstream.

A previous fix, commit 83370b31a915 ("selinux: fix error initialization
in inode_doinit_with_dentry()"), changed how failures were handled
before a SELinux policy was loaded.  Unfortunately that patch was
potentially problematic for two reasons: it set the isec->initialized
state without holding a lock, and it didn't set the inode's SELinux
label to the "default" for the particular filesystem.  The later can
be a problem if/when a later attempt to revalidate the inode fails
and SELinux reverts to the existing inode label.

This patch should restore the default inode labeling that existed
before the original fix, without affecting the LABEL_INVALID marking
such that revalidation will still be attempted in the future.

Fixes: 83370b31a915 ("selinux: fix error initialization in inode_doinit_with_dentry()")
Reported-by: Sven Schnelle <svens@linux.ibm.com>
Tested-by: Sven Schnelle <svens@linux.ibm.com>
Reviewed-by: Ondrej Mosnacek <omosnace@redhat.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Alexander Grund <theflamefire89@gmail.com>
---
 security/selinux/hooks.c | 31 +++++++++++++------------------
 1 file changed, 13 insertions(+), 18 deletions(-)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index b9c7e089906c..ac2381eec27f 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -1450,13 +1450,7 @@ static int inode_doinit_with_dentry(struct inode *inode, struct dentry *opt_dent
 			 * inode_doinit with a dentry, before these inodes could
 			 * be used again by userspace.
 			 */
-			isec->initialized = LABEL_INVALID;
-			/*
-			 * There is nothing useful to jump to the "out"
-			 * label, except a needless spin lock/unlock
-			 * cycle.
-			 */
-			return 0;
+			goto out_invalid;
 		}
 
 		len = INITCONTEXTLEN;
@@ -1564,15 +1558,8 @@ static int inode_doinit_with_dentry(struct inode *inode, struct dentry *opt_dent
 			 * inode_doinit() with a dentry, before these inodes
 			 * could be used again by userspace.
 			 */
-			if (!dentry) {
-				isec->initialized = LABEL_INVALID;
-				/*
-				 * There is nothing useful to jump to the "out"
-				 * label, except a needless spin lock/unlock
-				 * cycle.
-				 */
-				return 0;
-			}
+			if (!dentry)
+				goto out_invalid;
 			rc = selinux_genfs_get_sid(dentry, sclass,
 						   sbsec->flags, &sid);
 			dput(dentry);
@@ -1585,11 +1572,10 @@ static int inode_doinit_with_dentry(struct inode *inode, struct dentry *opt_dent
 out:
 	spin_lock(&isec->lock);
 	if (isec->initialized == LABEL_PENDING) {
-		if (!sid || rc) {
+		if (rc) {
 			isec->initialized = LABEL_INVALID;
 			goto out_unlock;
 		}
-
 		isec->initialized = LABEL_INITIALIZED;
 		isec->sid = sid;
 	}
@@ -1597,6 +1583,15 @@ static int inode_doinit_with_dentry(struct inode *inode, struct dentry *opt_dent
 out_unlock:
 	spin_unlock(&isec->lock);
 	return rc;
+
+out_invalid:
+	spin_lock(&isec->lock);
+	if (isec->initialized == LABEL_PENDING) {
+		isec->initialized = LABEL_INVALID;
+		isec->sid = sid;
+	}
+	spin_unlock(&isec->lock);
+	return 0;
 }
 
 /* Convert a Linux signal to an access vector. */
-- 
2.25.1

