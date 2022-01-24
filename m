Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6373498A58
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:02:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345086AbiAXTCl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:02:41 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:57424 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345389AbiAXTAN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:00:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B2149B81236;
        Mon, 24 Jan 2022 19:00:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1A98C340E5;
        Mon, 24 Jan 2022 19:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643050810;
        bh=46ZQ2Ukvtqdel2YKeI9Beyu+coFEEPVZxoQUk1YKJUY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lEDO1P8+vcdWgtmZiCU/NEiRmyQeTHlH0/JWJIlshPpaPnAy9ngSa7UQxbQPLZ/tN
         kOXpsYn4Gs3iNfC1oF+cTo4QELWxZuBz51dR2dNjt0H4HdE7cF+BdBKyJ4PjEiQnDW
         c4dnwuM0gT3IMqgM/f2tfNyWYNTxnX4h8JWBKbr4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Keeping <john@metanate.com>,
        Pavankumar Kondeti <quic_pkondeti@quicinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 076/157] usb: gadget: f_fs: Use stream_open() for endpoint files
Date:   Mon, 24 Jan 2022 19:42:46 +0100
Message-Id: <20220124183935.198233579@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183932.787526760@linuxfoundation.org>
References: <20220124183932.787526760@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 0336392686935..e4826454de1a7 100644
--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -608,7 +608,7 @@ static int ffs_ep0_open(struct inode *inode, struct file *file)
 	file->private_data = ffs;
 	ffs_data_opened(ffs);
 
-	return 0;
+	return stream_open(inode, file);
 }
 
 static int ffs_ep0_release(struct inode *inode, struct file *file)
@@ -1071,7 +1071,7 @@ ffs_epfile_open(struct inode *inode, struct file *file)
 	file->private_data = epfile;
 	ffs_data_opened(epfile->ffs);
 
-	return 0;
+	return stream_open(inode, file);
 }
 
 static int ffs_aio_cancel(struct kiocb *kiocb)
-- 
2.34.1



