Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09D62A256E
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 20:30:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730043AbfH2Sac (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 14:30:32 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:44971 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729165AbfH2Saa (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Aug 2019 14:30:30 -0400
Received: by mail-pf1-f194.google.com with SMTP id c81so2621045pfc.11
        for <stable@vger.kernel.org>; Thu, 29 Aug 2019 11:30:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=android.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=t7rGaqUzAk36ILWcKr/jrH6Y9v6WlXTDUlDGIYS/FWg=;
        b=isJCPHV3UCx5mYklMoclrNYYLuiDQl8rOsozhV+AOuvC+A2RL6Of1dXi59VVYyJ8Yh
         nbEhIdofSeqRVf4HCfoE6ntd1M93ZOHul+nGhedXl4X/3a2yARQ0GOzfEQ15nzNgQYPB
         1qKP8GgA9JnCgMRJQUtSXxcy4vfrkx21r3RNVe3qyvObBnL8kD7niQLjxUF4okFXNipE
         xH4SbLpar4QTNbuR639sRK9Rl7AjtvDaXh7RxA2QQ5TQMMwH7Jvn/lt+jb0pKjCbx2kA
         nIW6xVEvasZpHC5rUvv6GxUt4FvYgKMyRkjbLb/Yai1SwPEGGgtc9v1G/s23AMVOJplX
         pIfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=t7rGaqUzAk36ILWcKr/jrH6Y9v6WlXTDUlDGIYS/FWg=;
        b=pKXGb270CuKXm5IBsyjG47NgGIlYuOQoBed3gT0Kruv56Wd2qg4fK8OfKZzFPhn/2v
         l1cDaJknIvZ69D/0GGFl6qLxpa9HVNMeaRoN/jc304toGComdKlfFemis0yEO6YdF+LB
         TTh4Du6Ash+5khjNLFMNx05867o50k4uVAX2wdiCvPK9F31NYZUCyvl983eYo8cY5ydC
         Ys7J0aNvF8aRG1Q+Uy/aKFgdFAyYoiKs47znk+smy4qEeeAhd9DTIulUtb5vCCRIdUh9
         /a9pG5ZBM4Xne9fOOGEBbQ2LeqvGBWLHuBz2lwLUnRHXjToVH4jo9asfamHOWWsUff3R
         Anxg==
X-Gm-Message-State: APjAAAXb+y9MTfTz/qC4zR2+22SZt+0XyDEBGvP9nKsCAmSE9GPVqOuy
        8FAz+Rl2VG2Vt7jW6XvP5OjW2Q==
X-Google-Smtp-Source: APXvYqw/vXkr0PEX/jzpgnhtbh7cvLECq0WihqgmP+dtE4STT7/cXn7PqLsTujfn/flbDd+wdX6iYg==
X-Received: by 2002:a63:c84d:: with SMTP id l13mr9620053pgi.154.1567103429436;
        Thu, 29 Aug 2019 11:30:29 -0700 (PDT)
Received: from nebulus.mtv.corp.google.com ([2620:15c:211:200:5404:91ba:59dc:9400])
        by smtp.gmail.com with ESMTPSA id y16sm4090168pfc.36.2019.08.29.11.30.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2019 11:30:28 -0700 (PDT)
From:   Mark Salyzyn <salyzyn@android.com>
To:     linux-kernel@vger.kernel.org
Cc:     kernel-team@android.com, Mark Salyzyn <salyzyn@android.com>,
        linux-kernel@vger.kernel.orga,
        linux-security-module@vger.kernel.org, stable@vger.kernel.org,
        Miklos Szeredi <miklos@szeredi.hu>,
        linux-unionfs@vger.kernel.org
Subject: [PATCH] overlayfs: filter of trusted xattr results in audit.
Date:   Thu, 29 Aug 2019 11:30:14 -0700
Message-Id: <20190829183021.87586-1-salyzyn@android.com>
X-Mailer: git-send-email 2.23.0.187.g17f5b7556c-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When filtering xattr list for reading, presence of trusted xattr
results in a security audit log.  However, if there is other content
no errno will be set, and if there isn't, the errno will be -ENODATA
and not -EPERM as is usually associated with a lack of capability.
The check does not block the request to list the xattrs present.

Switch to ns_capable_noaudit to reflect a more appropriate check.

Signed-off-by: Mark Salyzyn <salyzyn@android.com>
Cc: linux-kernel@vger.kernel.orga
Cc: linux-security-module@vger.kernel.org
Cc: kernel-team@android.com
Cc: stable@vger.kernel.org # 4.4, 4.9, 4.14 & 4.19
---
 fs/overlayfs/inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 7663aeb85fa3..bc14781886bf 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -383,7 +383,8 @@ static bool ovl_can_list(const char *s)
 		return true;
 
 	/* Never list trusted.overlay, list other trusted for superuser only */
-	return !ovl_is_private_xattr(s) && capable(CAP_SYS_ADMIN);
+	return !ovl_is_private_xattr(s) &&
+	       ns_capable_noaudit(&init_user_ns, CAP_SYS_ADMIN);
 }
 
 ssize_t ovl_listxattr(struct dentry *dentry, char *list, size_t size)
-- 
2.23.0.187.g17f5b7556c-goog

