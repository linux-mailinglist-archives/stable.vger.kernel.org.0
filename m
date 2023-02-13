Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3F3E694A47
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 16:06:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231344AbjBMPGA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 10:06:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231414AbjBMPF6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 10:05:58 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 749751DB8A
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 07:05:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C50EDCE1B87
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 15:05:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1A5CC433D2;
        Mon, 13 Feb 2023 15:05:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676300749;
        bh=oq8qQtisxYxtgHO757OSD10qHlGvZcN+0TslBnYqKyo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=spZgOCUoKOQl+9PJtwjAhOQRtlOWHa+21KjrIc5izN98y5L6pcgDwlPKpwrcmuRsa
         o0/XpkJVC0e5ZKM01qo0rTQkT7vQZjokYiGQxZcZrlFMXFWNpIvcXlZqypoLqRtCh4
         jfxNzpfLY5DpmMiJ0sjR93FVnCO4cEa4ixJqLtnI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Devid Antonio Filoni <devid.filoni@egluetechnologies.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.10 105/139] can: j1939: do not wait 250 ms if the same addr was already claimed
Date:   Mon, 13 Feb 2023 15:50:50 +0100
Message-Id: <20230213144751.409601581@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144745.696901179@linuxfoundation.org>
References: <20230213144745.696901179@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Devid Antonio Filoni <devid.filoni@egluetechnologies.com>

commit 4ae5e1e97c44f4654516c1d41591a462ed62fa7b upstream.

The ISO 11783-5 standard, in "4.5.2 - Address claim requirements", states:
  d) No CF shall begin, or resume, transmission on the network until 250
     ms after it has successfully claimed an address except when
     responding to a request for address-claimed.

But "Figure 6" and "Figure 7" in "4.5.4.2 - Address-claim
prioritization" show that the CF begins the transmission after 250 ms
from the first AC (address-claimed) message even if it sends another AC
message during that time window to resolve the address contention with
another CF.

As stated in "4.4.2.3 - Address-claimed message":
  In order to successfully claim an address, the CF sending an address
  claimed message shall not receive a contending claim from another CF
  for at least 250 ms.

As stated in "4.4.3.2 - NAME management (NM) message":
  1) A commanding CF can
     d) request that a CF with a specified NAME transmit the address-
        claimed message with its current NAME.
  2) A target CF shall
     d) send an address-claimed message in response to a request for a
        matching NAME

Taking the above arguments into account, the 250 ms wait is requested
only during network initialization.

Do not restart the timer on AC message if both the NAME and the address
match and so if the address has already been claimed (timer has expired)
or the AC message has been sent to resolve the contention with another
CF (timer is still running).

Signed-off-by: Devid Antonio Filoni <devid.filoni@egluetechnologies.com>
Acked-by: Oleksij Rempel <o.rempel@pengutronix.de>
Link: https://lore.kernel.org/all/20221125170418.34575-1-devid.filoni@egluetechnologies.com
Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
Cc: stable@vger.kernel.org
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/can/j1939/address-claim.c |   40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

--- a/net/can/j1939/address-claim.c
+++ b/net/can/j1939/address-claim.c
@@ -165,6 +165,46 @@ static void j1939_ac_process(struct j193
 	 * leaving this function.
 	 */
 	ecu = j1939_ecu_get_by_name_locked(priv, name);
+
+	if (ecu && ecu->addr == skcb->addr.sa) {
+		/* The ISO 11783-5 standard, in "4.5.2 - Address claim
+		 * requirements", states:
+		 *   d) No CF shall begin, or resume, transmission on the
+		 *      network until 250 ms after it has successfully claimed
+		 *      an address except when responding to a request for
+		 *      address-claimed.
+		 *
+		 * But "Figure 6" and "Figure 7" in "4.5.4.2 - Address-claim
+		 * prioritization" show that the CF begins the transmission
+		 * after 250 ms from the first AC (address-claimed) message
+		 * even if it sends another AC message during that time window
+		 * to resolve the address contention with another CF.
+		 *
+		 * As stated in "4.4.2.3 - Address-claimed message":
+		 *   In order to successfully claim an address, the CF sending
+		 *   an address claimed message shall not receive a contending
+		 *   claim from another CF for at least 250 ms.
+		 *
+		 * As stated in "4.4.3.2 - NAME management (NM) message":
+		 *   1) A commanding CF can
+		 *      d) request that a CF with a specified NAME transmit
+		 *         the address-claimed message with its current NAME.
+		 *   2) A target CF shall
+		 *      d) send an address-claimed message in response to a
+		 *         request for a matching NAME
+		 *
+		 * Taking the above arguments into account, the 250 ms wait is
+		 * requested only during network initialization.
+		 *
+		 * Do not restart the timer on AC message if both the NAME and
+		 * the address match and so if the address has already been
+		 * claimed (timer has expired) or the AC message has been sent
+		 * to resolve the contention with another CF (timer is still
+		 * running).
+		 */
+		goto out_ecu_put;
+	}
+
 	if (!ecu && j1939_address_is_unicast(skcb->addr.sa))
 		ecu = j1939_ecu_create_locked(priv, name);
 


