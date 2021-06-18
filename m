Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58B5E3AC3E7
	for <lists+stable@lfdr.de>; Fri, 18 Jun 2021 08:30:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230136AbhFRGcz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Jun 2021 02:32:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:38820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231461AbhFRGcz (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Jun 2021 02:32:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF87C61245;
        Fri, 18 Jun 2021 06:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623997846;
        bh=SyJdEA20ePqHj7GBHSJzSinmDSeYIn72ez9eOWUCJ/A=;
        h=Subject:To:From:Date:From;
        b=vSrhuR8YfaKRlz0iAEVa2oOtSN3s+NnxNNEGHs+dIupHEQyTFQ38SmDYKmN1mZurB
         Qe1BrNqhEaeopshlQJxU6OhOK+xkIOE1vyhzpMgIaxgsadiK5GjNrex4fqYG0Vx6ax
         eGuS1cCJbPX+kzlvN/qeUGeK8zUoVY8nFRDqAG2Y=
Subject: patch "usb: typec: Add the missed altmode_id_remove() in" added to usb-next
To:     jingxiangfeng@huawei.com, gregkh@linuxfoundation.org,
        heikki.krogerus@linux.intel.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 18 Jun 2021 08:30:23 +0200
Message-ID: <1623997823200170@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: typec: Add the missed altmode_id_remove() in

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From 03026197bb657d784220b040c6173267a0375741 Mon Sep 17 00:00:00 2001
From: Jing Xiangfeng <jingxiangfeng@huawei.com>
Date: Thu, 17 Jun 2021 15:32:26 +0800
Subject: usb: typec: Add the missed altmode_id_remove() in
 typec_register_altmode()

typec_register_altmode() misses to call altmode_id_remove() in an error
path. Add the missed function call to fix it.

Fixes: 8a37d87d72f0 ("usb: typec: Bus type for alternate modes")
Cc: stable <stable@vger.kernel.org>
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Jing Xiangfeng <jingxiangfeng@huawei.com>
Link: https://lore.kernel.org/r/20210617073226.47599-1-jingxiangfeng@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/class.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/typec/class.c b/drivers/usb/typec/class.c
index b9429c9f65f6..aeef453aa658 100644
--- a/drivers/usb/typec/class.c
+++ b/drivers/usb/typec/class.c
@@ -517,8 +517,10 @@ typec_register_altmode(struct device *parent,
 	int ret;
 
 	alt = kzalloc(sizeof(*alt), GFP_KERNEL);
-	if (!alt)
+	if (!alt) {
+		altmode_id_remove(parent, id);
 		return ERR_PTR(-ENOMEM);
+	}
 
 	alt->adev.svid = desc->svid;
 	alt->adev.mode = desc->mode;
-- 
2.32.0


