Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61E0B378E7A
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 15:51:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242647AbhEJN3V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 09:29:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:54170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235755AbhEJNDe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 09:03:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E66FB611CE;
        Mon, 10 May 2021 13:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620651749;
        bh=68ftXjk1rpWTPJnkIv4ifbUIN/9h2e5XbLVHG3Gdqpw=;
        h=Subject:To:From:Date:From;
        b=wtBqyHHKrQoXAU6/wjBJdXTHZSv+wCK7yeRypZSmMb7ZZRocrAVUpRSg5UEcrVf3f
         fCzk71X2AWkP9VZvgoc3cfJu9C1QtVEEEmtEWgOER9TLDwIEPbhtu7k4C6PZh+fRFN
         4DtBqO5mvD5NIK0mmvf/DLM9NWGIvSumcVs0X93Y=
Subject: patch "usb: typec: ucsi: Put fwnode in any case during ->probe()" added to usb-linus
To:     andy.shevchenko@gmail.com, gregkh@linuxfoundation.org,
        heikki.krogerus@linux.intel.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 10 May 2021 15:02:27 +0200
Message-ID: <16206517473731@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: typec: ucsi: Put fwnode in any case during ->probe()

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From b9a0866a5bdf6a4643a52872ada6be6184c6f4f2 Mon Sep 17 00:00:00 2001
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Wed, 5 May 2021 01:23:37 +0300
Subject: usb: typec: ucsi: Put fwnode in any case during ->probe()

device_for_each_child_node() bumps a reference counting of a returned variable.
We have to balance it whenever we return to the caller.

Fixes: c1b0bc2dabfa ("usb: typec: Add support for UCSI interface")
Cc: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Link: https://lore.kernel.org/r/20210504222337.3151726-1-andy.shevchenko@gmail.com
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/ucsi/ucsi.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/typec/ucsi/ucsi.c b/drivers/usb/typec/ucsi/ucsi.c
index 282c3c825c13..0e1cec346e0f 100644
--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -999,6 +999,7 @@ static const struct typec_operations ucsi_ops = {
 	.pr_set = ucsi_pr_swap
 };
 
+/* Caller must call fwnode_handle_put() after use */
 static struct fwnode_handle *ucsi_find_fwnode(struct ucsi_connector *con)
 {
 	struct fwnode_handle *fwnode;
@@ -1033,7 +1034,7 @@ static int ucsi_register_port(struct ucsi *ucsi, int index)
 	command |= UCSI_CONNECTOR_NUMBER(con->num);
 	ret = ucsi_send_command(ucsi, command, &con->cap, sizeof(con->cap));
 	if (ret < 0)
-		goto out;
+		goto out_unlock;
 
 	if (con->cap.op_mode & UCSI_CONCAP_OPMODE_DRP)
 		cap->data = TYPEC_PORT_DRD;
@@ -1151,6 +1152,8 @@ static int ucsi_register_port(struct ucsi *ucsi, int index)
 	trace_ucsi_register_port(con->num, &con->status);
 
 out:
+	fwnode_handle_put(cap->fwnode);
+out_unlock:
 	mutex_unlock(&con->lock);
 	return ret;
 }
-- 
2.31.1


