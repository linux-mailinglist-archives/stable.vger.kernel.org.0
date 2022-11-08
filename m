Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81BBE6214F4
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:07:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235078AbiKHOG6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:06:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235076AbiKHOG5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:06:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B44F70565
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 06:06:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CB2C8615AF
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 14:06:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D066BC433C1;
        Tue,  8 Nov 2022 14:06:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667916416;
        bh=PTkj/63/1Bcy6LSp22f67ug3w1n2ZfilNFXYfvn42B0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pT0efXCA4oAJxXRa6wFNUngdvVFvPDFF7MFDBR7VzRXbSg1+fgPg4QHPJzlvoWds0
         6FPR6TpUs990KBGhljKQntR7Uo9BNpokIy31Duhhv6Xen0J0v/JHyfJnG/Ui+zYUiF
         mCLGbqr2m/XIezQmcRn+Ecjd3UKOJIemGQEvWQYo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Benjamin Coddington <bcodding@redhat.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 014/197] NFSv4.2: Fixup CLONE dest file size for zero-length count
Date:   Tue,  8 Nov 2022 14:37:32 +0100
Message-Id: <20221108133355.423271044@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
References: <20221108133354.787209461@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Benjamin Coddington <bcodding@redhat.com>

[ Upstream commit 038efb6348ce96228f6828354cb809c22a661681 ]

When holding a delegation, the NFS client optimizes away setting the
attributes of a file from the GETATTR in the compound after CLONE, and for
a zero-length CLONE we will end up setting the inode's size to zero in
nfs42_copy_dest_done().  Handle this case by computing the resulting count
from the server's reported size after CLONE's GETATTR.

Suggested-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Benjamin Coddington <bcodding@redhat.com>
Fixes: 94d202d5ca39 ("NFSv42: Copy offload should update the file size when appropriate")
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs42proc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/nfs/nfs42proc.c b/fs/nfs/nfs42proc.c
index 6dab9e408372..21c9e97c3ba3 100644
--- a/fs/nfs/nfs42proc.c
+++ b/fs/nfs/nfs42proc.c
@@ -1093,6 +1093,9 @@ static int _nfs42_proc_clone(struct rpc_message *msg, struct file *src_f,
 				&args.seq_args, &res.seq_res, 0);
 	trace_nfs4_clone(src_inode, dst_inode, &args, status);
 	if (status == 0) {
+		/* a zero-length count means clone to EOF in src */
+		if (count == 0 && res.dst_fattr->valid & NFS_ATTR_FATTR_SIZE)
+			count = nfs_size_to_loff_t(res.dst_fattr->size) - dst_offset;
 		nfs42_copy_dest_done(dst_inode, dst_offset, count);
 		status = nfs_post_op_update_inode(dst_inode, res.dst_fattr);
 	}
-- 
2.35.1



