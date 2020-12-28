Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17D012E40B4
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:57:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408097AbgL1Ozu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:55:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:52136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2441219AbgL1ORB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:17:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C283022AAA;
        Mon, 28 Dec 2020 14:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164980;
        bh=hBwo5UXRJC0YzTAz3HQDeIVycszqgjZdqb20HN6tMYc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q5fKjzN3NuTuQsa5bWbLWTioYy/8T+gWXinw1Awio7VjIxzGPaDGKoUJfLKGiUXIm
         GWaFa3O7djSX353o2IhlnF+k7hnXYnmxGHPaR7VNrM0ivCpelXXI6BnUaY2bj0N+91
         MRfXWY5XCgeNfo8+4JGv92Ss2YLBPHV4/xpOzJZo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 367/717] drm/mediatek: avoid dereferencing a null hdmi_phy on an error message
Date:   Mon, 28 Dec 2020 13:46:05 +0100
Message-Id: <20201228125038.589605736@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit b097efba9580d1f7cbc80cda84e768983e3de541 ]

Currently there is a null pointer check for hdmi_phy that implies it
may be null, however a dev_err messages dereferences this potential null
pointer.  Avoid a null pointer dereference by only emitting the dev_err
message if hdmi_phy is non-null.  It is a moot point if the error message
needs to be printed at all, but since this is a relatively new piece of
code it may be useful to keep the message in for the moment in case there
are unforseen errors that need to be reported.

Fixes: be28b6507c46 ("drm/mediatek: separate hdmi phy to different file")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Addresses-Coverity: ("Dereference after null check")
Link: https://lore.kernel.org/r/20201207150937.170435-1-colin.king@canonical.com
[vkoul: fix indent of return call]
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/mediatek/phy-mtk-hdmi.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/phy/mediatek/phy-mtk-hdmi.c b/drivers/phy/mediatek/phy-mtk-hdmi.c
index 47c029d4b270b..206cc34687223 100644
--- a/drivers/phy/mediatek/phy-mtk-hdmi.c
+++ b/drivers/phy/mediatek/phy-mtk-hdmi.c
@@ -84,8 +84,9 @@ mtk_hdmi_phy_dev_get_ops(const struct mtk_hdmi_phy *hdmi_phy)
 	    hdmi_phy->conf->hdmi_phy_disable_tmds)
 		return &mtk_hdmi_phy_dev_ops;
 
-	dev_err(hdmi_phy->dev, "Failed to get dev ops of phy\n");
-		return NULL;
+	if (hdmi_phy)
+		dev_err(hdmi_phy->dev, "Failed to get dev ops of phy\n");
+	return NULL;
 }
 
 static void mtk_hdmi_phy_clk_get_data(struct mtk_hdmi_phy *hdmi_phy,
-- 
2.27.0



