Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92EFF3CE1F2
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:13:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346268AbhGSP2e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:28:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:43618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346588AbhGSP0F (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:26:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4B650610D0;
        Mon, 19 Jul 2021 16:06:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710803;
        bh=QPEGqWnvg/M9SOi9/WFAMyHyq0f1o69BZE92gvGfvec=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I4yt3oeTxcSPHQIJlM4DvJU+mYsKWzSW3Bw6S6n67IXtWo9vABwe/pbeZffr3qbOl
         qiUWlhxtciZyfdBTD17F3qz7b8Qe8A79XckZ+dCQGGNlYwD/NJTtnDiS0eSa72cLAW
         HOclvz58cQIyCo7qRBsdNbaPQ6XW2St97mw6r+NQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 114/351] xhci: handle failed buffer copy to URB sg list and fix a W=1 copiler warning
Date:   Mon, 19 Jul 2021 16:51:00 +0200
Message-Id: <20210719144948.251045457@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mathias Nyman <mathias.nyman@linux.intel.com>

[ Upstream commit 271a21d8b280b186f8cc9ca6f7151902efde9512 ]

Set the urb->actual_length to bytes successfully copied in case all bytes
weren't copied from a temporary buffer to the URB sg list.
Also print a debug message

Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20210617150354.1512157-4-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 27283654ca08..9248ce8d09a4 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -1361,12 +1361,17 @@ static void xhci_unmap_temp_buf(struct usb_hcd *hcd, struct urb *urb)
 				 urb->transfer_buffer_length,
 				 dir);
 
-	if (usb_urb_dir_in(urb))
+	if (usb_urb_dir_in(urb)) {
 		len = sg_pcopy_from_buffer(urb->sg, urb->num_sgs,
 					   urb->transfer_buffer,
 					   buf_len,
 					   0);
-
+		if (len != buf_len) {
+			xhci_dbg(hcd_to_xhci(hcd),
+				 "Copy from tmp buf to urb sg list failed\n");
+			urb->actual_length = len;
+		}
+	}
 	urb->transfer_flags &= ~URB_DMA_MAP_SINGLE;
 	kfree(urb->transfer_buffer);
 	urb->transfer_buffer = NULL;
-- 
2.30.2



