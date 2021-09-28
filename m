Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8725F41A851
	for <lists+stable@lfdr.de>; Tue, 28 Sep 2021 08:02:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239285AbhI1GDi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Sep 2021 02:03:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:49944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238980AbhI1GBx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Sep 2021 02:01:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 582B7613B3;
        Tue, 28 Sep 2021 05:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632808653;
        bh=yhVH6Y5TeyZxusIfM3ydQf6bhlf+606vAiDW0DbitgA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Be2a0ostAJjVRuvOfbsDtHEAjqgMRiL5Pvdftk+hm8DPRc+wOnN4XZOEKeWy2xwyf
         SFg+I6A1GC1rKGKY/4YDjwk90gLOMYHl8O/kAtb4wHNuXEIPwG5+48h0hZ5+LxWEV/
         VJtT38zNyet1IMQcsegr8N32uCp/Y1IHxVvGRoJdWiKfSjIKBhQxGWdPxJ64nWOJ1Y
         UQwIIE0o+2i5O9y4qRkReh8+7NXu31NSshHz1LOc6dKOOrjjhD1lElbwsi9nKCOA0s
         8cuAefJauh7Pby0NCzGsxsc1ptT0UcO0yciTtu7IhdSJIXBqmWlna1lXCQnCetqf2s
         rbYofmOjrJ3RQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, hminas@synopsys.com,
        linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 7/8] usb: dwc2: check return value after calling platform_get_resource()
Date:   Tue, 28 Sep 2021 01:57:25 -0400
Message-Id: <20210928055727.173078-7-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210928055727.173078-1-sashal@kernel.org>
References: <20210928055727.173078-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index ef7f3b013fcb..ba7528916da4 100644
--- a/drivers/usb/dwc2/hcd.c
+++ b/drivers/usb/dwc2/hcd.c
@@ -5229,6 +5229,10 @@ int dwc2_hcd_init(struct dwc2_hsotg *hsotg)
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

