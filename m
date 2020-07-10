Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CACC221B454
	for <lists+stable@lfdr.de>; Fri, 10 Jul 2020 13:58:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726945AbgGJL6N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jul 2020 07:58:13 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:22564 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726840AbgGJL6M (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Jul 2020 07:58:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594382291;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=WrAUzsslcQ6587N6bpxNIRSuTpr2lTJ8ANwKcgAAxbY=;
        b=OZbDARtSE9shDd8MeAWB6v1zmXBXpIDcc5+f75rMkisqSs8H8mD+lgm0aaQb76D0LpA5oZ
        lgPN7rB9txrOaoOCeCleLINV1cuie7B5W9nfEApwJRd7mb/r/CHU1OVafujv14rVx64Lps
        Cj+uNEIhdeP0ntLeezUUuY+4Vywr5Mo=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-243-vXRw3GdeMdCwUFuZ_ds0rw-1; Fri, 10 Jul 2020 07:58:09 -0400
X-MC-Unique: vXRw3GdeMdCwUFuZ_ds0rw-1
Received: by mail-ed1-f72.google.com with SMTP id v8so6704299edj.4
        for <stable@vger.kernel.org>; Fri, 10 Jul 2020 04:58:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WrAUzsslcQ6587N6bpxNIRSuTpr2lTJ8ANwKcgAAxbY=;
        b=CHsXyH5g4BmBHksk/Ij4xigVT2nGI1iMboapsViR80gc5qMpRNvvG9Dmp7ebmZM8cs
         TfH94x56sNsogQIL6e2+6hDPdESi47AJAlQKMlhjsRXCUQcA28gi2QS2RfSSNiuDH3C9
         MDWISfJ5D2qQ80IFoAo4EbXGAgI38hyyfzCzDXpTcPdrf0Wg7+LY9HJ6rS/saonERC6v
         RhTYbbMEoYXyR1+PLk3aO9JdSlyKC4Spbph5n4jCok8VCxK8UXlW+D3QEdZRIUrQHosj
         P/SzgU6cykmt+T4szczsSGWzoQHnV8diFMCGZcQy7rbfvtEAnzkBF8+rsBEmMesC1XDA
         zagw==
X-Gm-Message-State: AOAM533GmP5fKbcLgaWFgg4KzgdonxZGccN5Wq6FIP8yFIGKKfuw8DWe
        GeER7F1b/pmJpxDn3humI0+rO3bThTE4j34KE7TLvFcK6v0+v+Tz7M9a85vWeXLf/3he9Zlg+ic
        kYVhPrQLOdmGbJUdg
X-Received: by 2002:a17:906:69d3:: with SMTP id g19mr41788064ejs.402.1594382287911;
        Fri, 10 Jul 2020 04:58:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwDuJCnhjKq7P41NLwcaIkbXSfBf3rS02RRzO4bSzyOQBnJMkwuSDs+EhrikFKVkS77vA9vUg==
X-Received: by 2002:a17:906:69d3:: with SMTP id g19mr41788051ejs.402.1594382287748;
        Fri, 10 Jul 2020 04:58:07 -0700 (PDT)
Received: from miu.piliscsaba.redhat.com (catv-212-96-48-140.catv.broadband.hu. [212.96.48.140])
        by smtp.gmail.com with ESMTPSA id a8sm3536951ejp.51.2020.07.10.04.58.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2020 04:58:07 -0700 (PDT)
From:   Miklos Szeredi <mszeredi@redhat.com>
To:     linux-fsdevel@vger.kernel.org
Cc:     Stefan Priebe <s.priebe@profihost.ag>,
        David Howells <dhowells@redhat.com>, stable@vger.kernel.org
Subject: [PATCH 1/3] fuse: use ->reconfigure() instead of ->remount_fs()
Date:   Fri, 10 Jul 2020 13:58:03 +0200
Message-Id: <20200710115805.4478-1-mszeredi@redhat.com>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

s_op->remount_fs() is only called from legacy_reconfigure(), which is not
used after being converted to the new API.

Convert to using ->reconfigure().  This restores the previous behavior of
syncing the filesystem and rejecting MS_MANDLOCK on remount.

Fixes: c30da2e981a7 ("fuse: convert to use the new mount API")
Cc: <stable@vger.kernel.org> # v5.4
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/fuse/inode.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 5b4aebf5821f..be39dff57c28 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -121,10 +121,12 @@ static void fuse_evict_inode(struct inode *inode)
 	}
 }
 
-static int fuse_remount_fs(struct super_block *sb, int *flags, char *data)
+static int fuse_reconfigure(struct fs_context *fc)
 {
+	struct super_block *sb = fc->root->d_sb;
+
 	sync_filesystem(sb);
-	if (*flags & SB_MANDLOCK)
+	if (fc->sb_flags & SB_MANDLOCK)
 		return -EINVAL;
 
 	return 0;
@@ -817,7 +819,6 @@ static const struct super_operations fuse_super_operations = {
 	.evict_inode	= fuse_evict_inode,
 	.write_inode	= fuse_write_inode,
 	.drop_inode	= generic_delete_inode,
-	.remount_fs	= fuse_remount_fs,
 	.put_super	= fuse_put_super,
 	.umount_begin	= fuse_umount_begin,
 	.statfs		= fuse_statfs,
@@ -1296,6 +1297,7 @@ static int fuse_get_tree(struct fs_context *fc)
 static const struct fs_context_operations fuse_context_ops = {
 	.free		= fuse_free_fc,
 	.parse_param	= fuse_parse_param,
+	.reconfigure	= fuse_reconfigure,
 	.get_tree	= fuse_get_tree,
 };
 
-- 
2.21.1

