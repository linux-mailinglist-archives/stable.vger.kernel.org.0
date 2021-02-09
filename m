Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68377314A54
	for <lists+stable@lfdr.de>; Tue,  9 Feb 2021 09:32:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229464AbhBIIb5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Feb 2021 03:31:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:44592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229608AbhBIIbk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Feb 2021 03:31:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5CD3564EBD;
        Tue,  9 Feb 2021 08:30:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612859459;
        bh=dD0A5OK3HsXVvWhyk59acFX0n0zj3YGqrrhuDxNWf6Q=;
        h=Subject:To:From:Date:From;
        b=TWxvNk6j+UrVRmbPV5AiDirjslPZKFI5UeTcjUmnK8GHU0ndTTl5wxvEF8HgVkKcF
         iGTR2ongCJLyDsmvrE9mlHbXclSk/1Rek8Yo6BUX4LvURU7NxuBX3E3z2kk0ncWS7C
         TRMeFHmo4sZNsQ7SikOrV43Lu0P6Aoe48ivIvHCo=
Subject: patch "mei: bus: block send with vtag on non-conformat FW" added to char-misc-testing
To:     alexander.usyskin@intel.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, tomas.winkler@intel.com
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 09 Feb 2021 09:30:44 +0100
Message-ID: <161285944420935@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    mei: bus: block send with vtag on non-conformat FW

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the char-misc-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From b398d53cd421454d64850f8b1f6d609ede9042d9 Mon Sep 17 00:00:00 2001
From: Alexander Usyskin <alexander.usyskin@intel.com>
Date: Mon, 8 Feb 2021 17:06:48 +0200
Subject: mei: bus: block send with vtag on non-conformat FW

Block data send with vtag if either transport layer or
FW client are not supporting vtags.

Cc: <stable@vger.kernel.org> # v5.10+
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Link: https://lore.kernel.org/r/20210208150649.141358-1-tomas.winkler@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/mei/bus.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/misc/mei/bus.c b/drivers/misc/mei/bus.c
index 580074e32599..935acc6bbf3c 100644
--- a/drivers/misc/mei/bus.c
+++ b/drivers/misc/mei/bus.c
@@ -61,6 +61,13 @@ ssize_t __mei_cl_send(struct mei_cl *cl, u8 *buf, size_t length, u8 vtag,
 		goto out;
 	}
 
+	if (vtag) {
+		/* Check if vtag is supported by client */
+		rets = mei_cl_vt_support_check(cl);
+		if (rets)
+			goto out;
+	}
+
 	if (length > mei_cl_mtu(cl)) {
 		rets = -EFBIG;
 		goto out;
-- 
2.30.0


