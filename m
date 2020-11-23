Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D6792C095E
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:18:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732992AbgKWNGu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 08:06:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:33634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732866AbgKWMtI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:49:08 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3151C20657;
        Mon, 23 Nov 2020 12:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135743;
        bh=iJSZOkCQzfmNtyqjPBfLXL5xXXBCUa05gfu2ZDTglH8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cD5KOgyAtetRgtx6qmbW9HpYElKdPn2HWaSM+T7krIbq78p7yoqtySvQnX4uMr6nI
         VQdFTvpZGUXAdedi7VVJdLd0iSmoVZmLfN4vSYipQx8G7Tl4Cs1ErzOEK7sMy570lV
         HShhFbf9Z0hXsFOJ9Y5UZERnfc+daZPRv22JkV4w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Xiongfeng Wang <wangxiongfeng2@huawei.com>,
        Jernej Skrabec <jernej.skrabec@siol.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 149/252] drm/sun4i: dw-hdmi: fix error return code in sun8i_dw_hdmi_bind()
Date:   Mon, 23 Nov 2020 13:21:39 +0100
Message-Id: <20201123121842.791125421@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiongfeng Wang <wangxiongfeng2@huawei.com>

[ Upstream commit 6654b57866b98230a270953dd34f67de17ab1708 ]

Fix to return a negative error code from the error handling case instead
of 0 in function sun8i_dw_hdmi_bind().

Fixes: b7c7436a5ff0 ("drm/sun4i: Implement A83T HDMI driver")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Xiongfeng Wang <wangxiongfeng2@huawei.com>
Reviewed-by: Jernej Skrabec <jernej.skrabec@siol.net>
Signed-off-by: Jernej Skrabec <jernej.skrabec@siol.net>
Link: https://patchwork.freedesktop.org/patch/msgid/1605488969-5211-1-git-send-email-wangxiongfeng2@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/sun4i/sun8i_dw_hdmi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/sun4i/sun8i_dw_hdmi.c b/drivers/gpu/drm/sun4i/sun8i_dw_hdmi.c
index d4c08043dd81d..92add2cef2e7d 100644
--- a/drivers/gpu/drm/sun4i/sun8i_dw_hdmi.c
+++ b/drivers/gpu/drm/sun4i/sun8i_dw_hdmi.c
@@ -208,6 +208,7 @@ static int sun8i_dw_hdmi_bind(struct device *dev, struct device *master,
 	phy_node = of_parse_phandle(dev->of_node, "phys", 0);
 	if (!phy_node) {
 		dev_err(dev, "Can't found PHY phandle\n");
+		ret = -EINVAL;
 		goto err_disable_clk_tmds;
 	}
 
-- 
2.27.0



