Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82F0758EE07
	for <lists+stable@lfdr.de>; Wed, 10 Aug 2022 16:16:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231135AbiHJOQE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Aug 2022 10:16:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232260AbiHJOQD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Aug 2022 10:16:03 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BE835FAFE;
        Wed, 10 Aug 2022 07:16:02 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id l22so17922160wrz.7;
        Wed, 10 Aug 2022 07:16:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=j7Qb4aUyvVNFaR2MvIyBKGEChv9dWRFrx3II0DQKzX4=;
        b=WXgkltJ84ZiIApjSZWpKWeqnabW6ZdRO33gtor9uKAFBZ0hMOsts4MW/vijoIxU+V5
         pWsvF2Oeb9IMMz1C39R9Sykpxx6l3NyQk9fQDIO5n4XsZ42XR4PcGT5svqjxM6bakcCg
         WL7MLZoxP6GlUpEkn1NogrjJ6svFykWXEQ/dxegXFBD8Kcho7I3PsCSyfxIHqIihBd8i
         CeQtI/NQRE7WYNMYJ8qlkjygw2Ic+0boWrB1LoLIueGAffoMdXik03W/KEnufn9feeb4
         jE7UQ7iKeqqDt6UtoHcrG2dE+n/oQgZ1ilR302/5QKRLaOiqHkBqSPlHPzE+HuyElI/c
         incQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=j7Qb4aUyvVNFaR2MvIyBKGEChv9dWRFrx3II0DQKzX4=;
        b=OwngOzbjAlabsEAvzmYoVMpa9SdDVFegJFiFtHetC4pezA2P65eesa5Bykycc81A1u
         2GKBpiXrvCOQZc0EoYB8bDnNyGaDfUglc8JNq+tK+/JiwP09VbHesziklIJ6byoHFc6g
         JQBrswmA0jZnnUf2HMo1+RRSvwA2rCXfYXd0DW1oN5pJiAlOs4oQip9XiIRBohpRpI9C
         7O9H94bHmzoPuw5RsaYqCGZsNzP5gVlkq/JW1WNFV5YAh3cmAkHxCV5ZuBBzi8VpTKC3
         Bjg5ILJYZjxwz67utQLZ+W3/4WEbbIPRGBdgasPgMUFHBnWYvVH+EMfROu9DNipj/xiX
         Xz2w==
X-Gm-Message-State: ACgBeo2i1eufXh05r1jYqGylXGSi5+gqDxYRgWL1gJB4GX0D79A5QxcN
        JAeoLpcaQ7QrJvphRp6pnMk=
X-Google-Smtp-Source: AA6agR63R4iyVX/3VIdMiAxoCixCERtFzZ0LbCNPzFZDWi9p1bPOR7gT60ey2KaQ7M4bpGy9DkFDQQ==
X-Received: by 2002:a05:6000:2cb:b0:21e:d9ce:fd76 with SMTP id o11-20020a05600002cb00b0021ed9cefd76mr17980457wry.482.1660140961509;
        Wed, 10 Aug 2022 07:16:01 -0700 (PDT)
Received: from localhost.localdomain ([77.137.66.49])
        by smtp.gmail.com with ESMTPSA id x13-20020adfdccd000000b0021d65675583sm16902969wrm.52.2022.08.10.07.15.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Aug 2022 07:16:01 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Manzanares <a.manzanares@samsung.com>,
        linux-xfs@vger.kernel.org, stable@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        Chandan Babu R <chandanrlinux@gmail.com>
Subject: [PATCH 5.10 v2 2/3] xfs: only set IOMAP_F_SHARED when providing a srcmap to a write
Date:   Wed, 10 Aug 2022 16:15:51 +0200
Message-Id: <20220810141552.168763-3-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220810141552.168763-1-amir73il@gmail.com>
References: <20220810141552.168763-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

commit 72a048c1056a72e37ea2ee34cc73d8c6d6cb4290 upstream.

While prototyping a free space defragmentation tool, I observed an
unexpected IO error while running a sequence of commands that can be
recreated by the following sequence of commands:

$ xfs_io -f -c "pwrite -S 0x58 -b 10m 0 10m" file1
$ cp --reflink=always file1 file2
$ punch-alternating -o 1 file2
$ xfs_io -c "funshare 0 10m" file2
fallocate: Input/output error

I then scraped this (abbreviated) stack trace from dmesg:

