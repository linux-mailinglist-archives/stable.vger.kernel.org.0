Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 167B6227170
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 23:43:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728197AbgGTVng (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 17:43:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:57078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728153AbgGTVi2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 17:38:28 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC4C522D01;
        Mon, 20 Jul 2020 21:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595281108;
        bh=MV517qUDiknYDooGSvBVdtDwv42VgYuNr25i+D7Z/3E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MEvkMvbKcfU4HDSe6nGSmxqGP2gJXl38VZptdlr+ZNugzy/Ogj484Q3MFlW8y6iTS
         hnDnmEJ9mFIAgyqhHO+Sme2b5fcdsiROf31o6DaNBk2CdOHcRV9Kxeti4DggAJQFhF
         pQD2FGjRpRgD8eH0tO2MVFMa2x4d5MN7pVBqnwSk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Evgeny Novikov <novikov@ispras.ru>,
        Felipe Balbi <balbi@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 17/34] usb: gadget: udc: gr_udc: fix memleak on error handling path in gr_ep_init()
Date:   Mon, 20 Jul 2020 17:37:50 -0400
Message-Id: <20200720213807.407380-17-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200720213807.407380-1-sashal@kernel.org>
References: <20200720213807.407380-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Evgeny Novikov <novikov@ispras.ru>

[ Upstream commit c8f8529e2c4141afa2ebb487ad48e8a6ec3e8c99 ]

gr_ep_init() does not assign the allocated request anywhere if allocation
of memory for the buffer fails. This is a memory leak fixed by the given
patch.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Evgeny Novikov <novikov@ispras.ru>
Signed-off-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/udc/gr_udc.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/udc/gr_udc.c b/drivers/usb/gadget/udc/gr_udc.c
index 116d386472efe..da73a06c20a39 100644
--- a/drivers/usb/gadget/udc/gr_udc.c
+++ b/drivers/usb/gadget/udc/gr_udc.c
@@ -1980,9 +1980,12 @@ static int gr_ep_init(struct gr_udc *dev, int num, int is_in, u32 maxplimit)
 
 	if (num == 0) {
 		_req = gr_alloc_request(&ep->ep, GFP_ATOMIC);
+		if (!_req)
+			return -ENOMEM;
+
 		buf = devm_kzalloc(dev->dev, PAGE_SIZE, GFP_DMA | GFP_ATOMIC);
-		if (!_req || !buf) {
-			/* possible _req freed by gr_probe via gr_remove */
+		if (!buf) {
+			gr_free_request(&ep->ep, _req);
 			return -ENOMEM;
 		}
 
-- 
2.25.1

