Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E3F5491499
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:23:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245202AbiARCXS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:23:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244767AbiARCVd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:21:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A093DC06175E;
        Mon, 17 Jan 2022 18:21:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 28120612CD;
        Tue, 18 Jan 2022 02:21:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F219BC36AEF;
        Tue, 18 Jan 2022 02:21:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642472492;
        bh=/8vqTdehX2rFsIR81hlKJ31cDN856d4O4/Em5efcq6Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eXHZOYRGB5I/f92r8KVs7lNZYJxG6yjZCUxJDRPqsTcpteXZGnAAhKh64EkNAQaQg
         kc1Q28rtNrSokCmih1XGfWoZdNV1BxOTpJD52ok1ECYxty2/McEXsJVjL2KKfM/JqE
         +nMItY0j8/MSGzBeKv+UvlyqCiPqkNexZzshkV2mh92qw8VS0micMx4yiDwCeugSda
         V4JSc6XJLiPUbxfcqWZR+T8b6lsHHfZ1JYkuXIx4tOzlZcvLu/P/3VK6PWAZUB828V
         6KhoGtzi8jhW2DwTeCq1cu/BbLGIOyz5yKF+8UzVKytCioK+F+mmTHge9l3nbe1LIM
         T87aSp2r5AYZA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pavankumar Kondeti <quic_pkondeti@quicinc.com>,
        John Keeping <john@metanate.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, balbi@kernel.org,
        axboe@kernel.dk, wcheng@codeaurora.org, djwong@kernel.org,
        dean@sensoray.com, andrew_gabbasov@mentor.com,
        salah.triki@gmail.com, plr.vincent@gmail.com, lkp@intel.com,
        linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 031/217] usb: gadget: f_fs: Use stream_open() for endpoint files
Date:   Mon, 17 Jan 2022 21:16:34 -0500
Message-Id: <20220118021940.1942199-31-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118021940.1942199-1-sashal@kernel.org>
References: <20220118021940.1942199-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavankumar Kondeti <quic_pkondeti@quicinc.com>

[ Upstream commit c76ef96fc00eb398c8fc836b0eb2f82bcc619dc7 ]

Function fs endpoint file operations are synchronized via an interruptible
mutex wait. However we see threads that do ep file operations concurrently
are getting blocked for the mutex lock in __fdget_pos(). This is an
uninterruptible wait and we see hung task warnings and kernel panic
if hung_task_panic systcl is enabled if host does not send/receive
the data for long time.

The reason for threads getting blocked in __fdget_pos() is due to
the file position protection introduced by the commit 9c225f2655e3
("vfs: atomic f_pos accesses as per POSIX"). Since function fs
endpoint files does not have the notion of the file position, switch
to the stream mode. This will bypass the file position mutex and
threads will be blocked in interruptible state for the function fs
mutex.

It should not affects user space as we are only changing the task state
changes the task state from UNINTERRUPTIBLE to INTERRUPTIBLE while waiting
for the USB transfers to be finished. However there is a slight change to
the O_NONBLOCK behavior. Earlier threads that are using O_NONBLOCK are also
getting blocked inside fdget_pos(). Now they reach to function fs and error
code is returned. The non blocking behavior is actually honoured now.

Reviewed-by: John Keeping <john@metanate.com>
Signed-off-by: Pavankumar Kondeti <quic_pkondeti@quicinc.com>
Link: https://lore.kernel.org/r/1636712682-1226-1-git-send-email-quic_pkondeti@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/function/f_fs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
index a7e069b185448..25ad1e97a4585 100644
--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -614,7 +614,7 @@ static int ffs_ep0_open(struct inode *inode, struct file *file)
 	file->private_data = ffs;
 	ffs_data_opened(ffs);
 
-	return 0;
+	return stream_open(inode, file);
 }
 
 static int ffs_ep0_release(struct inode *inode, struct file *file)
@@ -1154,7 +1154,7 @@ ffs_epfile_open(struct inode *inode, struct file *file)
 	file->private_data = epfile;
 	ffs_data_opened(epfile->ffs);
 
-	return 0;
+	return stream_open(inode, file);
 }
 
 static int ffs_aio_cancel(struct kiocb *kiocb)
-- 
2.34.1

