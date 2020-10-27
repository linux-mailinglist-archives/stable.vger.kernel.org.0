Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 596EF29BCB4
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:41:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1811009AbgJ0Qgn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 12:36:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:45826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1800383AbgJ0Prd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:47:33 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7AC322065C;
        Tue, 27 Oct 2020 15:47:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813653;
        bh=LbD6IoHZieJJCtXlbN6HKrol80WwfBAzwbr2lDW+r+U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mitcOIjIOd5GMh9P3cN69CpTbeD3IqxD1HlzykVHn9Cbmyz04/8JW7xa9uZwIzc/x
         8qUGDt9KIENBG++POo2oBKLCa4zXftedM7jjwWyxG6E7GNRGaY+CUjpRfI3XkQZ15j
         GfDG4JKQOgcLb68dAr0z2QgAaDSm7sUDk//TqH8A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dennis YC Hsieh <dennis-yc.hsieh@mediatek.com>,
        Bibby Hsieh <bibby.hsieh@mediatek.com>,
        Chun-Kuang Hu <chunkuang.hu@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 625/757] drm/mediatek: reduce clear event
Date:   Tue, 27 Oct 2020 14:54:35 +0100
Message-Id: <20201027135519.865117077@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dennis YC Hsieh <dennis-yc.hsieh@mediatek.com>

[ Upstream commit bee1abc9cc021f50b90f22a589d9ddc816a80db0 ]

No need to clear event again since event always clear before wait.
This fix depend on patch:
  "soc: mediatek: cmdq: add clear option in cmdq_pkt_wfe api"

Fixes: 2f965be7f9008 ("drm/mediatek: apply CMDQ control flow")
Signed-off-by: Dennis YC Hsieh <dennis-yc.hsieh@mediatek.com>
Reviewed-by: Bibby Hsieh <bibby.hsieh@mediatek.com>
Acked-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Link: https://lore.kernel.org/r/1594136714-11650-10-git-send-email-dennis-yc.hsieh@mediatek.com
Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_drm_crtc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/mediatek/mtk_drm_crtc.c b/drivers/gpu/drm/mediatek/mtk_drm_crtc.c
index a4977009d3076..ac038572164d3 100644
--- a/drivers/gpu/drm/mediatek/mtk_drm_crtc.c
+++ b/drivers/gpu/drm/mediatek/mtk_drm_crtc.c
@@ -481,7 +481,7 @@ static void mtk_drm_crtc_hw_config(struct mtk_drm_crtc *mtk_crtc)
 		mbox_flush(mtk_crtc->cmdq_client->chan, 2000);
 		cmdq_handle = cmdq_pkt_create(mtk_crtc->cmdq_client, PAGE_SIZE);
 		cmdq_pkt_clear_event(cmdq_handle, mtk_crtc->cmdq_event);
-		cmdq_pkt_wfe(cmdq_handle, mtk_crtc->cmdq_event, true);
+		cmdq_pkt_wfe(cmdq_handle, mtk_crtc->cmdq_event, false);
 		mtk_crtc_ddp_config(crtc, cmdq_handle);
 		cmdq_pkt_finalize(cmdq_handle);
 		cmdq_pkt_flush_async(cmdq_handle, ddp_cmdq_cb, cmdq_handle);
-- 
2.25.1



