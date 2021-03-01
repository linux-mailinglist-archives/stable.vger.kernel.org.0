Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D3D532885B
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:39:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238841AbhCARjD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:39:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:54068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238252AbhCARb5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:31:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 210CC650A2;
        Mon,  1 Mar 2021 16:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617585;
        bh=45lhKKLiELLdEcRFR19q7lqkm/z2bbe1BVHsBP3S3dE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cfcKh/xVt3bINdINlY1SX5i/E5WXDTlAUp1+erj8vQggDsQgQdqTdW3HoSHs3N+3F
         Xp7T+XOrSOfOK0xpdUU3TxleQ5loyQSRwGy9sKtPNfZl9kKyOndjvDbJMNh3amVnlU
         l5Z6H9PhsLFTUeC0l9XAzDSeG53xQYmkHOTzyOeg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joe Perches <joe@perches.com>,
        Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 098/340] media: lmedm04: Fix misuse of comma
Date:   Mon,  1 Mar 2021 17:10:42 +0100
Message-Id: <20210301161053.155273080@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161048.294656001@linuxfoundation.org>
References: <20210301161048.294656001@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joe Perches <joe@perches.com>

[ Upstream commit 59a3e78f8cc33901fe39035c1ab681374bba95ad ]

There's a comma used instead of a semicolon that causes multiple
statements to be executed after an if instead of just the intended
single statement.

Replace the comma with a semicolon.

Fixes: 15e1ce33182d ("[media] lmedm04: Fix usb_submit_urb BOGUS urb xfer, pipe 1 != type 3 in interrupt urb")
Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/dvb-usb-v2/lmedm04.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/dvb-usb-v2/lmedm04.c b/drivers/media/usb/dvb-usb-v2/lmedm04.c
index 62d3566bf7eeb..5ac1a6af87826 100644
--- a/drivers/media/usb/dvb-usb-v2/lmedm04.c
+++ b/drivers/media/usb/dvb-usb-v2/lmedm04.c
@@ -391,7 +391,7 @@ static int lme2510_int_read(struct dvb_usb_adapter *adap)
 	ep = usb_pipe_endpoint(d->udev, lme_int->lme_urb->pipe);
 
 	if (usb_endpoint_type(&ep->desc) == USB_ENDPOINT_XFER_BULK)
-		lme_int->lme_urb->pipe = usb_rcvbulkpipe(d->udev, 0xa),
+		lme_int->lme_urb->pipe = usb_rcvbulkpipe(d->udev, 0xa);
 
 	usb_submit_urb(lme_int->lme_urb, GFP_ATOMIC);
 	info("INT Interrupt Service Started");
-- 
2.27.0



