Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 033523D0C14
	for <lists+stable@lfdr.de>; Wed, 21 Jul 2021 12:13:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237641AbhGUJH7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Jul 2021 05:07:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:38228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237981AbhGUI7j (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 21 Jul 2021 04:59:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7107261181;
        Wed, 21 Jul 2021 09:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626860416;
        bh=ZqqbsjvqFIVeV1TmXwniSEiaANw5jxKW1CUK9APF4+U=;
        h=Subject:To:From:Date:From;
        b=Yd6iZkJjiZpMHKD663We/WG3DfGsuN6Uyb95QUqPNsY4l/QIBCGR5yU1oK4iSZqcG
         nYjj1GDMLVspi9swJqAp80ClUv7gQyEQO/7dZoE4YZEypd+OrTcPIFeQ0kX2BSY8sz
         rVjbzGKkvh305GrcIBmKzdk6K45kfO0B414alOPo=
Subject: patch "staging: rtl8723bs: Fix a resource leak in sd_int_dpc" added to staging-linus
To:     xyz.sun.ok@gmail.com, gregkh@linuxfoundation.org,
        hdegoede@redhat.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 21 Jul 2021 11:40:13 +0200
Message-ID: <1626860413105240@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    staging: rtl8723bs: Fix a resource leak in sd_int_dpc

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 990e4ad3ddcb72216caeddd6e62c5f45a21e8121 Mon Sep 17 00:00:00 2001
From: Xiangyang Zhang <xyz.sun.ok@gmail.com>
Date: Mon, 28 Jun 2021 23:22:39 +0800
Subject: staging: rtl8723bs: Fix a resource leak in sd_int_dpc

The "c2h_evt" variable is not freed when function call
"c2h_evt_read_88xx" failed

Fixes: 554c0a3abf21 ("staging: Add rtl8723bs sdio wifi driver")
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Xiangyang Zhang <xyz.sun.ok@gmail.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210628152239.5475-1-xyz.sun.ok@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/rtl8723bs/hal/sdio_ops.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/rtl8723bs/hal/sdio_ops.c b/drivers/staging/rtl8723bs/hal/sdio_ops.c
index 2dd251ce177e..a545832a468e 100644
--- a/drivers/staging/rtl8723bs/hal/sdio_ops.c
+++ b/drivers/staging/rtl8723bs/hal/sdio_ops.c
@@ -909,6 +909,8 @@ void sd_int_dpc(struct adapter *adapter)
 				} else {
 					rtw_c2h_wk_cmd(adapter, (u8 *)c2h_evt);
 				}
+			} else {
+				kfree(c2h_evt);
 			}
 		} else {
 			/* Error handling for malloc fail */
-- 
2.32.0


