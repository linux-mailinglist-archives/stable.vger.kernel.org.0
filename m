Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9529C2A5229
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 21:48:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731327AbgKCUrV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:47:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:37532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731319AbgKCUrT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:47:19 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F24520719;
        Tue,  3 Nov 2020 20:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436437;
        bh=KR4QHxH+a9sW1U1meUBzdRbpsUwIwQoe5pCg9PWyj+o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w2okzq709P8+ZEuDifn+f9cvpTYaS5xBlaZzvrbHMsAyBCpH9nxp8l48aYAC/ZhzT
         VvjhXcalcK5rKFy2ChNhiDfneN/z1+R6Fs18v0jo3vizE9s3gYk6/BX6HJKGoXHeYr
         sKC2lRlCbceFEKCpPt+mTDTvUXw6qIV2u3CACZpc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Li Jun <jun.li@nxp.com>, ChiYuan Huang <cy_huang@richtek.com>
Subject: [PATCH 5.9 249/391] usb: typec: tcpm: reset hard_reset_count for any disconnect
Date:   Tue,  3 Nov 2020 21:35:00 +0100
Message-Id: <20201103203403.816258131@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Li Jun <jun.li@nxp.com>

commit 2d9c6442a9c81f4f8dee678d0b3c183173ab1e2d upstream.

Current tcpm_detach() only reset hard_reset_count if port->attached
is true, this may cause this counter clear is missed if the CC
disconnect event is generated after tcpm_port_reset() is done
by other events, e.g. VBUS off comes first before CC disconect for
a power sink, in that case the first tcpm_detach() will only clear
port->attached flag but leave hard_reset_count there because
tcpm_port_is_disconnected() is still false, then later tcpm_detach()
by CC disconnect will directly return due to port->attached is cleared,
finally this will result tcpm will not try hard reset or error recovery
for later attach.

ChiYuan reported this issue on his platform with below tcpm trace:
After power sink session setup after hard reset 2 times, detach
from the power source and then attach:
[ 4848.046358] VBUS off
[ 4848.046384] state change SNK_READY -> SNK_UNATTACHED
[ 4848.050908] Setting voltage/current limit 0 mV 0 mA
[ 4848.050936] polarity 0
[ 4848.052593] Requesting mux state 0, usb-role 0, orientation 0
[ 4848.053222] Start toggling
[ 4848.086500] state change SNK_UNATTACHED -> TOGGLING
[ 4848.089983] CC1: 0 -> 0, CC2: 3 -> 3 [state TOGGLING, polarity 0, connected]
[ 4848.089993] state change TOGGLING -> SNK_ATTACH_WAIT
[ 4848.090031] pending state change SNK_ATTACH_WAIT -> SNK_DEBOUNCED @200 ms
[ 4848.141162] CC1: 0 -> 0, CC2: 3 -> 0 [state SNK_ATTACH_WAIT, polarity 0, disconnected]
[ 4848.141170] state change SNK_ATTACH_WAIT -> SNK_ATTACH_WAIT
[ 4848.141184] pending state change SNK_ATTACH_WAIT -> SNK_UNATTACHED @20 ms
[ 4848.163156] state change SNK_ATTACH_WAIT -> SNK_UNATTACHED [delayed 20 ms]
[ 4848.163162] Start toggling
[ 4848.216918] CC1: 0 -> 0, CC2: 0 -> 3 [state TOGGLING, polarity 0, connected]
[ 4848.216954] state change TOGGLING -> SNK_ATTACH_WAIT
[ 4848.217080] pending state change SNK_ATTACH_WAIT -> SNK_DEBOUNCED @200 ms
[ 4848.231771] CC1: 0 -> 0, CC2: 3 -> 0 [state SNK_ATTACH_WAIT, polarity 0, disconnected]
[ 4848.231800] state change SNK_ATTACH_WAIT -> SNK_ATTACH_WAIT
[ 4848.231857] pending state change SNK_ATTACH_WAIT -> SNK_UNATTACHED @20 ms
[ 4848.256022] state change SNK_ATTACH_WAIT -> SNK_UNATTACHED [delayed20 ms]
[ 4848.256049] Start toggling
[ 4848.871148] VBUS on
[ 4848.885324] CC1: 0 -> 0, CC2: 0 -> 3 [state TOGGLING, polarity 0, connected]
[ 4848.885372] state change TOGGLING -> SNK_ATTACH_WAIT
[ 4848.885548] pending state change SNK_ATTACH_WAIT -> SNK_DEBOUNCED @200 ms
[ 4849.088240] state change SNK_ATTACH_WAIT -> SNK_DEBOUNCED [delayed200 ms]
[ 4849.088284] state change SNK_DEBOUNCED -> SNK_ATTACHED
[ 4849.088291] polarity 1
[ 4849.088769] Requesting mux state 1, usb-role 2, orientation 2
[ 4849.088895] state change SNK_ATTACHED -> SNK_STARTUP
[ 4849.088907] state change SNK_STARTUP -> SNK_DISCOVERY
[ 4849.088915] Setting voltage/current limit 5000 mV 0 mA
[ 4849.088927] vbus=0 charge:=1
[ 4849.090505] state change SNK_DISCOVERY -> SNK_WAIT_CAPABILITIES
[ 4849.090828] pending state change SNK_WAIT_CAPABILITIES -> SNK_READY @240 ms
[ 4849.335878] state change SNK_WAIT_CAPABILITIES -> SNK_READY [delayed240 ms]

this patch fix this issue by clear hard_reset_count at any cases
of cc disconnect, í.e. don't check port->attached flag.

Fixes: 4b4e02c83167 ("typec: tcpm: Move out of staging")
Cc: stable@vger.kernel.org
Reported-and-tested-by: ChiYuan Huang <cy_huang@richtek.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Li Jun <jun.li@nxp.com>
Link: https://lore.kernel.org/r/1602500592-3817-1-git-send-email-jun.li@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/typec/tcpm/tcpm.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -2789,6 +2789,9 @@ static void tcpm_reset_port(struct tcpm_
 
 static void tcpm_detach(struct tcpm_port *port)
 {
+	if (tcpm_port_is_disconnected(port))
+		port->hard_reset_count = 0;
+
 	if (!port->attached)
 		return;
 
@@ -2797,9 +2800,6 @@ static void tcpm_detach(struct tcpm_port
 		port->tcpc->set_bist_data(port->tcpc, false);
 	}
 
-	if (tcpm_port_is_disconnected(port))
-		port->hard_reset_count = 0;
-
 	tcpm_reset_port(port);
 }
 


