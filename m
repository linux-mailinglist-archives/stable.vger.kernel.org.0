Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00072476623
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 23:46:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231452AbhLOWp7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 17:45:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231172AbhLOWp7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Dec 2021 17:45:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86F75C061574
        for <stable@vger.kernel.org>; Wed, 15 Dec 2021 14:45:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2588861B6C
        for <stable@vger.kernel.org>; Wed, 15 Dec 2021 22:45:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07AD9C36AE3;
        Wed, 15 Dec 2021 22:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639608358;
        bh=hfdTVJAQBQLjgsniYzChV5H2IHn9TbMimNxpHShheOk=;
        h=Subject:To:From:Date:From;
        b=R+tijxW6sGsYb/t/7YFfnpyfNARqCAKR9FkTADlJAovml85KdAAlyCpR20Ja2T/32
         /xG+WOodkK4ovt0CIk9Nofsta2RPfxM9Wcq6ZF5REgcC1XnUQ1xgeJSZMQt91zNq+X
         Oltk+z9vYEZAVwz/oSK9KL3UAuQj7V3W8j00CTMU=
Subject: patch "usb: typec: tcpm: fix tcpm unregister port but leave a pending timer" added to usb-linus
To:     xu.yang_2@nxp.com, gregkh@linuxfoundation.org,
        heikki.krogerus@linux.intel.com, linux@roeck-us.net,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 15 Dec 2021 23:45:48 +0100
Message-ID: <1639608348189233@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: typec: tcpm: fix tcpm unregister port but leave a pending timer

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From ca4d8344a72b91fb9d4c8bfbc22204b4c09c5d8f Mon Sep 17 00:00:00 2001
From: Xu Yang <xu.yang_2@nxp.com>
Date: Thu, 9 Dec 2021 18:15:07 +0800
Subject: usb: typec: tcpm: fix tcpm unregister port but leave a pending timer

In current design, when the tcpm port is unregisterd, the kthread_worker
will be destroyed in the last step. Inside the kthread_destroy_worker(),
the worker will flush all the works and wait for them to end. However, if
one of the works calls hrtimer_start(), this hrtimer will be pending until
timeout even though tcpm port is removed. Once the hrtimer timeout, many
strange kernel dumps appear.

Thus, we can first complete kthread_destroy_worker(), then cancel all the
hrtimers. This will guarantee that no hrtimer is pending at the end.

Fixes: 3ed8e1c2ac99 ("usb: typec: tcpm: Migrate workqueue to RT priority for processing events")
cc: <stable@vger.kernel.org>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Xu Yang <xu.yang_2@nxp.com>
Link: https://lore.kernel.org/r/20211209101507.499096-1-xu.yang_2@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/tcpm.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/typec/tcpm/tcpm.c b/drivers/usb/typec/tcpm/tcpm.c
index 6010b9901126..59d4fa2443f2 100644
--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -324,6 +324,7 @@ struct tcpm_port {
 
 	bool attached;
 	bool connected;
+	bool registered;
 	bool pd_supported;
 	enum typec_port_type port_type;
 
@@ -6291,7 +6292,8 @@ static enum hrtimer_restart state_machine_timer_handler(struct hrtimer *timer)
 {
 	struct tcpm_port *port = container_of(timer, struct tcpm_port, state_machine_timer);
 
-	kthread_queue_work(port->wq, &port->state_machine);
+	if (port->registered)
+		kthread_queue_work(port->wq, &port->state_machine);
 	return HRTIMER_NORESTART;
 }
 
@@ -6299,7 +6301,8 @@ static enum hrtimer_restart vdm_state_machine_timer_handler(struct hrtimer *time
 {
 	struct tcpm_port *port = container_of(timer, struct tcpm_port, vdm_state_machine_timer);
 
-	kthread_queue_work(port->wq, &port->vdm_state_machine);
+	if (port->registered)
+		kthread_queue_work(port->wq, &port->vdm_state_machine);
 	return HRTIMER_NORESTART;
 }
 
@@ -6307,7 +6310,8 @@ static enum hrtimer_restart enable_frs_timer_handler(struct hrtimer *timer)
 {
 	struct tcpm_port *port = container_of(timer, struct tcpm_port, enable_frs_timer);
 
-	kthread_queue_work(port->wq, &port->enable_frs);
+	if (port->registered)
+		kthread_queue_work(port->wq, &port->enable_frs);
 	return HRTIMER_NORESTART;
 }
 
@@ -6315,7 +6319,8 @@ static enum hrtimer_restart send_discover_timer_handler(struct hrtimer *timer)
 {
 	struct tcpm_port *port = container_of(timer, struct tcpm_port, send_discover_timer);
 
-	kthread_queue_work(port->wq, &port->send_discover_work);
+	if (port->registered)
+		kthread_queue_work(port->wq, &port->send_discover_work);
 	return HRTIMER_NORESTART;
 }
 
@@ -6403,6 +6408,7 @@ struct tcpm_port *tcpm_register_port(struct device *dev, struct tcpc_dev *tcpc)
 	typec_port_register_altmodes(port->typec_port,
 				     &tcpm_altmode_ops, port,
 				     port->port_altmode, ALTMODE_DISCOVERY_MAX);
+	port->registered = true;
 
 	mutex_lock(&port->lock);
 	tcpm_init(port);
@@ -6424,6 +6430,9 @@ void tcpm_unregister_port(struct tcpm_port *port)
 {
 	int i;
 
+	port->registered = false;
+	kthread_destroy_worker(port->wq);
+
 	hrtimer_cancel(&port->send_discover_timer);
 	hrtimer_cancel(&port->enable_frs_timer);
 	hrtimer_cancel(&port->vdm_state_machine_timer);
@@ -6435,7 +6444,6 @@ void tcpm_unregister_port(struct tcpm_port *port)
 	typec_unregister_port(port->typec_port);
 	usb_role_switch_put(port->role_sw);
 	tcpm_debugfs_exit(port);
-	kthread_destroy_worker(port->wq);
 }
 EXPORT_SYMBOL_GPL(tcpm_unregister_port);
 
-- 
2.34.1


