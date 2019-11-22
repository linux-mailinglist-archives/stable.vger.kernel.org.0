Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36F2F106C66
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 11:51:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730009AbfKVKvr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:51:47 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:36812 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730030AbfKVKvq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Nov 2019 05:51:46 -0500
Received: by mail-wm1-f67.google.com with SMTP id n188so5121796wme.1
        for <stable@vger.kernel.org>; Fri, 22 Nov 2019 02:51:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=IYvLW8dFLd2i3abuhtpQEsje/E4kH68QhKyD7uWKyBc=;
        b=mizHDut5vTuyzETw7KbpwD+bz1bUNIbTnGzACpyTFp33vtbIm/uniwWpJeYuRxNVU9
         J2B+URcM2A9bQ31Le9jHZsthBuQPGDTNYuKLQNtgt1WFXyy2eUGiiwY3GtQw0MC1oOlV
         fgPLDhZn1iMbY7/ynH6B2ciGxNy5a8qlenfdAJcrfBNfhi/YdQ8MlIMJNfVVv7uW/hSR
         8MW5SMcuLOwRW2FT7zYPtlOzEbDkWXkxy6mKYMpBNNZBTIN4wNnuWWD98tDs6RFMpxgX
         tJQa3SM3a+aFBSInP59S50GfDs0bFIXNcYCYZV5XuJvgX4LzckElhLKv4jybyw77LaeB
         o2uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IYvLW8dFLd2i3abuhtpQEsje/E4kH68QhKyD7uWKyBc=;
        b=NgFy8K3rMfiOkBex1EsGn/tELaohyPEl08LUDmGPmCx9AlbbK9eAVIwpPVHLPBRYhH
         4gUM25Lc+RP9AOlq3p+QYqYfgTLeNx0qOqSqygrQHa73/Ynn59GLKvnFsHhUliFK14FH
         M/xmbGrWmZwW8ykDcfh6g+bPab1ZrdUh0icVGRo0SSv0xDrdoA0YSCOLKmHWR1eBqOz5
         S/+IM41ejo7qudqo/p7dBroVcwjTNiStCFQn4By0paKaDXpvTyECF1hS80jOQBpmRjnP
         h2GtxZ4hOfX8VriCx7zgdTBS7DRB8SzkwO+1W4oQQJxdGks22Gk+oZ/sCXAI6IEaVZah
         /Klg==
X-Gm-Message-State: APjAAAXmELdjFFxa7z9t+X4Sq5FWt3K8fxEEMnb52gw3fgBRrexTRRp2
        aSjGFD3SKTC/TOvWkRFG0Q/cpbXlQ4A=
X-Google-Smtp-Source: APXvYqxWCk5yULlzXhuScZMcTBjxtkyr+l4KZo2UZUM6O7IECQQNoJdwNThSalG+G5tlSDPxXi5vvw==
X-Received: by 2002:a1c:5603:: with SMTP id k3mr16874605wmb.150.1574419904536;
        Fri, 22 Nov 2019 02:51:44 -0800 (PST)
Received: from localhost.localdomain ([2.27.35.135])
        by smtp.gmail.com with ESMTPSA id w4sm2894338wmk.29.2019.11.22.02.51.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Nov 2019 02:51:44 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org, gregkh@google.com, stable@vger.kernel.org
Subject: [PATCH 4.4 9/9] ext4: avoid unnecessary stalls in ext4_evict_inode()
Date:   Fri, 22 Nov 2019 10:51:13 +0000
Message-Id: <20191122105113.11213-9-lee.jones@linaro.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122105113.11213-1-lee.jones@linaro.org>
References: <20191122105113.11213-1-lee.jones@linaro.org>
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
index 3557c5717c8d..821349149726 100644
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

