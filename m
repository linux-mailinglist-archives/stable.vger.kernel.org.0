Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34DEF6A833B
	for <lists+stable@lfdr.de>; Thu,  2 Mar 2023 14:07:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229572AbjCBNHX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Mar 2023 08:07:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbjCBNHW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Mar 2023 08:07:22 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACC954C6E6
        for <stable@vger.kernel.org>; Thu,  2 Mar 2023 05:07:10 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id f13so67315433edz.6
        for <stable@vger.kernel.org>; Thu, 02 Mar 2023 05:07:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1677762429;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=W8jKwCX/ceD2lfLDQ/Jr6zujwOsAn91spsgYEW7AGCg=;
        b=Un8P68sDgNULbDppani3GM3C8MmI6xcIfnij8M8YBQAxvuXcISMITPUWWHWjfP+h5H
         Wnvw1Y7zUBhL/Hk4zIDW5p+ceoGX/NgygLRlPsmpp7wrlkzmQ4aBDjEKCK4ObHnxmq/G
         ZptXxjMgrZB8N9Rg+y/qf6RmJRNP62OFN1kgErkOmEpitXHY0gE+3xwHO+N5xDTUxJCJ
         nFv1fn9+rjoiLfnkm/ObdbUB9VBbmLPVYEHDN/QEYLgrtlcz6RaSE+qGR6hyiSL4JCZl
         rJTrHZTGcesn7kAhpY28+ll5rsPkMcI31tH9ABecg+JQSEH2VMeIFZn+ldS9vdt6if6V
         1CFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677762429;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=W8jKwCX/ceD2lfLDQ/Jr6zujwOsAn91spsgYEW7AGCg=;
        b=KU++O8PbVbpCYRYTar+ws1HN+7a/ySDwDWWuyPxquecBbleFIc4A4gYUOs4G7xiQ8d
         bKjlCku2K65SFN1dWtwKLVLX/DwldkcE2jGyHa6TZQKvVjP5B53i6P7H/EB5vPc/lKGO
         Zc2lEr3ShBLDtquLQN7wuTHaWoaqHwRlHz5yIE1VOpCefcS0q2kZgn+EqRq5UZjRvs5r
         fG166LudPoMv7yZiWIb9dHAjo7TfFcl+wF6X9tQieQ9tq9xREISUZAKLpJk3Oo1s8nBb
         y4/gcXRyEX9zfk8UB+t6hk/vLZg3lCp2h5fq5lj/JmXo3jGMsVZG9jFLwMVBIh0B3gWa
         wodQ==
X-Gm-Message-State: AO0yUKUVas/s4SUDoslLexeMo8HwIweh2JRCI7tpyQWZcXpD/QDcrnIs
        BQyta/ocrE75DJGPnPmIsvEV0g==
X-Google-Smtp-Source: AK7set+oXDy4KSwSCxsdJcV40svXT8MbjKeNJlOEqd6UH4B1Qj0EhnpqTZGxkZmDnv0/dRcCC/mkqQ==
X-Received: by 2002:a05:6402:1602:b0:4c2:96d0:c0cb with SMTP id f2-20020a056402160200b004c296d0c0cbmr395452edv.23.1677762429156;
        Thu, 02 Mar 2023 05:07:09 -0800 (PST)
Received: from heron.intern.cm-ag (p200300dc6f390200529a4cfffe3dd983.dip0.t-ipconnect.de. [2003:dc:6f39:200:529a:4cff:fe3d:d983])
        by smtp.gmail.com with ESMTPSA id b8-20020a509f08000000b004c041723816sm703848edf.89.2023.03.02.05.07.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Mar 2023 05:07:08 -0800 (PST)
From:   Max Kellermann <max.kellermann@ionos.com>
To:     xiubli@redhat.com, idryomov@gmail.com, jlayton@kernel.org,
        ceph-devel@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Max Kellermann <max.kellermann@ionos.com>,
        stable@vger.kernel.org
