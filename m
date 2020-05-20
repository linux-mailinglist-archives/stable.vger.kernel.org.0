Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E893C1DB6E8
	for <lists+stable@lfdr.de>; Wed, 20 May 2020 16:28:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727063AbgETO2O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 May 2020 10:28:14 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:32880 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726933AbgETOWZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 May 2020 10:22:25 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jbPbv-00035g-B6; Wed, 20 May 2020 15:22:19 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jbPbu-007DQF-QX; Wed, 20 May 2020 15:22:18 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Kalle Valo" <kvalo@codeaurora.org>,
        "Navid Emamdoost" <navid.emamdoost@gmail.com>
Date:   Wed, 20 May 2020 15:13:58 +0100
Message-ID: <lsq.1589984008.28533969@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 30/99] brcmfmac: Fix memory leak in brcmf_usbdev_qinit
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

From: Navid Emamdoost <navid.emamdoost@gmail.com>

commit 4282dc057d750c6a7dd92953564b15c26b54c22c upstream.

In the implementation of brcmf_usbdev_qinit() the allocated memory for
reqs is leaking if usb_alloc_urb() fails. Release reqs in the error
handling path.

Fixes: 71bb244ba2fd ("brcm80211: fmac: add USB support for bcm43235/6/8 chipsets")
Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/brcm80211/brcmfmac/usb.c | 1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/wireless/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
@@ -365,6 +365,7 @@ fail:
 			usb_free_urb(req->urb);
 		list_del(q->next);
 	}
+	kfree(reqs);
 	return NULL;
 
 }

