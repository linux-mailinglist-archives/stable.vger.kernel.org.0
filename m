Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAD595F267
	for <lists+stable@lfdr.de>; Thu,  4 Jul 2019 07:52:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725920AbfGDFwH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Jul 2019 01:52:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:53924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725861AbfGDFwH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Jul 2019 01:52:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE20921882;
        Thu,  4 Jul 2019 05:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562219526;
        bh=TOmnPOZpcgJbwg/ToomrhKzlwkbdPfMdsZXh87fLq0U=;
        h=Subject:To:From:Date:From;
        b=Iro9WgLgany2dNqSHJdQOrlM4bYBvYOvBCYkvZCEwJB/R99XINwZ1Ru73khnMinXn
         Km5EIDMJR3gioHaw54o18VuKz01F1O34zAwbgdLpXlOKOp5kZMnB7WcToH62KbSK1Z
         DB/zQAdg8lhO39EqyKpFzDVQpT+IxHpGIw0uzS9Q=
Subject: patch "drivers/usb/typec/tps6598x.c: fix 4CC cmd write" added to usb-next
To:     nikolaus.voss@loewensteinmedical.de, gregkh@linuxfoundation.org,
        heikki.krogerus@linux.intel.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 04 Jul 2019 07:51:36 +0200
Message-ID: <15622194969433@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    drivers/usb/typec/tps6598x.c: fix 4CC cmd write

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From 2681795b5e7a5bf336537661010072f4c22cea31 Mon Sep 17 00:00:00 2001
From: Nikolaus Voss <nikolaus.voss@loewensteinmedical.de>
Date: Fri, 28 Jun 2019 11:01:09 +0200
Subject: drivers/usb/typec/tps6598x.c: fix 4CC cmd write

Writing 4CC commands with tps6598x_write_4cc() already has
a pointer arg, don't reference it when using as arg to
tps6598x_block_write(). Correcting this enforces the constness
of the pointer to propagate to tps6598x_block_write(), so add
the const qualifier there to avoid the warning.

Fixes: 0a4c005bd171 ("usb: typec: driver for TI TPS6598x USB Power Delivery controllers")
Signed-off-by: Nikolaus Voss <nikolaus.voss@loewensteinmedical.de>
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tps6598x.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/typec/tps6598x.c b/drivers/usb/typec/tps6598x.c
index a170c49c2542..a38d1409f15b 100644
--- a/drivers/usb/typec/tps6598x.c
+++ b/drivers/usb/typec/tps6598x.c
@@ -127,7 +127,7 @@ tps6598x_block_read(struct tps6598x *tps, u8 reg, void *val, size_t len)
 }
 
 static int tps6598x_block_write(struct tps6598x *tps, u8 reg,
-				void *val, size_t len)
+				const void *val, size_t len)
 {
 	u8 data[TPS_MAX_LEN + 1];
 
@@ -173,7 +173,7 @@ static inline int tps6598x_write64(struct tps6598x *tps, u8 reg, u64 val)
 static inline int
 tps6598x_write_4cc(struct tps6598x *tps, u8 reg, const char *val)
 {
-	return tps6598x_block_write(tps, reg, &val, sizeof(u32));
+	return tps6598x_block_write(tps, reg, val, 4);
 }
 
 static int tps6598x_read_partner_identity(struct tps6598x *tps)
-- 
2.22.0


