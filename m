Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32AC5303C82
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 13:07:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392343AbhAZMHU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 07:07:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392337AbhAZLW4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Jan 2021 06:22:56 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C842C061788
        for <stable@vger.kernel.org>; Tue, 26 Jan 2021 03:21:05 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id w1so22361302ejf.11
        for <stable@vger.kernel.org>; Tue, 26 Jan 2021 03:21:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zY7eyzui5lrsV2Pla8jrRefVhNic/1zSoUc/C9YVCgo=;
        b=H0ynR2cTeva2XzhMbn0gwM2WFfwJKAoWgrfEWVdjSBRNZqWtqgx8C0iVi0a4U1eC3t
         FAoTK/UJbWtzPEGofVExhqAFzB28vjg3vriGoWyf2bqe38b3EEKwnkW7nFZpiJbOsoxj
         /HwcxaXcG1IxqSZkkL4VPs5eLhd1Cp0Wv4CAE40z/p1iUxZ2O4L9lZyGs7+t5RB/RcYA
         aTeMLU/S0xG0a7OV5OuNIfjTIvMJz2hU6ht93HB01yWvzRkW7IAFQ2kDAT0wgW2d6ZeX
         9i2I6IWynR5evunlMfCoKAC7xmUFPKuwAZv4D5Y/fPuveVcAqf+EoCOStALHfKEE3teN
         jqMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zY7eyzui5lrsV2Pla8jrRefVhNic/1zSoUc/C9YVCgo=;
        b=DMuPGDi9sWmgepcu+cly8jYmEMerIbABy9wUdk9wNqkuS6QoOxAPMpaeQtC+Wum+bc
         7p6LNdypr+KsN+GyrwPLC5BlyDROH6226D+VPcFCqXixu2SAWqK6bftMYmQrPRDucAtV
         Rs31/1fNuTAEUIrcsk8KcC/JVkL97wZAKqVBhEE792PiTsQQt/3RcdfEPZQtUhnPe3Rf
         dgPDpti+vcu79WEhpC9muhEriPnJDJ54nXypapwuiNJBUCS/pjlz/771cB+1JSqsL7iU
         RjswVqcEcrGKvN1fAbNNRmigCE3Kkr/vUzFzsbtUvLbHvt/1ROQrNoS74xoDeRf6AU5y
         OW2Q==
X-Gm-Message-State: AOAM530cH+x4jyktMfzAgXYbpQudZM4PpihsAb1GA9aT+gjT3dy8KtAW
        PwuHE/rc5/TQwiaO8nEvmVF1h6QWnBH0XQ==
X-Google-Smtp-Source: ABdhPJymDFUozw5ybFdh9uTrQRXEHZKRzbxc9RhmlAKCDBt4A2x3uyT/gwIp1iIkMq77Um3LiclkxA==
X-Received: by 2002:a17:906:1a0c:: with SMTP id i12mr3262512ejf.325.1611660064020;
        Tue, 26 Jan 2021 03:21:04 -0800 (PST)
Received: from localhost.localdomain ([148.252.129.161])
        by smtp.gmail.com with ESMTPSA id o17sm12167128edr.17.2021.01.26.03.21.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jan 2021 03:21:03 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        syzbot+9c9c35374c0ecac06516@syzkaller.appspotmail.com
Subject: [PATCH stable 06/11] io_uring: do sqo disable on install_fd error
Date:   Tue, 26 Jan 2021 11:17:05 +0000
Message-Id: <bdc76b5d2e1bd58d4deb9ad1011e86f5a2689dfb.1611659564.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1611659564.git.asml.silence@gmail.com>
References: <cover.1611659564.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 06585c497b55045ec21aa8128e340f6a6587351c ]

WARNING: CPU: 0 PID: 8494 at fs/io_uring.c:8717
	io_ring_ctx_wait_and_kill+0x4f2/0x600 fs/io_uring.c:8717
Call Trace:
 io_uring_release+0x3e/0x50 fs/io_uring.c:8759
 __fput+0x283/0x920 fs/file_table.c:280
 task_work_run+0xdd/0x190 kernel/task_work.c:140
 tracehook_notify_resume include/linux/tracehook.h:189 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:174 [inline]
 exit_to_user_mode_prepare+0x249/0x250 kernel/entry/common.c:201
 __syscall_exit_to_user_mode_work kernel/entry/common.c:291 [inline]
 syscall_exit_to_user_mode+0x19/0x50 kernel/entry/common.c:302
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

failed io_uring_install_fd() is a special case, we don't do
io_ring_ctx_wait_and_kill() directly but defer it to fput, though still
need to io_disable_sqo_submit() before.

note: it doesn't fix any real problem, just a warning. That's because
sqring won't be available to the userspace in this case and so SQPOLL
won't submit anything.

Cc: stable@vger.kernel.org # 5.5+
Reported-by: syzbot+9c9c35374c0ecac06516@syzkaller.appspotmail.com
Fixes: d9d05217cb69 ("io_uring: stop SQPOLL submit on creator's death")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index f1f1de815755..2acea64656f3 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -9501,6 +9501,7 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p,
 	 */
 	ret = io_uring_install_fd(ctx, file);
 	if (ret < 0) {
+		io_disable_sqo_submit(ctx);
 		/* fput will clean it up */
 		fput(file);
 		return ret;
-- 
2.24.0

