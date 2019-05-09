Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D89019232
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 21:05:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727487AbfEITFK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 15:05:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:40700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727915AbfEISr6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 May 2019 14:47:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F169217D7;
        Thu,  9 May 2019 18:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557427678;
        bh=sjNQ5IgPNKUyGx6RJsA8iWeENSdeFmBwhTuFKrrrZ3U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zGmDrTmLjxoEmFp84HhNIoBWT7jDoI4Db1771qJRcS/O1d4PtSVMrTaJsFuRjIpcV
         VMV8QT7GuA2T05B9YyjoAVcpCLz9cgsiYV93qXV/OrRzJJ/VXvVhzymMs5VobYWaVu
         Bbd2KgAERmA37OrBBU0K2fc9Ybm/1iQaeaSiebjM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        CK Hu <ck.hu@mediatek.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 28/66] drm/mediatek: Fix an error code in mtk_hdmi_dt_parse_pdata()
Date:   Thu,  9 May 2019 20:42:03 +0200
Message-Id: <20190509181304.853099638@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190509181301.719249738@linuxfoundation.org>
References: <20190509181301.719249738@linuxfoundation.org>
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
index 643f5edd68fe3..c7a77d6f612b2 100644
--- a/drivers/gpu/drm/mediatek/mtk_hdmi.c
+++ b/drivers/gpu/drm/mediatek/mtk_hdmi.c
@@ -1473,7 +1473,6 @@ static int mtk_hdmi_dt_parse_pdata(struct mtk_hdmi *hdmi,
 	if (IS_ERR(regmap))
 		ret = PTR_ERR(regmap);
 	if (ret) {
-		ret = PTR_ERR(regmap);
 		dev_err(dev,
 			"Failed to get system configuration registers: %d\n",
 			ret);
-- 
2.20.1



