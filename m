Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1332292C39
	for <lists+stable@lfdr.de>; Mon, 19 Oct 2020 19:03:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730962AbgJSRDa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Oct 2020 13:03:30 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:32886 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730921AbgJSRCr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Oct 2020 13:02:47 -0400
Date:   Mon, 19 Oct 2020 17:02:44 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1603126965;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rQPEhAKOQNmR8Qe2Z+vrAsDXOE5DX3hk4zXgPWd2vRU=;
        b=giRTdDgMw193aqNbCTM45VA3xRTtKnSoHuVF1BTkBx9TS0SX0P3t/4lVzE24/2+y+x2z0+
        CRSByfGiNK4qb/8uj691ez24UNSRfOuxPtmclTKAPR/0DTo1GhD5j79Er2h6I1fjRFghTZ
        luaAByx2Sn4T4kB4IvG1uddXCUq77893vOZxzKcss8vnXiPLkHLsY9RJ/K6tfD4GKKmuTi
        mVMLKowzJ+OhoHKDY8RHKfZvUQdZFP19o5O63EQT2qoOtxLJJPRgM1o+WUsY/Q+BaAplck
        Ojas2b6k6p38VTd1WnjHFrezcRSmLl1HjIDqa3XquroiS/A+mxRGo2bKx7jinQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1603126965;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rQPEhAKOQNmR8Qe2Z+vrAsDXOE5DX3hk4zXgPWd2vRU=;
        b=kYwB08rHdXbS8raICadUTdoktpPRlcqrvPIpeYh/nL/OiL6LCrLOHt/xNeJ3Yj1nxFLgUe
        nFy+KibCVYTISkCQ==
From:   "tip-bot2 for Anant Thazhemadam" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: perf/urgent] staging: comedi: check validity of wMaxPacketSize
 of usb endpoints found
Cc:     syzbot+009f546aa1370056b1c2@syzkaller.appspotmail.com,
        Anant Thazhemadam <anant.thazhemadam@gmail.com>,
        stable <stable@vger.kernel.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20201010082933.5417-1-anant.thazhemadam@gmail.com>
References: <20201010082933.5417-1-anant.thazhemadam@gmail.com>
MIME-Version: 1.0
Message-ID: <160312696435.7002.11176979799560597940.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the perf/urgent branch of tip:

Commit-ID:     38df15cb4ce149ce3648d2a9ccc0140afa71fc02
Gitweb:        https://git.kernel.org/tip/38df15cb4ce149ce3648d2a9ccc0140afa71fc02
Author:        Anant Thazhemadam <anant.thazhemadam@gmail.com>
AuthorDate:    Sat, 10 Oct 2020 13:59:32 +05:30
Committer:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CommitterDate: Sat, 17 Oct 2020 08:31:21 +02:00

staging: comedi: check validity of wMaxPacketSize of usb endpoints found

commit e1f13c879a7c21bd207dc6242455e8e3a1e88b40 upstream.

While finding usb endpoints in vmk80xx_find_usb_endpoints(), check if
wMaxPacketSize = 0 for the endpoints found.

Some devices have isochronous endpoints that have wMaxPacketSize = 0
(as required by the USB-2 spec).
However, since this doesn't apply here, wMaxPacketSize = 0 can be
considered to be invalid.

Reported-by: syzbot+009f546aa1370056b1c2@syzkaller.appspotmail.com
Tested-by: syzbot+009f546aa1370056b1c2@syzkaller.appspotmail.com
Signed-off-by: Anant Thazhemadam <anant.thazhemadam@gmail.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20201010082933.5417-1-anant.thazhemadam@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/comedi/drivers/vmk80xx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/staging/comedi/drivers/vmk80xx.c b/drivers/staging/comedi/drivers/vmk80xx.c
index 65dc6c5..7956abc 100644
--- a/drivers/staging/comedi/drivers/vmk80xx.c
+++ b/drivers/staging/comedi/drivers/vmk80xx.c
@@ -667,6 +667,9 @@ static int vmk80xx_find_usb_endpoints(struct comedi_device *dev)
 	if (!devpriv->ep_rx || !devpriv->ep_tx)
 		return -ENODEV;
 
+	if (!usb_endpoint_maxp(devpriv->ep_rx) || !usb_endpoint_maxp(devpriv->ep_tx))
+		return -EINVAL;
+
 	return 0;
 }
 
