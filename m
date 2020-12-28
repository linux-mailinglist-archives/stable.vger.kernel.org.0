Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4C792E62BF
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:40:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406124AbgL1NtY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:49:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:51082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404792AbgL1NtY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:49:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A64052078D;
        Mon, 28 Dec 2020 13:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163323;
        bh=/zurbYb0+8DJHu8Ys+Psm5UIg7CqA5tbTd6hQZIeH2k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I51O5WVOqzEPJD5cKw8MURcoR2nyelIHZHpsx2fCbuwf8zwahROMwiee8tpjbcq3D
         wU/JhdWSDJWKICPX0Jj34nSFT5M2ojREPz/FGmG1K7vVUpSjYodVtGRgCF5vjyRP/V
         dPRC916ZuQO2WAW0v4+aLn/jcOL4u+A0O0Jzcw/0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 247/453] drm/mediatek: avoid dereferencing a null hdmi_phy on an error message
Date:   Mon, 28 Dec 2020 13:48:03 +0100
Message-Id: <20201228124949.113387029@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
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
 drivers/gpu/drm/mediatek/mtk_hdmi_phy.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/mediatek/mtk_hdmi_phy.c b/drivers/gpu/drm/mediatek/mtk_hdmi_phy.c
index 5223498502c49..23a74eb5d7f81 100644
--- a/drivers/gpu/drm/mediatek/mtk_hdmi_phy.c
+++ b/drivers/gpu/drm/mediatek/mtk_hdmi_phy.c
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



