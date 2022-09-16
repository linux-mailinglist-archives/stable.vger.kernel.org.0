Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB93B5BAACF
	for <lists+stable@lfdr.de>; Fri, 16 Sep 2022 12:33:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231539AbiIPKSA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Sep 2022 06:18:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231542AbiIPKRI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Sep 2022 06:17:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8635AAF482;
        Fri, 16 Sep 2022 03:12:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CE3E0B8253F;
        Fri, 16 Sep 2022 10:11:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19B2BC433D6;
        Fri, 16 Sep 2022 10:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663323083;
        bh=gN+TChiF6PLFreSWeA3c6I1/So0dZbAUn8vkHPJ6KfQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jf+6zINhEvN7Qna/U1GpQiZfs59KiT286sLC8COvS6TwrO/nkfQJqlYfqBIQMuAnK
         rcNd2fPcBS/xzAAX2i3mC/kl1wilos3MHj9gPVMhvEoPiF51duxzlzKwRjlJ4qJOmg
         4aGUWktZc8ESmk6FmM9WA+kqJL9tCw7EuQCo/96E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Wysochanski <dwysocha@redhat.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 5.15 01/35] NFS: Fix WARN_ON due to unionization of nfs_inode.nrequests
Date:   Fri, 16 Sep 2022 12:08:24 +0200
Message-Id: <20220916100446.997792525@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220916100446.916515275@linuxfoundation.org>
References: <20220916100446.916515275@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Wysochanski <dwysocha@redhat.com>

commit 0ebeebcf59601bcfa0284f4bb7abdec051eb856d upstream.

Fixes the following WARN_ON
WARNING: CPU: 2 PID: 18678 at fs/nfs/inode.c:123 nfs_clear_inode+0x3b/0x50 [nfs]
...
Call Trace:
  nfs4_evict_inode+0x57/0x70 [nfsv4]
  evict+0xd1/0x180
  dispose_list+0x48/0x60
  evict_inodes+0x156/0x190
  generic_shutdown_super+0x37/0x110
  nfs_kill_super+0x1d/0x40 [nfs]
  deactivate_locked_super+0x36/0xa0

Signed-off-by: Dave Wysochanski <dwysocha@redhat.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/nfs_fs.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/include/linux/nfs_fs.h
+++ b/include/linux/nfs_fs.h
@@ -593,7 +593,9 @@ bool nfs_commit_end(struct nfs_mds_commi
 static inline int
 nfs_have_writebacks(struct inode *inode)
 {
-	return atomic_long_read(&NFS_I(inode)->nrequests) != 0;
+	if (S_ISREG(inode->i_mode))
+		return atomic_long_read(&NFS_I(inode)->nrequests) != 0;
+	return 0;
 }
 
 /*


