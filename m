Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8564E429020
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 16:04:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237173AbhJKOF0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:05:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:49348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238059AbhJKOCA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 10:02:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C63A960FD7;
        Mon, 11 Oct 2021 13:57:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960666;
        bh=Z28H7KHsrJ1XwtZGBXP15YQurWcfpEoEhxnJbXv+iTo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q059gsrv8SRDtSSpYwiTHn08/AFnlUaaBIab1Z7yBhwJxgbP4RSJVcB9pWB1v1j7x
         +Q/FDFPVsaVK62r/d8LaF2d9LZSaSsFMplo7WscllsEiLH76zB35zrEkbXMVtnQV8c
         u+oPGHDn2qdjLLluoJpstijdYhSQOKPy86VEX5Ws=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Xu Yang <xu.yang_2@nxp.com>
Subject: [PATCH 5.14 007/151] usb: typec: tcpci: dont handle vSafe0V event if its not enabled
Date:   Mon, 11 Oct 2021 15:44:39 +0200
Message-Id: <20211011134518.080286876@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134517.833565002@linuxfoundation.org>
References: <20211011134517.833565002@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xu Yang <xu.yang_2@nxp.com>

commit 05300871c0e21c288bd5c30ac6f9b1da6ddeed22 upstream.

USB TCPCI Spec, 4.4.3 Mask Registers:
"A masked register will still indicate in the ALERT register, but shall
not set the Alert# pin low."

Thus, the Extended Status will still indicate in ALERT register if vSafe0V
is detected by TCPC even though being masked. In current code, howerer,
this event will not be handled in detection time. Rather it will be
handled when next ALERT event coming(CC evnet, PD event, etc).

Tcpm might transition to a wrong state in this situation. Thus, the vSafe0V
event should not be handled when it's masked.

Fixes: 766c485b86ef ("usb: typec: tcpci: Add support to report vSafe0V")
cc: <stable@vger.kernel.org>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Xu Yang <xu.yang_2@nxp.com>
Link: https://lore.kernel.org/r/20210926101415.3775058-1-xu.yang_2@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/tcpci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/typec/tcpm/tcpci.c
+++ b/drivers/usb/typec/tcpm/tcpci.c
@@ -696,7 +696,7 @@ irqreturn_t tcpci_irq(struct tcpci *tcpc
 		tcpm_pd_receive(tcpci->port, &msg);
 	}
 
-	if (status & TCPC_ALERT_EXTENDED_STATUS) {
+	if (tcpci->data->vbus_vsafe0v && (status & TCPC_ALERT_EXTENDED_STATUS)) {
 		ret = regmap_read(tcpci->regmap, TCPC_EXTENDED_STATUS, &raw);
 		if (!ret && (raw & TCPC_EXTENDED_STATUS_VSAFE0V))
 			tcpm_vbus_change(tcpci->port);


