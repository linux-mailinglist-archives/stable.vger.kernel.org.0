Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3BBE450CF8
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:44:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238812AbhKORrb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:47:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:57922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238592AbhKORpF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:45:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 52CA061A56;
        Mon, 15 Nov 2021 17:28:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636997329;
        bh=QuXmE2lWvHc9LN3vPAq8z3LS+T6wmno+A635dT1cSOw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2c+L9u15/4rxM9MwrBMy0Selg3xzSmFYVmKJA+taK1v8faz7V5/6oUxTo84BZ/JGr
         5LGCJFKZYzFMg7X8n20vg45h8vhIaIM06DRvB8AQzBI1UWMYEspdbp/Ld1pxqMz9DI
         vDQ9sZ2gI/pDF+MEVSD+a3DNKMSJwgr8aS/pQ8LU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Jonas=20Dre=C3=9Fler?= <verdre@v0yd.nl>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 5.10 107/575] mwifiex: Read a PCI register after writing the TX ring write pointer
Date:   Mon, 15 Nov 2021 17:57:12 +0100
Message-Id: <20211115165347.361006477@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonas Dreßler <verdre@v0yd.nl>

commit e5f4eb8223aa740237cd463246a7debcddf4eda1 upstream.

On the 88W8897 PCIe+USB card the firmware randomly crashes after setting
the TX ring write pointer. The issue is present in the latest firmware
version 15.68.19.p21 of the PCIe+USB card.

Those firmware crashes can be worked around by reading any PCI register
of the card after setting that register, so read the PCI_VENDOR_ID
register here. The reason this works is probably because we keep the bus
from entering an ASPM state for a bit longer, because that's what causes
the cards firmware to crash.

This fixes a bug where during RX/TX traffic and with ASPM L1 substates
enabled (the specific substates where the issue happens appear to be
platform dependent), the firmware crashes and eventually a command
timeout appears in the logs.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=109681
Cc: stable@vger.kernel.org
Signed-off-by: Jonas Dreßler <verdre@v0yd.nl>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20211011133224.15561-2-verdre@v0yd.nl
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/marvell/mwifiex/pcie.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -1480,6 +1480,14 @@ mwifiex_pcie_send_data(struct mwifiex_ad
 			ret = -1;
 			goto done_unmap;
 		}
+
+		/* The firmware (latest version 15.68.19.p21) of the 88W8897 PCIe+USB card
+		 * seems to crash randomly after setting the TX ring write pointer when
+		 * ASPM powersaving is enabled. A workaround seems to be keeping the bus
+		 * busy by reading a random register afterwards.
+		 */
+		mwifiex_read_reg(adapter, PCI_VENDOR_ID, &rx_val);
+
 		if ((mwifiex_pcie_txbd_not_full(card)) &&
 		    tx_param->next_pkt_len) {
 			/* have more packets and TxBD still can hold more */


