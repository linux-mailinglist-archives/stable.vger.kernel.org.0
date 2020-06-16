Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4560A1FAB4F
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 10:33:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726471AbgFPIdi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 04:33:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726052AbgFPIdh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Jun 2020 04:33:37 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74A60C05BD43;
        Tue, 16 Jun 2020 01:33:37 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id j1so9157499pfe.4;
        Tue, 16 Jun 2020 01:33:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=QKQejvBtg3av9F/iGZAAjpJ2+FU7i9mSORd83pRkwKI=;
        b=kGGnaLdiu2xlVj51rLyrymTdIXbp/ogYBXlCMN4fE8rlpNT4mNYNPKeYYYkiVaRKuz
         jXztKb9uo43Wbmjfa+IKBbeswKOxmIS8TU6mX/rc6UhK7etr4kqUE+teaWgnHzRIHXw/
         032IZQqwr566LCdpfvRZN7aFVD4ztpzSkCEqmYdVzln7o7RldXQvMNh3Oyh8UuejREKQ
         pNyfEyqBWjDPJOSeVEq/tC6jUI5VDoDO6uUEqqj+mlkbfa7SnuaWAWmrKU0yHwQEW7m/
         cQJn2J9Djs5looot5aZWt5jZ8fSCb3ZWVklk2KFIoZHiSOXgoz/PLKjFWf9bcD3+z5lA
         Pq1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=QKQejvBtg3av9F/iGZAAjpJ2+FU7i9mSORd83pRkwKI=;
        b=kZyg7t+VxM+YdZnMrbnLdh141v7J43kw0jzhK76zmGsml++pzZfsYddjvIGOPR5iGe
         2ViToUOHpxOcj9ljNq83WX7vuKDPNUWOUg9z9LoY5e+NQUL4slNviBV3OoSjHqVWmX0x
         8uJhBUT81MQVl4TMHHxz2C/+MyobgjU2p51l7dj/97VCzxd5CHBztezDrvT2FyvSduRe
         5iv60crzBT1830gr+jXj/4GvhAaUDqtNA3ZK3uFWKu7XQEIvwAxexmjZEgKw3uCkaX8I
         EoRN8c+UxYrNBcBbF8byXMBqppyJWC4ekfVOJKBzQNkpQLNYJ3Rx5XfWPtX5t2k0VJlz
         EmUw==
X-Gm-Message-State: AOAM530mjWcwlPeSKpNwnR0xrFTtcSLvBebpTjBFLvJJqxtmeNYwZ8an
        g+9jqpriHkt3tPMMrzIooME=
X-Google-Smtp-Source: ABdhPJyXSq0oGDjKVml62dLiiAvvoUed6V74N4szXQxoGMG6L5hmG2a7f1ctwXWUEsYB8rzwbr5XHw==
X-Received: by 2002:a63:541c:: with SMTP id i28mr1319109pgb.344.1592296417007;
        Tue, 16 Jun 2020 01:33:37 -0700 (PDT)
Received: from her0gyu-virtual-machine.localdomain ([1.221.137.163])
        by smtp.gmail.com with ESMTPSA id i3sm1751246pjv.1.2020.06.16.01.33.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2020 01:33:36 -0700 (PDT)
From:   youngjun <her0gyugyu@gmail.com>
To:     amir73il@gmail.com
Cc:     linux-unionfs@vger.kernel.org, youngjun <her0gyugyu@gmail.com>,
        stable@vger.kernel.org
Subject: [PATCH v4] ovl: inode reference leak in ovl_is_inuse true case.
Date:   Tue, 16 Jun 2020 17:33:29 +0900
Message-Id: <20200616083329.25876-1-her0gyugyu@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200615155645.32939-1-her0gyugyu@gmail.com>
References: <20200615155645.32939-1-her0gyugyu@gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When "ovl_is_inuse" true case, trap inode reference not put.
plus adding the comment explaining sequence of
ovl_is_inuse after ovl_setup_trap.

Fixes: 0be0bfd2de9d ("ovl: fix regression caused by overlapping layers..")
Cc: <stable@vger.kernel.org> # v4.19+
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: youngjun <her0gyugyu@gmail.com>
---
 fs/overlayfs/super.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 91476bc422f9..3097142b1e23 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1493,14 +1493,22 @@ static int ovl_get_layers(struct super_block *sb, struct ovl_fs *ofs,
 		if (err < 0)
 			goto out;
 
+		/*
+		 * Check if lower root conflicts with this overlay layers before checking
+		 * if it is in-use as upperdir/workdir of "another" mount, because we do
+		 * not bother to check in ovl_is_inuse() if the upperdir/workdir is in fact
+		 * in-use by our upperdir/workdir.
+		 */
 		err = ovl_setup_trap(sb, stack[i].dentry, &trap, "lowerdir");
 		if (err)
 			goto out;
 
 		if (ovl_is_inuse(stack[i].dentry)) {
 			err = ovl_report_in_use(ofs, "lowerdir");
-			if (err)
+			if (err) {
+				iput(trap);
 				goto out;
+			}
 		}
 
 		mnt = clone_private_mount(&stack[i]);
-- 
2.17.1

Sorry. I Wrongly sent subect version. I changed it to v4.
Thank you Amir.

