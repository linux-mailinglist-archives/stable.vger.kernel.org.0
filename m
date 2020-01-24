Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46174148265
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:27:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391655AbgAXL1o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:27:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:43456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391661AbgAXL1n (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:27:43 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5BEA02075D;
        Fri, 24 Jan 2020 11:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579865263;
        bh=xWk2oEJWg+aEf/TJMfstF2XmROQRtAxpW4vgKbueuwc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KN5kCCmSAeacpd+iM7G29xcTzhKgj5nI495gyIejgIN26o1onEw83R9wuyjgiUzpf
         JQueJxQvoFlRJd6uYIZUcbvAlpSO1dsBrj/j+fctnDvY6oRfVp1g7GWXWJ9tkqfTgX
         r8QCfBX4anxNrk9/C+6uxr2NJ5AekHeBjwyHcPrU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Ruslan Bilovol <ruslan.bilovol@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 485/639] usb: host: xhci-hub: fix extra endianness conversion
Date:   Fri, 24 Jan 2020 10:30:55 +0100
Message-Id: <20200124093149.481211942@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
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
index 8f180bf7561a2..9772c0de59b7d 100644
--- a/drivers/usb/host/xhci-hub.c
+++ b/drivers/usb/host/xhci-hub.c
@@ -1104,7 +1104,7 @@ int xhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 			}
 			port_li = readl(ports[wIndex]->addr + PORTLI);
 			status = xhci_get_ext_port_status(temp, port_li);
-			put_unaligned_le32(cpu_to_le32(status), &buf[4]);
+			put_unaligned_le32(status, &buf[4]);
 		}
 		break;
 	case SetPortFeature:
-- 
2.20.1



