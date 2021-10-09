Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 866E1427AA6
	for <lists+stable@lfdr.de>; Sat,  9 Oct 2021 15:38:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233209AbhJINkt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Oct 2021 09:40:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:56804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233146AbhJINks (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Oct 2021 09:40:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DBA2F60184;
        Sat,  9 Oct 2021 13:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633786731;
        bh=J1c7Y+Tjny1snJti96l/8k5PKupVEfZQA/aQ0/LS51U=;
        h=Subject:To:Cc:From:Date:From;
        b=cuZrh9ruSGA6pFNQBZ8sEEmTs0bgkCyYMoyr1CMRA4yF/bFMproVh91r5NSx6ELRn
         zTIhqa+Gt0i/tY6mP+PIq4F3G1Jm/KDjb4xTBVIUfN8SN2dW6J1knwQHHhDXWBWcXQ
         H1Oap/sEBUjDI0AJlRdltSwLW37ZTrcJr/8F6fv8=
Subject: FAILED: patch "[PATCH] usb: typec: tcpm: handle SRC_STARTUP state if cc changes" failed to apply to 4.19-stable tree
To:     xu.yang_2@nxp.com, gregkh@linuxfoundation.org,
        heikki.krogerus@linux.intel.com, linux@roeck-us.net,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 09 Oct 2021 15:38:48 +0200
Message-ID: <16337867281195@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 6d91017a295e9790eec02c4e43f020cdb55f5d98 Mon Sep 17 00:00:00 2001
From: Xu Yang <xu.yang_2@nxp.com>
Date: Tue, 28 Sep 2021 19:16:39 +0800
Subject: [PATCH] usb: typec: tcpm: handle SRC_STARTUP state if cc changes

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

