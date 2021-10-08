Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70247426982
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 13:37:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240295AbhJHLjK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 07:39:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:60688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240388AbhJHLgH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Oct 2021 07:36:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8849E615A6;
        Fri,  8 Oct 2021 11:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633692728;
        bh=ILLNq2aBQucLuAgFr9UwGbHMon6GgtjcOD6UT4ffFjk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AZKBlmulbMHkFXmZdfnXJgd4hCXqZ00wuoee6U0bESqi1TQyAHSsj++LR3aycUSyK
         xNUCNCYOtOUJT+dsT2zc7O/ko0w7pmDD7dd44xWGnDxFmOyVJ9H0zoNFapCqOh5r5s
         KdmWvyNiBti6guOFW4LgJKzA4+xzuGkx/1zBGdHY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yang Yingliang <yangyingliang@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 18/48] usb: dwc2: check return value after calling platform_get_resource()
Date:   Fri,  8 Oct 2021 13:27:54 +0200
Message-Id: <20211008112720.621158057@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211008112720.008415452@linuxfoundation.org>
References: <20211008112720.008415452@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 856e6e8e0f9300befa87dde09edb578555c99a82 ]

It will cause null-ptr-deref if platform_get_resource() returns NULL,
we need check the return value.

Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20210831084236.1359677-1-yangyingliang@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc2/hcd.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/usb/dwc2/hcd.c b/drivers/usb/dwc2/hcd.c
index 2a7828971d05..a215ec9e172e 100644
--- a/drivers/usb/dwc2/hcd.c
+++ b/drivers/usb/dwc2/hcd.c
@@ -5191,6 +5191,10 @@ int dwc2_hcd_init(struct dwc2_hsotg *hsotg)
 	hcd->has_tt = 1;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		retval = -EINVAL;
+		goto error1;
+	}
 	hcd->rsrc_start = res->start;
 	hcd->rsrc_len = resource_size(res);
 
-- 
2.33.0



