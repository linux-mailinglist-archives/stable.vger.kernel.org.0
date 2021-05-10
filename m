Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6EBB378E75
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 15:51:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242626AbhEJN3S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 09:29:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:51230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350763AbhEJNBW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 09:01:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C3CA611BD;
        Mon, 10 May 2021 13:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620651615;
        bh=royZP2niyaD07jbWOHD2jSH7U4+HKs7fh5uVumkSKHs=;
        h=Subject:To:From:Date:From;
        b=M5NCe3GTOvyEIRjUUDE+iixxLFY1jUEn2mlp08SHwdEGsswc0jcGeZKs2VSopZsjO
         W6dX3O7/vutFL+nImuf6TjFcVQ+Keko1W6Csxu9XkF5R7486AAjm4jxV3LsJ/wJEYn
         GEpu+7wqaG8z/tR7Xh7wjkfNV1lI0/K7WhgOCMro=
Subject: patch "usb: typec: tcpm: Fix wrong handling in GET_SINK_CAP" added to usb-linus
To:     kyletso@google.com, gregkh@linuxfoundation.org,
        heikki.krogerus@linux.intel.com, linux@roeck-us.net,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 10 May 2021 15:00:12 +0200
Message-ID: <162065161212240@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: typec: tcpm: Fix wrong handling in GET_SINK_CAP

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 2e2b8d15adc2f6ab2d4aa0550e241b9742a436a0 Mon Sep 17 00:00:00 2001
From: Kyle Tso <kyletso@google.com>
Date: Tue, 4 May 2021 01:18:49 +0800
Subject: usb: typec: tcpm: Fix wrong handling in GET_SINK_CAP

After receiving Sink Capabilities Message in GET_SINK_CAP AMS, it is
incorrect to call tcpm_pd_handle_state because the Message is expected
and the current state is not Ready states. The result of this incorrect
operation ends in Soft Reset which is definitely wrong. Simply
forwarding to Ready States is enough to finish the AMS.

Fixes: 8dea75e11380 ("usb: typec: tcpm: Protocol Error handling")
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Kyle Tso <kyletso@google.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210503171849.2605302-1-kyletso@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/tcpm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/typec/tcpm/tcpm.c b/drivers/usb/typec/tcpm/tcpm.c
index c4fdc00a3bc8..68e04e397e92 100644
--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -2390,7 +2390,7 @@ static void tcpm_pd_data_request(struct tcpm_port *port,
 		port->nr_sink_caps = cnt;
 		port->sink_cap_done = true;
 		if (port->ams == GET_SINK_CAPABILITIES)
-			tcpm_pd_handle_state(port, ready_state(port), NONE_AMS, 0);
+			tcpm_set_state(port, ready_state(port), 0);
 		/* Unexpected Sink Capabilities */
 		else
 			tcpm_pd_handle_msg(port,
-- 
2.31.1


