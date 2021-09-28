Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4E1E41A821
	for <lists+stable@lfdr.de>; Tue, 28 Sep 2021 08:00:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239095AbhI1GBx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Sep 2021 02:01:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:49184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238950AbhI1GAA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Sep 2021 02:00:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AC3B4613AD;
        Tue, 28 Sep 2021 05:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632808631;
        bh=2iabheF+uJp+Z+9OHfVQDR7iplTtXBfjB0lBc0ON6wg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sokv55ALONmLDGQRLixRBWxy0yXOj9qWb82iS7tneWtET4ur50pKZwtIlyj6P8DOm
         Fsfy/+hRp7ToMUzfPhh/Ay15pto90NHGBR+oTM1XgGlWQ18Ffir7CMQrdIzBInTG3b
         BxpOo/Y1iITvfQ51ZU5VlWGDcdVGTDbKEkShJ306VYWhEOiJOwOGDbO8WySYrATLUr
         L+DjODVbYiDr7rEees9sZZZ5Xx/5xCy+1JYahjMiSPKazgBTWI7AJVPMT+pgBPP01N
         10fVq9a6EyyLTuHSEnjLCbVp349n/4MZZoMZyzKpDxknD1OFZBLJf3CRDWXHEU/1Ny
         Zob9LKZwf6OjQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, hminas@synopsys.com,
        linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 07/11] usb: dwc2: check return value after calling platform_get_resource()
Date:   Tue, 28 Sep 2021 01:57:00 -0400
Message-Id: <20210928055704.172814-7-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210928055704.172814-1-sashal@kernel.org>
References: <20210928055704.172814-1-sashal@kernel.org>
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

