Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6567D40E52A
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:26:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245045AbhIPRIb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:08:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:35946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349473AbhIPRFw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:05:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B8B1161872;
        Thu, 16 Sep 2021 16:35:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810143;
        bh=Ij2J7ZY0EYA4SRi/ycfyi++V5khckp+5urzgc9BwJ4k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BwPEHvVSj8NpPXK4Fc4jkP0H+EKkNZON2tC6E3CEAvmOWnoX0hbLq3cMjVnNf41kg
         MXDInCqx+4o934PuEQMtTmljd2xbawyNdBbGAioBjAzHpTUvLfqGC/QLjmrB2RZma3
         kmfggxm3F9CkoaM41SSM/3e54DwKK+qGsx7GfWTc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Eizan Miyamoto <eizan@chromium.org>,
        Matthias Brugger <matthias.bgg@gmail.com>
Subject: [PATCH 5.14 033/432] soc: mediatek: mmsys: Fix missing UFOE component in mt8173 table routing
Date:   Thu, 16 Sep 2021 17:56:22 +0200
Message-Id: <20210916155811.942436912@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
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
 


