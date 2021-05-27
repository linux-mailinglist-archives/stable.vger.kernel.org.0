Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEC15392F50
	for <lists+stable@lfdr.de>; Thu, 27 May 2021 15:17:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236115AbhE0NTK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 May 2021 09:19:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:39600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236405AbhE0NTI (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 May 2021 09:19:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F2CD0610FC;
        Thu, 27 May 2021 13:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622121454;
        bh=cihUyPjDvhM0gn1T9nom34m/rWP3xvq7afy4b2MM0e0=;
        h=Subject:To:From:Date:From;
        b=GPjsD9RDe5VZYBXQyt/luFWFNCycFELmUYhQpKLRSFR1ADTioU0fZQa3pLsi0jTwr
         CLTsk+l9PAS2xvz6zhC29HzKl0LveMJWPCpPz0B+ylzcyAhSFxDMHFxn8enGGDFW2E
         UZ9iqp7R+A2XAQ9QieChidm3YM/5MYwIx7/P8z9o=
Subject: patch "mei: request autosuspend after sending rx flow control" added to char-misc-linus
To:     alexander.usyskin@intel.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, tomas.winkler@intel.com
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 27 May 2021 15:17:32 +0200
Message-ID: <162212145259137@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    mei: request autosuspend after sending rx flow control

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From bbf0a94744edfeee298e4a9ab6fd694d639a5cdf Mon Sep 17 00:00:00 2001
From: Alexander Usyskin <alexander.usyskin@intel.com>
Date: Wed, 26 May 2021 22:33:34 +0300
Subject: mei: request autosuspend after sending rx flow control

A rx flow control waiting in the control queue may block autosuspend.
Re-request autosuspend after flow control been sent to unblock
the transition to the low power state.

Cc: <stable@vger.kernel.org>
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Link: https://lore.kernel.org/r/20210526193334.445759-1-tomas.winkler@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/mei/interrupt.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/misc/mei/interrupt.c b/drivers/misc/mei/interrupt.c
index a98f6b895af7..aab3ebfa9fc4 100644
--- a/drivers/misc/mei/interrupt.c
+++ b/drivers/misc/mei/interrupt.c
@@ -277,6 +277,9 @@ static int mei_cl_irq_read(struct mei_cl *cl, struct mei_cl_cb *cb,
 		return ret;
 	}
 
+	pm_runtime_mark_last_busy(dev->dev);
+	pm_request_autosuspend(dev->dev);
+
 	list_move_tail(&cb->list, &cl->rd_pending);
 
 	return 0;
-- 
2.31.1


