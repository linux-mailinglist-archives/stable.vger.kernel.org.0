Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5885F44B823
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:37:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345025AbhKIWkZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:40:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:59824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345468AbhKIWhs (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:37:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A33C861186;
        Tue,  9 Nov 2021 22:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496574;
        bh=r5lZmU0BFLKVwlIX/4dzFag2v05yG0YFczMkqPvQNBs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qTE0LeVg0f8GphVGQ8PFtoyuumLWzpUGFighUbFKk8gbmehL85f7/7m4jOmptscYm
         qZ3nHU9QgdvpAVeNYWj9U9QTgwh0DXwQgiVFcV+db7zKpWlF2Hnrq64j6QmuAhmN6D
         Autfx7/kTCoVDL5O9V8hMLXRLExDFzT0SVHpISF19B5KbG6UTXIsGNbivAXchGVO37
         QZ2DEl3soR8EMia/eR9Eh4ZHMiV2YVV4M1EO+LKItyWLvv9dfMKrzPJrH0q73y97jt
         SVawy1TRVyTqSyWjAOLa30ehhU6svZN5wZeaYo3Zjm6V8G+xm7Fbom7jHE1Qk9O4us
         PHJQGL8Pmp0DQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 19/30] usb: host: ohci-tmio: check return value after calling platform_get_resource()
Date:   Tue,  9 Nov 2021 17:22:13 -0500
Message-Id: <20211109222224.1235388-19-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109222224.1235388-1-sashal@kernel.org>
References: <20211109222224.1235388-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 9eff2b2e59fda25051ab36cd1cb5014661df657b ]

It will cause null-ptr-deref if platform_get_resource() returns NULL,
we need check the return value.

Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20211011134920.118477-1-yangyingliang@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/ohci-tmio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/host/ohci-tmio.c b/drivers/usb/host/ohci-tmio.c
index fed43c6dd85cc..b611c8b09a89f 100644
--- a/drivers/usb/host/ohci-tmio.c
+++ b/drivers/usb/host/ohci-tmio.c
@@ -199,7 +199,7 @@ static int ohci_hcd_tmio_drv_probe(struct platform_device *dev)
 	if (usb_disabled())
 		return -ENODEV;
 
-	if (!cell)
+	if (!cell || !regs || !config || !sram)
 		return -EINVAL;
 
 	if (irq < 0)
-- 
2.33.0

