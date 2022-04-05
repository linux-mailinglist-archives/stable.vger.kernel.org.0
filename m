Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A27074F2D19
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:35:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233829AbiDEIjL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:39:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240071AbiDEIWf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:22:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E1C1DFB7;
        Tue,  5 Apr 2022 01:19:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AE7E660989;
        Tue,  5 Apr 2022 08:19:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C276BC385A4;
        Tue,  5 Apr 2022 08:19:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146784;
        bh=a3X9AFzHlu8+WSu53lKw4fxPUWErvt/B1kO6xdYwI7g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z0OWW3vpgFLFCSc43bFahq4pLW2+YsC/u22uvkaBZ9wKUEFeF9Nz2sLiaKaJBuEKO
         nFTjy0buPK3HzvmVOH7H+w1XzPfdWsEHGD57w39bpdF/5tBmamZonPCKOksjoeN5yC
         Pu/lUJTj1hw5VaN8jCZH9WfVJax0jWNTDOAcjL3M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+3c765c5248797356edaa@syzkaller.appspotmail.com,
        Dongliang Mu <mudongliangabcd@gmail.com>,
        Anton Altaparmakov <anton@tuxera.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0888/1126] ntfs: add sanity check on allocation size
Date:   Tue,  5 Apr 2022 09:27:15 +0200
Message-Id: <20220405070433.593698884@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dongliang Mu <mudongliangabcd@gmail.com>

[ Upstream commit 714fbf2647b1a33d914edd695d4da92029c7e7c0 ]

ntfs_read_inode_mount invokes ntfs_malloc_nofs with zero allocation
size.  It triggers one BUG in the __ntfs_malloc function.

Fix this by adding sanity check on ni->attr_list_size.

Link: https://lkml.kernel.org/r/20220120094914.47736-1-dzm91@hust.edu.cn
Reported-by: syzbot+3c765c5248797356edaa@syzkaller.appspotmail.com
Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
Acked-by: Anton Altaparmakov <anton@tuxera.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs/inode.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/ntfs/inode.c b/fs/ntfs/inode.c
index 4474adb393ca..517b71c73aa9 100644
--- a/fs/ntfs/inode.c
+++ b/fs/ntfs/inode.c
@@ -1881,6 +1881,10 @@ int ntfs_read_inode_mount(struct inode *vi)
 		}
 		/* Now allocate memory for the attribute list. */
 		ni->attr_list_size = (u32)ntfs_attr_size(a);
+		if (!ni->attr_list_size) {
+			ntfs_error(sb, "Attr_list_size is zero");
+			goto put_err_out;
+		}
 		ni->attr_list = ntfs_malloc_nofs(ni->attr_list_size);
 		if (!ni->attr_list) {
 			ntfs_error(sb, "Not enough memory to allocate buffer "
-- 
2.34.1



