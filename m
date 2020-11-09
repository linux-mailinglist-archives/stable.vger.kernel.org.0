Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 546FA2ABBA6
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:32:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732255AbgKINOM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:14:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:40346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729958AbgKINOM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:14:12 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BDAC020789;
        Mon,  9 Nov 2020 13:14:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927650;
        bh=Yb+poyMjHvPJ5NCCLX6WjKFIr6arh83gmJcZlwD9Pe4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=09gxlNXzvHMTfU3kymvxmfh0JGAFIsj2ecQd6ccfqAR2XhUOLPFTARF74LyFXqAvc
         bEbMk5vO06V62tGai5R63+PXhE1E+4rShb7GzcFyxLTbXHbrtp0J7+h/3faCTifsA0
         otaKHaUqK3V7MJaYjGZBA9lY5p9ca93G+rxwbmBU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jun Li <jun.li@nxp.com>,
        Peter Chen <peter.chen@nxp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 59/85] usb: cdns3: gadget: suspicious implicit sign extension
Date:   Mon,  9 Nov 2020 13:55:56 +0100
Message-Id: <20201109125025.406163166@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125022.614792961@linuxfoundation.org>
References: <20201109125022.614792961@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



