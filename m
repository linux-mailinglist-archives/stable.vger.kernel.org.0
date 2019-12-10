Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C807118618
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 12:21:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727116AbfLJLVf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 06:21:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:49894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726915AbfLJLVf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 06:21:35 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F1D8320663;
        Tue, 10 Dec 2019 11:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575976894;
        bh=S+PsjiWzDoa6HtgE6GZNOi1QdCSFS+pAXF/QOM6Ir54=;
        h=Subject:To:From:Date:From;
        b=K3vt3ZFgxklTe7irt77LQ5yBCexJmeltXQXmzMlNvdLxyJgn671pl+Vb2vVvzLvBB
         63f1g1wTT2DsemzzaWqjT3ztXJZBNBRWkLFEml7LgxkRlcgCxQH1EOaV+YuwcOPTDs
         MfX7TJE8ugU3+/Yh4haSd7xxLtPzmS8pDdPpjqVk=
Subject: patch "usb: core: urb: fix URB structure initialization function" added to usb-linus
To:     ingrassia@epigenesys.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 10 Dec 2019 12:21:21 +0100
Message-ID: <15759768811792@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: core: urb: fix URB structure initialization function

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 1cd17f7f0def31e3695501c4f86cd3faf8489840 Mon Sep 17 00:00:00 2001
From: Emiliano Ingrassia <ingrassia@epigenesys.com>
Date: Wed, 27 Nov 2019 17:03:55 +0100
Subject: usb: core: urb: fix URB structure initialization function

Explicitly initialize URB structure urb_list field in usb_init_urb().
This field can be potentially accessed uninitialized and its
initialization is coherent with the usage of list_del_init() in
usb_hcd_unlink_urb_from_ep() and usb_giveback_urb_bh() and its
explicit initialization in usb_hcd_submit_urb() error path.

Signed-off-by: Emiliano Ingrassia <ingrassia@epigenesys.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20191127160355.GA27196@ingrassia.epigenesys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/urb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/core/urb.c b/drivers/usb/core/urb.c
index 0eab79f82ce4..da923ec17612 100644
--- a/drivers/usb/core/urb.c
+++ b/drivers/usb/core/urb.c
@@ -45,6 +45,7 @@ void usb_init_urb(struct urb *urb)
 	if (urb) {
 		memset(urb, 0, sizeof(*urb));
 		kref_init(&urb->kref);
+		INIT_LIST_HEAD(&urb->urb_list);
 		INIT_LIST_HEAD(&urb->anchor_list);
 	}
 }
-- 
2.24.0


