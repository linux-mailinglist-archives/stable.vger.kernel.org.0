Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89D7B47A708
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 10:31:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229449AbhLTJbC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 04:31:02 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:39712 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbhLTJbB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 04:31:01 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8B5B260F1D
        for <stable@vger.kernel.org>; Mon, 20 Dec 2021 09:31:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CB24C36AE5;
        Mon, 20 Dec 2021 09:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639992661;
        bh=DMVrmaG6UJvGmTnaXC413tCwRagegeYAUa5L/9RqH14=;
        h=Subject:To:Cc:From:Date:From;
        b=VZ4VqUAi2mAcg1krGMdBmN1h5kIoh/E0iiyd1AmPhpPse6koaEus9IVgZvXX9jNKt
         /YRx31nm8KMib90M9HN89/2GK8PrQ9ibbbl6HwGF0pafQ7/cGkFMVo9d4GsW3k7zWG
         3zlbp4SIE6ODhvjTPIDxmTiQcbaPi8NZkBKuEwGk=
Subject: FAILED: patch "[PATCH] usb: typec: tcpm: fix tcpm unregister port but leave a" failed to apply to 5.10-stable tree
To:     xu.yang_2@nxp.com, gregkh@linuxfoundation.org,
        heikki.krogerus@linux.intel.com, linux@roeck-us.net,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 20 Dec 2021 10:30:58 +0100
Message-ID: <163999265825287@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From ca4d8344a72b91fb9d4c8bfbc22204b4c09c5d8f Mon Sep 17 00:00:00 2001
From: Xu Yang <xu.yang_2@nxp.com>
Date: Thu, 9 Dec 2021 18:15:07 +0800
Subject: [PATCH] usb: typec: tcpm: fix tcpm unregister port but leave a
 pending timer

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
 

