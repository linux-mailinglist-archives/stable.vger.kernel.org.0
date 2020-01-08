Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D8CA134BFF
	for <lists+stable@lfdr.de>; Wed,  8 Jan 2020 20:49:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728252AbgAHTs6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jan 2020 14:48:58 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43602 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730437AbgAHTqD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jan 2020 14:46:03 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ipHHD-0006p2-FO; Wed, 08 Jan 2020 19:45:59 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1ipHHC-007dnZ-Hy; Wed, 08 Jan 2020 19:45:58 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Amit Pundir" <amit.pundir@linaro.org>,
        "Arnd Bergmann" <arnd@arndb.de>, "Xerox Lin" <xerox_lin@htc.com>,
        "Rajkumar Raghupathy" <raghup@codeaurora.org>,
        "Felipe Balbi" <felipe.balbi@linux.intel.com>
Date:   Wed, 08 Jan 2020 19:43:37 +0000
Message-ID: <lsq.1578512578.927773857@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 39/63] usb: gadget: rndis: free response queue during
 REMOTE_NDIS_RESET_MSG
In-Reply-To: <lsq.1578512578.117275639@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.81-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Xerox Lin <xerox_lin@htc.com>

commit 207707d8fd48ebc977fb2b2794004a020e1ee08e upstream.

When rndis data transfer is in progress, some Windows7 Host PC is not
sending the GET_ENCAPSULATED_RESPONSE command for receiving the response
for the previous SEND_ENCAPSULATED_COMMAND processed.

The rndis function driver appends each response for the
SEND_ENCAPSULATED_COMMAND in a queue. As the above process got corrupted,
the Host sends a REMOTE_NDIS_RESET_MSG command to do a soft-reset.
As the rndis response queue is not freed, the previous response is sent
as a part of this REMOTE_NDIS_RESET_MSG's reset response and the Host
block any more Rndis transfers.

Hence free the rndis response queue as a part of this soft-reset so that
the correct response for REMOTE_NDIS_RESET_MSG is sent properly during the
response command.

Signed-off-by: Rajkumar Raghupathy <raghup@codeaurora.org>
Signed-off-by: Xerox Lin <xerox_lin@htc.com>
[AmitP: Cherry-picked this patch and folded other relevant
        fixes from Android common kernel android-4.4]
Signed-off-by: Amit Pundir <amit.pundir@linaro.org>
Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>
[bwh: Backported to 3.16:
 - Pass configNr instead of params as first argument to
   rndis_{get_next,free}_response()
 - Adjust filename, context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/gadget/rndis.c | 6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/usb/gadget/rndis.c
+++ b/drivers/usb/gadget/rndis.c
@@ -686,6 +686,12 @@ static int rndis_reset_response(int conf
 	rndis_reset_cmplt_type *resp;
 	rndis_resp_t *r;
 	struct rndis_params *params = rndis_per_dev_params + configNr;
+	u8 *xbuf;
+	u32 length;
+
+	/* drain the response queue */
+	while ((xbuf = rndis_get_next_response(configNr, &length)))
+		rndis_free_response(configNr, xbuf);
 
 	r = rndis_add_response(configNr, sizeof(rndis_reset_cmplt_type));
 	if (!r)

