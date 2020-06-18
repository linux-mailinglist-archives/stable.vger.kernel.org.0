Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CBE21FDED8
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 03:39:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732191AbgFRBgL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:36:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:41636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731973AbgFRBbJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:31:09 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E8F6C2224B;
        Thu, 18 Jun 2020 01:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443868;
        bh=GihSLx6Fpufc/S8q8V2ThvmkL+yQN55aJ1H8Pq4HuUg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IXMiRzjOKoUh7IiL0/ZNdmMDLyLy70phI1ZKYkd/eInCDdnnDIAjDoilmILG4/8bl
         GwXG+VQTnp1sMXveT9GX9je55ZT60gs3Dfk20ODiF6eOlIIE6FADPsxq9bfrr9EQ9f
         KdAmiz8jeGOc3GKQFTEeJON5BIe5leWvP4iN9gJE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qiushi Wu <wu000273@umn.edu>, Felipe Balbi <balbi@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 49/60] usb: gadget: fix potential double-free in m66592_probe.
Date:   Wed, 17 Jun 2020 21:29:53 -0400
Message-Id: <20200618013004.610532-49-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618013004.610532-1-sashal@kernel.org>
References: <20200618013004.610532-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index b1cfa96cc88f..db95eab8b432 100644
--- a/drivers/usb/gadget/udc/m66592-udc.c
+++ b/drivers/usb/gadget/udc/m66592-udc.c
@@ -1684,7 +1684,7 @@ static int m66592_probe(struct platform_device *pdev)
 
 err_add_udc:
 	m66592_free_request(&m66592->ep[0].ep, m66592->ep0_req);
-
+	m66592->ep0_req = NULL;
 clean_up3:
 	if (m66592->pdata->on_chip) {
 		clk_disable(m66592->clk);
-- 
2.25.1

