Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3079FCD6F1
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 19:51:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729944AbfJFRvk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:51:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:38898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730783AbfJFRjZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:39:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C61562087E;
        Sun,  6 Oct 2019 17:39:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570383565;
        bh=TcQJWdjIDXDwAH8RWD2Ob2jmrYxZ0FEDUkeX5eqwNmI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e16HH8BZmS3QtGPe4HgC1FsM2i/N82eFyxUJJ7ySdKc4riND8rqwEr4wA+aIL7ejD
         CuyodP8dAzjULt6pNRmXu3jfvrb5QM5XKlpL222b3lLf0IJXnP8rOhp8PheDdLsZo1
         s5fEoCkS4cj+HVBSeJjrI5kcYyqOWfNJdYagxaLc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Olivier Moysan <olivier.moysan@st.com>,
        Jyri Sarha <jsarha@ti.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 014/166] drm/bridge: sii902x: fix missing reference to mclk clock
Date:   Sun,  6 Oct 2019 19:19:40 +0200
Message-Id: <20191006171213.963286832@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171212.850660298@linuxfoundation.org>
References: <20191006171212.850660298@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Olivier Moysan <olivier.moysan@st.com>

[ Upstream commit 365d28c92f8cd3d3860f8dd057a8c136e24b3698 ]

Add devm_clk_get call to retrieve reference to master clock.

Fixes: ff5781634c41 ("drm/bridge: sii902x: Implement HDMI audio support")

Signed-off-by: Olivier Moysan <olivier.moysan@st.com>
Reviewed-by: Jyri Sarha <jsarha@ti.com>
Acked-by: Andrzej Hajda <a.hajda@samsung.com
Signed-off-by: Benjamin Gaignard <benjamin.gaignard@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/1563811560-29589-2-git-send-email-olivier.moysan@st.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/sii902x.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/bridge/sii902x.c b/drivers/gpu/drm/bridge/sii902x.c
index dd7aa466b2805..36acc256e67e3 100644
--- a/drivers/gpu/drm/bridge/sii902x.c
+++ b/drivers/gpu/drm/bridge/sii902x.c
@@ -750,6 +750,7 @@ static int sii902x_audio_codec_init(struct sii902x *sii902x,
 		sii902x->audio.i2s_fifo_sequence[i] |= audio_fifo_id[i] |
 			i2s_lane_id[lanes[i]] |	SII902X_TPI_I2S_FIFO_ENABLE;
 
+	sii902x->audio.mclk = devm_clk_get(dev, "mclk");
 	if (IS_ERR(sii902x->audio.mclk)) {
 		dev_err(dev, "%s: No clock (audio mclk) found: %ld\n",
 			__func__, PTR_ERR(sii902x->audio.mclk));
-- 
2.20.1



