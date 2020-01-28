Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49C2014B739
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:12:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728119AbgA1OM1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:12:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:33708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728692AbgA1OM0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:12:26 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D8AC24688;
        Tue, 28 Jan 2020 14:12:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580220745;
        bh=3l9KYTvOjFvT1VGu3SQ+LVA+swFkY/dGrLC8yjQouQw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0t2cqkD7m6l91pNwoMUCWT426klwnqOp4/GY+NNwyCrqcwb0KO/h3QBorWcwkGwtt
         /6jD49vr3dwQEBcrmdHjpnk4KDOFm3sTCo9EFHwuhOupQpPmU+QxKP+91aiHx9qXLO
         HTyGErzRkZhae0QustpPu1o7AIHQike4+E4F0NZk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Ruslan Bilovol <ruslan.bilovol@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 113/183] usb: host: xhci-hub: fix extra endianness conversion
Date:   Tue, 28 Jan 2020 15:05:32 +0100
Message-Id: <20200128135841.214448678@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135829.486060649@linuxfoundation.org>
References: <20200128135829.486060649@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ruslan Bilovol <ruslan.bilovol@gmail.com>

[ Upstream commit 6269e4c76eacabaea0d0099200ae1a455768d208 ]

Don't do extra cpu_to_le32 conversion for
put_unaligned_le32 because it is already implemented
in this function.

Fixes sparse error:
xhci-hub.c:1152:44: warning: incorrect type in argument 1 (different base types)
xhci-hub.c:1152:44:    expected unsigned int [usertype] val
xhci-hub.c:1152:44:    got restricted __le32 [usertype]

Fixes: 395f540 "xhci: support new USB 3.1 hub request to get extended port status"
Cc: Mathias Nyman <mathias.nyman@linux.intel.com>
Signed-off-by: Ruslan Bilovol <ruslan.bilovol@gmail.com>
Link: https://lore.kernel.org/r/1562501839-26522-1-git-send-email-ruslan.bilovol@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-hub.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci-hub.c b/drivers/usb/host/xhci-hub.c
index 40c95ed6afbf6..3ef80c2c0dcc1 100644
--- a/drivers/usb/host/xhci-hub.c
+++ b/drivers/usb/host/xhci-hub.c
@@ -965,7 +965,7 @@ int xhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 			}
 			port_li = readl(port_array[wIndex] + PORTLI);
 			status = xhci_get_ext_port_status(temp, port_li);
-			put_unaligned_le32(cpu_to_le32(status), &buf[4]);
+			put_unaligned_le32(status, &buf[4]);
 		}
 		break;
 	case SetPortFeature:
-- 
2.20.1



