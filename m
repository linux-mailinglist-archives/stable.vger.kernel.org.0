Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 948804A9B12
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 15:36:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243173AbiBDOgV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 09:36:21 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:41016 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233084AbiBDOgV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Feb 2022 09:36:21 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2D554B8374F
        for <stable@vger.kernel.org>; Fri,  4 Feb 2022 14:36:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60C7BC004E1;
        Fri,  4 Feb 2022 14:36:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643985378;
        bh=qZhl4YKBBk3I+MH9Xns+XtoGNBQ52zeLZU8taDTvCgk=;
        h=Subject:To:From:Date:From;
        b=twaOo80q7GyUeGkMKwlIKIMZW9MrqG7vCUz8/WFvoquta87m2aBLFpl9DmCe8zgBX
         5SqRm2RarDwgouVkIR6rIOtooGpNv5MYUyyxVBBczYlT3hKR7OCuWUz/6exKP+5mmF
         Uhh3DIaO0I1xqxRvPROkgJy1mD18FZX7XzjKCsp4=
Subject: patch "vt_ioctl: fix array_index_nospec in vt_setactivate" added to tty-linus
To:     jakobkoschel@gmail.com, bjohannesmeyer@gmail.com,
        gregkh@linuxfoundation.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 04 Feb 2022 15:36:16 +0100
Message-ID: <164398537673255@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    vt_ioctl: fix array_index_nospec in vt_setactivate

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 61cc70d9e8ef5b042d4ed87994d20100ec8896d9 Mon Sep 17 00:00:00 2001
From: Jakob Koschel <jakobkoschel@gmail.com>
Date: Thu, 27 Jan 2022 15:44:04 +0100
Subject: vt_ioctl: fix array_index_nospec in vt_setactivate

array_index_nospec ensures that an out-of-bounds value is set to zero
on the transient path. Decreasing the value by one afterwards causes
a transient integer underflow. vsa.console should be decreased first
and then sanitized with array_index_nospec.

Kasper Acknowledgements: Jakob Koschel, Brian Johannesmeyer, Kaveh
Razavi, Herbert Bos, Cristiano Giuffrida from the VUSec group at VU
Amsterdam.

Co-developed-by: Brian Johannesmeyer <bjohannesmeyer@gmail.com>
Signed-off-by: Brian Johannesmeyer <bjohannesmeyer@gmail.com>
Signed-off-by: Jakob Koschel <jakobkoschel@gmail.com>
Link: https://lore.kernel.org/r/20220127144406.3589293-1-jakobkoschel@gmail.com
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/vt/vt_ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/vt/vt_ioctl.c b/drivers/tty/vt/vt_ioctl.c
index 3639bb6dc372..e0714a9c9fd7 100644
--- a/drivers/tty/vt/vt_ioctl.c
+++ b/drivers/tty/vt/vt_ioctl.c
@@ -599,8 +599,8 @@ static int vt_setactivate(struct vt_setactivate __user *sa)
 	if (vsa.console == 0 || vsa.console > MAX_NR_CONSOLES)
 		return -ENXIO;
 
-	vsa.console = array_index_nospec(vsa.console, MAX_NR_CONSOLES + 1);
 	vsa.console--;
+	vsa.console = array_index_nospec(vsa.console, MAX_NR_CONSOLES);
 	console_lock();
 	ret = vc_allocate(vsa.console);
 	if (ret) {
-- 
2.35.1


