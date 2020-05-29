Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 498661E75FB
	for <lists+stable@lfdr.de>; Fri, 29 May 2020 08:35:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725562AbgE2Gf5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 May 2020 02:35:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:53548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725308AbgE2Gf5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 29 May 2020 02:35:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D97820721;
        Fri, 29 May 2020 06:35:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590734156;
        bh=qBYmMBT9z3YULOaQ6mRu6ivm+VHLkIqbQ7D2lTAaPfw=;
        h=Subject:To:From:Date:From;
        b=ctZdd3Nbje/BdJVxhuBIXMXjLSSv2oRl7Rq+Jm9AdPamrDeMlE3Ni9g7ekStXnAfG
         dVdmxt/VXcnKsJOc/XWuiz1tNMOin4Ykrace31kJyvy9g+0hJpsLe+DjAEAyalCeH3
         tYn/NGvhkQs5nLxuWpf2RfaZSkB+dHYHpbBqr/Qo=
Subject: patch "CDC-ACM: heed quirk also in error handling" added to usb-next
To:     oneukum@suse.com, gregkh@linuxfoundation.org,
        jdawin@math.uni-bielefeld.de, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 29 May 2020 08:35:53 +0200
Message-ID: <159073415322542@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    CDC-ACM: heed quirk also in error handling

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From 97fe809934dd2b0b37dfef3a2fc70417f485d7af Mon Sep 17 00:00:00 2001
From: Oliver Neukum <oneukum@suse.com>
Date: Tue, 26 May 2020 14:44:20 +0200
Subject: CDC-ACM: heed quirk also in error handling

If buffers are iterated over in the error case, the lower limits
for quirky devices must be heeded.

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Reported-by: Jean Rene Dawin <jdawin@math.uni-bielefeld.de>
Fixes: a4e7279cd1d19 ("cdc-acm: introduce a cool down")
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200526124420.22160-1-oneukum@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/class/cdc-acm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index ded8d93834ca..f67088bb8218 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -584,7 +584,7 @@ static void acm_softint(struct work_struct *work)
 	}
 
 	if (test_and_clear_bit(ACM_ERROR_DELAY, &acm->flags)) {
-		for (i = 0; i < ACM_NR; i++) 
+		for (i = 0; i < acm->rx_buflimit; i++)
 			if (test_and_clear_bit(i, &acm->urbs_in_error_delay))
 					acm_submit_read_urb(acm, i, GFP_NOIO);
 	}
-- 
2.26.2


