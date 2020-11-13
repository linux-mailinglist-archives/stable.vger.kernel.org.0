Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DA0D2B1408
	for <lists+stable@lfdr.de>; Fri, 13 Nov 2020 02:51:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726005AbgKMBvs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Nov 2020 20:51:48 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28543 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726150AbgKMBvs (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Nov 2020 20:51:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605232306;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=L/Z3Qi+K44uPDOMxGFWn+iPAJcAilXzhC51ZODYps6I=;
        b=QU66eQHGuItW+Cq8vgx5JRpf5MKQgSjMYlw44RCxUx+ZTyZRjUmvr3ApbSCYBMDvYGmAbt
        VIigmC4LkomJ2HINqakVZkoRNAoX6bs9UApmn2hiCBRB2lSBidy7d5SpFG/AaUYVWN6kVQ
        qRv7WVQFT9cLA7VTIkkFASCnky7Tb38=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-169-c0AfABpbOjWsEQqcnYIHwQ-1; Thu, 12 Nov 2020 20:51:45 -0500
X-MC-Unique: c0AfABpbOjWsEQqcnYIHwQ-1
Received: by mail-pg1-f199.google.com with SMTP id q5so5098498pgt.0
        for <stable@vger.kernel.org>; Thu, 12 Nov 2020 17:51:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=L/Z3Qi+K44uPDOMxGFWn+iPAJcAilXzhC51ZODYps6I=;
        b=RmMqE5Xnj9O1/clj+xN8Bvqk45F1X7koZYK59ICklfif4DAYqB4yU8MYvRLcN/y/Wj
         T8x+ZhW46/GOn/TnmDN28CJldPrNBL9CE233UFxWuFiSPaClV8C6jcfvSxCK+NsbmHr4
         FmzLnOlVtPScLFV4U6BgO8f8QCVa7UdgEY3O3eSEreXJn1YOjNw7ghG36qe+O2GOMQO4
         dC3C/SMjCJGnYL48GWqpvVu5xJL2yZpRTHl1f+p6+88T+lU7X7/5Z/fXni17D/YaDOYe
         bQU6P1D6GQH1cUOIqSfzbXZEcmPRDdoXGqLVRUvkzdGIyWbBuIdwOJ6uWwVjV71J/Z3Y
         +lgg==
X-Gm-Message-State: AOAM530WsgA23TPngQ8hp0hTIdYNCXSrSUxz7r1Z3+giwtWOXI5TZzlo
        BaAiUrV6ZdLenA25eRrFaxvNnL6UX8K8hQowY2RX16bOJoeD/5grB1L+H440ktw7OGWtndmNYT9
        Hu6SHmtc65OwmNAYC
X-Received: by 2002:a63:e04:: with SMTP id d4mr174866pgl.101.1605232300945;
        Thu, 12 Nov 2020 17:51:40 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyac+3QmeMS0sD56E6qdYzMD1Zsj065wwrtOHNQz6buD4ChJNRZPNGWf7bd6UFEWbX9l51UcA==
X-Received: by 2002:a63:e04:: with SMTP id d4mr174848pgl.101.1605232300716;
        Thu, 12 Nov 2020 17:51:40 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id z17sm8063487pfq.121.2020.11.12.17.51.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 17:51:40 -0800 (PST)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Dennis Gilmore <dgilmore@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Gao Xiang <hsiangkao@redhat.com>, stable@vger.kernel.org
Subject: [PATCH v2] xfs: fix forkoff miscalculation related to XFS_LITINO(mp)
Date:   Fri, 13 Nov 2020 09:50:44 +0800
Message-Id: <20201113015044.844213-1-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20201112063005.692054-1-hsiangkao@redhat.com>
References: <20201112063005.692054-1-hsiangkao@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Currently, commit e9e2eae89ddb dropped a (int) decoration from
XFS_LITINO(mp), and since sizeof() expression is also involved,
the result of XFS_LITINO(mp) is simply as the size_t type
(commonly unsigned long).

Considering the expression in xfs_attr_shortform_bytesfit():
  offset = (XFS_LITINO(mp) - bytes) >> 3;
let "bytes" be (int)340, and
    "XFS_LITINO(mp)" be (unsigned long)336.

on 64-bit platform, the expression is
  offset = ((unsigned long)336 - (int)340) >> 3 =
           (int)(0xfffffffffffffffcUL >> 3) = -1

but on 32-bit platform, the expression is
  offset = ((unsigned long)336 - (int)340) >> 3 =
           (int)(0xfffffffcUL >> 3) = 0x1fffffff
instead.

so offset becomes a large positive number on 32-bit platform, and
cause xfs_attr_shortform_bytesfit() returns maxforkoff rather than 0.

Therefore, one result is
  "ASSERT(new_size <= XFS_IFORK_SIZE(ip, whichfork));"

assertion failure in xfs_idata_realloc(), which was also the root
cause of the original bugreport from Dennis, see:
   https://bugzilla.redhat.com/show_bug.cgi?id=1894177

And it can also be manually triggered with the following commands:
  $ touch a;
  $ setfattr -n user.0 -v "`seq 0 80`" a;
  $ setfattr -n user.1 -v "`seq 0 80`" a

on 32-bit platform.

Fix the case in xfs_attr_shortform_bytesfit() by bailing out
"XFS_LITINO(mp) < bytes" in advance suggested by Eric and a misleading
comment together with this bugfix suggested by Darrick. It seems the
other users of XFS_LITINO(mp) are not impacted.

Reported-by: Dennis Gilmore <dgilmore@redhat.com>
Fixes: e9e2eae89ddb ("xfs: only check the superblock version for dinode size calculation")
Cc: <stable@vger.kernel.org> # 5.7+
Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
changes since v1:
 - fix 2 typos ">> 8" to ">> 3" mentioned by Eric;
 - directly bail out "XFS_LITINO(mp) < bytes" suggested
   by Eric and Darrick;
 - fix a misleading comment together suggested by Darrick;
 - since (int) decorator doesn't need to be added, so update
   the patch subject as well.

 fs/xfs/libxfs/xfs_attr_leaf.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index bb128db220ac..c8d91034850b 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -515,7 +515,7 @@ xfs_attr_copy_value(
  *========================================================================*/
 
 /*
- * Query whether the requested number of additional bytes of extended
+ * Query whether the total requested number of attr fork bytes of extended
  * attribute space will be able to fit inline.
  *
  * Returns zero if not, else the di_forkoff fork offset to be used in the
@@ -535,6 +535,10 @@ xfs_attr_shortform_bytesfit(
 	int			maxforkoff;
 	int			offset;
 
+	/* there is no chance we can fit */
+	if (bytes > XFS_LITINO(mp))
+		return 0;
+
 	/* rounded down */
 	offset = (XFS_LITINO(mp) - bytes) >> 3;
 
-- 
2.18.4

