Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70EED585B58
	for <lists+stable@lfdr.de>; Sat, 30 Jul 2022 19:04:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235255AbiG3RE4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 30 Jul 2022 13:04:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230120AbiG3REz (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 30 Jul 2022 13:04:55 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98A6813F13
        for <stable@vger.kernel.org>; Sat, 30 Jul 2022 10:04:54 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id p5so9038723edi.12
        for <stable@vger.kernel.org>; Sat, 30 Jul 2022 10:04:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=v7llhAnJ1XIt1ETAkueExb82zG7Fr/UgA91RklqvvIc=;
        b=V/zFj1N8+AhHnyHWgV1Ga7qZ1imoAUkL5fLR9b5/WrnC5Jkg94L0zvdmgKgl8L4TRn
         u0ugMmTRQwy/mZ7kP7m9RucZgdcCZGts489l55drouvZCqENYPQvpQ3k00c3IHdwEij4
         7N2PCZalPfIMQWLLeAUs0yxnrcfgDvmauwFjo270xVs+TYKKGvaAHbsaliE/RrClWE0p
         nluZcE8v8FOZZibyGdkQTzobjsOMqFftuMW+YXp3FtdmO4HhyZeRu0Hc9sNobCZaHzNw
         7IA+9BqXOLQUoqfPC2faM3/EE0CZ7w3gUEeaAHRrV/Pah81lGlmTbH75AVRqFqg94Rva
         Kpgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=v7llhAnJ1XIt1ETAkueExb82zG7Fr/UgA91RklqvvIc=;
        b=HP7yGheyKL61r4EqtiS/je2+Q4AHqsf85QfP3XVZszAsIm8fcjYA+g4yCjaDEiLjrW
         Vb94D4XkyFrgWy5+Uk9mQYpEDx9qf+hu153ZkAEA2+y/bpqsevsI9vn5XhuFgnDgcgRs
         u1DTFAdIyCEhwyB3xfJs0iiCjv/TyPN4DEG/8vBXjGS/xQNEyysOUyDY1fw56DwIvGJS
         BlJijKk/4dDSkssI4jsYrQsUx2kN4U/MyhJkoahmmcwL4kcdYcvv938hZ2yLesVXxvM0
         JY3H1eXihcCBMnNVRSi40JsTrT74n/4xDuAOcIvYrhRwEl9qkOAYiNJC/41Y6/FSgnbf
         QrDw==
X-Gm-Message-State: ACgBeo0ab6pXxnQ0ELrPacN1Qy1zTkmVbiC8YdiZvs8/gH7X42rjGerz
        jVUYTkaYzw2RRO6ykefcuVsBO56h7bY5pQ==
X-Google-Smtp-Source: AA6agR4jK6GbTILnHbvAobDBSI+0PwdJwhkh5SpJj2Fh8pCFsHLM5iHuyTAsz/rvza9PIr8Rcpw1cg==
X-Received: by 2002:a05:6402:b88:b0:43d:6175:761f with SMTP id cf8-20020a0564020b8800b0043d6175761fmr2022978edb.237.1659200693223;
        Sat, 30 Jul 2022 10:04:53 -0700 (PDT)
Received: from alex-Mint.fritz.box (p200300f6af2fc300f82d90934ef08f18.dip0.t-ipconnect.de. [2003:f6:af2f:c300:f82d:9093:4ef0:8f18])
        by smtp.googlemail.com with ESMTPSA id b8-20020aa7c908000000b0043af8007e7fsm4101868edt.3.2022.07.30.10.04.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Jul 2022 10:04:52 -0700 (PDT)
From:   Alexander Grund <theflamefire89@gmail.com>
To:     stable@vger.kernel.org
Cc:     Tianyue Ren <rentianyue@kylinos.cn>,
        Alexander Grund <theflamefire89@gmail.com>
Subject: [PATCH 4.9 5/6] selinux: fix error initialization in inode_doinit_with_dentry()
Date:   Sat, 30 Jul 2022 19:03:42 +0200
Message-Id: <20220730170343.11477-6-theflamefire89@gmail.com>
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

From: Tianyue Ren <rentianyue@kylinos.cn>

commit 83370b31a915493231e5b9addc72e4bef69f8d31 upstream.

Mark the inode security label as invalid if we cannot find
a dentry so that we will retry later rather than marking it
initialized with the unlabeled SID.

Fixes: 9287aed2ad1f ("selinux: Convert isec->lock into a spinlock")
Signed-off-by: Tianyue Ren <rentianyue@kylinos.cn>
[PM: minor comment tweaks]
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Alexander Grund <theflamefire89@gmail.com>
---
 security/selinux/hooks.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index d252890debf7..b9c7e089906c 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -1450,7 +1450,13 @@ static int inode_doinit_with_dentry(struct inode *inode, struct dentry *opt_dent
 			 * inode_doinit with a dentry, before these inodes could
 			 * be used again by userspace.
 			 */
-			goto out;
+			isec->initialized = LABEL_INVALID;
+			/*
+			 * There is nothing useful to jump to the "out"
+			 * label, except a needless spin lock/unlock
+			 * cycle.
+			 */
+			return 0;
 		}
 
 		len = INITCONTEXTLEN;
@@ -1558,8 +1564,15 @@ static int inode_doinit_with_dentry(struct inode *inode, struct dentry *opt_dent
 			 * inode_doinit() with a dentry, before these inodes
 			 * could be used again by userspace.
 			 */
-			if (!dentry)
-				goto out;
+			if (!dentry) {
+				isec->initialized = LABEL_INVALID;
+				/*
+				 * There is nothing useful to jump to the "out"
+				 * label, except a needless spin lock/unlock
+				 * cycle.
+				 */
+				return 0;
+			}
 			rc = selinux_genfs_get_sid(dentry, sclass,
 						   sbsec->flags, &sid);
 			dput(dentry);
-- 
2.25.1

