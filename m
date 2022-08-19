Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE112599E80
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 17:43:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349999AbiHSPmh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 11:42:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350001AbiHSPlw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 11:41:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 031DB102F35;
        Fri, 19 Aug 2022 08:41:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 46CD2B8277D;
        Fri, 19 Aug 2022 15:41:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 947BEC433D7;
        Fri, 19 Aug 2022 15:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660923670;
        bh=3ZsFsvZyMK+E7wOFl4R8OLSIHARPZ4AMFBzPb0nUZ6o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XsVtPRkEgKCFURn5YwJ95C7IwKKGu21+9CdrYWqKULAUef6Gv+VRArCyAfo4sWbny
         R0G/FripBkk/X6KWJTbUtTNqUsCyQqPNQqgIx1XqbGKZEc1LSO8Cz5WU9GfCWpihu5
         taP0x/xYsFz+jthcCyMQvNqRddSF7duw81Y7aBBc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hyunchul Lee <hyc.lee@gmail.com>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Steve French <stfrench@microsoft.com>,
        zdi-disclosures@trendmicro.com
Subject: [PATCH 5.15 04/14] ksmbd: prevent out of bound read for SMB2_WRITE
Date:   Fri, 19 Aug 2022 17:40:20 +0200
Message-Id: <20220819153711.816369367@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153711.658766010@linuxfoundation.org>
References: <20220819153711.658766010@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Hyunchul Lee <hyc.lee@gmail.com>

commit ac60778b87e45576d7bfdbd6f53df902654e6f09 upstream.

OOB read memory can be written to a file,
if DataOffset is 0 and Length is too large
in SMB2_WRITE request of compound request.

To prevent this, when checking the length of
the data area of SMB2_WRITE in smb2_get_data_area_len(),
let the minimum of DataOffset be the size of
SMB2 header + the size of SMB2_WRITE header.

This bug can lead an oops looking something like:

[  798.008715] BUG: KASAN: slab-out-of-bounds in copy_page_from_iter_atomic+0xd3d/0x14b0
[  798.008724] Read of size 252 at addr ffff88800f863e90 by task kworker/0:2/2859
...
[  798.008754] Call Trace:
[  798.008756]  <TASK>
[  798.008759]  dump_stack_lvl+0x49/0x5f
[  798.008764]  print_report.cold+0x5e/0x5cf
[  798.008768]  ? __filemap_get_folio+0x285/0x6d0
[  798.008774]  ? copy_page_from_iter_atomic+0xd3d/0x14b0
[  798.008777]  kasan_report+0xaa/0x120
[  798.008781]  ? copy_page_from_iter_atomic+0xd3d/0x14b0
[  798.008784]  kasan_check_range+0x100/0x1e0
[  798.008788]  memcpy+0x24/0x60
[  798.008792]  copy_page_from_iter_atomic+0xd3d/0x14b0
[  798.008795]  ? pagecache_get_page+0x53/0x160
[  798.008799]  ? iov_iter_get_pages_alloc+0x1590/0x1590
[  798.008803]  ? ext4_write_begin+0xfc0/0xfc0
[  798.008807]  ? current_time+0x72/0x210
[  798.008811]  generic_perform_write+0x2c8/0x530
[  798.008816]  ? filemap_fdatawrite_wbc+0x180/0x180
[  798.008820]  ? down_write+0xb4/0x120
[  798.008824]  ? down_write_killable+0x130/0x130
[  798.008829]  ext4_buffered_write_iter+0x137/0x2c0
[  798.008833]  ext4_file_write_iter+0x40b/0x1490
[  798.008837]  ? __fsnotify_parent+0x275/0xb20
[  798.008842]  ? __fsnotify_update_child_dentry_flags+0x2c0/0x2c0
[  798.008846]  ? ext4_buffered_write_iter+0x2c0/0x2c0
[  798.008851]  __kernel_write+0x3a1/0xa70
[  798.008855]  ? __x64_sys_preadv2+0x160/0x160
[  798.008860]  ? security_file_permission+0x4a/0xa0
[  798.008865]  kernel_write+0xbb/0x360
[  798.008869]  ksmbd_vfs_write+0x27e/0xb90 [ksmbd]
[  798.008881]  ? ksmbd_vfs_read+0x830/0x830 [ksmbd]
[  798.008892]  ? _raw_read_unlock+0x2a/0x50
[  798.008896]  smb2_write+0xb45/0x14e0 [ksmbd]
[  798.008909]  ? __kasan_check_write+0x14/0x20
[  798.008912]  ? _raw_spin_lock_bh+0xd0/0xe0
[  798.008916]  ? smb2_read+0x15e0/0x15e0 [ksmbd]
[  798.008927]  ? memcpy+0x4e/0x60
[  798.008931]  ? _raw_spin_unlock+0x19/0x30
[  798.008934]  ? ksmbd_smb2_check_message+0x16af/0x2350 [ksmbd]
[  798.008946]  ? _raw_spin_lock_bh+0xe0/0xe0
[  798.008950]  handle_ksmbd_work+0x30e/0x1020 [ksmbd]
[  798.008962]  process_one_work+0x778/0x11c0
[  798.008966]  ? _raw_spin_lock_irq+0x8e/0xe0
[  798.008970]  worker_thread+0x544/0x1180
[  798.008973]  ? __cpuidle_text_end+0x4/0x4
[  798.008977]  kthread+0x282/0x320
[  798.008982]  ? process_one_work+0x11c0/0x11c0
[  798.008985]  ? kthread_complete_and_exit+0x30/0x30
[  798.008989]  ret_from_fork+0x1f/0x30
[  798.008995]  </TASK>

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org
Reported-by: zdi-disclosures@trendmicro.com # ZDI-CAN-17817
Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/smb2misc.c |    7 +++++--
 fs/ksmbd/smb2pdu.c  |    6 ++----
 2 files changed, 7 insertions(+), 6 deletions(-)

--- a/fs/ksmbd/smb2misc.c
+++ b/fs/ksmbd/smb2misc.c
@@ -132,8 +132,11 @@ static int smb2_get_data_area_len(unsign
 		*len = le16_to_cpu(((struct smb2_read_req *)hdr)->ReadChannelInfoLength);
 		break;
 	case SMB2_WRITE:
-		if (((struct smb2_write_req *)hdr)->DataOffset) {
-			*off = le16_to_cpu(((struct smb2_write_req *)hdr)->DataOffset);
+		if (((struct smb2_write_req *)hdr)->DataOffset ||
+		    ((struct smb2_write_req *)hdr)->Length) {
+			*off = max_t(unsigned int,
+				     le16_to_cpu(((struct smb2_write_req *)hdr)->DataOffset),
+				     offsetof(struct smb2_write_req, Buffer) - 4);
 			*len = le32_to_cpu(((struct smb2_write_req *)hdr)->Length);
 			break;
 		}
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -6471,10 +6471,8 @@ int smb2_write(struct ksmbd_work *work)
 		    (offsetof(struct smb2_write_req, Buffer) - 4)) {
 			data_buf = (char *)&req->Buffer[0];
 		} else {
-			if ((u64)le16_to_cpu(req->DataOffset) + length > get_rfc1002_len(req)) {
-				pr_err("invalid write data offset %u, smb_len %u\n",
-				       le16_to_cpu(req->DataOffset),
-				       get_rfc1002_len(req));
+			if (le16_to_cpu(req->DataOffset) <
+			    offsetof(struct smb2_write_req, Buffer)) {
 				err = -EINVAL;
 				goto out;
 			}


