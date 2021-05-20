Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2EAC38A8F7
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:57:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238683AbhETKz4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:55:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:52024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238612AbhETKxr (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:53:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E895C61883;
        Thu, 20 May 2021 10:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504844;
        bh=ipKLPeu42Bq8fzgLGyaGkLJPTPp01iaR00TYtrxmb4o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ee2O+IRcZsbiDIyl57Np6R9gRt2aGm9KXEaNCTxyWlEjSULQkGv7Y3lO+EZtP3org
         AjPwzybJzVxNG5+beY2fffvu1BcO9m0iwT7+52y2vJ2kpOgw4MB36EbbsCt009hVFl
         4DKdadeukVKHlh8yQBNPxoLXM7zfoBTQ8nZyBCNA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabian Vogt <fabian@ritter-vogt.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 105/240] fotg210-udc: Dont DMA more than the buffer can take
Date:   Thu, 20 May 2021 11:21:37 +0200
Message-Id: <20210520092112.210510206@linuxfoundation.org>
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

[ Upstream commit 3e7c2510bdfe89a9ec223dd7acd6bfc8bb1cbeb6 ]

Before this, it wrote as much as available into the buffer, even if it
didn't fit.

Fixes: b84a8dee23fd ("usb: gadget: add Faraday fotg210_udc driver")
Signed-off-by: Fabian Vogt <fabian@ritter-vogt.de>
Link: https://lore.kernel.org/r/20210324141115.9384-7-fabian@ritter-vogt.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/udc/fotg210-udc.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/udc/fotg210-udc.c b/drivers/usb/gadget/udc/fotg210-udc.c
index 491b04dd6db7..b2910bc65e51 100644
--- a/drivers/usb/gadget/udc/fotg210-udc.c
+++ b/drivers/usb/gadget/udc/fotg210-udc.c
@@ -340,8 +340,9 @@ static void fotg210_start_dma(struct fotg210_ep *ep,
 		} else {
 			buffer = req->req.buf + req->req.actual;
 			length = ioread32(ep->fotg210->reg +
-					FOTG210_FIBCR(ep->epnum - 1));
-			length &= FIBCR_BCFX;
+					FOTG210_FIBCR(ep->epnum - 1)) & FIBCR_BCFX;
+			if (length > req->req.length - req->req.actual)
+				length = req->req.length - req->req.actual;
 		}
 	} else {
 		buffer = req->req.buf + req->req.actual;
-- 
2.30.2



