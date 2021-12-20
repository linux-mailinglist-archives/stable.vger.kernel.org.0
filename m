Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8F1947AF8E
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 16:15:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235105AbhLTPPF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 10:15:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238246AbhLTPM7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 10:12:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDE0BC08EC6A;
        Mon, 20 Dec 2021 06:57:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2985E6118D;
        Mon, 20 Dec 2021 14:57:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EEF8C36AE7;
        Mon, 20 Dec 2021 14:57:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640012231;
        bh=O0u+wGFcTK8cBNh0D43Jg2MFQDBLRQliHOyObiEwMrQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d2daBWOqIM1eL8asL5BCSCpM63DfAWZb2tGLP75qFIlCx0Z2e6gf/88ZhS0/Nv2iL
         +mmiOyiyX+1FEqVa0pwMEpzZv7LaGccz7ZQySrsTIRzEfhdcx3n67gyLQOo1XmO6Cn
         pAd4HlE8w9BTtP8z0Ib6uejs57juzYqP+3YqNJO8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Xu Yang <xu.yang_2@nxp.com>
Subject: [PATCH 5.15 127/177] usb: typec: tcpm: fix tcpm unregister port but leave a pending timer
Date:   Mon, 20 Dec 2021 15:34:37 +0100
Message-Id: <20211220143044.351663268@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143040.058287525@linuxfoundation.org>
References: <20211220143040.058287525@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xu Yang <xu.yang_2@nxp.com>

commit ca4d8344a72b91fb9d4c8bfbc22204b4c09c5d8f upstream.

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
 drivers/usb/typec/tcpm/tcpm.c |   18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -324,6 +324,7 @@ struct tcpm_port {
 
 	bool attached;
 	bool connected;
+	bool registered;
 	bool pd_supported;
 	enum typec_port_type port_type;
 
@@ -6291,7 +6292,8 @@ static enum hrtimer_restart state_machin
 {
 	struct tcpm_port *port = container_of(timer, struct tcpm_port, state_machine_timer);
 
-	kthread_queue_work(port->wq, &port->state_machine);
+	if (port->registered)
+		kthread_queue_work(port->wq, &port->state_machine);
 	return HRTIMER_NORESTART;
 }
 
@@ -6299,7 +6301,8 @@ static enum hrtimer_restart vdm_state_ma
 {
 	struct tcpm_port *port = container_of(timer, struct tcpm_port, vdm_state_machine_timer);
 
-	kthread_queue_work(port->wq, &port->vdm_state_machine);
+	if (port->registered)
+		kthread_queue_work(port->wq, &port->vdm_state_machine);
 	return HRTIMER_NORESTART;
 }
 
@@ -6307,7 +6310,8 @@ static enum hrtimer_restart enable_frs_t
 {
 	struct tcpm_port *port = container_of(timer, struct tcpm_port, enable_frs_timer);
 
-	kthread_queue_work(port->wq, &port->enable_frs);
+	if (port->registered)
+		kthread_queue_work(port->wq, &port->enable_frs);
 	return HRTIMER_NORESTART;
 }
 
@@ -6315,7 +6319,8 @@ static enum hrtimer_restart send_discove
 {
 	struct tcpm_port *port = container_of(timer, struct tcpm_port, send_discover_timer);
 
-	kthread_queue_work(port->wq, &port->send_discover_work);
+	if (port->registered)
+		kthread_queue_work(port->wq, &port->send_discover_work);
 	return HRTIMER_NORESTART;
 }
 
@@ -6403,6 +6408,7 @@ struct tcpm_port *tcpm_register_port(str
 	typec_port_register_altmodes(port->typec_port,
 				     &tcpm_altmode_ops, port,
 				     port->port_altmode, ALTMODE_DISCOVERY_MAX);
+	port->registered = true;
 
 	mutex_lock(&port->lock);
 	tcpm_init(port);
@@ -6424,6 +6430,9 @@ void tcpm_unregister_port(struct tcpm_po
 {
 	int i;
 
+	port->registered = false;
+	kthread_destroy_worker(port->wq);
+
 	hrtimer_cancel(&port->send_discover_timer);
 	hrtimer_cancel(&port->enable_frs_timer);
 	hrtimer_cancel(&port->vdm_state_machine_timer);
@@ -6435,7 +6444,6 @@ void tcpm_unregister_port(struct tcpm_po
 	typec_unregister_port(port->typec_port);
 	usb_role_switch_put(port->role_sw);
 	tcpm_debugfs_exit(port);
-	kthread_destroy_worker(port->wq);
 }
 EXPORT_SYMBOL_GPL(tcpm_unregister_port);
 


