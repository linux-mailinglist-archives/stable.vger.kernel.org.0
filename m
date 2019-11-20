Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0958103DC2
	for <lists+stable@lfdr.de>; Wed, 20 Nov 2019 15:51:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731862AbfKTOvv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Nov 2019 09:51:51 -0500
Received: from mail-ed1-f66.google.com ([209.85.208.66]:33396 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731836AbfKTOvu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Nov 2019 09:51:50 -0500
Received: by mail-ed1-f66.google.com with SMTP id a24so20481644edt.0;
        Wed, 20 Nov 2019 06:51:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LdZZamBZOTXJ+H49jpFbHd4kFB5olOuJEEXYQ+Tq3NY=;
        b=dgZEIp0JWrBkNmGhY1hotc/HfrYrsv061gkPNzjqZ+nDs5m/8jP2Sv9F3N6Bpp6+o2
         QFdwjJ1R4/CGyMPpkH7xAVjffMLKBy/CrnCOEHURxLjG7A3otnYfV89ihKbCYRg68kEz
         4ovkIlw6TBugxwmyl+Bc50gyX3QdXnp4HV/6z0f1a+ytSOdIwH3sok1vvend7wRX4pj5
         1HKdewXuetw/yj7ektzucVP6VksturXb7yrGa6mjCyROLtltrQRldPA3vnLBXD+iKU8M
         kChAaryOf5RZ7gqAm04Tijcq01q14HImTxhbnNka3/cW0CFK7lc/52/QvO17hqkk+MLQ
         GXBQ==
X-Gm-Message-State: APjAAAUqTbBPGl+flcfDdipMo5HxO0ApCixTUtjB95V1r/if5DSUnvzZ
        sI/Q7Hfg0bKKdkGAV450nq4=
X-Google-Smtp-Source: APXvYqx4sL4itCM4mhO7FgVoymcvMnSi2elIRoWRpIrIaTNkF429Yn2Jt/uSeG1Yvnpm1OX14iuOXw==
X-Received: by 2002:a17:906:f108:: with SMTP id gv8mr6110283ejb.180.1574261508945;
        Wed, 20 Nov 2019 06:51:48 -0800 (PST)
Received: from green.intra.ispras.ru (bran.ispras.ru. [83.149.199.196])
        by smtp.googlemail.com with ESMTPSA id r3sm1457572eds.64.2019.11.20.06.51.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Nov 2019 06:51:48 -0800 (PST)
From:   Denis Efremov <efremov@linux.com>
Cc:     Denis Efremov <efremov@linux.com>,
        linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Casey Schaufler <casey@schaufler-ca.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>, stable@vger.kernel.org
Subject: [PATCH] Smack: check length in smk_set_cipso()
Date:   Wed, 20 Nov 2019 17:51:18 +0300
Message-Id: <20191120145118.30402-1-efremov@linux.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

It's possible to trigger out-of-bounds read in smk_set_cipso().
For example (from root):
$ echo "test 1" > /sys/fs/smackfs/cipso2
BUG: KASAN: slab-out-of-bounds in vsscanf+0x2203/0x2990
Read of size 1 at addr ffff888061b023c9 by task bash/5578

The patch adds length checks for SMK_LONG_FMT format.

The bug was found by syzkaller.

Cc: Casey Schaufler <casey@schaufler-ca.com>
Cc: James Morris <jmorris@namei.org>
Cc: "Serge E. Hallyn" <serge@hallyn.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Denis Efremov <efremov@linux.com>
---
 security/smack/smackfs.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
index e3e05c04dbd1..fad50a5a807b 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -878,6 +878,9 @@ static ssize_t smk_set_cipso(struct file *file, const char __user *buf,
 	else
 		rule += strlen(skp->smk_known) + 1;
 
+	if (rule - data + 2 * SMK_DIGITLEN - 1 >= count)
+		goto out;
+
 	ret = sscanf(rule, "%d", &maplevel);
 	if (ret != 1 || maplevel > SMACK_CIPSO_MAXLEVEL)
 		goto out;
@@ -887,15 +890,19 @@ static ssize_t smk_set_cipso(struct file *file, const char __user *buf,
 	if (ret != 1 || catlen > SMACK_CIPSO_MAXCATNUM)
 		goto out;
 
-	if (format == SMK_FIXED24_FMT &&
-	    count != (SMK_CIPSOMIN + catlen * SMK_DIGITLEN))
+	rule += SMK_DIGITLEN;
+
+	if ((format == SMK_FIXED24_FMT &&
+	     count != (SMK_CIPSOMIN + catlen * SMK_DIGITLEN)) ||
+	    (format == SMK_LONG_FMT &&
+	     count != (rule - data + catlen * SMK_DIGITLEN)))
 		goto out;
 
 	memset(mapcatset, 0, sizeof(mapcatset));
 
 	for (i = 0; i < catlen; i++) {
-		rule += SMK_DIGITLEN;
 		ret = sscanf(rule, "%u", &cat);
+		rule += SMK_DIGITLEN;
 		if (ret != 1 || cat > SMACK_CIPSO_MAXCATNUM)
 			goto out;
 
-- 
2.21.0

