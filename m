Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58EFD3C2E64
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:27:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233344AbhGJC06 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:26:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:43192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233266AbhGJC0b (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:26:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 622D8613EE;
        Sat, 10 Jul 2021 02:23:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625883824;
        bh=wVFWZjD32RCEOXrQYqbhnw7dQOnDS4glSrjrbV4SPHo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XF/Xz+Dmweuf/emnq/LdQPZPYr5GdWtW1v/wywEIAioznrBBgg1Rg6Ks1wFyL2tJM
         nW5bRopze2jTPa6d87Dx02T9HpHE3tTpqyMWti0TpimqsjylnAbjDz29FyO0+3I4O2
         00R3+O00W9xOxMBkbgu5GPN6QvBtFckCafewxyXig1yw6Hi16TT+kzoR83GkemrnZj
         9fFXSgL4tTGa5eGuvJtncJHCbVP0W+Oj+ebbzW2FG33CbT5HgqUfQjbcTL8lcboldn
         aKDbIbfkdkiTxF/8MY11sQBGv9WTdFQNWDfBOUZepUoc6cAbZbMf0eh3STvwv7tJfu
         AjRZ9GrtEST/w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mathias Nyman <mathias.nyman@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 072/104] xhci: handle failed buffer copy to URB sg list and fix a W=1 copiler warning
Date:   Fri,  9 Jul 2021 22:21:24 -0400
Message-Id: <20210710022156.3168825-72-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710022156.3168825-1-sashal@kernel.org>
References: <20210710022156.3168825-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 0d2f1c37ab74..73cdaa3f3067 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -1362,12 +1362,17 @@ static void xhci_unmap_temp_buf(struct usb_hcd *hcd, struct urb *urb)
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

