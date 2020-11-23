Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 260B32C0B91
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:56:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730998AbgKWN1M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 08:27:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:43128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730988AbgKWMb6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:31:58 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0EB5520728;
        Mon, 23 Nov 2020 12:31:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606134718;
        bh=NmcLqOzY0L6k1gax5UwQiGLZERegTRW0f+gWaW1D90Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cVb/7l0wK+6jm2nwPiSGDk2ny/FB2wRc7N07phQpEhrm/KbcjFsPZNKVinh0fnN6l
         LPLD7yZOjCk3LQ1CRj5WOiGRe7AQ1P+wU0+rTcAmezTt81g59BbVi0qeUaBhvN7bwJ
         NCF5dfuu/tqKlsruSXwtVeXHWEZm6M2YTZ3SnKeo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Xiongfeng Wang <wangxiongfeng2@huawei.com>,
        Jernej Skrabec <jernej.skrabec@siol.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 57/91] drm/sun4i: dw-hdmi: fix error return code in sun8i_dw_hdmi_bind()
Date:   Mon, 23 Nov 2020 13:22:17 +0100
Message-Id: <20201123121812.094602839@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121809.285416732@linuxfoundation.org>
References: <20201123121809.285416732@linuxfoundation.org>
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
index 31875b636434a..5073622cbb567 100644
--- a/drivers/gpu/drm/sun4i/sun8i_dw_hdmi.c
+++ b/drivers/gpu/drm/sun4i/sun8i_dw_hdmi.c
@@ -140,6 +140,7 @@ static int sun8i_dw_hdmi_bind(struct device *dev, struct device *master,
 	phy_node = of_parse_phandle(dev->of_node, "phys", 0);
 	if (!phy_node) {
 		dev_err(dev, "Can't found PHY phandle\n");
+		ret = -EINVAL;
 		goto err_disable_clk_tmds;
 	}
 
-- 
2.27.0



