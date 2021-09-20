Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9F84411F2E
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:38:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352197AbhITRit (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:38:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:40862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347957AbhITRgo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:36:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D5BEE615A6;
        Mon, 20 Sep 2021 17:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632157596;
        bh=U4rjSsLhtKHkhPDxki2lr2YctzUD0/73TwCs51t1cw8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FviPEMS48ckKjy0re+p1QAcz1agxSX9F1k9J6J00BG/Fe2djLXjQ4T+x7paqCH036
         5QVxX7XXYZnseCZDDuGscS4no1dyxH0o7BxjESH2PFRMUEhqED0lTWyPumBy05+n+P
         mgGqf8K3luWuzp/YunTyRR7yjARs1H5NLqOvbqXI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Halasa <khalasa@piap.pl>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 062/293] media: TDA1997x: enable EDID support
Date:   Mon, 20 Sep 2021 18:40:24 +0200
Message-Id: <20210920163935.381055365@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163933.258815435@linuxfoundation.org>
References: <20210920163933.258815435@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Hałasa <khalasa@piap.pl>

[ Upstream commit ea3e1c36e38810427485f06c2becc1f29e54521d ]

Without this patch, the TDA19971 chip's EDID is inactive.
EDID never worked with this driver, it was all tested with HDMI signal
sources which don't need EDID support.

Signed-off-by: Krzysztof Halasa <khalasa@piap.pl>
Fixes: 9ac0038db9a7 ("media: i2c: Add TDA1997x HDMI receiver driver")
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/tda1997x.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/i2c/tda1997x.c b/drivers/media/i2c/tda1997x.c
index d114ac5243ec..dab441bbc9f0 100644
--- a/drivers/media/i2c/tda1997x.c
+++ b/drivers/media/i2c/tda1997x.c
@@ -2229,6 +2229,7 @@ static int tda1997x_core_init(struct v4l2_subdev *sd)
 	/* get initial HDMI status */
 	state->hdmi_status = io_read(sd, REG_HDMI_FLAGS);
 
+	io_write(sd, REG_EDID_ENABLE, EDID_ENABLE_A_EN | EDID_ENABLE_B_EN);
 	return 0;
 }
 
-- 
2.30.2



