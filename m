Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58C105EA092
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 12:40:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236153AbiIZKkN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 06:40:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236501AbiIZKj2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 06:39:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9F6B4D15C;
        Mon, 26 Sep 2022 03:23:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8CDA460B2F;
        Mon, 26 Sep 2022 10:23:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5048BC433D6;
        Mon, 26 Sep 2022 10:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664187808;
        bh=pZBlqy+MLlyTpWtUdAz5D06w7QXEQEmHyBZwybIOafc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qZ8tDRJz4S7aS/4rHF0oU36emiXiNbTkTs0RKFotmbl7AU3YoicAXdbZJcKJkqkqQ
         YQ2tcfHvLyxHjrYWj0vWLwdaBPOc8meR65njxbMb//89gCpNkQk5NX2MXl4F7MI2uO
         VqIPdIP9LJOJubYWds4Im47tzkc4g6ErwRm0ut/8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        syzbot+81684812ea68216e08c5@syzkaller.appspotmail.com,
        Muchun Song <songmuchun@bytedance.com>,
        Hyeonggon Yoo <42.hyeyoo@gmail.com>,
        Chao Yu <chao.yu@oppo.com>,
        David Rientjes <rientjes@google.com>,
        Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH 5.4 065/120] mm/slub: fix to return errno if kmalloc() fails
Date:   Mon, 26 Sep 2022 12:11:38 +0200
Message-Id: <20220926100753.362508743@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100750.519221159@linuxfoundation.org>
References: <20220926100750.519221159@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <chao.yu@oppo.com>

commit 7e9c323c52b379d261a72dc7bd38120a761a93cd upstream.

In create_unique_id(), kmalloc(, GFP_KERNEL) can fail due to
out-of-memory, if it fails, return errno correctly rather than
triggering panic via BUG_ON();

kernel BUG at mm/slub.c:5893!
Internal error: Oops - BUG: 0 [#1] PREEMPT SMP

Call trace:
 sysfs_slab_add+0x258/0x260 mm/slub.c:5973
 __kmem_cache_create+0x60/0x118 mm/slub.c:4899
 create_cache mm/slab_common.c:229 [inline]
 kmem_cache_create_usercopy+0x19c/0x31c mm/slab_common.c:335
 kmem_cache_create+0x1c/0x28 mm/slab_common.c:390
 f2fs_kmem_cache_create fs/f2fs/f2fs.h:2766 [inline]
 f2fs_init_xattr_caches+0x78/0xb4 fs/f2fs/xattr.c:808
 f2fs_fill_super+0x1050/0x1e0c fs/f2fs/super.c:4149
 mount_bdev+0x1b8/0x210 fs/super.c:1400
 f2fs_mount+0x44/0x58 fs/f2fs/super.c:4512
 legacy_get_tree+0x30/0x74 fs/fs_context.c:610
 vfs_get_tree+0x40/0x140 fs/super.c:1530
 do_new_mount+0x1dc/0x4e4 fs/namespace.c:3040
 path_mount+0x358/0x914 fs/namespace.c:3370
 do_mount fs/namespace.c:3383 [inline]
 __do_sys_mount fs/namespace.c:3591 [inline]
 __se_sys_mount fs/namespace.c:3568 [inline]
 __arm64_sys_mount+0x2f8/0x408 fs/namespace.c:3568

Cc: <stable@kernel.org>
Fixes: 81819f0fc8285 ("SLUB core")
Reported-by: syzbot+81684812ea68216e08c5@syzkaller.appspotmail.com
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Signed-off-by: Chao Yu <chao.yu@oppo.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/slub.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/slub.c
+++ b/mm/slub.c
@@ -5743,7 +5743,8 @@ static char *create_unique_id(struct kme
 	char *name = kmalloc(ID_STR_LENGTH, GFP_KERNEL);
 	char *p = name;
 
-	BUG_ON(!name);
+	if (!name)
+		return ERR_PTR(-ENOMEM);
 
 	*p++ = ':';
 	/*
@@ -5825,6 +5826,8 @@ static int sysfs_slab_add(struct kmem_ca
 		 * for the symlinks.
 		 */
 		name = create_unique_id(s);
+		if (IS_ERR(name))
+			return PTR_ERR(name);
 	}
 
 	s->kobj.kset = kset;