WARNING: CPU: 0 PID: 30788 at fs/iomap/buffered-io.c:577 iomap_write_begin+0x376/0x450
CPU: 0 PID: 30788 Comm: xfs_io Not tainted 5.14.0-rc6-xfsx #rc6 5ef57b62a900814b3e4d885c755e9014541c8732
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.13.0-1ubuntu1.1 04/01/2014
RIP: 0010:iomap_write_begin+0x376/0x450
RSP: 0018:ffffc90000c0fc20 EFLAGS: 00010297
RAX: 0000000000000001 RBX: ffffc90000c0fd10 RCX: 0000000000001000
RDX: ffffc90000c0fc54 RSI: 000000000000000c RDI: 000000000000000c
RBP: ffff888005d5dbd8 R08: 0000000000102000 R09: ffffc90000c0fc50
R10: 0000000000b00000 R11: 0000000000101000 R12: ffffea0000336c40
R13: 0000000000001000 R14: ffffc90000c0fd10 R15: 0000000000101000
FS:  00007f4b8f62fe40(0000) GS:ffff88803ec00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000056361c554108 CR3: 000000000524e004 CR4: 00000000001706f0
Call Trace:
 iomap_unshare_actor+0x95/0x140
 iomap_apply+0xfa/0x300
 iomap_file_unshare+0x44/0x60
 xfs_reflink_unshare+0x50/0x140 [xfs 61947ea9b3a73e79d747dbc1b90205e7987e4195]
 xfs_file_fallocate+0x27c/0x610 [xfs 61947ea9b3a73e79d747dbc1b90205e7987e4195]
 vfs_fallocate+0x133/0x330
 __x64_sys_fallocate+0x3e/0x70
 do_syscall_64+0x35/0x80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f4b8f79140a

Looking at the iomap tracepoints, I saw this:

iomap_iter:           dev 8:64 ino 0x100 pos 0 length 0 flags WRITE|0x80 (0x81) ops xfs_buffered_write_iomap_ops caller iomap_file_unshare
iomap_iter_dstmap:    dev 8:64 ino 0x100 bdev 8:64 addr -1 offset 0 length 131072 type DELALLOC flags SHARED
iomap_iter_srcmap:    dev 8:64 ino 0x100 bdev 8:64 addr 147456 offset 0 length 4096 type MAPPED flags
iomap_iter:           dev 8:64 ino 0x100 pos 0 length 4096 flags WRITE|0x80 (0x81) ops xfs_buffered_write_iomap_ops caller iomap_file_unshare
iomap_iter_dstmap:    dev 8:64 ino 0x100 bdev 8:64 addr -1 offset 4096 length 4096 type DELALLOC flags SHARED
console:              WARNING: CPU: 0 PID: 30788 at fs/iomap/buffered-io.c:577 iomap_write_begin+0x376/0x450

The first time funshare calls ->iomap_begin, xfs sees that the first
block is shared and creates a 128k delalloc reservation in the COW fork.
The delalloc reservation is returned as dstmap, and the shared block is
returned as srcmap.  So far so good.

funshare calls ->iomap_begin to try the second block.  This time there's
no srcmap (punch-alternating punched it out!) but we still have the
delalloc reservation in the COW fork.  Therefore, we again return the
reservation as dstmap and the hole as srcmap.  iomap_unshare_iter
incorrectly tries to unshare the hole, which __iomap_write_begin rejects
because shared regions must be fully written and therefore cannot
require zeroing.

Therefore, change the buffered write iomap_begin function not to set
IOMAP_F_SHARED when there isn't a source mapping to read from for the
unsharing.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_iomap.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 74bc2beadc23..bd5a25f4952d 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1062,11 +1062,11 @@ xfs_buffered_write_iomap_begin(
 		error = xfs_bmbt_to_iomap(ip, srcmap, &imap, 0);
 		if (error)
 			return error;
-	} else {
-		xfs_trim_extent(&cmap, offset_fsb,
-				imap.br_startoff - offset_fsb);
+		return xfs_bmbt_to_iomap(ip, iomap, &cmap, IOMAP_F_SHARED);
 	}
-	return xfs_bmbt_to_iomap(ip, iomap, &cmap, IOMAP_F_SHARED);
+
+	xfs_trim_extent(&cmap, offset_fsb, imap.br_startoff - offset_fsb);
+	return xfs_bmbt_to_iomap(ip, iomap, &cmap, 0);
 
 out_unlock:
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
-- 
2.25.1

