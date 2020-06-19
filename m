Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 338FB200CFA
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 16:53:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389526AbgFSOwE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 10:52:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:45712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389152AbgFSOv4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 10:51:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0F64621852;
        Fri, 19 Jun 2020 14:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592578316;
        bh=tQhxigQbmQOKnMbx5j51NiN66GZ0gOKoylnatGUazao=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hVs6o9wPAcFH1EaxOYuS/cEc99+wWuzbo+B9KgzaEz4dRVIBh43IUu4I3DY/AI25J
         Z1I1RWb5W55OM/BQ22kEsVwHaHHJmQD5jMbd2bvau7rki/M8dHUe2WPHdIiilLdM7A
         KnMO5GFAZR+6MwTH4psUjM/LgMpdqxFMcA5l3c/I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Larry Finger <Larry.Finger@lwfinger.net>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 4.14 167/190] b43legacy: Fix case where channel status is corrupted
Date:   Fri, 19 Jun 2020 16:33:32 +0200
Message-Id: <20200619141642.121194934@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141633.446429600@linuxfoundation.org>
References: <20200619141633.446429600@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Larry Finger <Larry.Finger@lwfinger.net>

commit ec4d3e3a054578de34cd0b587ab8a1ac36f629d9 upstream.

This patch fixes commit 75388acd0cd8 ("add mac80211-based driver for
legacy BCM43xx devices")

In https://bugzilla.kernel.org/show_bug.cgi?id=207093, a defect in
b43legacy is reported. Upon testing, thus problem exists on PPC and
X86 platforms, is present in the oldest kernel tested (3.2), and
has been present in the driver since it was first added to the kernel.

The problem is a corrupted channel status received from the device.
Both the internal card in a PowerBook G4 and the PCMCIA version
(Broadcom BCM4306 with PCI ID 14e4:4320) have the problem. Only Rev, 2
(revision 4 of the 802.11 core) of the chip has been tested. No other
devices using b43legacy are available for testing.

Various sources of the problem were considered. Buffer overrun and
other sources of corruption within the driver were rejected because
the faulty channel status is always the same, not a random value.
It was concluded that the faulty data is coming from the device, probably
due to a firmware bug. As that source is not available, the driver
must take appropriate action to recover.

At present, the driver reports the error, and them continues to process
the bad packet. This is believed that to be a mistake, and the correct
action is to drop the correpted packet.

Fixes: 75388acd0cd8 ("add mac80211-based driver for legacy BCM43xx devices")
Cc: Stable <stable@vger.kernel.org>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Reported-and-tested by: F. Erhard <erhard_f@mailbox.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20200407190043.1686-1-Larry.Finger@lwfinger.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/broadcom/b43legacy/xmit.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/wireless/broadcom/b43legacy/xmit.c
+++ b/drivers/net/wireless/broadcom/b43legacy/xmit.c
@@ -571,6 +571,7 @@ void b43legacy_rx(struct b43legacy_wldev
 	default:
 		b43legacywarn(dev->wl, "Unexpected value for chanstat (0x%X)\n",
 		       chanstat);
+		goto drop;
 	}
 
 	memcpy(IEEE80211_SKB_RXCB(skb), &status, sizeof(status));


