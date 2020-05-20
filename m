Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2734D1DB6D9
	for <lists+stable@lfdr.de>; Wed, 20 May 2020 16:28:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727801AbgETO15 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 May 2020 10:27:57 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:32912 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726948AbgETOW0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 May 2020 10:22:26 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jbPbv-00035j-M8; Wed, 20 May 2020 15:22:19 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jbPbu-007DPv-LX; Wed, 20 May 2020 15:22:18 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Johan Hovold" <johan@kernel.org>,
        "Arend van Spriel" <arend@broadcom.com>,
        "Kalle Valo" <kvalo@codeaurora.org>
Date:   Wed, 20 May 2020 15:13:54 +0100
Message-ID: <lsq.1589984008.243525296@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 26/99] brcmfmac: fix interface sanity check
In-Reply-To: <lsq.1589984008.673931885@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.84-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 3428fbcd6e6c0850b1a8b2a12082b7b2aabb3da3 upstream.

Make sure to use the current alternate setting when verifying the
interface descriptors to avoid binding to an invalid interface.

Failing to do so could cause the driver to misbehave or trigger a WARN()
in usb_submit_urb() that kernels with panic_on_warn set would choke on.

Fixes: 71bb244ba2fd ("brcm80211: fmac: add USB support for bcm43235/6/8 chipsets")
Cc: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
[bwh: Backported to 3.16:
 - Altsetting lookup is done by the IFALTS() macro
 - Adjust filename]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/drivers/net/wireless/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
@@ -41,7 +41,7 @@
 
 #define CONFIGDESC(usb)         (&((usb)->actconfig)->desc)
 #define IFPTR(usb, idx)         ((usb)->actconfig->interface[(idx)])
-#define IFALTS(usb, idx)        (IFPTR((usb), (idx))->altsetting[0])
+#define IFALTS(usb, idx)        (*IFPTR((usb), (idx))->cur_altsetting)
 #define IFDESC(usb, idx)        IFALTS((usb), (idx)).desc
 #define IFEPDESC(usb, idx, ep)  (IFALTS((usb), (idx)).endpoint[(ep)]).desc
 

