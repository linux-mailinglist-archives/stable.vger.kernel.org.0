Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CF0451A96C
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:17:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356275AbiEDRL4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:11:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355854AbiEDRIx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:08:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE84D517EF;
        Wed,  4 May 2022 09:54:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 54005617DE;
        Wed,  4 May 2022 16:54:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2186C385A4;
        Wed,  4 May 2022 16:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683278;
        bh=pH8kHLg29q84DA3lAKF1knzAlPKUewGQtsmALlQhDkw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vZ+7BeYAlPHdnlzNgC7qPe+tcOz9IRzGJ0j/Mdum+OMtQltGTr6pTY+871Gy6yY4l
         c0r6NhMZ18xPK4Y8TidQMZm0oN0kuBWU99JfByTlsYqrgbNNsO+R0VkjjSKwnLAbQW
         8moYuBYy9EhvAbffbO6IkQRdF56+4bAVbEpt8Mz0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Namjae Jeon <linkinjeon@kernel.org>,
        Hyunchul Lee <hyc.lee@gmail.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 131/177] ksmbd: increment reference count of parent fp
Date:   Wed,  4 May 2022 18:45:24 +0200
Message-Id: <20220504153104.887434253@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153053.873100034@linuxfoundation.org>
References: <20220504153053.873100034@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 8510a043d334ecdf83d4604782f288db6bf21d60 ]

Add missing increment reference count of parent fp in
ksmbd_lookup_fd_inode().

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ksmbd/smb2pdu.c   | 2 ++
 fs/ksmbd/vfs_cache.c | 1 +
 2 files changed, 3 insertions(+)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 192d8308afc2..a9fdb47c2791 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -5768,8 +5768,10 @@ static int set_rename_info(struct ksmbd_work *work, struct ksmbd_file *fp,
 	if (parent_fp) {
 		if (parent_fp->daccess & FILE_DELETE_LE) {
 			pr_err("parent dir is opened with delete access\n");
+			ksmbd_fd_put(work, parent_fp);
 			return -ESHARE;
 		}
+		ksmbd_fd_put(work, parent_fp);
 	}
 next:
 	return smb2_rename(work, fp, user_ns, rename_info,
diff --git a/fs/ksmbd/vfs_cache.c b/fs/ksmbd/vfs_cache.c
index 29c1db66bd0f..8b873d92d785 100644
--- a/fs/ksmbd/vfs_cache.c
+++ b/fs/ksmbd/vfs_cache.c
@@ -497,6 +497,7 @@ struct ksmbd_file *ksmbd_lookup_fd_inode(struct inode *inode)
 	list_for_each_entry(lfp, &ci->m_fp_list, node) {
 		if (inode == file_inode(lfp->filp)) {
 			atomic_dec(&ci->m_count);
+			lfp = ksmbd_fp_get(lfp);
 			read_unlock(&ci->m_lock);
 			return lfp;
 		}
-- 
2.35.1



