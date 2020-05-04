Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10F101C361F
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 11:50:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728549AbgEDJux (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 05:50:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:56808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728447AbgEDJux (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 May 2020 05:50:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 723BB2073E;
        Mon,  4 May 2020 09:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588585852;
        bh=Dvv+dLFULWPh9ijI/eO2mOpSKVzGlGeQPeHA3s9r7oI=;
        h=Subject:To:From:Date:From;
        b=gq5G0P2dEfwlAGnQ5bHPKKrxks1Ti/VJSyMlpQJ3s654i3RDLTAlTkyfmakfAq+u0
         EEri2tNGU/BydEEUXbfK0I0xLwOmAN1zvig5uQHTKP1Jc+6aMceC3ICgslmpd8V5xz
         5fK+5tj8SpsS29tNFN/nozG0XEhwqfp91qYB8+A4=
Subject: patch "vt: fix unicode console freeing with a common interface" added to tty-linus
To:     nico@fluxnic.net, gregkh@linuxfoundation.org, sam@ravnborg.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 04 May 2020 11:50:42 +0200
Message-ID: <1588585842159116@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    vt: fix unicode console freeing with a common interface

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 57d38f26d81e4275748b69372f31df545dcd9b71 Mon Sep 17 00:00:00 2001
From: Nicolas Pitre <nico@fluxnic.net>
Date: Sat, 2 May 2020 11:01:07 -0400
Subject: vt: fix unicode console freeing with a common interface

By directly using kfree() in different places we risk missing one if
it is switched to using vfree(), especially if the corresponding
vmalloc() is hidden away within a common abstraction.

Oh wait, that's exactly what happened here.

So let's fix this by creating a common abstraction for the free case
as well.

Signed-off-by: Nicolas Pitre <nico@fluxnic.net>
Reported-by: syzbot+0bfda3ade1ee9288a1be@syzkaller.appspotmail.com
Fixes: 9a98e7a80f95 ("vt: don't use kmalloc() for the unicode screen buffer")
Cc: <stable@vger.kernel.org>
Reviewed-by: Sam Ravnborg <sam@ravnborg.org>
Link: https://lore.kernel.org/r/nycvar.YSQ.7.76.2005021043110.2671@knanqh.ubzr
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/vt/vt.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index e5ffed795e4c..48a8199f7845 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -365,9 +365,14 @@ static struct uni_screen *vc_uniscr_alloc(unsigned int cols, unsigned int rows)
 	return uniscr;
 }
 
+static void vc_uniscr_free(struct uni_screen *uniscr)
+{
+	vfree(uniscr);
+}
+
 static void vc_uniscr_set(struct vc_data *vc, struct uni_screen *new_uniscr)
 {
-	vfree(vc->vc_uni_screen);
+	vc_uniscr_free(vc->vc_uni_screen);
 	vc->vc_uni_screen = new_uniscr;
 }
 
@@ -1230,7 +1235,7 @@ static int vc_do_resize(struct tty_struct *tty, struct vc_data *vc,
 	err = resize_screen(vc, new_cols, new_rows, user);
 	if (err) {
 		kfree(newscreen);
-		kfree(new_uniscr);
+		vc_uniscr_free(new_uniscr);
 		return err;
 	}
 
-- 
2.26.2


