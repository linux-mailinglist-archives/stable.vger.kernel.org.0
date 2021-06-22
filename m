Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 213963B0F3A
	for <lists+stable@lfdr.de>; Tue, 22 Jun 2021 23:06:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbhFVVIp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Jun 2021 17:08:45 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:38084 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbhFVVIo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Jun 2021 17:08:44 -0400
Received: from mail-qt1-f197.google.com ([209.85.160.197])
        by youngberry.canonical.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <gpiccoli@canonical.com>)
        id 1lvnbG-0003pI-V5
        for stable@vger.kernel.org; Tue, 22 Jun 2021 21:06:26 +0000
Received: by mail-qt1-f197.google.com with SMTP id 100-20020aed206d0000b029024ea3acef5bso528740qta.12
        for <stable@vger.kernel.org>; Tue, 22 Jun 2021 14:06:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GarGwpDratldITv2GDntmBJ2VppPCBqaNEdWFHfGpm0=;
        b=KZR3xxaySww2MODvKotgRUa10i//s4lXa30dgjTFtemx9pFFu0Bs8lqOwPUXSwhp38
         zvT/x2hDe6RuCcXxgJTyznZUkb1T5HqfI8++g+44IEpgKq7xpzFi1xwXuV/RKCKytH5c
         gK6/NQ2A+gyIDTKky2ppwpqDmqFNhEUXkInjRsJODhiTI0ISvzDHy1J9NmAzybSNHTca
         qOACtvclaAZvl9s4U5NDr02SCkb6RXpnJX5NCGD5tBIjkrhRLelo+Y9LXscaBnUKX1tw
         R9oLVvrntR+c+pbIoePQDFPmYnXuI6JqzHTJk93kNhuSgXLzV4QoxZmQuyjZfQ0RMt2J
         uo6Q==
X-Gm-Message-State: AOAM533jgt1MEfLpkW9dNYheubiGlytJoksfyD+ZFbxUs6ZJyO+nxslx
        0fs0RnKeHBC9/m5JJP9wGP1zjmjtWTe5Yow8wGbD6YG1oGzs0FQUuhhbQa1qvugzPX8zivbctV2
        8u5iTY0fq3GowPmdwxoVfk4xIjolM9AXLgw==
X-Received: by 2002:a37:674a:: with SMTP id b71mr3555190qkc.459.1624395986144;
        Tue, 22 Jun 2021 14:06:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxFYiXPA8PA6c7Fe1myy41tTNi+E7ndCATIEoWWspqGhIDt5TaNA8ubtLtvV5DbJlPThXOSqQ==
X-Received: by 2002:a37:674a:: with SMTP id b71mr3555170qkc.459.1624395985887;
        Tue, 22 Jun 2021 14:06:25 -0700 (PDT)
Received: from localhost ([187.183.41.59])
        by smtp.gmail.com with ESMTPSA id d22sm10336128qkk.19.2021.06.22.14.06.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 22 Jun 2021 14:06:25 -0700 (PDT)
From:   "Guilherme G. Piccoli" <gpiccoli@canonical.com>
To:     stable@vger.kernel.org
Cc:     gpiccoli@canonical.com, viro@zeniv.linux.org.uk
Subject: [4.14.y][PATCH 1/2] kernfs: deal with kernfs_fill_super() failures
Date:   Tue, 22 Jun 2021 18:06:21 -0300
Message-Id: <20210622210622.9925-1-gpiccoli@canonical.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

commit 82382acec0c97b91830fff7130d0acce4ac4f3f3 upstream.

make sure that info->node is initialized early, so that kernfs_kill_sb()
can list_del() it safely.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Guilherme G. Piccoli <gpiccoli@canonical.com>
---

Hey Al, is there any reason for the absence of this patch in the stable
kernels? We had a report of a crash (NULL-ptr dereference) that seems to be
fixed by this patch - if there isn't a reason, I'd like to propose this one
to be merged on 4.14.y . I've build-tested in x86-64 with defconfig.

Thanks in advance,


Guilherme


 fs/kernfs/mount.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/kernfs/mount.c b/fs/kernfs/mount.c
index 5019058e0f6a..610267585f8f 100644
--- a/fs/kernfs/mount.c
+++ b/fs/kernfs/mount.c
@@ -320,6 +320,7 @@ struct dentry *kernfs_mount_ns(struct file_system_type *fs_type, int flags,
 
 	info->root = root;
 	info->ns = ns;
+	INIT_LIST_HEAD(&info->node);
 
 	sb = sget_userns(fs_type, kernfs_test_super, kernfs_set_super, flags,
 			 &init_user_ns, info);
-- 
2.31.1

