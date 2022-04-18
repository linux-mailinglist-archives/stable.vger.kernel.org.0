Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6C8850505C
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:22:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238569AbiDRMYc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:24:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238495AbiDRMXX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:23:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC2881BE86;
        Mon, 18 Apr 2022 05:18:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5458C60F01;
        Mon, 18 Apr 2022 12:18:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65372C385A1;
        Mon, 18 Apr 2022 12:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284336;
        bh=BAY7BvL+3ZQxQmWytA/czDFBqyn2lJXnPslvkiwTo7Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pu1QchYxUjHMLHwLYswjeQVdeihVpiGN+G1ofjsSLEEXsTil88hxGxRhqxGJQcO2e
         S/EsqzdZB0GlqUK5/jGHc0mfFFDgF5jqkLjh7BkiLQ6Bf9LsIYduknU33X9EjHiijr
         XraP2HEl6Wb4mkCF1kryzt0yBFoNM+VnQyHjFOp0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Wysochanski <dwysocha@redhat.com>,
        David Howells <dhowells@redhat.com>, linux-cachefs@redhat.com,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 079/219] cachefiles: Fix KASAN slab-out-of-bounds in cachefiles_set_volume_xattr
Date:   Mon, 18 Apr 2022 14:10:48 +0200
Message-Id: <20220418121208.383594279@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121203.462784814@linuxfoundation.org>
References: <20220418121203.462784814@linuxfoundation.org>
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

From: Dave Wysochanski <dwysocha@redhat.com>

[ Upstream commit 7b2f6c306601240635c72caa61f682e74d4591b2 ]

Use the actual length of volume coherency data when setting the
xattr to avoid the following KASAN report.

 BUG: KASAN: slab-out-of-bounds in cachefiles_set_volume_xattr+0xa0/0x350 [cachefiles]
 Write of size 4 at addr ffff888101e02af4 by task kworker/6:0/1347

 CPU: 6 PID: 1347 Comm: kworker/6:0 Kdump: loaded Not tainted 5.18.0-rc1-nfs-fscache-netfs+ #13
 Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.14.0-4.fc34 04/01/2014
 Workqueue: events fscache_create_volume_work [fscache]
 Call Trace:
  <TASK>
  dump_stack_lvl+0x45/0x5a
  print_report.cold+0x5e/0x5db
  ? __lock_text_start+0x8/0x8
  ? cachefiles_set_volume_xattr+0xa0/0x350 [cachefiles]
  kasan_report+0xab/0x120
  ? cachefiles_set_volume_xattr+0xa0/0x350 [cachefiles]
  kasan_check_range+0xf5/0x1d0
  memcpy+0x39/0x60
  cachefiles_set_volume_xattr+0xa0/0x350 [cachefiles]
  cachefiles_acquire_volume+0x2be/0x500 [cachefiles]
  ? __cachefiles_free_volume+0x90/0x90 [cachefiles]
  fscache_create_volume_work+0x68/0x160 [fscache]
  process_one_work+0x3b7/0x6a0
  worker_thread+0x2c4/0x650
  ? process_one_work+0x6a0/0x6a0
  kthread+0x16c/0x1a0
  ? kthread_complete_and_exit+0x20/0x20
  ret_from_fork+0x22/0x30
  </TASK>

 Allocated by task 1347:
  kasan_save_stack+0x1e/0x40
  __kasan_kmalloc+0x81/0xa0
  cachefiles_set_volume_xattr+0x76/0x350 [cachefiles]
  cachefiles_acquire_volume+0x2be/0x500 [cachefiles]
  fscache_create_volume_work+0x68/0x160 [fscache]
  process_one_work+0x3b7/0x6a0
  worker_thread+0x2c4/0x650
  kthread+0x16c/0x1a0
  ret_from_fork+0x22/0x30

 The buggy address belongs to the object at ffff888101e02af0
 which belongs to the cache kmalloc-8 of size 8
 The buggy address is located 4 bytes inside of
 8-byte region [ffff888101e02af0, ffff888101e02af8)

 The buggy address belongs to the physical page:
 page:00000000a2292d70 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x101e02
 flags: 0x17ffffc0000200(slab|node=0|zone=2|lastcpupid=0x1fffff)
 raw: 0017ffffc0000200 0000000000000000 dead000000000001 ffff888100042280
 raw: 0000000000000000 0000000080660066 00000001ffffffff 0000000000000000
 page dumped because: kasan: bad access detected

 Memory state around the buggy address:
 ffff888101e02980: fc 00 fc fc fc fc 00 fc fc fc fc 00 fc fc fc fc
 ffff888101e02a00: 00 fc fc fc fc 00 fc fc fc fc 00 fc fc fc fc 00
 >ffff888101e02a80: fc fc fc fc 00 fc fc fc fc 00 fc fc fc fc 04 fc
                                                            ^
 ffff888101e02b00: fc fc fc 00 fc fc fc fc 00 fc fc fc fc 00 fc fc
 ffff888101e02b80: fc fc 00 fc fc fc fc 00 fc fc fc fc 00 fc fc fc
 ==================================================================

Fixes: 413a4a6b0b55 "cachefiles: Fix volume coherency attribute"
Signed-off-by: Dave Wysochanski <dwysocha@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
cc: linux-cachefs@redhat.com
Link: https://lore.kernel.org/r/20220405134649.6579-1-dwysocha@redhat.com/ # v1
Link: https://lore.kernel.org/r/20220405142810.8208-1-dwysocha@redhat.com/ # Incorrect v2
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cachefiles/xattr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cachefiles/xattr.c b/fs/cachefiles/xattr.c
index 35465109d9c4..00b087c14995 100644
--- a/fs/cachefiles/xattr.c
+++ b/fs/cachefiles/xattr.c
@@ -203,7 +203,7 @@ bool cachefiles_set_volume_xattr(struct cachefiles_volume *volume)
 	if (!buf)
 		return false;
 	buf->reserved = cpu_to_be32(0);
-	memcpy(buf->data, p, len);
+	memcpy(buf->data, p, volume->vcookie->coherency_len);
 
 	ret = cachefiles_inject_write_error();
 	if (ret == 0)
-- 
2.35.1



