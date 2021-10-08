Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 553F7426915
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 13:32:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241683AbhJHLd5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 07:33:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:59392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241256AbhJHLcz (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Oct 2021 07:32:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 13DDF61038;
        Fri,  8 Oct 2021 11:30:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633692632;
        bh=2iabheF+uJp+Z+9OHfVQDR7iplTtXBfjB0lBc0ON6wg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BM9KgvnNDeaQuxSSwEPhcM6i9PyRu4NhLoioACcU4sJA9fvd9dkjVSCLN5g7cadzK
         hSMgaJRnsL/I+Q5m1UwOTOu/Hj/LSTHDbGgd6Ru7BfTiHUxoFYSAunuumUVqqrwNj/
         VDdFbdjbUGjuM/q0wQeNIvmvh+GpI3BcXEsFdx+M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yang Yingliang <yangyingliang@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 07/16] usb: dwc2: check return value after calling platform_get_resource()
Date:   Fri,  8 Oct 2021 13:27:57 +0200
Message-Id: <20211008112715.709403391@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211008112715.444305067@linuxfoundation.org>
References: <20211008112715.444305067@linuxfoundation.org>
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
index f29fbadb0548..78329d0e9af0 100644
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



