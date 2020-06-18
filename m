Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22A601FE474
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:18:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730174AbgFRBTh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:19:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:51496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730171AbgFRBTg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:19:36 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E4B721D82;
        Thu, 18 Jun 2020 01:19:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443176;
        bh=D3F8OeDLQgHlOhxrNCZPhck53CQnJDDLhPaT7YaAwrI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jt1z6W3NKL6r9rZm+gr49xjheiU6h9EBhLITwgZy4ASDYsj2Ju5XhzHhL+bLX0wO5
         yaOX2GzaPn42WSurpyaUpgbLGVtoU+gfKmSajh0vqrGT9FfKoaToyokurogrgMltJl
         Ryauz2W+E3dqiJdXSWYU0P8UOx5FK1JMTz38AyLU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wei Yongjun <weiyongjun1@huawei.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 139/266] USB: ohci-sm501: fix error return code in ohci_hcd_sm501_drv_probe()
Date:   Wed, 17 Jun 2020 21:14:24 -0400
Message-Id: <20200618011631.604574-139-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618011631.604574-1-sashal@kernel.org>
References: <20200618011631.604574-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

[ Upstream commit b919e077cccfbb77beb98809568b2fb0b4d113ec ]

Fix to return a negative error code from the error handling
case instead of 0, as done elsewhere in this function.

Fixes: 7d9e6f5aebe8 ("usb: host: ohci-sm501: init genalloc for local memory")
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/20200506135625.106910-1-weiyongjun1@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/ohci-sm501.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/host/ohci-sm501.c b/drivers/usb/host/ohci-sm501.c
index c158cda9e4b9..cff965240327 100644
--- a/drivers/usb/host/ohci-sm501.c
+++ b/drivers/usb/host/ohci-sm501.c
@@ -157,9 +157,10 @@ static int ohci_hcd_sm501_drv_probe(struct platform_device *pdev)
 	 * the call to usb_hcd_setup_local_mem() below does just that.
 	 */
 
-	if (usb_hcd_setup_local_mem(hcd, mem->start,
-				    mem->start - mem->parent->start,
-				    resource_size(mem)) < 0)
+	retval = usb_hcd_setup_local_mem(hcd, mem->start,
+					 mem->start - mem->parent->start,
+					 resource_size(mem));
+	if (retval < 0)
 		goto err5;
 	retval = usb_add_hcd(hcd, irq, IRQF_SHARED);
 	if (retval)
-- 
2.25.1

