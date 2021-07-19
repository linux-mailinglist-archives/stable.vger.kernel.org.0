Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A07ED3CD89B
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:04:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242777AbhGSOXo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:23:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:55504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242517AbhGSOWI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:22:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 55A9961249;
        Mon, 19 Jul 2021 15:02:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626706938;
        bh=ge8k98Jmmh4+fuZZPKhrjZr04XydmynMYogBFTwWaOM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ARJJGPVtLvF2XU4X6fZqx9nxdNSRy2+89Mbt23mIvrKh2SD+zaIGj8GBoQ+2+SPOF
         bwEcuXTL0L9ZA/fstdymWW1cEYOA0rzMAon35VehMAmNi7rCgH7cIAytlXUVzqi+R0
         Z2E+1RubnUPRN6zNRww9/a52nIkf1GR/+4aq2P08=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 159/188] usb: gadget: hid: fix error return code in hid_bind()
Date:   Mon, 19 Jul 2021 16:52:23 +0200
Message-Id: <20210719144941.697146014@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144913.076563739@linuxfoundation.org>
References: <20210719144913.076563739@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 88693f770bb09c196b1eb5f06a484a254ecb9924 ]

Fix to return a negative error code from the error handling
case instead of 0.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20210618043835.2641360-1-yangyingliang@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/legacy/hid.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/legacy/hid.c b/drivers/usb/gadget/legacy/hid.c
index 7e5d2c48476e..97329ba5d382 100644
--- a/drivers/usb/gadget/legacy/hid.c
+++ b/drivers/usb/gadget/legacy/hid.c
@@ -175,8 +175,10 @@ static int hid_bind(struct usb_composite_dev *cdev)
 		struct usb_descriptor_header *usb_desc;
 
 		usb_desc = usb_otg_descriptor_alloc(gadget);
-		if (!usb_desc)
+		if (!usb_desc) {
+			status = -ENOMEM;
 			goto put;
+		}
 		usb_otg_descriptor_init(gadget, usb_desc);
 		otg_desc[0] = usb_desc;
 		otg_desc[1] = NULL;
-- 
2.30.2



