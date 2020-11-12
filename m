Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5EF72AFFB2
	for <lists+stable@lfdr.de>; Thu, 12 Nov 2020 07:31:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726291AbgKLGbX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Nov 2020 01:31:23 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37941 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726287AbgKLGbW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Nov 2020 01:31:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605162681;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=RhtA6QSp1QbBfU96em4sj0ByA3Z5T9kaKGCTzLh5k6A=;
        b=D4os0q/CP2wos0lqcfds3/+eVZ05+UDzEJCWcUCrR8I9tJsP5lJs0fkdn0kZ0W90fPvzkE
        u6Qn/n6aYt+XbRpc6JDC1fvukF1FhuujlsDjWxqPC9vD+ZSnuJN2jLE7iS/W7EhsWFu3th
        tIkWG4NwFoMDPfASEG37PKVp835tddU=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-167-gaVImnazNiSN9T7pu-UAKw-1; Thu, 12 Nov 2020 01:31:19 -0500
X-MC-Unique: gaVImnazNiSN9T7pu-UAKw-1
Received: by mail-pf1-f197.google.com with SMTP id b139so3181250pfb.2
        for <stable@vger.kernel.org>; Wed, 11 Nov 2020 22:31:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=RhtA6QSp1QbBfU96em4sj0ByA3Z5T9kaKGCTzLh5k6A=;
        b=W+2KfWYFmWwiIBt3Z7nu6aLwMVD3O2XZR3tCuhbc1fHxq9CM5BcbUH+oZSa4FVwSJD
         vGYU+UYkf1/1UeLSkZAExrKoS3nmskkJFyCXNEPTK6GmfdkeysRLFX+4lY6I750aWLf5
         kgLxQ+Vprz1FO3rQ49vrxA9EW6GbQYbHpMJvrrO9/VkA9yo1rD1KuPW762FTwMcWzsEs
         NWm/rR2J5T7qdyhFDSEi1MFS1DPYDExhMlBrGLRNvy4/NCKwckkm8D9gcbEsK3jdQA0E
         N72EPgXyNjyRChnElya0OvfenUej1c1nBONbwDwdvuvzsmdg1U0sGtj4rTf0A7YEDoio
         bolg==
X-Gm-Message-State: AOAM530B1mq95DN7mmB+eofh0+HRWT1yNgTzm6J0Ou+/tko2SD0Qs459
        ihLOzlWA4wuQyStDtzuw6snLx7FpeOChEXcD8FDQUnxv1zUAnzfTiIMQcoHriUV14PqDDCfTnxI
        Nvt5enxeG1RE5ChgC
X-Received: by 2002:a17:90b:f10:: with SMTP id br16mr7618500pjb.60.1605162678220;
        Wed, 11 Nov 2020 22:31:18 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxkpudI07BN4usbj64YYaOQxy5Cz9zNtPxALGTMfevPPYhdXWMdSav0XlUgYldyBfOdUQZtIQ==
X-Received: by 2002:a17:90b:f10:: with SMTP id br16mr7618477pjb.60.1605162677976;
        Wed, 11 Nov 2020 22:31:17 -0800 (PST)
Received: from xiangao.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id k25sm4942345pfi.42.2020.11.11.22.31.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2020 22:31:17 -0800 (PST)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Gao Xiang <hsiangkao@redhat.com>, stable@vger.kernel.org
Subject: [PATCH] xfs: fix signed calculation related to XFS_LITINO(mp)
Date:   Thu, 12 Nov 2020 14:30:05 +0800
Message-Id: <20201112063005.692054-1-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.18.4
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
  offset = ((unsigned long)336 - (int)340) >> 8 =
           (int)(0xfffffffffffffffcUL >> 3) = -1

but on 32-bit platform, the expression is
  offset = ((unsigned long)336 - (int)340) >> 8 =
           (int)(0xfffffffcUL >> 3) = 0x1fffffff
instead.

so offset becomes a large number on 32-bit platform, and cause
xfs_attr_shortform_bytesfit() returns maxforkoff rather than 0

Therefore, one result is
  "ASSERT(new_size <= XFS_IFORK_SIZE(ip, whichfork));"
  assertion failure in xfs_idata_realloc().

, which can be triggered with the following commands:
 touch a;
 setfattr -n user.0 -v "`seq 0 80`" a;
 setfattr -n user.1 -v "`seq 0 80`" a
on 32-bit platform.

Fix it by restoring (int) decorator to XFS_LITINO(mp) since
int type for XFS_LITINO(mp) is safe and all pre-exist signed
calculations are correct.

Fixes: e9e2eae89ddb ("xfs: only check the superblock version for dinode size calculation")
Cc: <stable@vger.kernel.org> # 5.7+
Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
I'm not sure this is the preferred way or just simply fix
xfs_attr_shortform_bytesfit() since I don't look into the
rest of XFS_LITINO(mp) users. Add (int) to XFS_LITINO(mp)
will avoid all potential regression at least.

 fs/xfs/libxfs/xfs_format.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index dd764da08f6f..f58f0a44c024 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1061,7 +1061,7 @@ enum xfs_dinode_fmt {
 		sizeof(struct xfs_dinode) : \
 		offsetof(struct xfs_dinode, di_crc))
 #define XFS_LITINO(mp) \
-	((mp)->m_sb.sb_inodesize - XFS_DINODE_SIZE(&(mp)->m_sb))
+	((int)((mp)->m_sb.sb_inodesize - XFS_DINODE_SIZE(&(mp)->m_sb)))
 
 /*
  * Inode data & attribute fork sizes, per inode.
-- 
2.18.4

