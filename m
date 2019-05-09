Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBCB01918E
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 20:59:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728021AbfEISwr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 14:52:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:46986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728749AbfEISwq (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 May 2019 14:52:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CDE0120578;
        Thu,  9 May 2019 18:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557427966;
        bh=Ibtws5LG+vnbLSs2hHATQTdPi9vzfuTzlRM6ycO2Opo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F+smWmF5BWf7KBYqeltLDr+Y3VSXmi1tBc1iNh0Sv6uoTCdpK2lrQodj1694kfmHv
         Y7L9BDQnDecMZsjBDYSFeNg2TAnR+O0vkjq3y/ag4Fv9zjkcOyhSMtEaNTkWILBupM
         GfW/nRo9RSZgb5OeXeLCnHBGwrscgkVoQzaNXE04=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        CK Hu <ck.hu@mediatek.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 35/95] drm/mediatek: Fix an error code in mtk_hdmi_dt_parse_pdata()
Date:   Thu,  9 May 2019 20:41:52 +0200
Message-Id: <20190509181311.753102908@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190509181309.180685671@linuxfoundation.org>
References: <20190509181309.180685671@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 2d85978341e6a32e7443d9f28639da254d53f400 ]

We don't want to overwrite "ret", it already holds the correct error
code.  The "regmap" variable might be a valid pointer as this point.

Fixes: 8f83f26891e1 ("drm/mediatek: Add HDMI support")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: CK Hu <ck.hu@mediatek.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_hdmi.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/gpu/drm/mediatek/mtk_hdmi.c b/drivers/gpu/drm/mediatek/mtk_hdmi.c
index 862f3ec221318..c910850d20770 100644
--- a/drivers/gpu/drm/mediatek/mtk_hdmi.c
+++ b/drivers/gpu/drm/mediatek/mtk_hdmi.c
@@ -1479,7 +1479,6 @@ static int mtk_hdmi_dt_parse_pdata(struct mtk_hdmi *hdmi,
 	if (IS_ERR(regmap))
 		ret = PTR_ERR(regmap);
 	if (ret) {
-		ret = PTR_ERR(regmap);
 		dev_err(dev,
 			"Failed to get system configuration registers: %d\n",
 			ret);
-- 
2.20.1



