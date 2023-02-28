Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DFCD6A598B
	for <lists+stable@lfdr.de>; Tue, 28 Feb 2023 13:56:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230482AbjB1M4p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Feb 2023 07:56:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbjB1M4p (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Feb 2023 07:56:45 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7514B2C656
        for <stable@vger.kernel.org>; Tue, 28 Feb 2023 04:55:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677588955;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=m/fs8umwFwlJyvsXEZVrmdoQqGymBt8fGE5zULs29YY=;
        b=acbioQYHxgiKsUR6yvV33p/87VawVoJAUL1Vh4Dh1G4oceJ3FGUSVnWWjIY1/8EFBL/k6m
        SaPw0yTrQroUnKpmTzEh/Hg/hGD+qRXw+WuoLrAtxSr4rS+e+bDAIq7c27YWxPSRmAMr07
        /0vdzZY5pVYYKI/l4qEum0NLhG1ERpc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-628-gilucjVrP1ylUf9pA244tg-1; Tue, 28 Feb 2023 07:55:52 -0500
X-MC-Unique: gilucjVrP1ylUf9pA244tg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C15E985A588;
        Tue, 28 Feb 2023 12:55:51 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A9AB92026D76;
        Tue, 28 Feb 2023 12:55:48 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, lhenriques@suse.de, vshankar@redhat.com,
        mchangir@redhat.com, Xiubo Li <xiubli@redhat.com>,
        stable@vger.kernel.org
Subject: [PATCH] ceph: do not print the whole xattr value if it's too long
Date:   Tue, 28 Feb 2023 20:55:31 +0800
Message-Id: <20230228125531.165361-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

If the xattr's value size is long enough the kernel will warn and
then will fail the xfstests test case.

Just print part of the value string if it's too long.

Cc: stable@vger.kernel.org
URL: https://tracker.ceph.com/issues/58404
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/xattr.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
index b10d459c2326..6638bb0ec10f 100644
--- a/fs/ceph/xattr.c
+++ b/fs/ceph/xattr.c
@@ -561,6 +561,7 @@ static struct ceph_vxattr *ceph_match_vxattr(struct inode *inode,
 	return NULL;
 }
 
+#define XATTR_MAX_VAL 256
 static int __set_xattr(struct ceph_inode_info *ci,
 			   const char *name, int name_len,
 			   const char *val, int val_len,
@@ -654,8 +655,10 @@ static int __set_xattr(struct ceph_inode_info *ci,
 		dout("__set_xattr_val p=%p\n", p);
 	}
 
-	dout("__set_xattr_val added %llx.%llx xattr %p %.*s=%.*s\n",
-	     ceph_vinop(&ci->netfs.inode), xattr, name_len, name, val_len, val);
+	dout("__set_xattr_val added %llx.%llx xattr %p %.*s=%.*s%s\n",
+	     ceph_vinop(&ci->netfs.inode), xattr, name_len, name,
+	     val_len > XATTR_MAX_VAL ? XATTR_MAX_VAL : val_len, val,
+	     val_len > XATTR_MAX_VAL ? "..." : "");
 
 	return 0;
 }
@@ -681,8 +684,10 @@ static struct ceph_inode_xattr *__get_xattr(struct ceph_inode_info *ci,
 		else if (c > 0)
 			p = &(*p)->rb_right;
 		else {
-			dout("__get_xattr %s: found %.*s\n", name,
-			     xattr->val_len, xattr->val);
+			int len = xattr->val_len;
+			dout("__get_xattr %s: found %.*s%s\n", name,
+			     len > XATTR_MAX_VAL ? XATTR_MAX_VAL : len,
+			     xattr->val, len > XATTR_MAX_VAL ? "..." : "");
 			return xattr;
 		}
 	}
-- 
2.31.1

