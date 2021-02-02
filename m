Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C4C030C307
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 16:08:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232920AbhBBPHl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 10:07:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:51596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231281AbhBBOQv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 09:16:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6425764FB7;
        Tue,  2 Feb 2021 13:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612274050;
        bh=TpZbbwr9wlvVCQwnktn8RnArixjRDNYTuiSMPBhjGlQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mwbi54T7ymlLiHrpEag/PWrlMmAa+2z41cUa8OAXQl4rwgbgkhst9lYmJpHLoGlQz
         2xRW+baIMDX5tTOSgLSE9ze0hqiXM3Ba6nDCpd0bWBlRn9E+ewmdV3h6IEPhXkvBal
         T/kEw1RZhKZxGSazCsgvhWWBbLp3u9JeVADBRj34=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Juergen Gross <jgross@suse.com>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Salvatore Bonaccorso <carnil@debian.org>,
        Jason Andryuk <jandryuk@gmail.com>
Subject: [PATCH 4.19 15/37] xen: Fix XenStore initialisation for XS_LOCAL
Date:   Tue,  2 Feb 2021 14:38:58 +0100
Message-Id: <20210202132943.534336956@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132942.915040339@linuxfoundation.org>
References: <20210202132942.915040339@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

commit 5f46400f7a6a4fad635d5a79e2aa5a04a30ffea1 upstream.

In commit 3499ba8198ca ("xen: Fix event channel callback via INTX/GSI")
I reworked the triggering of xenbus_probe().

I tried to simplify things by taking out the workqueue based startup
triggered from wake_waiting(); the somewhat poorly named xenbus IRQ
handler.

I missed the fact that in the XS_LOCAL case (Dom0 starting its own
xenstored or xenstore-stubdom, which happens after the kernel is booted
completely), that IRQ-based trigger is still actually needed.

So... put it back, except more cleanly. By just spawning a xenbus_probe
thread which waits on xb_waitq and runs the probe the first time it
gets woken, just as the workqueue-based hack did.

This is actually a nicer approach for *all* the back ends with different
interrupt methods, and we can switch them all over to that without the
complex conditions for when to trigger it. But not in -rc6. This is
the minimal fix for the regression, although it's a step in the right
direction instead of doing a partial revert and actually putting the
workqueue back. It's also simpler than the workqueue.

Fixes: 3499ba8198ca ("xen: Fix event channel callback via INTX/GSI")
Reported-by: Juergen Gross <jgross@suse.com>
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Reviewed-by: Juergen Gross <jgross@suse.com>
Link: https://lore.kernel.org/r/4c9af052a6e0f6485d1de43f2c38b1461996db99.camel@infradead.org
Signed-off-by: Juergen Gross <jgross@suse.com>
Cc: Salvatore Bonaccorso <carnil@debian.org>
Cc: Jason Andryuk <jandryuk@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/xen/xenbus/xenbus_probe.c |   31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

--- a/drivers/xen/xenbus/xenbus_probe.c
+++ b/drivers/xen/xenbus/xenbus_probe.c
@@ -714,6 +714,23 @@ static bool xs_hvm_defer_init_for_callba
 #endif
 }
 
+static int xenbus_probe_thread(void *unused)
+{
+	DEFINE_WAIT(w);
+
+	/*
+	 * We actually just want to wait for *any* trigger of xb_waitq,
+	 * and run xenbus_probe() the moment it occurs.
+	 */
+	prepare_to_wait(&xb_waitq, &w, TASK_INTERRUPTIBLE);
+	schedule();
+	finish_wait(&xb_waitq, &w);
+
+	DPRINTK("probing");
+	xenbus_probe();
+	return 0;
+}
+
 static int __init xenbus_probe_initcall(void)
 {
 	/*
@@ -725,6 +742,20 @@ static int __init xenbus_probe_initcall(
 	     !xs_hvm_defer_init_for_callback()))
 		xenbus_probe();
 
+	/*
+	 * For XS_LOCAL, spawn a thread which will wait for xenstored
+	 * or a xenstore-stubdom to be started, then probe. It will be
+	 * triggered when communication starts happening, by waiting
+	 * on xb_waitq.
+	 */
+	if (xen_store_domain_type == XS_LOCAL) {
+		struct task_struct *probe_task;
+
+		probe_task = kthread_run(xenbus_probe_thread, NULL,
+					 "xenbus_probe");
+		if (IS_ERR(probe_task))
+			return PTR_ERR(probe_task);
+	}
 	return 0;
 }
 device_initcall(xenbus_probe_initcall);


