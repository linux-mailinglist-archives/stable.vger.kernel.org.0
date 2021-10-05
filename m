Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85C444225A0
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 13:47:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233564AbhJELtJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 07:49:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:58828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232658AbhJELtI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Oct 2021 07:49:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D60AD61244;
        Tue,  5 Oct 2021 11:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633434438;
        bh=NtKyQTMFlZCHKON0SpsAxnK9SHxqFksgcWrHLPm9ofg=;
        h=Subject:To:From:Date:From;
        b=pWDUjo6Q73dzKRCYiZCtDIlHkg8MfkThjKgXzlcNd9b/+MMlHVLEXcPsm2pA+3kUW
         zfh4nNu3djMaSwRNzn97NJHuWwlS3aLv+amYoShhvfqhsTsldX12vFpXdVWHfa+WxA
         1mRdK/J5cwDxwR66NXSUceneY/oUGCSedYHqsF34=
Subject: patch "usb: typec: tcpm: handle SRC_STARTUP state if cc changes" added to usb-linus
To:     xu.yang_2@nxp.com, gregkh@linuxfoundation.org,
        heikki.krogerus@linux.intel.com, linux@roeck-us.net,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 05 Oct 2021 13:47:08 +0200
Message-ID: <163343442818059@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: typec: tcpm: handle SRC_STARTUP state if cc changes

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 6d91017a295e9790eec02c4e43f020cdb55f5d98 Mon Sep 17 00:00:00 2001
From: Xu Yang <xu.yang_2@nxp.com>
Date: Tue, 28 Sep 2021 19:16:39 +0800
Subject: usb: typec: tcpm: handle SRC_STARTUP state if cc changes

TCPM for DRP should do the same action as SRC_ATTACHED when cc changes in
SRC_STARTUP state. Otherwise, TCPM will transition to SRC_UNATTACHED state
which is not satisfied with the Type-C spec.

Per Type-C spec:
DRP port should move to Unattached.SNK instead of Unattached.SRC if sink
removed.

Fixes: 4b4e02c83167 ("typec: tcpm: Move out of staging")
cc: <stable@vger.kernel.org>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Xu Yang <xu.yang_2@nxp.com>
Link: https://lore.kernel.org/r/20210928111639.3854174-1-xu.yang_2@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/tcpm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/typec/tcpm/tcpm.c b/drivers/usb/typec/tcpm/tcpm.c
index a4d37205df54..7f2f3ff1b391 100644
--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -4876,6 +4876,7 @@ static void _tcpm_cc_change(struct tcpm_port *port, enum typec_cc_status cc1,
 			tcpm_set_state(port, SRC_ATTACH_WAIT, 0);
 		break;
 	case SRC_ATTACHED:
+	case SRC_STARTUP:
 	case SRC_SEND_CAPABILITIES:
 	case SRC_READY:
 		if (tcpm_port_is_disconnected(port) ||
-- 
2.33.0


