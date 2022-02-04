Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AAFC4A9B14
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 15:36:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344460AbiBDOg2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 09:36:28 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:40898 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233084AbiBDOg2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Feb 2022 09:36:28 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EDF1260FC8
        for <stable@vger.kernel.org>; Fri,  4 Feb 2022 14:36:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF86BC004E1;
        Fri,  4 Feb 2022 14:36:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643985387;
        bh=8i+b7pmVSXu/LVS713BWFRfPvXWaLvrs9lLMLfji6PM=;
        h=Subject:To:From:Date:From;
        b=GwzIVryUzgo5rkvpyW/HM/LZaFKJ2XkoSxu5RXWqlMga30V3by5RK20eLzmw4Qp4+
         VMi5LfsoYNckgKwtk2/l0b2ZPc4rzUBsbMdG1EvUO9BSNfUGtitaVm+LSvoFMI0lD0
         LVEBIdz63lBE2GYSWEo+Ebkpw6tO52yK0YHUTlak=
Subject: patch "vt_ioctl: add array_index_nospec to VT_ACTIVATE" added to tty-linus
To:     jakobkoschel@gmail.com, bjohannesmeyer@gmail.com,
        gregkh@linuxfoundation.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 04 Feb 2022 15:36:16 +0100
Message-ID: <164398537614315@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    vt_ioctl: add array_index_nospec to VT_ACTIVATE

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 28cb138f559f8c1a1395f5564f86b8bbee83631b Mon Sep 17 00:00:00 2001
From: Jakob Koschel <jakobkoschel@gmail.com>
Date: Thu, 27 Jan 2022 15:44:05 +0100
Subject: vt_ioctl: add array_index_nospec to VT_ACTIVATE

in vt_setactivate an almost identical code path has been patched
with array_index_nospec. In the VT_ACTIVATE path the user input
is from a system call argument instead of a usercopy.
For consistency both code paths should have the same mitigations
applied.

Kasper Acknowledgements: Jakob Koschel, Brian Johannesmeyer, Kaveh
Razavi, Herbert Bos, Cristiano Giuffrida from the VUSec group at VU
Amsterdam.

Co-developed-by: Brian Johannesmeyer <bjohannesmeyer@gmail.com>
Signed-off-by: Brian Johannesmeyer <bjohannesmeyer@gmail.com>
Signed-off-by: Jakob Koschel <jakobkoschel@gmail.com>
Link: https://lore.kernel.org/r/20220127144406.3589293-2-jakobkoschel@gmail.com
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/vt/vt_ioctl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/tty/vt/vt_ioctl.c b/drivers/tty/vt/vt_ioctl.c
index e0714a9c9fd7..58013698635f 100644
--- a/drivers/tty/vt/vt_ioctl.c
+++ b/drivers/tty/vt/vt_ioctl.c
@@ -845,6 +845,7 @@ int vt_ioctl(struct tty_struct *tty,
 			return -ENXIO;
 
 		arg--;
+		arg = array_index_nospec(arg, MAX_NR_CONSOLES);
 		console_lock();
 		ret = vc_allocate(arg);
 		console_unlock();
-- 
2.35.1


