Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE5F741A7F9
	for <lists+stable@lfdr.de>; Tue, 28 Sep 2021 07:59:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239059AbhI1GAx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Sep 2021 02:00:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:49524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239405AbhI1F73 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Sep 2021 01:59:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8D08861362;
        Tue, 28 Sep 2021 05:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632808613;
        bh=CQOKEx4OOhdguTMSrfdFeCZg+pUPHXjZ7+YAlyYSt80=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RBQRdbbyEUkg0IlhQ9tyUj2k5hEVFHLCB76GgI0gWptncyp9f+XOARSU+4c530o7Q
         6HJAp2dDjnl1HVjPBptxqieCUjvCa+AXUvEHPlLCrLHKGszK8sZ1FR/QZooBpBqWoC
         3w7VVuUQKmQbgDB/UL5G7NgoXNcx8J/4fbe/GA06yHePl0Za22Yzjb4hnspeZPXKGX
         XmPXdIoiKs9v8lmA546DT0bAl9Tzt73qUBSHw+HfUYbV6DjnzHjxSJ8oCx+7+SzmsK
         JDLDNztHIJNc/oETfQhr1pj10ULlyCogmjayxIFQUS6ubXzeZ7xqlyJ9mvXO83U/HY
         abxrL2K86PEpQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, hminas@synopsys.com,
        linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 13/23] usb: dwc2: check return value after calling platform_get_resource()
Date:   Tue, 28 Sep 2021 01:56:34 -0400
Message-Id: <20210928055645.172544-13-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210928055645.172544-1-sashal@kernel.org>
References: <20210928055645.172544-1-sashal@kernel.org>
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
index 6af1dcbc3656..30919f741b7f 100644
--- a/drivers/usb/dwc2/hcd.c
+++ b/drivers/usb/dwc2/hcd.c
@@ -5074,6 +5074,10 @@ int dwc2_hcd_init(struct dwc2_hsotg *hsotg)
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

