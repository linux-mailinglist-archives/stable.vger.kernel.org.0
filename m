Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05B01360D88
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 17:03:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234445AbhDOPD1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 11:03:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:45910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234697AbhDOO7a (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Apr 2021 10:59:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 753F4613ED;
        Thu, 15 Apr 2021 14:55:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618498536;
        bh=9SPFnlefxA4sG0tRri1VW5BiYlozgyxK5kXcLW47EMU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k4ITq/vFu0XKRsDgSYGua7bfa5KiNwXoPAacY37+2UPPpED+38+Ar28JjM9IRzmq/
         lSdM789GNyLet+oWWbB3Ak8V7sOKo8Q3zZPu/HAo4C8rfHy2Dd7DtD5bbMoXbXh+2G
         wDvGXgKoyo/yxAOr1cI/23S3DCKY2koAj33J0oPw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Juergen Gross <jgross@suse.com>
Subject: [PATCH 4.14 68/68] xen/events: fix setting irq affinity
Date:   Thu, 15 Apr 2021 16:47:49 +0200
Message-Id: <20210415144416.708440064@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210415144414.464797272@linuxfoundation.org>
References: <20210415144414.464797272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Juergen Gross <jgross@suse.com>

The backport of upstream patch 25da4618af240fbec61 ("xen/events: don't
unmask an event channel when an eoi is pending") introduced a
regression for stable kernels 5.10 and older: setting IRQ affinity for
IRQs related to interdomain events would no longer work, as moving the
IRQ to its new cpu was not included in the irq_ack callback for those
events.

Fix that by adding the needed call.

Note that kernels 5.11 and later don't need the explicit moving of the
IRQ to the target cpu in the irq_ack callback, due to a rework of the
affinity setting in kernel 5.11.

Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/xen/events/events_base.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/xen/events/events_base.c
+++ b/drivers/xen/events/events_base.c
@@ -1782,7 +1782,7 @@ static void lateeoi_ack_dynirq(struct ir
 
 	if (VALID_EVTCHN(evtchn)) {
 		do_mask(info, EVT_MASK_REASON_EOI_PENDING);
-		event_handler_exit(info);
+		ack_dynirq(data);
 	}
 }
 
@@ -1793,7 +1793,7 @@ static void lateeoi_mask_ack_dynirq(stru
 
 	if (VALID_EVTCHN(evtchn)) {
 		do_mask(info, EVT_MASK_REASON_EXPLICIT);
-		event_handler_exit(info);
+		ack_dynirq(data);
 	}
 }
 


