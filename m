Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56C4C6D717
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 01:07:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391683AbfGRXG3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jul 2019 19:06:29 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:44852 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728524AbfGRXG3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Jul 2019 19:06:29 -0400
Received: by mail-pf1-f196.google.com with SMTP id t16so13266972pfe.11;
        Thu, 18 Jul 2019 16:06:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XOpbXKQjFIWxL9L7MymjemNedb65xZQkcaFvd4hXAD4=;
        b=D5BkP9GJGEhWTkiLBcz4YRNjYeOoS8EHN4F78itoHEpMDui8SdPKBHucIPJMIJ7sgu
         P8uLHG23JSmSpT55yrML6/Caci7YGAciVMu35heZ1/TBQgBGHwcVSi60Mad+XpG8Af5t
         pb3M8JQ42X4v0WYCe7s50nVoVX/tKrCopfcv6TGMK9d3Z6NKdjRUvXn/YQZQCMnfNrNZ
         PQM1ruEJohrpaA3gi4loPRejw8KFfboJs3nyGH7M38jkt++SHRdnG/yeK5z0Qt10GMJV
         uObJluEsyurRrWULU8TfgEAsEcYqF3KtOJku3fCTLrN/LaiVxyqvMusyVXSvtYd51qDg
         Q+hg==
X-Gm-Message-State: APjAAAW1OvEtL2595NCMX3Ae0PGozCiIyGHv9tDq71pQobGP2B0rCjIx
        eU5OYYpahx7b9o0ngL47OI8=
X-Google-Smtp-Source: APXvYqxipZjOJXFzwMfSCc16MjWFaYbB3RSqAYWWKlqnFRWq6N+USOvW/7fiSSqm6lV0exRWJaD3Jg==
X-Received: by 2002:a17:90a:7d09:: with SMTP id g9mr52753680pjl.38.1563491188441;
        Thu, 18 Jul 2019 16:06:28 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id v3sm26916513pfm.188.2019.07.18.16.06.21
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 18 Jul 2019 16:06:26 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id 6160D413C3; Thu, 18 Jul 2019 23:06:19 +0000 (UTC)
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     linux-xfs@vger.kernel.org, gregkh@linuxfoundation.org,
        Alexander.Levin@microsoft.com
Cc:     stable@vger.kernel.org, amir73il@gmail.com, hch@infradead.org,
        zlang@redhat.com, "Darrick J. Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Dave Chinner <dchinner@redhat.com>,
        Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH 6/9] xfs: reserve blocks for ifree transaction during log recovery
Date:   Thu, 18 Jul 2019 23:06:14 +0000
Message-Id: <20190718230617.7439-7-mcgrof@kernel.org>
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

commit 15a268d9f263ed3a0601a1296568241a5a3da7aa upstream.

Log recovery frees all the inodes stored in the unlinked list, which can
cause expansion of the free inode btree.  The ifree code skips block
reservations if it thinks there's a per-AG space reservation, but we
don't set up the reservation until after log recovery, which means that
a finobt expansion blows up in xfs_trans_mod_sb when we exceed the
transaction's block reservation.

To fix this, we set the "no finobt reservation" flag to true when we
create the xfs_mount and only set it to false if we confirm that every
AG had enough free space to put aside for the finobt.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Suggested-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 fs/xfs/xfs_fsops.c | 1 +
 fs/xfs/xfs_super.c | 7 +++++++
 2 files changed, 8 insertions(+)

diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 7c00b8bedfe3..09fd602507ef 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -534,6 +534,7 @@ xfs_fs_reserve_ag_blocks(
 	int			error = 0;
 	int			err2;
 
+	mp->m_finobt_nores = false;
 	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
 		pag = xfs_perag_get(mp, agno);
 		err2 = xfs_ag_resv_init(pag, NULL);
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 207ee302b1bb..dce8114e3198 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1561,6 +1561,13 @@ xfs_mount_alloc(
 	INIT_DELAYED_WORK(&mp->m_eofblocks_work, xfs_eofblocks_worker);
 	INIT_DELAYED_WORK(&mp->m_cowblocks_work, xfs_cowblocks_worker);
 	mp->m_kobj.kobject.kset = xfs_kset;
+	/*
+	 * We don't create the finobt per-ag space reservation until after log
+	 * recovery, so we must set this to true so that an ifree transaction
+	 * started during log recovery will not depend on space reservations
+	 * for finobt expansion.
+	 */
+	mp->m_finobt_nores = true;
 	return mp;
 }
 
-- 
2.20.1

