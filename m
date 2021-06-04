Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAF2F39B825
	for <lists+stable@lfdr.de>; Fri,  4 Jun 2021 13:41:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229682AbhFDLmr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Jun 2021 07:42:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:38718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230187AbhFDLmr (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Jun 2021 07:42:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DA94A61423;
        Fri,  4 Jun 2021 11:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622806861;
        bh=a9kv/1hPfpTeSlZCnqiDyIamjlylenZup0gxllInFGU=;
        h=Subject:To:From:Date:From;
        b=DbIp6KQSgSSL7/nGwZE+DwMdrjtYV1HOlcu5x9NiiTGDsfSEma9uKAFeQeD4O3+Xa
         uYR3lCKL47JiLBwdF5c+VKtYKNxxlP2Boyd8VUlxJPXYsVqLj5+4Cn2Eq24iA2Rnr/
         5ERp6NLIaGdCVc4IGgDe+f3Scm9kTp3JvP6soXHM=
Subject: patch "usb: gadget: f_fs: Ensure io_completion_wq is idle during unbind" added to usb-linus
To:     wcheng@codeaurora.org, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 04 Jun 2021 13:40:59 +0200
Message-ID: <1622806859122149@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: gadget: f_fs: Ensure io_completion_wq is idle during unbind

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 6fc1db5e6211e30fbb1cee8d7925d79d4ed2ae14 Mon Sep 17 00:00:00 2001
From: Wesley Cheng <wcheng@codeaurora.org>
Date: Fri, 21 May 2021 17:44:21 -0700
Subject: usb: gadget: f_fs: Ensure io_completion_wq is idle during unbind

During unbind, ffs_func_eps_disable() will be executed, resulting in
completion callbacks for any pending USB requests.  When using AIO,
irrespective of the completion status, io_data work is queued to
io_completion_wq to evaluate and handle the completed requests.  Since
work runs asynchronously to the unbind() routine, there can be a
scenario where the work runs after the USB gadget has been fully
removed, resulting in accessing of a resource which has been already
freed. (i.e. usb_ep_free_request() accessing the USB ep structure)

Explicitly drain the io_completion_wq, instead of relying on the
destroy_workqueue() (in ffs_data_put()) to make sure no pending
completion work items are running.

Signed-off-by: Wesley Cheng <wcheng@codeaurora.org>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/1621644261-1236-1-git-send-email-wcheng@codeaurora.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_fs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
index bf109191659a..d4844afeaffc 100644
--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -3567,6 +3567,9 @@ static void ffs_func_unbind(struct usb_configuration *c,
 		ffs->func = NULL;
 	}
 
+	/* Drain any pending AIO completions */
+	drain_workqueue(ffs->io_completion_wq);
+
 	if (!--opts->refcnt)
 		functionfs_unbind(ffs);
 
-- 
2.31.1


