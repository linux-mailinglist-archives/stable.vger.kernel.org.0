Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E09753A642A
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:19:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234972AbhFNLVN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:21:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:45866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235803AbhFNLTg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:19:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 197E661988;
        Mon, 14 Jun 2021 10:51:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667880;
        bh=kbxxd7nqoz8CxICtuZQ96bLBcJqebX66O3PCGblxZWc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YaZwFx2q5595Jw7aJTp/zYqcAbTNBeIhTCSy0Gc/JplV2UD75At1OI161G8e9/GfF
         N5QlFd3pZRhNZ2ZGXRZGs787USKt2rKjDrFLFs++BccDmFg/EnegcFry6229xMjR5s
         YQaLdfDrCghZCbv5s1v6kc2BrYd5XUEpbjpsoX1A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Li Jun <jun.li@nxp.com>
Subject: [PATCH 5.12 111/173] usb: typec: tcpm: cancel frs hrtimer when unregister tcpm port
Date:   Mon, 14 Jun 2021 12:27:23 +0200
Message-Id: <20210614102701.858860025@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102658.137943264@linuxfoundation.org>
References: <20210614102658.137943264@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Li Jun <jun.li@nxp.com>

commit 7ade4805e296c8d1e40c842395bbe478c7210555 upstream.

Like the state_machine_timer, we should also cancel possible pending
frs hrtimer when unregister tcpm port.

Fixes: 8dc4bd073663 ("usb: typec: tcpm: Add support for Sink Fast Role SWAP(FRS)")
Cc: stable <stable@vger.kernel.org>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Li Jun <jun.li@nxp.com>
Link: https://lore.kernel.org/r/1622627829-11070-2-git-send-email-jun.li@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/tcpm.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -6228,6 +6228,7 @@ void tcpm_unregister_port(struct tcpm_po
 {
 	int i;
 
+	hrtimer_cancel(&port->enable_frs_timer);
 	hrtimer_cancel(&port->vdm_state_machine_timer);
 	hrtimer_cancel(&port->state_machine_timer);
 


