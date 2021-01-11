Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D69E2F1487
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:27:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732486AbhAKNQq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:16:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:35320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732482AbhAKNQp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:16:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7D4D92251F;
        Mon, 11 Jan 2021 13:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370965;
        bh=mjw7k9PTZPm3lxBElJ4hbpVY0ZiMp9ZckBuLku1Jras=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qBS97qYC7Pz/j0rjKqCv3odoAFZNPo/JFRMM/QB535BzWeymQCI9bt9xZcRL0SbTu
         N2auGHRaQnn4mopiyQ8E0DXLwv002jXvKGKwPSpF8Oa1mO/wKbXtKrKpExY+6CxbhF
         Unzg8nAR/B17bP1arkoJj0fcxJn6F8swRd7IE2rk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Madhusudanarao Amara <madhusudanarao.amara@intel.com>
Subject: [PATCH 5.10 081/145] usb: typec: intel_pmc_mux: Configure HPD first for HPD+IRQ request
Date:   Mon, 11 Jan 2021 14:01:45 +0100
Message-Id: <20210111130052.421430582@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130048.499958175@linuxfoundation.org>
References: <20210111130048.499958175@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Madhusudanarao Amara <madhusudanarao.amara@intel.com>

commit 0f041b8592daaaea46e91a8ebb3b47e6e0171fd8 upstream.

Warm reboot scenarios some times type C Mux driver gets Mux configuration
request as HPD=1,IRQ=1. In that scenario typeC Mux driver need to configure
Mux as follows as per IOM requirement:
 (1). Confgiure Mux HPD = 1, IRQ = 0
 (2). Configure Mux with HPD = 1, IRQ = 1

IOM expects TypeC Mux configuration as follows:
 (1). HPD=1, IRQ=0
 (2). HPD=1, IRQ=1
if IOM gets mux config request (2) without configuring (1), it will ignore
the request. The impact of this is there is no DP_alt mode display.

Fixes: 43d596e32276 ("usb: typec: intel_pmc_mux: Check the port status before connect")
Cc: stable@vger.kernel.org
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Madhusudanarao Amara <madhusudanarao.amara@intel.com>
Link: https://lore.kernel.org/r/20201216140918.49197-1-madhusudanarao.amara@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/typec/mux/intel_pmc_mux.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/usb/typec/mux/intel_pmc_mux.c
+++ b/drivers/usb/typec/mux/intel_pmc_mux.c
@@ -202,10 +202,21 @@ static int
 pmc_usb_mux_dp_hpd(struct pmc_usb_port *port, struct typec_displayport_data *dp)
 {
 	u8 msg[2] = { };
+	int ret;
 
 	msg[0] = PMC_USB_DP_HPD;
 	msg[0] |= port->usb3_port << PMC_USB_MSG_USB3_PORT_SHIFT;
 
+	/* Configure HPD first if HPD,IRQ comes together */
+	if (!IOM_PORT_HPD_ASSERTED(port->iom_status) &&
+	    dp->status & DP_STATUS_IRQ_HPD &&
+	    dp->status & DP_STATUS_HPD_STATE) {
+		msg[1] = PMC_USB_DP_HPD_LVL;
+		ret = pmc_usb_command(port, msg, sizeof(msg));
+		if (ret)
+			return ret;
+	}
+
 	if (dp->status & DP_STATUS_IRQ_HPD)
 		msg[1] = PMC_USB_DP_HPD_IRQ;
 


