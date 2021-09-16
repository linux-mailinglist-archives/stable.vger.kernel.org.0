Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E378140DD3B
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 16:51:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238812AbhIPOxF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 10:53:05 -0400
Received: from smtp67.ord1d.emailsrvr.com ([184.106.54.67]:60182 "EHLO
        smtp67.ord1d.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236188AbhIPOxF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Sep 2021 10:53:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mev.co.uk;
        s=20190130-41we5z8j; t=1631803531;
        bh=wntXMQVPfNAlvsw/B4mAyFrI8LJDb845y3vVM0u8iFg=;
        h=From:To:Subject:Date:From;
        b=MircA7Fey+K8tQNrdz3EtKb91UFYLZjNHJnovfprFiX2tmEkmua6dgSddXhPPue6f
         vdGp83GClC8iKtg8+RiQ+9ddTnAYsnZOSw+Qtj2Q5+sWU1xTSfhWcgfelQCngijfVL
         KTvL5ay0J+pAwGN2qUGx3idLNJzyoAaTl6nA57HQ=
X-Auth-ID: abbotti@mev.co.uk
Received: by smtp17.relay.ord1d.emailsrvr.com (Authenticated sender: abbotti-AT-mev.co.uk) with ESMTPSA id 482D7201F5;
        Thu, 16 Sep 2021 10:45:30 -0400 (EDT)
From:   Ian Abbott <abbotti@mev.co.uk>
To:     linux-kernel@vger.kernel.org
Cc:     Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Greg Kroah-Hartman <greglh@linuxfoundation.org>,
        linux-staging@lists.linux.dev, stable@vger.kernel.org
Subject: [PATCH] comedi: Fix memory leak in compat_insnlist()
Date:   Thu, 16 Sep 2021 15:44:38 +0100
Message-Id: <20210916144438.156858-1-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Classification-ID: 712c3295-ddca-4044-8232-b0e932842c75-1-1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

`compat_insnlist()` handles the 32-bit version of the `COMEDI_INSNLIST`
ioctl (whenwhen `CONFIG_COMPAT` is enabled).  It allocates memory to
temporarily hold an array of `struct comedi_insn` converted from the
32-bit version in user space.  This memory is only being freed if there
is a fault while filling the array, otherwise it is leaked.

Add a call to `kfree()` to fix the leak.

Fixes: b8d47d881305 ("comedi: get rid of compat_alloc_user_space() mess in COMEDI_INSNLIST compat"
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Greg Kroah-Hartman <greglh@linuxfoundation.org>
Cc: linux-staging@lists.linux.dev
Cc: <stable@vger.kernel.org> # 5.13+
Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
N.B. Also need patches for 5.8+ from before comedi moved out of staging.
---
 drivers/comedi/comedi_fops.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/comedi/comedi_fops.c b/drivers/comedi/comedi_fops.c
index df77b6bf5c64..763cea8418f8 100644
--- a/drivers/comedi/comedi_fops.c
+++ b/drivers/comedi/comedi_fops.c
@@ -3090,6 +3090,7 @@ static int compat_insnlist(struct file *file, unsigned long arg)
 	mutex_lock(&dev->mutex);
 	rc = do_insnlist_ioctl(dev, insns, insnlist32.n_insns, file);
 	mutex_unlock(&dev->mutex);
+	kfree(insns);
 	return rc;
 }
 
-- 
2.33.0

