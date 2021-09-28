Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADC0641A791
	for <lists+stable@lfdr.de>; Tue, 28 Sep 2021 07:56:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239076AbhI1F6L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Sep 2021 01:58:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:48374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239112AbhI1F5k (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Sep 2021 01:57:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7FB6B611C7;
        Tue, 28 Sep 2021 05:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632808561;
        bh=ILLNq2aBQucLuAgFr9UwGbHMon6GgtjcOD6UT4ffFjk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CSD5JaaWnU0wMBfCGKOwwSqMyGl0uiAcuxF1UTA+REb3Qx6W5g/aPN2nvqI7IWSU4
         1zIxdzd4AIeHl5EoRD4eps2hHDtlJgk9lqqsfDmrSVEss9umyw2Q+kNtBcGsA4JboR
         TTxXry/bidZmQ7rM5XqpYFgb2o5jl+YR6wkle3UgIdT8qMZLq6sdAuFLG2rnmq+Tv9
         wwZ2Jd7+hEc03EpLsPz4O1/1kOgVV+kOCyeWRYQfiquWGltvbwgdS1ujkTIELKUyfn
         xc1k2OyX8e6s6vQjGqAXHv0CK6RdC3/k6jFBTbQD23D0Yr+A7NJqLstAZnT3hYCe4p
         Gzeoexu4krXsQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, hminas@synopsys.com,
        linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 19/40] usb: dwc2: check return value after calling platform_get_resource()
Date:   Tue, 28 Sep 2021 01:55:03 -0400
Message-Id: <20210928055524.172051-19-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210928055524.172051-1-sashal@kernel.org>
References: <20210928055524.172051-1-sashal@kernel.org>
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

