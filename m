Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD029314271
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 22:59:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229707AbhBHV6R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 16:58:17 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41838 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236989AbhBHV6L (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Feb 2021 16:58:11 -0500
Received: from mail-oi1-f197.google.com ([209.85.167.197])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <seth.forshee@canonical.com>)
        id 1l9EXA-0004lW-RV
        for stable@vger.kernel.org; Mon, 08 Feb 2021 21:57:29 +0000
Received: by mail-oi1-f197.google.com with SMTP id x23so1344407oic.18
        for <stable@vger.kernel.org>; Mon, 08 Feb 2021 13:57:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=slTd59I7Y8E1WEkwRd821CTDk7j9skLtmaaFeE6az84=;
        b=U7/oUrTzFj5CK96AHWIYHY1yyrspskKuwAKTRhbGhW13mrP1odj9RdYa/Nk0MD4CFY
         EsoeHTVXKPzNKAFHdER+drgyQo4u+1Edbl+GLECH22RPWatnG7YJ6koAbEt3ORsez6nU
         kk7/LK+hWVqZbVAYXvlNHYu9SyByilCI4ptpl3siAnNTWHdeaFaNt6b/TsEemOQDOJLk
         aeEm+jdvTnVPZL85Or+agZIOw+mySMpOUlHueMIlqvWTS3rw6S0t0lgfdeeiA8QmmYBK
         Jldq8n3jDOHbAwT/xLZz48RqiyQgwLUaERWiqY1k5Xke+9Q7DvaIv06x8BNsmfa9QPoq
         v+DQ==
X-Gm-Message-State: AOAM533LUvJFprahVEHnxc3BrKMJyOHCuzZuw4QydF7W+b5+3Xgnti6e
        c4O7/al76RspbIlpd91Fo4kmRX1iO5IiBwPmcHhQKX27i5zbDaae2iSqwAMlLWAZ03rKcYGFtjz
        JhvStFWy2kS5b2yzQs34JUO25bfjIy2+/vQ==
X-Received: by 2002:aca:52c3:: with SMTP id g186mr547243oib.136.1612821447890;
        Mon, 08 Feb 2021 13:57:27 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzdmxPQ0LjgXEXekhxPlC8Xp1x895S5NdnL8KBPc+KE+eBLEBoYWh33hbrIv2kwqD1i89kT+w==
X-Received: by 2002:aca:52c3:: with SMTP id g186mr547233oib.136.1612821447721;
        Mon, 08 Feb 2021 13:57:27 -0800 (PST)
Received: from localhost ([2605:a601:ac0f:820:953a:a460:6ddc:bef4])
        by smtp.gmail.com with ESMTPSA id g3sm3839161ooi.28.2021.02.08.13.57.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Feb 2021 13:57:26 -0800 (PST)
From:   Seth Forshee <seth.forshee@canonical.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Chris Down <chris@chrisdown.name>,
        Amir Goldstein <amir73il@gmail.com>,
        Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>, linux-mm@kvack.org,
        linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH] tmpfs: disallow CONFIG_TMPFS_INODE64 on alpha
Date:   Mon,  8 Feb 2021 15:57:26 -0600
Message-Id: <20210208215726.608197-1-seth.forshee@canonical.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

As with s390, alpha is a 64-bit architecture with a 32-bit ino_t.
With CONFIG_TMPFS_INODE64=y tmpfs mounts will get 64-bit inode
numbers and display "inode64" in the mount options, whereas
passing "inode64" in the mount options will fail. This leads to
erroneous behaviours such as this:

 # mkdir mnt
 # mount -t tmpfs nodev mnt
 # mount -o remount,rw mnt
 mount: /home/ubuntu/mnt: mount point not mounted or bad option.

Prevent CONFIG_TMPFS_INODE64 from being selected on alpha.

Fixes: ea3271f7196c ("tmpfs: support 64-bit inums per-sb")
Cc: stable@vger.kernel.org # v5.9+
Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 fs/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/Kconfig b/fs/Kconfig
index 3347ec7bd837..da524c4d7b7e 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -203,7 +203,7 @@ config TMPFS_XATTR
 
 config TMPFS_INODE64
 	bool "Use 64-bit ino_t by default in tmpfs"
-	depends on TMPFS && 64BIT && !S390
+	depends on TMPFS && 64BIT && !(S390 || ALPHA)
 	default n
 	help
 	  tmpfs has historically used only inode numbers as wide as an unsigned
-- 
2.29.2

