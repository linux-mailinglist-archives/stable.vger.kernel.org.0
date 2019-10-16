Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62200DA00A
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:24:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404708AbfJPWHT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 18:07:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:51606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406690AbfJPV6O (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:58:14 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B2C0921928;
        Wed, 16 Oct 2019 21:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571263092;
        bh=hFaSuMMtLqZ7dMbrUvxByma5TWhJWl68+RXBc3wEyL0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WTbyRA6io6leGUumT9tq0W/wBhJuxk7dGESlN44DrX51Z8ggrqXVCNwE0Gc0pBJoC
         kVkz6MLMCb1OsRZ5QCga5Jo0a1Xyz52Gp89oJY0Pn6kWKmvdijceF75beYPREusx9V
         R+MVLPlYj2Rlt0VMn1bF7pwtsxv4PI9ODVYV5cVs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 5.3 014/112] xhci: Fix NULL pointer dereference in xhci_clear_tt_buffer_complete()
Date:   Wed, 16 Oct 2019 14:50:06 -0700
Message-Id: <20191016214847.698593207@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016214844.038848564@linuxfoundation.org>
References: <20191016214844.038848564@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mathias Nyman <mathias.nyman@linux.intel.com>

commit cfbb8a84c2d2ef49bccacb511002bca4f6053555 upstream.

udev stored in ep->hcpriv might be NULL if tt buffer is cleared
due to a halted control endpoint during device enumeration

xhci_clear_tt_buffer_complete is called by hub_tt_work() once it's
scheduled,  and by then usb core might have freed and allocated a
new udev for the next enumeration attempt.

Fixes: ef513be0a905 ("usb: xhci: Add Clear_TT_Buffer")
Cc: <stable@vger.kernel.org> # v5.3
Reported-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/1570190373-30684-9-git-send-email-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/xhci.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -5237,8 +5237,16 @@ static void xhci_clear_tt_buffer_complet
 	unsigned int ep_index;
 	unsigned long flags;
 
+	/*
+	 * udev might be NULL if tt buffer is cleared during a failed device
+	 * enumeration due to a halted control endpoint. Usb core might
+	 * have allocated a new udev for the next enumeration attempt.
+	 */
+
 	xhci = hcd_to_xhci(hcd);
 	udev = (struct usb_device *)ep->hcpriv;
+	if (!udev)
+		return;
 	slot_id = udev->slot_id;
 	ep_index = xhci_get_endpoint_index(&ep->desc);
 


