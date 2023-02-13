Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A370B694A56
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 16:06:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231473AbjBMPGc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 10:06:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231452AbjBMPGa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 10:06:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEA4E1DBB5
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 07:06:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5CB12B81253
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 15:06:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5B1FC4339E;
        Mon, 13 Feb 2023 15:06:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676300785;
        bh=rBQ2n6Al8ifFhz+/YpcGJx6OcBmmwX2em7hYq8jO6tQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WIWGZ1J88UTuMhfWOaBx8ZJJ3GEajYkfDoC4fE/WrSGUV5vE4DwWQIUIMnWB+l2qA
         dmLYh9N4M1Oky67EBfO5eqBF6YSjXK7josMD3IvNjrqpfV/yFhUpV39MG+1zXS2dZ8
         Q/hCCBxOkme44JZf9KdKjx/VHENI8seA9fXInFRc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, ZhaoLong Wang <wangzhaolong1@huawei.com>,
        "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.10 128/139] cifs: Fix use-after-free in rdata->read_into_pages()
Date:   Mon, 13 Feb 2023 15:51:13 +0100
Message-Id: <20230213144752.710756764@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144745.696901179@linuxfoundation.org>
References: <20230213144745.696901179@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: ZhaoLong Wang <wangzhaolong1@huawei.com>

commit aa5465aeca3c66fecdf7efcf554aed79b4c4b211 upstream.

When the network status is unstable, use-after-free may occur when
read data from the server.

  BUG: KASAN: use-after-free in readpages_fill_pages+0x14c/0x7e0

  Call Trace:
   <TASK>
   dump_stack_lvl+0x38/0x4c
   print_report+0x16f/0x4a6
   kasan_report+0xb7/0x130
   readpages_fill_pages+0x14c/0x7e0
   cifs_readv_receive+0x46d/0xa40
   cifs_demultiplex_thread+0x121c/0x1490
   kthread+0x16b/0x1a0
   ret_from_fork+0x2c/0x50
   </TASK>

  Allocated by task 2535:
   kasan_save_stack+0x22/0x50
   kasan_set_track+0x25/0x30
   __kasan_kmalloc+0x82/0x90
   cifs_readdata_direct_alloc+0x2c/0x110
   cifs_readdata_alloc+0x2d/0x60
   cifs_readahead+0x393/0xfe0
   read_pages+0x12f/0x470
   page_cache_ra_unbounded+0x1b1/0x240
   filemap_get_pages+0x1c8/0x9a0
   filemap_read+0x1c0/0x540
   cifs_strict_readv+0x21b/0x240
   vfs_read+0x395/0x4b0
   ksys_read+0xb8/0x150
   do_syscall_64+0x3f/0x90
   entry_SYSCALL_64_after_hwframe+0x72/0xdc

  Freed by task 79:
   kasan_save_stack+0x22/0x50
   kasan_set_track+0x25/0x30
   kasan_save_free_info+0x2e/0x50
   __kasan_slab_free+0x10e/0x1a0
   __kmem_cache_free+0x7a/0x1a0
   cifs_readdata_release+0x49/0x60
   process_one_work+0x46c/0x760
   worker_thread+0x2a4/0x6f0
   kthread+0x16b/0x1a0
   ret_from_fork+0x2c/0x50

  Last potentially related work creation:
   kasan_save_stack+0x22/0x50
   __kasan_record_aux_stack+0x95/0xb0
   insert_work+0x2b/0x130
   __queue_work+0x1fe/0x660
   queue_work_on+0x4b/0x60
   smb2_readv_callback+0x396/0x800
   cifs_abort_connection+0x474/0x6a0
   cifs_reconnect+0x5cb/0xa50
   cifs_readv_from_socket.cold+0x22/0x6c
   cifs_read_page_from_socket+0xc1/0x100
   readpages_fill_pages.cold+0x2f/0x46
   cifs_readv_receive+0x46d/0xa40
   cifs_demultiplex_thread+0x121c/0x1490
   kthread+0x16b/0x1a0
   ret_from_fork+0x2c/0x50

The following function calls will cause UAF of the rdata pointer.

readpages_fill_pages
 cifs_read_page_from_socket
  cifs_readv_from_socket
   cifs_reconnect
    __cifs_reconnect
     cifs_abort_connection
      mid->callback() --> smb2_readv_callback
       queue_work(&rdata->work)  # if the worker completes first,
                                 # the rdata is freed
          cifs_readv_complete
            kref_put
              cifs_readdata_release
                kfree(rdata)
 return rdata->...               # UAF in readpages_fill_pages()

Similarly, this problem also occurs in the uncache_fill_pages().

Fix this by adjusts the order of condition judgment in the return
statement.

Signed-off-by: ZhaoLong Wang <wangzhaolong1@huawei.com>
Cc: stable@vger.kernel.org
Acked-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/file.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -3539,7 +3539,7 @@ uncached_fill_pages(struct TCP_Server_In
 		rdata->got_bytes += result;
 	}
 
-	return rdata->got_bytes > 0 && result != -ECONNABORTED ?
+	return result != -ECONNABORTED && rdata->got_bytes > 0 ?
 						rdata->got_bytes : result;
 }
 
@@ -4302,7 +4302,7 @@ readpages_fill_pages(struct TCP_Server_I
 		rdata->got_bytes += result;
 	}
 
-	return rdata->got_bytes > 0 && result != -ECONNABORTED ?
+	return result != -ECONNABORTED && rdata->got_bytes > 0 ?
 						rdata->got_bytes : result;
 }
 


