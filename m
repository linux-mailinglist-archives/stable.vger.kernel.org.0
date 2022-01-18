Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BBAB4916CE
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:36:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344448AbiARCgd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:36:33 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:44344 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244972AbiARCd1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:33:27 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2FF43B81243;
        Tue, 18 Jan 2022 02:33:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7079EC36AE3;
        Tue, 18 Jan 2022 02:33:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473205;
        bh=PIlHMzSJcbtlID3nr+KRYnPjFbUreuFKXZbjpwgQed0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sM/171nS2L14Zjz9vDewLyY/ouIs1NYXDm2zhxQKe8wgeC9T2dLtoAoN/4LsWjZ2L
         FpMja+kcELLVS2jlB+mHr3gOgGOQET7GfvgB3UeF0WacvU2J74N1dMkeOsrMDkmdo2
         HL8Bj8G8A0vV/lrtFqY5GbS0aDwLm60OKf5Q2zevQ4K76bFa6JSQf40JqgC0VgaV/z
         X63Xd474pjENd1cLbBlzSNPJCw+9NzpcBTNjpuk42r7o47vN9AzxaCdqt48Lh8ymMD
         VQbA7/jh+Di4861NHyZfqLoo8ocmYZuquIS6dJb9y82CGJC3jXQWl/F2NmbnCABUZZ
         hGEqCfLHnc2pg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pavankumar Kondeti <quic_pkondeti@quicinc.com>,
        John Keeping <john@metanate.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, balbi@kernel.org,
        axboe@kernel.dk, andrew_gabbasov@mentor.com, djwong@kernel.org,
        dean@sensoray.com, salah.triki@gmail.com, wcheng@codeaurora.org,
        plr.vincent@gmail.com, lkp@intel.com, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 025/188] usb: gadget: f_fs: Use stream_open() for endpoint files
Date:   Mon, 17 Jan 2022 21:29:09 -0500
Message-Id: <20220118023152.1948105-25-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118023152.1948105-1-sashal@kernel.org>
References: <20220118023152.1948105-1-sashal@kernel.org>
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
index aac343f7d7d3d..782d67c2c6e0d 100644
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

