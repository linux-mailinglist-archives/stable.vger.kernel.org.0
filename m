Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B15D3C319C
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:49:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235427AbhGJCnE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:43:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:60716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235251AbhGJClr (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:41:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 00767613D6;
        Sat, 10 Jul 2021 02:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625884742;
        bh=mrt589wS+yaIuYhEoK1hDGW+oRU/G8TwBt8BJea3Fv8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uswnlLTeQbHKEAK9jiQt0l7al+aWnnU8umrqAc3vt5MIAuPqDawR1O2mNWJ1Ld9Xv
         qrhZsZ+A3nnZtkTMLfAC865oseUC9Hu8+FunIwEdWRU9pSPGd+itV9czrtcyI0Rzcs
         7SvLSkMJztiiUxX2XxexkUDK5YVp+RyhQdrS4WCkgEatE5A24g+9GZ3n/Z0TTc6osZ
         aziS7ENQadxzxQWHUOBOmNTy/IRO8+u1GHkEo2asnoL8EoVEkDvnuPc0b1S8MZ2JmK
         27dT0gSo1jBWaQcIT7LsSL+ZzjuW+s9r7zz+xKwaiNZJxYKB+LXWXKS2JpC0GCeNRX
         HplfAYpBQzuLw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        Hulk Robot <hulkci@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 20/26] usb: gadget: hid: fix error return code in hid_bind()
Date:   Fri,  9 Jul 2021 22:35:58 -0400
Message-Id: <20210710023604.3172486-20-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710023604.3172486-1-sashal@kernel.org>
References: <20210710023604.3172486-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index a71a884f79fc..cccbb948821b 100644
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

