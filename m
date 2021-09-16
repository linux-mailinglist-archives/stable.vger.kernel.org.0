Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4E6E40E17D
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 18:29:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242255AbhIPQav (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:30:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:38934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241886AbhIPQ21 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:28:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F212161357;
        Thu, 16 Sep 2021 16:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631809088;
        bh=Ij2J7ZY0EYA4SRi/ycfyi++V5khckp+5urzgc9BwJ4k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B0uizy+d3RuaKSgLqe4QrGjjLGtmy46pFeOMD8LTSvrBSNXr3b0p0bhozd/D+Tsvx
         eTqoTVZUS3I7AE0FIqpaMveTHU/jqtkQobvdU7Wu9bjvH9nxz0llQS21JOe1Axl+Oh
         9RmTaqOt/JIHj5IBXrqcRcBqCOsEHfUzMiDASjyk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Eizan Miyamoto <eizan@chromium.org>,
        Matthias Brugger <matthias.bgg@gmail.com>
Subject: [PATCH 5.13 026/380] soc: mediatek: mmsys: Fix missing UFOE component in mt8173 table routing
Date:   Thu, 16 Sep 2021 17:56:23 +0200
Message-Id: <20210916155804.858985532@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155803.966362085@linuxfoundation.org>
References: <20210916155803.966362085@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Enric Balletbo i Serra <enric.balletbo@collabora.com>

commit 25423731956b3d72bc35d336227c88ada49148e8 upstream.

The UFOE (data compression engine) component needs to be enabled to have
the imgtec gpu driver working. If we don't enable it we see a black screen.
Looks like when we switched to use and array for setting the routing
registers in commit 440147639ac7 ("soc: mediatek: mmsys: Use an array for
setting the routing registers") we missed to add this component in the new
routing table, it was present before that commit, so fix it by adding
this component in the mt8173 routing table.

Fixes: 440147639ac7 ("soc: mediatek: mmsys: Use an array for setting the routing registers")
Signed-off-by: Enric Balletbo i Serra <enric.balletbo@collabora.com>
Tested-by: Eizan Miyamoto <eizan@chromium.org>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210625062448.3462177-1-enric.balletbo@collabora.com
[mb: taking into account mask value]
Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/soc/mediatek/mtk-mmsys.h |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/soc/mediatek/mtk-mmsys.h
+++ b/drivers/soc/mediatek/mtk-mmsys.h
@@ -262,6 +262,10 @@ static const struct mtk_mmsys_routes mms
 		DDP_COMPONENT_RDMA2, DDP_COMPONENT_DSI3,
 		DISP_REG_CONFIG_DSIO_SEL_IN, DSI3_SEL_IN_MASK,
 		DSI3_SEL_IN_RDMA2
+	}, {
+		DDP_COMPONENT_UFOE, DDP_COMPONENT_DSI0,
+		DISP_REG_CONFIG_DISP_UFOE_MOUT_EN, UFOE_MOUT_EN_DSI0,
+		UFOE_MOUT_EN_DSI0
 	}
 };
 


