Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CADF16D70A
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 01:07:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391326AbfGRXGW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jul 2019 19:06:22 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:41750 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728524AbfGRXGW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Jul 2019 19:06:22 -0400
Received: by mail-pg1-f195.google.com with SMTP id x15so3211526pgg.8;
        Thu, 18 Jul 2019 16:06:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RrGwnDIom4ZFYE5fokLWAofw8P39aInJ+75MpS6dYUY=;
        b=P1sr1lvdOjP9q4y5nMv2L/n34MSNMq4WYk7sYEzrb/Wza65cZ99SdQEFOQ+xfky0uh
         0rTxEMKWrUGQ/yxiJ9hDFwKP1mVxaUsuc3B6hjoUJV7u4w6MsWvSHZh3yCtkWNKr31E6
         dhERoUFLh0AG2JiTlU2vq8EhTWe0G1sh2YhnbGZAdVyhnNgYUpBToPkxbAbEYeMO+M9t
         rMiMglsCECyt8nvwxZEhY5U0LBQeAqLom6LRImEh4RCAOnpxa2jZA/bayM+DACv1JSYe
         ZIZKMt0JC9Nh3bhpgRoQvUxLP+EFk2UNwb61clocXSeF+SPdEoV1GJr55NB57NMqKC6V
         jmmQ==
X-Gm-Message-State: APjAAAX6RfAhIOuVLXurID4ZVVwEn6uxhQrQ7T3RLa9pevf0H8JIu8E3
        d9SKovItDN9hkMhB1e/cA7k=
X-Google-Smtp-Source: APXvYqwG9Ca4dM15fm3yeZQi2YPcXMRaY1uZ3V1bOUeUc6WvLHjWuQD1LJWrBRntYHJ3E06dNrpjeA==
X-Received: by 2002:a63:494d:: with SMTP id y13mr51271481pgk.109.1563491181078;
        Thu, 18 Jul 2019 16:06:21 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id w2sm22802922pgc.32.2019.07.18.16.06.19
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 18 Jul 2019 16:06:19 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id 1F84340004; Thu, 18 Jul 2019 23:06:19 +0000 (UTC)
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     linux-xfs@vger.kernel.org, gregkh@linuxfoundation.org,
        Alexander.Levin@microsoft.com
Cc:     stable@vger.kernel.org, amir73il@gmail.com, hch@infradead.org,
        zlang@redhat.com, "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <dchinner@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Dave Chinner <david@fromorbit.com>,
        Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH 1/9] xfs: fix pagecache truncation prior to reflink
Date:   Thu, 18 Jul 2019 23:06:09 +0000
Message-Id: <20190718230617.7439-2-mcgrof@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190718230617.7439-1-mcgrof@kernel.org>
References: <20190718230617.7439-1-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit 4918ef4ea008cd2ff47eb852894e3f9b9047f4f3 upstream.

Prior to remapping blocks, it is necessary to remove pages from the
destination file's page cache.  Unfortunately, the truncation is not
aggressive enough -- if page size > block size, we'll end up zeroing
subpage blocks instead of removing them.  So, round the start offset
down and the end offset up to page boundaries.  We already wrote all
the dirty data so the larger range shouldn't be a problem.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 fs/xfs/xfs_reflink.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 7088f44c0c59..38ea08a3dd1d 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1369,8 +1369,9 @@ xfs_reflink_remap_prep(
 		goto out_unlock;
 
 	/* Zap any page cache for the destination file's range. */
-	truncate_inode_pages_range(&inode_out->i_data, pos_out,
-				   PAGE_ALIGN(pos_out + *len) - 1);
+	truncate_inode_pages_range(&inode_out->i_data,
+			round_down(pos_out, PAGE_SIZE),
+			round_up(pos_out + *len, PAGE_SIZE) - 1);
 
 	/* If we're altering the file contents... */
 	if (!is_dedupe) {
-- 
2.20.1

