Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62CB23E8012
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:47:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235771AbhHJRqE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:46:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:38076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236136AbhHJRoc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:44:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8140A610A0;
        Tue, 10 Aug 2021 17:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617176;
        bh=kZhnoqq0lOs/n/AkRcgA4EmH5PJ3/PgnMkbxD7CHxgs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kGGu0jMPUZVDUoRKvMEWRXQXfSIdVjqhNoGXtDGBdpZKxeLFh18WXhb/YAS0uSGyg
         qyzt+zyfqUmmAIYUVNwvBNAD+qpIx+uS56UY/zhTH1g+ocwnB8Y/JqOuow3Aqx/nBd
         6s6Jt4fQogfvJIT3N7ev4RNkvmjz3JmIzm6aZL40=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Badhri Jagan Sridharan <badhri@google.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Kyle Tso <kyletso@google.com>
Subject: [PATCH 5.10 071/135] usb: typec: tcpm: Keep other events when receiving FRS and Sourcing_vbus events
Date:   Tue, 10 Aug 2021 19:30:05 +0200
Message-Id: <20210810172958.141122822@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810172955.660225700@linuxfoundation.org>
References: <20210810172955.660225700@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kyle Tso <kyletso@google.com>

commit 43ad944cd73f2360ec8ff31d29ea44830b3119af upstream.

When receiving FRS and Sourcing_Vbus events from low-level drivers, keep
other events which come a bit earlier so that they will not be ignored
in the event handler.

Fixes: 8dc4bd073663 ("usb: typec: tcpm: Add support for Sink Fast Role SWAP(FRS)")
Cc: stable <stable@vger.kernel.org>
Cc: Badhri Jagan Sridharan <badhri@google.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Badhri Jagan Sridharan <badhri@google.com>
Signed-off-by: Kyle Tso <kyletso@google.com>
Link: https://lore.kernel.org/r/20210803091314.3051302-1-kyletso@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/tcpm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -4314,7 +4314,7 @@ EXPORT_SYMBOL_GPL(tcpm_pd_hard_reset);
 void tcpm_sink_frs(struct tcpm_port *port)
 {
 	spin_lock(&port->pd_event_lock);
-	port->pd_events = TCPM_FRS_EVENT;
+	port->pd_events |= TCPM_FRS_EVENT;
 	spin_unlock(&port->pd_event_lock);
 	kthread_queue_work(port->wq, &port->event_work);
 }
@@ -4323,7 +4323,7 @@ EXPORT_SYMBOL_GPL(tcpm_sink_frs);
 void tcpm_sourcing_vbus(struct tcpm_port *port)
 {
 	spin_lock(&port->pd_event_lock);
-	port->pd_events = TCPM_SOURCING_VBUS;
+	port->pd_events |= TCPM_SOURCING_VBUS;
 	spin_unlock(&port->pd_event_lock);
 	kthread_queue_work(port->wq, &port->event_work);
 }