Subject: [PATCH] fs/ceph/mds_client: ignore responses for waiting requests
Date:   Thu,  2 Mar 2023 14:06:50 +0100
Message-Id: <20230302130650.2209938-1-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If a request is put on the waiting list, its submission is postponed
until the session becomes ready (e.g. via `mdsc->waiting_for_map` or
`session->s_waiting`).  If a `CEPH_MSG_CLIENT_REPLY` happens to be
received before `CEPH_MSG_MDS_MAP`, the request gets freed, and then
this assertion fails:

 WARN_ON_ONCE(!list_empty(&req->r_wait));

This occurred on a server after the Ceph MDS connection failed, and a
corrupt reply packet was received for a waiting request:

 libceph: mds1 (1)10.0.0.10:6801 socket error on write
 libceph: mds1 (1)10.0.0.10:6801 session reset
 ceph: mds1 closed our session
 ceph: mds1 reconnect start
 ceph: mds1 reconnect success
 ceph: problem parsing mds trace -5
 ceph: mds parse_reply err -5
 ceph: mdsc_handle_reply got corrupt reply mds1(tid:5530222)
 [...]
 ------------[ cut here ]------------
 WARNING: CPU: 9 PID: 229180 at fs/ceph/mds_client.c:966 ceph_mdsc_release_request+0x17a/0x180
 Modules linked in:
 CPU: 9 PID: 229180 Comm: kworker/9:3 Not tainted 6.1.8-cm4all1 #45
 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-2 04/01/2014
 Workqueue: ceph-msgr ceph_con_workfn
 RIP: 0010:ceph_mdsc_release_request+0x17a/0x180
 Code: 39 d8 75 26 5b 48 89 ee 48 8b 3d f9 2d 04 02 5d e9 fb 01 c9 ff e8 56 85 ab ff eb 9c 48 8b 7f 58 e8 db 4d ff ff e9 a4 fe ff ff <0f> 0b eb d6 66 90 0f 1f 44 00 00 41 54 48 8d 86 b8 03 00 00 55 4c
 RSP: 0018:ffffa6f2c0e2bd20 EFLAGS: 00010287
 RAX: ffff8f58b93687f8 RBX: ffff8f592f6374a8 RCX: 0000000000000aed
 RDX: 0000000000000ac0 RSI: 0000000000000000 RDI: 0000000000000000
 RBP: ffff8f592f637148 R08: 0000000000000001 R09: ffffffffa901de00
 R10: 0000000000000001 R11: ffffd630ad09dfc8 R12: ffff8f58b9368000
 R13: ffff8f5806b33800 R14: ffff8f58894f6780 R15: 000000000054626e
 FS:  0000000000000000(0000) GS:ffff8f630f040000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 00007ffc2926df68 CR3: 0000000218dce002 CR4: 00000000001706e0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
 Call Trace:
  <TASK>
  mds_dispatch+0xec5/0x1460
  ? inet_recvmsg+0x4d/0xf0
  ceph_con_process_message+0x6b/0x80
  ceph_con_v1_try_read+0xb92/0x1400
  ceph_con_workfn+0x383/0x4e0
  process_one_work+0x1da/0x370
  ? process_one_work+0x370/0x370
  worker_thread+0x4d/0x3c0
  ? process_one_work+0x370/0x370
  kthread+0xbb/0xe0
  ? kthread_complete_and_exit+0x20/0x20
  ret_from_fork+0x22/0x30
  </TASK>
 ---[ end trace 0000000000000000 ]---
 ceph: mds1 caps renewed

If we know that a request has not yet been submitted, we should ignore
all responses for it, just like we ignore responses for unknown TIDs.

To: ceph-devel@vger.kernel.org
Cc: stable@vger.kernel.org
Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
---
 fs/ceph/mds_client.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 27a245d959c0..fa74fdb2cbfb 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -3275,6 +3275,13 @@ static void handle_reply(struct ceph_mds_session *session, struct ceph_msg *msg)
 	}
 	dout("handle_reply %p\n", req);
 
+	/* waiting, not yet submitted? */
+	if (!list_empty(&req->r_wait)) {
+		pr_err("mdsc_handle_reply on waiting request tid %llu\n", tid);
+		mutex_unlock(&mdsc->mutex);
+		goto out;
+	}
+
 	/* correct session? */
 	if (req->r_session != session) {
 		pr_err("mdsc_handle_reply got %llu on session mds%d"
-- 
2.39.2

