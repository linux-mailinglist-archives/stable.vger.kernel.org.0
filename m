Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51275205F02
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:32:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390882AbgFWU2d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:28:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:48328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390879AbgFWU2c (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:28:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B87B12064B;
        Tue, 23 Jun 2020 20:28:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592944112;
        bh=SHAhC7DmFtppXWs7b0Kn01bV/vNSQiVgCjFt4xW8ddQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TWMjWShE2b44ffTzepxRz5CzQFKiDPor0appv47qVozgrwtbq0o1Q4aGh62S34Exb
         fDKV9MIAtlXgCpBUptTJ/bCn4R7KVZIIqj8GNdJiCBYjX5TZNBLjiy1JsrtcDH32+f
         V0DU2yvQj8hWz3Gt+bf9xP+hYRB7kW8kDrVYePh0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qiushi Wu <wu000273@umn.edu>,
        Felipe Balbi <balbi@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 178/314] usb: gadget: fix potential double-free in m66592_probe.
Date:   Tue, 23 Jun 2020 21:56:13 +0200
Message-Id: <20200623195347.380962831@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195338.770401005@linuxfoundation.org>
References: <20200623195338.770401005@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qiushi Wu <wu000273@umn.edu>

[ Upstream commit 44734a594196bf1d474212f38fe3a0d37a73278b ]

m66592_free_request() is called under label "err_add_udc"
and "clean_up", and m66592->ep0_req is not set to NULL after
first free, leading to a double-free. Fix this issue by
setting m66592->ep0_req to NULL after the first free.

Fixes: 0f91349b89f3 ("usb: gadget: convert all users to the new udc infrastructure")
Signed-off-by: Qiushi Wu <wu000273@umn.edu>
Signed-off-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/udc/m66592-udc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/udc/m66592-udc.c b/drivers/usb/gadget/udc/m66592-udc.c
index a8288df6aadf0..ea59b56e54023 100644
--- a/drivers/usb/gadget/udc/m66592-udc.c
+++ b/drivers/usb/gadget/udc/m66592-udc.c
@@ -1667,7 +1667,7 @@ static int m66592_probe(struct platform_device *pdev)
 
 err_add_udc:
 	m66592_free_request(&m66592->ep[0].ep, m66592->ep0_req);
-
+	m66592->ep0_req = NULL;
 clean_up3:
 	if (m66592->pdata->on_chip) {
 		clk_disable(m66592->clk);
-- 
2.25.1



