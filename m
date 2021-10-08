Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72DA6426923
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 13:32:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241809AbhJHLeK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 07:34:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:59492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241293AbhJHLc7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Oct 2021 07:32:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E10E6137F;
        Fri,  8 Oct 2021 11:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633692652;
        bh=CQOKEx4OOhdguTMSrfdFeCZg+pUPHXjZ7+YAlyYSt80=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IXOiawvalU6qP/ecAO2k+eize4E7eii2OEJjQucwq4w+VEQqs+mx0GhU3UwlyOt3Y
         GJm3/vdRv7ArkGU8CuOKifu56bLowdAuCyJypCSJWoNiPS5Q2u2QlPIS1oXV+I1LwO
         dEmeeU9jwAblbU12CoEJ7zm+TyvQE7wX5CFFtwO8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yang Yingliang <yangyingliang@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 13/29] usb: dwc2: check return value after calling platform_get_resource()
Date:   Fri,  8 Oct 2021 13:28:00 +0200
Message-Id: <20211008112717.388452329@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211008112716.914501436@linuxfoundation.org>
References: <20211008112716.914501436@linuxfoundation.org>
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



