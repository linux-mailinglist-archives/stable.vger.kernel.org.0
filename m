Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D65721BC5F4
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 19:01:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727929AbgD1RBT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 13:01:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:60308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726406AbgD1RBT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 13:01:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8408C20730;
        Tue, 28 Apr 2020 17:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588093279;
        bh=s94R4c7OwOCN7AoUYOJ/x6rGSi/T7q8FqmlXiEiGjSQ=;
        h=Subject:To:From:Date:From;
        b=XlTA37C9QV4pfE70rasMQJoUIsVPPIe2CUDaVjKTWa+XGXErjLjbymc/L6Kpw+pec
         m/IGaWgBZUqYCXknGyEntx2a16SVRa+lqNM6inxNBY6E1fF3pnGhIOe6cm0aOqoZjK
         /j3Ok1crJPq/irBJu70hki60IM7cpS0OUcGHRoR4=
Subject: patch "thunderbolt: Check return value of tb_sw_read() in usb4_switch_op()" added to usb-linus
To:     mika.westerberg@linux.intel.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, yehezkelshb@gmail.com
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 28 Apr 2020 19:01:16 +0200
Message-ID: <15880932762362@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    thunderbolt: Check return value of tb_sw_read() in usb4_switch_op()

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From c3bf9930921b33edb31909006607e478751a6f5e Mon Sep 17 00:00:00 2001
From: Mika Westerberg <mika.westerberg@linux.intel.com>
Date: Thu, 9 Apr 2020 10:18:10 +0300
Subject: thunderbolt: Check return value of tb_sw_read() in usb4_switch_op()

The function misses checking return value of tb_sw_read() before it
accesses the value that was read. Fix this by checking the return value
first.

Fixes: b04079837b20 ("thunderbolt: Add initial support for USB4")
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Reviewed-by: Yehezkel Bernat <yehezkelshb@gmail.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/usb4.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/thunderbolt/usb4.c b/drivers/thunderbolt/usb4.c
index 3d084cec136f..50c7534ba31e 100644
--- a/drivers/thunderbolt/usb4.c
+++ b/drivers/thunderbolt/usb4.c
@@ -182,6 +182,9 @@ static int usb4_switch_op(struct tb_switch *sw, u16 opcode, u8 *status)
 		return ret;
 
 	ret = tb_sw_read(sw, &val, TB_CFG_SWITCH, ROUTER_CS_26, 1);
+	if (ret)
+		return ret;
+
 	if (val & ROUTER_CS_26_ONS)
 		return -EOPNOTSUPP;
 
-- 
2.26.2


