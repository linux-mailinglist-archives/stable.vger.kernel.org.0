Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 700162D858B
	for <lists+stable@lfdr.de>; Sat, 12 Dec 2020 11:02:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438529AbgLLKA4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Dec 2020 05:00:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:34560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438527AbgLLKAs (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 12 Dec 2020 05:00:48 -0500
Subject: patch "USB: serial: mos7720: fix parallel-port state restore" added to usb-next
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1607767208;
        bh=Q1QMo8Byh+EJo4JXRE32rZcaWgtm0czIDy4D1A/eID4=;
        h=To:From:Date:From;
        b=2Ido6Rr6HMlhgq5W2v6f6DqZov5XddvCen9CgObmnjL1cYtr+Fmzb4mMmn/asGsXb
         UXceFnm9qi876+kVMw7XKMukSH2I+ZGRbROLpqHpEp3MOshORmSuY1nOsFVlLwJ7Bm
         XA/plLeMMgkS/sJnPU85kTW+V9kkQWbV0SBCirVk=
To:     johan@kernel.org, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 12 Dec 2020 10:59:28 +0100
Message-ID: <1607767168790@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: serial: mos7720: fix parallel-port state restore

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From 975323ab8f116667676c30ca3502a6757bd89e8d Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan@kernel.org>
Date: Wed, 4 Nov 2020 17:47:27 +0100
Subject: USB: serial: mos7720: fix parallel-port state restore

The parallel-port restore operations is called when a driver claims the
port and is supposed to restore the provided state (e.g. saved when
releasing the port).

Fixes: b69578df7e98 ("USB: usbserial: mos7720: add support for parallel port on moschip 7715")
Cc: stable <stable@vger.kernel.org>     # 2.6.35
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/serial/mos7720.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/serial/mos7720.c b/drivers/usb/serial/mos7720.c
index 5eed1078fac8..5a5d2a95070e 100644
--- a/drivers/usb/serial/mos7720.c
+++ b/drivers/usb/serial/mos7720.c
@@ -639,6 +639,8 @@ static void parport_mos7715_restore_state(struct parport *pp,
 		spin_unlock(&release_lock);
 		return;
 	}
+	mos_parport->shadowDCR = s->u.pc.ctr;
+	mos_parport->shadowECR = s->u.pc.ecr;
 	write_parport_reg_nonblock(mos_parport, MOS7720_DCR,
 				   mos_parport->shadowDCR);
 	write_parport_reg_nonblock(mos_parport, MOS7720_ECR,
-- 
2.29.2


