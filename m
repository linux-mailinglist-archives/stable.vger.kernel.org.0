Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D92133E81A0
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 20:01:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237481AbhHJSAl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 14:00:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:59580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236497AbhHJR67 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:58:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9950F6113A;
        Tue, 10 Aug 2021 17:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617567;
        bh=rWzar62zifTqpmMCntjMbUBKnJw/jGeZW1B59B3H2EA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=orx1cwCWLwy8QC+1oxKv2cEZns6e0BDG83OyO6Fk2ufdECfDo19FritI4RcsXFMmg
         l4EEZzs6ck5F/AhenEqRBbRGBCqkZ3kZqbKWtyAMVTG2ePM58AhglV9HbvTaUJNwTz
         htaWVleCl3HKcTMu1p3vCKrAQB07f0OAaWEB2jCY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Badhri Jagan Sridharan <badhri@google.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Kyle Tso <kyletso@google.com>
Subject: [PATCH 5.13 098/175] usb: typec: tcpm: Keep other events when receiving FRS and Sourcing_vbus events
Date:   Tue, 10 Aug 2021 19:30:06 +0200
Message-Id: <20210810173004.184959769@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810173000.928681411@linuxfoundation.org>
References: <20210810173000.928681411@linuxfoundation.org>
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
@@ -5355,7 +5355,7 @@ EXPORT_SYMBOL_GPL(tcpm_pd_hard_reset);
 void tcpm_sink_frs(struct tcpm_port *port)
 {
 	spin_lock(&port->pd_event_lock);
-	port->pd_events = TCPM_FRS_EVENT;
+	port->pd_events |= TCPM_FRS_EVENT;
 	spin_unlock(&port->pd_event_lock);
 	kthread_queue_work(port->wq, &port->event_work);
 }
@@ -5364,7 +5364,7 @@ EXPORT_SYMBOL_GPL(tcpm_sink_frs);
 void tcpm_sourcing_vbus(struct tcpm_port *port)
 {
 	spin_lock(&port->pd_event_lock);
-	port->pd_events = TCPM_SOURCING_VBUS;
+	port->pd_events |= TCPM_SOURCING_VBUS;
 	spin_unlock(&port->pd_event_lock);
 	kthread_queue_work(port->wq, &port->event_work);
 }


