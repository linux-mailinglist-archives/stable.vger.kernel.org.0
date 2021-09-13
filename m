Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB06B409404
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:26:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345801AbhIMO1C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:27:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:45636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346593AbhIMOY4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:24:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A9A8A61155;
        Mon, 13 Sep 2021 13:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540919;
        bh=FVmS1h5hXXW0B7vmiVB4dQsfTg5klaEqvNcxlRdaTp0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UPk6qg7MmfN+fDZMb2E1A9EaEqhnZvDoM/uhXDfAfOQVU8gnYtZO9pIkPCHLeRnkU
         BGicOcfxXhemvCfApszMrYl+DewYUyj1C0HPX0P/8boHMjX2zCBMj9bsjX4EWR2h3k
         SFUw2sKp88s6qEPF1x1sBhHG2+MCnahFP5nMpdaM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Halasa <khalasa@piap.pl>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 088/334] media: TDA1997x: enable EDID support
Date:   Mon, 13 Sep 2021 15:12:22 +0200
Message-Id: <20210913131116.357689361@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
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
index 91e6db847bb5..3a191e257fad 100644
--- a/drivers/media/i2c/tda1997x.c
+++ b/drivers/media/i2c/tda1997x.c
@@ -2233,6 +2233,7 @@ static int tda1997x_core_init(struct v4l2_subdev *sd)
 	/* get initial HDMI status */
 	state->hdmi_status = io_read(sd, REG_HDMI_FLAGS);
 
+	io_write(sd, REG_EDID_ENABLE, EDID_ENABLE_A_EN | EDID_ENABLE_B_EN);
 	return 0;
 }
 
-- 
2.30.2



