Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2313641A881
	for <lists+stable@lfdr.de>; Tue, 28 Sep 2021 08:03:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239805AbhI1GFX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Sep 2021 02:05:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:48798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239637AbhI1GAz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Sep 2021 02:00:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0DCB66137C;
        Tue, 28 Sep 2021 05:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632808642;
        bh=hvvol/WnNDR9Ex7DOkdK4SNSSmPXLQicgu6bxiu1ou8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mOTOrifpEiT/oIyhGKRx5wFSAqhLoa3mO2Lb3mViA9ilHMqGnrbEsT6iQE4+u7fed
         9M5A0EEa2TJ4ez+KPQzFmmHhnqbg5zNcOIBDnMw3geO0DFFXQyNAYEjXK4cBfNyqR7
         gi1cy8ebMu979VTzCwAf2S6Ol/O3xm5twF6P8ueKwpouY3xBT2oVYyz09KXJLGd/rc
         PsNFQPjyaNtSslHLgrzlvyxMPD2wREOiJCM5JVy2DTqMY7E4yAlyAuLxy4J1b6XwFH
         Fvr8e/v+0zfE0dSpU0NTNaRjRHv8etMzST/u598zNUSylv9zu7u/ahiK1JIN7ZifcU
         Yh8JPFHX2uYvA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, hminas@synopsys.com,
        linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 07/10] usb: dwc2: check return value after calling platform_get_resource()
Date:   Tue, 28 Sep 2021 01:57:13 -0400
Message-Id: <20210928055716.172951-7-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210928055716.172951-1-sashal@kernel.org>
References: <20210928055716.172951-1-sashal@kernel.org>
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
index 58e53e3d905b..22c4d554865e 100644
--- a/drivers/usb/dwc2/hcd.c
+++ b/drivers/usb/dwc2/hcd.c
@@ -5234,6 +5234,10 @@ int dwc2_hcd_init(struct dwc2_hsotg *hsotg)
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

