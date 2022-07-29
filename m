Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 999C9584948
	for <lists+stable@lfdr.de>; Fri, 29 Jul 2022 03:13:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233421AbiG2BNh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jul 2022 21:13:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbiG2BNg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Jul 2022 21:13:36 -0400
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BBEB6BD40;
        Thu, 28 Jul 2022 18:13:32 -0700 (PDT)
Received: by mail-pg1-f170.google.com with SMTP id 6so2829275pgb.13;
        Thu, 28 Jul 2022 18:13:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nWX8earIdDVsBRHDmC8mWA0KRrT14T7sOCqzUxZsmpc=;
        b=dbQJnzLn/XY0EOMhN9+SvKvdalpA61CDHkOApoHafcsM1VTJYxHlGtV1KJu7flk5ui
         x5LthH6Z7jB7V30Ik/wtSGpLwNnkF+oqwD0W8MUYLYR0OjG5k7oPrSzgs/T9QKxdHFcZ
         KVtATv7bLk9pdl0p0oHNCUVcO7nVbczJDTLmPLnrLyvLpYWsMXiwcIXhYpHA4wmn8urR
         MG0r63aCGVhACsCA0tNY8V3iVrvo2YzRS8v5z61C2NZOx+i9uCkhzNdD1H6/G5ZbC1Ba
         4QTGwcqLXNaErKPhTHmh9QwY9g11TFPg7UH9RFFh5mO8ysB7rXhW/HY1iuqufxVrUbj/
         0OKw==
X-Gm-Message-State: AJIora9fbfHhIMpjxLApl5E7v2YEXEatptBaKehT+Rud5fJesHsHRvL6
        pp7R/vhLGkEmisai/IUErh7FiMSHFXo=
X-Google-Smtp-Source: AGRyM1vogZlzFRFSU+3ZEJOjZG+2fCWK/dgX/N1bYZyquDNCmATqsNJk+xAJThoNtn9g2tmYtftD2g==
X-Received: by 2002:a63:6c83:0:b0:419:aa0d:216c with SMTP id h125-20020a636c83000000b00419aa0d216cmr1072865pgc.328.1659057211092;
        Thu, 28 Jul 2022 18:13:31 -0700 (PDT)
Received: from localhost.localdomain ([211.49.23.9])
        by smtp.gmail.com with ESMTPSA id mn17-20020a17090b189100b001f23db09351sm1642673pjb.46.2022.07.28.18.13.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jul 2022 18:13:30 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, hyc.lee@gmail.com, senozhatsky@chromium.org,
        gregkh@linuxfoundation.org, Namjae Jeon <linkinjeon@kernel.org>,
        stable@vger.kernel.org, zdi-disclosures@trendmicro.com
Subject: [PATCH v3] ksmbd: prevent out of bound read for SMB2_WRITE
Date:   Fri, 29 Jul 2022 10:13:20 +0900
Message-Id: <20220729011321.15663-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 v2:
   - add missing fixes and stable tags.
 v3:
   - fix sparse warnings reported from kernel test robot.

 fs/ksmbd/smb2misc.c | 7 +++++--
 fs/ksmbd/smb2pdu.c  | 8 +++-----
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/fs/ksmbd/smb2misc.c b/fs/ksmbd/smb2misc.c
index f8f456377a51..aa1e663d9deb 100644
--- a/fs/ksmbd/smb2misc.c
+++ b/fs/ksmbd/smb2misc.c
@@ -136,8 +136,11 @@ static int smb2_get_data_area_len(unsigned int *off, unsigned int *len,
 		*len = le16_to_cpu(((struct smb2_read_req *)hdr)->ReadChannelInfoLength);
 		break;
 	case SMB2_WRITE:
-		if (((struct smb2_write_req *)hdr)->DataOffset) {
-			*off = le16_to_cpu(((struct smb2_write_req *)hdr)->DataOffset);
+		if (((struct smb2_write_req *)hdr)->DataOffset ||
+		    ((struct smb2_write_req *)hdr)->Length) {
+			*off = max_t(unsigned int,
+				     le16_to_cpu(((struct smb2_write_req *)hdr)->DataOffset),
+				     offsetof(struct smb2_write_req, Buffer));
 			*len = le32_to_cpu(((struct smb2_write_req *)hdr)->Length);
 			break;
 		}
diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 7ecb6d87ae3e..ea47aa0262ee 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -6514,14 +6514,12 @@ int smb2_write(struct ksmbd_work *work)
 		writethrough = true;
 
 	if (is_rdma_channel == false) {
-		if ((u64)le16_to_cpu(req->DataOffset) + length >
-		    get_rfc1002_len(work->request_buf)) {
-			pr_err("invalid write data offset %u, smb_len %u\n",
-			       le16_to_cpu(req->DataOffset),
-			       get_rfc1002_len(work->request_buf));
+		if (le16_to_cpu(req->DataOffset) <
+		    offsetof(struct smb2_write_req, Buffer)) {
 			err = -EINVAL;
 			goto out;
 		}
+
 		data_buf = (char *)(((char *)&req->hdr.ProtocolId) +
 				    le16_to_cpu(req->DataOffset));
 
-- 
2.25.1

