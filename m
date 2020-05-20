Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A8D21DB6A9
	for <lists+stable@lfdr.de>; Wed, 20 May 2020 16:27:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728045AbgETO0a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 May 2020 10:26:30 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33008 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727009AbgETOW1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 May 2020 10:22:27 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jbPbv-00035c-FY; Wed, 20 May 2020 15:22:19 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jbPbu-007DPg-HT; Wed, 20 May 2020 15:22:18 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Siva Rebbagondla" <siva.rebbagondla@redpinesignals.com>,
        "Fariya Fatima" <fariyaf@gmail.com>,
        "Johan Hovold" <johan@kernel.org>,
        "Amitkumar Karwar" <amit.karwar@redpinesignals.com>,
        "Prameela Rani Garnepudi" <prameela.j04cs@gmail.com>,
        "Kalle Valo" <kvalo@codeaurora.org>,
        syzbot+b563b7f8dbe8223a51e8@syzkaller.appspotmail.com
Date:   Wed, 20 May 2020 15:13:51 +0100
Message-ID: <lsq.1589984008.54508774@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 23/99] rsi: fix use-after-free on failed probe and unbind
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

commit e93cd35101b61e4c79149be2cfc927c4b28dc60c upstream.

Make sure to stop both URBs before returning after failed probe as well
as on disconnect to avoid use-after-free in the completion handler.

Reported-by: syzbot+b563b7f8dbe8223a51e8@syzkaller.appspotmail.com
Fixes: a4302bff28e2 ("rsi: add bluetooth rx endpoint")
Fixes: dad0d04fa7ba ("rsi: Add RS9113 wireless driver")
Cc: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
Cc: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Cc: Amitkumar Karwar <amit.karwar@redpinesignals.com>
Cc: Fariya Fatima <fariyaf@gmail.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
[bwh: Backported to 3.16: There is no BT support, so we only need to
 kill one URB on disconnect.]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/drivers/net/wireless/rsi/rsi_91x_usb.c
+++ b/drivers/net/wireless/rsi/rsi_91x_usb.c
@@ -245,6 +245,14 @@ static void rsi_rx_done_handler(struct u
 	rsi_set_event(&dev->rx_thread.event);
 }
 
+static void rsi_rx_urb_kill(struct rsi_hw *adapter)
+{
+	struct rsi_91x_usbdev *dev = (struct rsi_91x_usbdev *)adapter->rsi_dev;
+	struct urb *urb = dev->rx_usb_urb[0];
+
+	usb_kill_urb(urb);
+}
+
 /**
  * rsi_rx_urb_submit() - This function submits the given URB to the USB stack.
  * @adapter: Pointer to the adapter structure.
@@ -510,6 +518,8 @@ static void rsi_disconnect(struct usb_in
 	if (!adapter)
 		return;
 
+	rsi_rx_urb_kill(adapter);
+
 	rsi_mac80211_detach(adapter);
 	rsi_deinit_usb_interface(adapter);
 	rsi_91x_deinit(adapter);

