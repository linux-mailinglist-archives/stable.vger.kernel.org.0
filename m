Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 282DA5EA443
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:43:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238450AbiIZLnC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:43:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238285AbiIZLmV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:42:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A0B271736;
        Mon, 26 Sep 2022 03:45:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D554F60BAA;
        Mon, 26 Sep 2022 10:44:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF0ECC433C1;
        Mon, 26 Sep 2022 10:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664189070;
        bh=eOChhNzF/2ujg/vJSP6nXkufiXzX4HbcSRXtcrw7yTw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YKV2f5ohDtkZbcO1fITXrmK2l/zzlMk/p0aME8Bf2LBHJ8CUNQF5J7/s/r1kixLlD
         CG9rTnj+gbtLRmT7CQZBo+siZo2TOJDQzBqr1LQkjj/QqG5FODIYc5gmnTzmj0P1eM
         KqPOpKXh/Cei5GovIAbiTMM678haLX8hqdq3m+Xo=
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
Subject: [PATCH 5.19 062/207] mm/slub: fix to return errno if kmalloc() fails
Date:   Mon, 26 Sep 2022 12:10:51 +0200
Message-Id: <20220926100809.379448705@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100806.522017616@linuxfoundation.org>
References: <20220926100806.522017616@linuxfoundation.org>
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
@@ -5918,7 +5918,8 @@ static char *create_unique_id(struct kme
 	char *name = kmalloc(ID_STR_LENGTH, GFP_KERNEL);
 	char *p = name;
 
-	BUG_ON(!name);
+	if (!name)
+		return ERR_PTR(-ENOMEM);
 
 	*p++ = ':';
 	/*
@@ -5976,6 +5977,8 @@ static int sysfs_slab_add(struct kmem_ca
 		 * for the symlinks.
 		 */
 		name = create_unique_id(s);
+		if (IS_ERR(name))
+			return PTR_ERR(name);
 	}
 
 	s->kobj.kset = kset;


