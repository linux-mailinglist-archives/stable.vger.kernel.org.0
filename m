Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD0D338C67D
	for <lists+stable@lfdr.de>; Fri, 21 May 2021 14:28:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233060AbhEUM3v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 May 2021 08:29:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:55532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229457AbhEUM3u (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 May 2021 08:29:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6E47D6108B;
        Fri, 21 May 2021 12:28:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621600107;
        bh=EezurDKh02VyRW/NX2SqEkDSr6W7jIg2IXs6ZE/YL4U=;
        h=Subject:To:From:Date:From;
        b=AH9/exaEIQlfJ2Dnu5ILOTQvWaWfIPkEiqtzKqVC12u5XRHbC7P8rAasAr8ebTiuV
         7l6Z8qH/Qs3H39kPAOdDd59v5tgQxdI8LuPfdmXpZWkzmmfYgJC0DkTq7s9Y3TzQXf
         yTso/X+GQ92dKo3+Pru/NG5q84StGfVxRNkBXyZQ=
Subject: patch "usb: typec: ucsi: Clear pending after acking connector change" added to usb-linus
To:     bjorn.andersson@linaro.org, bberg@redhat.com,
        gregkh@linuxfoundation.org, heikki.krogerus@linux.intel.com,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 21 May 2021 14:28:17 +0200
Message-ID: <1621600097216132@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: typec: ucsi: Clear pending after acking connector change

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 8c9b3caab3ac26db1da00b8117901640c55a69dd Mon Sep 17 00:00:00 2001
From: Bjorn Andersson <bjorn.andersson@linaro.org>
Date: Sat, 15 May 2021 21:09:53 -0700
Subject: usb: typec: ucsi: Clear pending after acking connector change

It's possible that the interrupt handler for the UCSI driver signals a
connector changes after the handler clears the PENDING bit, but before
it has sent the acknowledge request. The result is that the handler is
invoked yet again, to ack the same connector change.

At least some versions of the Qualcomm UCSI firmware will not handle the
second - "spurious" - acknowledgment gracefully. So make sure to not
clear the pending flag until the change is acknowledged.

Any connector changes coming in after the acknowledgment, that would
have the pending flag incorrectly cleared, would afaict be covered by
the subsequent connector status check.

Fixes: 217504a05532 ("usb: typec: ucsi: Work around PPM losing change information")
Cc: stable <stable@vger.kernel.org>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Acked-By: Benjamin Berg <bberg@redhat.com>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20210516040953.622409-1-bjorn.andersson@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/ucsi/ucsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/typec/ucsi/ucsi.c b/drivers/usb/typec/ucsi/ucsi.c
index 1d8b7df59ff4..b433169ef6fa 100644
--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -717,8 +717,8 @@ static void ucsi_handle_connector_change(struct work_struct *work)
 	ucsi_send_command(con->ucsi, command, NULL, 0);
 
 	/* 3. ACK connector change */
-	clear_bit(EVENT_PENDING, &ucsi->flags);
 	ret = ucsi_acknowledge_connector_change(ucsi);
+	clear_bit(EVENT_PENDING, &ucsi->flags);
 	if (ret) {
 		dev_err(ucsi->dev, "%s: ACK failed (%d)", __func__, ret);
 		goto out_unlock;
-- 
2.31.1


