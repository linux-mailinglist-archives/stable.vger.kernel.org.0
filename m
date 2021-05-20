Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29C8838A8E9
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:54:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238641AbhETKzT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:55:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:49448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239245AbhETKwz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:52:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4ED9B613D6;
        Thu, 20 May 2021 10:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504837;
        bh=WJpsw6vekG4EeARk0DUidThXyp16RxGecDQXShEeJpY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o3YcTvgVk4VO/1cTqGD4iXKEVsR4JHzYN1+c3cAuExioJiivpBci5rteaf/h47d1/
         6l/puPlbPrlxJI/mLmzFr45H+roQaqpPl1b1KjVb1XtI8nvINcRqvuxf93Z3YBY//8
         HhIqWCYrhN7m/Ak52h+NIPgyyNtHFAiNSXUxzMBo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabian Vogt <fabian@ritter-vogt.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 102/240] fotg210-udc: Fix EP0 IN requests bigger than two packets
Date:   Thu, 20 May 2021 11:21:34 +0200
Message-Id: <20210520092112.117308911@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092108.587553970@linuxfoundation.org>
References: <20210520092108.587553970@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabian Vogt <fabian@ritter-vogt.de>

[ Upstream commit 078ba935651e149c92c41161e0322e3372cc2705 ]

For a 134 Byte packet, it sends the first two 64 Byte packets just fine,
but then notice that less than a packet is remaining and call fotg210_done
without actually sending the rest.

Fixes: b84a8dee23fd ("usb: gadget: add Faraday fotg210_udc driver")
Signed-off-by: Fabian Vogt <fabian@ritter-vogt.de>
Link: https://lore.kernel.org/r/20210324141115.9384-3-fabian@ritter-vogt.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/udc/fotg210-udc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/udc/fotg210-udc.c b/drivers/usb/gadget/udc/fotg210-udc.c
index 7831c556a40b..1eda6fc750c1 100644
--- a/drivers/usb/gadget/udc/fotg210-udc.c
+++ b/drivers/usb/gadget/udc/fotg210-udc.c
@@ -827,7 +827,7 @@ static void fotg210_ep0in(struct fotg210_udc *fotg210)
 		if (req->req.length)
 			fotg210_start_dma(ep, req);
 
-		if ((req->req.length - req->req.actual) < ep->ep.maxpacket)
+		if (req->req.actual == req->req.length)
 			fotg210_done(ep, req, 0);
 	} else {
 		fotg210_set_cxdone(fotg210);
-- 
2.30.2



