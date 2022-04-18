Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 236B6505884
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 16:02:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243846AbiDROEw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 10:04:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245679AbiDROD5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 10:03:57 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C42AC2BD4;
        Mon, 18 Apr 2022 06:09:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 346A1CE10A2;
        Mon, 18 Apr 2022 13:09:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B303C385A1;
        Mon, 18 Apr 2022 13:08:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650287340;
        bh=ingGZxMaEc9r5alfLYbLed9tPRonczPlahQ4UPFgo+s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=swkoQZ9wvvF63t78BCChyqkTPzosfUq+fUNhriMYyc6HmeqWX3bIBUQpjFl5N6tgc
         vCqthtDfNDkDZ9ZXBpuYDSRcanDMQBoN30i+GgbPFEy0bLTW2QV+hRZ/aTYl1eLGM6
         PjGyd2ZNfvT9lMTuLYx825yhG4g39lfsOscGGI6M=
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
Subject: [PATCH 4.9 132/218] ntfs: add sanity check on allocation size
Date:   Mon, 18 Apr 2022 14:13:18 +0200
Message-Id: <20220418121203.365116416@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121158.636999985@linuxfoundation.org>
References: <20220418121158.636999985@linuxfoundation.org>
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
index 8cd134750ebb..4150b3633f77 100644
--- a/fs/ntfs/inode.c
+++ b/fs/ntfs/inode.c
@@ -1915,6 +1915,10 @@ int ntfs_read_inode_mount(struct inode *vi)
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



