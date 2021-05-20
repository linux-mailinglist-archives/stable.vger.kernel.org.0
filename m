Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE92A38AABF
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 13:17:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239837AbhETLRE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 07:17:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:37174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240610AbhETLPA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 07:15:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5502861955;
        Thu, 20 May 2021 10:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621505326;
        bh=uy3xaIeNdD5r8adhSdQ7+dPo37KVWtOH3gwnu1EkGac=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GR8pMML7wtsphayabrc/6I0E2dOHvYXJJDZMVgfQ+bZd2I9hKOBVUv2NnlTFXn8lQ
         gTVIrq7y5AaN/qx5W2g4yMLtlrP5f0lPsVenvNH0DuvPY17Iy2ix1U6j7O1zNw+1Xd
         /uUxlBlDEuIiiTBiF2Ltci5tEOQCUmlFbeYqA7xs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabian Vogt <fabian@ritter-vogt.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 085/190] fotg210-udc: Remove a dubious condition leading to fotg210_done
Date:   Thu, 20 May 2021 11:22:29 +0200
Message-Id: <20210520092105.007208378@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092102.149300807@linuxfoundation.org>
References: <20210520092102.149300807@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabian Vogt <fabian@ritter-vogt.de>

[ Upstream commit c7f755b243494d6043aadcd9a2989cb157958b95 ]

When the EP0 IN request was not completed but less than a packet sent,
it would complete the request successfully. That doesn't make sense
and can't really happen as fotg210_start_dma always sends
min(length, maxpkt) bytes.

Fixes: b84a8dee23fd ("usb: gadget: add Faraday fotg210_udc driver")
Signed-off-by: Fabian Vogt <fabian@ritter-vogt.de>
Link: https://lore.kernel.org/r/20210324141115.9384-4-fabian@ritter-vogt.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/udc/fotg210-udc.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/udc/fotg210-udc.c b/drivers/usb/gadget/udc/fotg210-udc.c
index 1eda6fc750c1..d0a9ce7d0635 100644
--- a/drivers/usb/gadget/udc/fotg210-udc.c
+++ b/drivers/usb/gadget/udc/fotg210-udc.c
@@ -385,8 +385,7 @@ static void fotg210_ep0_queue(struct fotg210_ep *ep,
 	}
 	if (ep->dir_in) { /* if IN */
 		fotg210_start_dma(ep, req);
-		if ((req->req.length == req->req.actual) ||
-		    (req->req.actual < ep->ep.maxpacket))
+		if (req->req.length == req->req.actual)
 			fotg210_done(ep, req, 0);
 	} else { /* OUT */
 		u32 value = ioread32(ep->fotg210->reg + FOTG210_DMISGR0);
-- 
2.30.2



