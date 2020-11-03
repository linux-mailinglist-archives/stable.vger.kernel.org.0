Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D266D2A3925
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 02:23:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728154AbgKCBUg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Nov 2020 20:20:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:35448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728040AbgKCBUf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Nov 2020 20:20:35 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A818B2242E;
        Tue,  3 Nov 2020 01:20:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604366435;
        bh=Yb+poyMjHvPJ5NCCLX6WjKFIr6arh83gmJcZlwD9Pe4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G6ZDy0eTHeq9q+7USY24vO9do3g5qwBLs1gwprD/XNv+Q9hitKWHde2K0q6w29JrJ
         VNUi7xj8DJLmgKBULc5zwjfrCot535KjQlf7oQENu8tPDCveg3nMLzyHvKlwwaW9tM
         kqFNq9YonXGklZ2ZGnr4SQ9arz6QgywKxsX5SNRU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Chen <peter.chen@nxp.com>, Jun Li <jun.li@nxp.com>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 21/24] usb: cdns3: gadget: suspicious implicit sign extension
Date:   Mon,  2 Nov 2020 20:20:04 -0500
Message-Id: <20201103012007.183429-21-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201103012007.183429-1-sashal@kernel.org>
References: <20201103012007.183429-1-sashal@kernel.org>
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
index bc4024041ef26..ec5c05454531d 100644
--- a/drivers/usb/cdns3/gadget.h
+++ b/drivers/usb/cdns3/gadget.h
@@ -1057,7 +1057,7 @@ struct cdns3_trb {
 #define TRB_TDL_SS_SIZE_GET(p)	(((p) & GENMASK(23, 17)) >> 17)
 
 /* transfer_len bitmasks - bits 31:24 */
-#define TRB_BURST_LEN(p)	(((p) << 24) & GENMASK(31, 24))
+#define TRB_BURST_LEN(p)	((unsigned int)((p) << 24) & GENMASK(31, 24))
 #define TRB_BURST_LEN_GET(p)	(((p) & GENMASK(31, 24)) >> 24)
 
 /* Data buffer pointer bitmasks*/
-- 
2.27.0

