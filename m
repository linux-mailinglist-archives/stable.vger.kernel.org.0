Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F188E6D714
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 01:07:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391658AbfGRXG2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jul 2019 19:06:28 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:41336 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728524AbfGRXG2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Jul 2019 19:06:28 -0400
Received: by mail-pf1-f194.google.com with SMTP id m30so13291093pff.8;
        Thu, 18 Jul 2019 16:06:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dbKBgzrzQrC5cGlbyCVNUXmHFj744pksl4qhcQY0yIo=;
        b=LVdxQBrWiUUKIkvtNCCDAwHEBm+L8Jehw6N+HQ71qToK0IFLNnm3rPo4mpPZ/FA7Ue
         P142/onXrnlEtaEntI2qNaCIpmOaviXShUR1NNP7nqchK9RPI3RSoB1AxDkkSejhQnC7
         vVZkDxDf+2GrF88/7CJThzEKfYZGIA0HNw9oDRwxj4hWi9l76zzXHbnbTrN/1mi//no9
         VmIvkuvqfuUc6TF/qyB5x/9uUt1rdAbgoi/qxVnbCBWkQAOE9WmaoOJ8LT3I+bzX8V//
         rsC8XO64oSkT4fWKZ5qh3dnOEOF6NJW6N9nagWm4Np1kB3+t7pf4DQF19CYfAayDku08
         oa3w==
X-Gm-Message-State: APjAAAWcDatpQjNHR+E+sMTvFXrlkeR98hLfuJuusxrMKf5HpOaPWm5B
        KuPJDrMcGgeKV3N4gz1B1Og=
X-Google-Smtp-Source: APXvYqxdBXs8p5rBq6FmFrjUwDTLMIS99dIbZe96dqCIwIuJnBMkGcJnWTSNI1knQV1bD6q9Ocsu9g==
X-Received: by 2002:a17:90a:f498:: with SMTP id bx24mr54672904pjb.91.1563491187667;
        Thu, 18 Jul 2019 16:06:27 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id i15sm31178948pfd.160.2019.07.18.16.06.22
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 18 Jul 2019 16:06:26 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id 68A37413E9; Thu, 18 Jul 2019 23:06:19 +0000 (UTC)
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     linux-xfs@vger.kernel.org, gregkh@linuxfoundation.org,
        Alexander.Levin@microsoft.com
Cc:     stable@vger.kernel.org, amir73il@gmail.com, hch@infradead.org,
        zlang@redhat.com, "Luis R. Rodriguez" <mcgrof@kernel.org>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 7/9] xfs: fix reporting supported extra file attributes for statx()
Date:   Thu, 18 Jul 2019 23:06:15 +0000
Message-Id: <20190718230617.7439-8-mcgrof@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190718230617.7439-1-mcgrof@kernel.org>
References: <20190718230617.7439-1-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@kernel.org>

commit 1b9598c8fb9965fff901c4caa21fed9644c34df3 upstream.

statx(2) notes that any attribute that is not indicated as supported by
stx_attributes_mask has no usable value. Commit 5f955f26f3d42d ("xfs: report
crtime and attribute flags to statx") added support for informing userspace
of extra file attributes but forgot to list these flags as supported
making reporting them rather useless for the pedantic userspace author.

$ git describe --contains 5f955f26f3d42d04aba65590a32eb70eedb7f37d
v4.11-rc6~5^2^2~2

Fixes: 5f955f26f3d42d ("xfs: report crtime and attribute flags to statx")
Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
[darrick: add a comment reminding people to keep attributes_mask up to date]
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 fs/xfs/xfs_iops.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 1efef69a7f1c..74047bd0c1ae 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -531,6 +531,10 @@ xfs_vn_getattr(
 		}
 	}
 
+	/*
+	 * Note: If you add another clause to set an attribute flag, please
+	 * update attributes_mask below.
+	 */
 	if (ip->i_d.di_flags & XFS_DIFLAG_IMMUTABLE)
 		stat->attributes |= STATX_ATTR_IMMUTABLE;
 	if (ip->i_d.di_flags & XFS_DIFLAG_APPEND)
@@ -538,6 +542,10 @@ xfs_vn_getattr(
 	if (ip->i_d.di_flags & XFS_DIFLAG_NODUMP)
 		stat->attributes |= STATX_ATTR_NODUMP;
 
+	stat->attributes_mask |= (STATX_ATTR_IMMUTABLE |
+				  STATX_ATTR_APPEND |
+				  STATX_ATTR_NODUMP);
+
 	switch (inode->i_mode & S_IFMT) {
 	case S_IFBLK:
 	case S_IFCHR:
-- 
2.20.1

