Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE5E92A3960
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 02:25:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726506AbgKCBZC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Nov 2020 20:25:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:34456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727981AbgKCBUD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Nov 2020 20:20:03 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0A7252242F;
        Tue,  3 Nov 2020 01:20:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604366402;
        bh=86wGNSI8JmYe8ggY2XcpLkC6ohVEoexUDpj4tCkLil0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BSMbjTfGZjOS72STf9BwP8H1/XEpdrK5EovH5gr2i2PkP7Zu4N24lM0cABp7KvN4F
         OlkDAyPNPeX6tGE2pcIOpWoAjLYAOQ8FdMqtBGFMuqrHZy8Yb1rRJHOpCLFkMVnPUE
         DyMjsSwzIu2dJzI/+moAJmap1aWn6r4g0LQiWTvE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Chen <peter.chen@nxp.com>, Jun Li <jun.li@nxp.com>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.8 26/29] usb: cdns3: gadget: suspicious implicit sign extension
Date:   Mon,  2 Nov 2020 20:19:25 -0500
Message-Id: <20201103011928.183145-26-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201103011928.183145-1-sashal@kernel.org>
References: <20201103011928.183145-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Chen <peter.chen@nxp.com>

[ Upstream commit 5fca3f062879f8e5214c56f3e3e2be6727900f5d ]

The code:
trb->length = cpu_to_le32(TRB_BURST_LEN(priv_ep->trb_burst_size)
	       	| TRB_LEN(length));

TRB_BURST_LEN(priv_ep->trb_burst_size) may be overflow for int 32 if
priv_ep->trb_burst_size is equal or larger than 0x80;

Below is the Coverity warning:
sign_extension: Suspicious implicit sign extension: priv_ep->trb_burst_size
with type u8 (8 bits, unsigned) is promoted in priv_ep->trb_burst_size << 24
to type int (32 bits, signed), then sign-extended to type unsigned long
(64 bits, unsigned). If priv_ep->trb_burst_size << 24 is greater than 0x7FFFFFFF,
the upper bits of the result will all be 1.

To fix it, it needs to add an explicit cast to unsigned int type for ((p) << 24).

Reviewed-by: Jun Li <jun.li@nxp.com>
Signed-off-by: Peter Chen <peter.chen@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/cdns3/gadget.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/cdns3/gadget.h b/drivers/usb/cdns3/gadget.h
index 52765b098b9e1..28c4f6aca6891 100644
--- a/drivers/usb/cdns3/gadget.h
+++ b/drivers/usb/cdns3/gadget.h
@@ -1067,7 +1067,7 @@ struct cdns3_trb {
 #define TRB_TDL_SS_SIZE_GET(p)	(((p) & GENMASK(23, 17)) >> 17)
 
 /* transfer_len bitmasks - bits 31:24 */
-#define TRB_BURST_LEN(p)	(((p) << 24) & GENMASK(31, 24))
+#define TRB_BURST_LEN(p)	((unsigned int)((p) << 24) & GENMASK(31, 24))
 #define TRB_BURST_LEN_GET(p)	(((p) & GENMASK(31, 24)) >> 24)
 
 /* Data buffer pointer bitmasks*/
-- 
2.27.0

