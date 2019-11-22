Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B549E106CA5
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 11:55:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729649AbfKVKxh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:53:37 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:44873 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730223AbfKVKxg (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Nov 2019 05:53:36 -0500
Received: by mail-wr1-f68.google.com with SMTP id i12so8001418wrn.11
        for <stable@vger.kernel.org>; Fri, 22 Nov 2019 02:53:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=oIIGMhbYISHZGu9r96uoFeZiZpVGd1I91v4mf/cGzkM=;
        b=PUfcmUCcLNfVPw8lb6rvYxvuuivUoRhYRYTYBP0Pz6g1prA6DtYXazm7EeslR16aHJ
         1xC4xgfYq/lYYfDr4cG3q22YJtUDzN2oGoAd5DuuB0AlyKCbrNAXz/iVqGPJYNenVRgu
         NtJZY6dJbpUgdVZCjE0Lo7e1Q/Noy3l59VB97KrqTLCHM1fV0HNGQFoDLjmQ91E5VZaW
         hG+7ujJEmFvqUMGP39f5qVCOODf5CHsMOQlGzYoajO0t/sHicVuUZyltABD4Kagy54lL
         vfFm1EuzA0CKamhP+fHIeknSZ+diZCGppDCl6u3l8wRDrid7D669x5Im12eTnSCmVwIP
         D5OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oIIGMhbYISHZGu9r96uoFeZiZpVGd1I91v4mf/cGzkM=;
        b=cOcBDKmgeS5KUcWYh6Vc9FSPBP2JwVq6jfkPj+SEepUnl/r8BxX2H07PiLcbKE1HjG
         CgNq1dll7qOHBwzX+p97T/Pj87QPv59kc/SKgv42MiGVaFVY40r8c/113TPuZAkOziGQ
         1fSMOEef2g44jkbAgFT4g010Uwp+nY53zc4MIjkYMl0d8fzdcZJxKJ+RvqaHR/xDGnBv
         yKQzXoNt9vIm2SNj6/bHp0e8kAhTjjwQySJZ9JBeLZjSyQDN2vBsugMcHTRYV4VDgPNx
         lwn5hPnI/VJu2x1TFFX3Cfkahqf/jcbveNr7JGvMtDr4G5/fUzAesHGBMZV3/3le67JN
         Kzfw==
X-Gm-Message-State: APjAAAWBQdZLZOW2uQExnM64Usep4oDoy7hoOLRddGmMHmzYNwdjFp53
        +vHveJ6cZLz4klgOAPPS0lwx9A==
X-Google-Smtp-Source: APXvYqx0wXMjpR42nKKrFRWSVit+dPoSeye230u9OvcO/ubIOayhm3Cn0vKEovStWWbzSROAhAy5yg==
X-Received: by 2002:adf:90d0:: with SMTP id i74mr16311198wri.298.1574420014557;
        Fri, 22 Nov 2019 02:53:34 -0800 (PST)
Received: from localhost.localdomain ([2.27.35.135])
        by smtp.gmail.com with ESMTPSA id o1sm7444087wrs.50.2019.11.22.02.53.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Nov 2019 02:53:34 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org, gregkh@google.com, stable@vger.kernel.org
Subject: [PATCH 4.9 8/8] ext4: avoid unnecessary stalls in ext4_evict_inode()
Date:   Fri, 22 Nov 2019 10:52:53 +0000
Message-Id: <20191122105253.11375-8-lee.jones@linaro.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122105253.11375-1-lee.jones@linaro.org>
References: <20191122105253.11375-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

[ Upstream commit 3abb1a0fc2871f2db52199e1748a1d48a54a3427 ]

These days inode reclaim calls evict_inode() only when it has no pages
in the mapping.  In that case it is not necessary to wait for transaction
commit in ext4_evict_inode() as there can be no pages waiting to be
committed.  So avoid unnecessary transaction waiting in that case.

We still have to keep the check for the case where ext4_evict_inode()
gets called from other paths (e.g. umount) where inode still can have
some page cache pages.

Reported-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 fs/ext4/inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index a73056e06bde..2ad48d166f32 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -212,7 +212,8 @@ void ext4_evict_inode(struct inode *inode)
 		 */
 		if (inode->i_ino != EXT4_JOURNAL_INO &&
 		    ext4_should_journal_data(inode) &&
-		    (S_ISLNK(inode->i_mode) || S_ISREG(inode->i_mode))) {
+		    (S_ISLNK(inode->i_mode) || S_ISREG(inode->i_mode)) &&
+		    inode->i_data.nrpages) {
 			journal_t *journal = EXT4_SB(inode->i_sb)->s_journal;
 			tid_t commit_tid = EXT4_I(inode)->i_datasync_tid;
 
-- 
2.24.0

