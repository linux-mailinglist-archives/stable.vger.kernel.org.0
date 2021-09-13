Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05463409146
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:59:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244842AbhIMOAW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:00:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:40308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245519AbhIMN5c (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:57:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 525EB6138D;
        Mon, 13 Sep 2021 13:36:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540183;
        bh=qOOevOLNhiAsgu3FtvK0d8BD+Yg9reJfq3YzzOlZygc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xM6NvngcLWDVRqiTI9TmB0g/MbSWmGWIE1fHyiqeZXFAmSSIq/ZrcTMb65DSWUPf0
         t4NsRjitqxRIO7Ws21YF6vFHxzbwdh99NKGpJ8WQU1rkXgmjuqJBbOQrJQBhMrxGsn
         hTBGcDz2lda0NrqJuGin/eXy4+5iinW01ltViYXc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Halasa <khalasa@piap.pl>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 085/300] media: TDA1997x: enable EDID support
Date:   Mon, 13 Sep 2021 15:12:26 +0200
Message-Id: <20210913131112.254935106@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131109.253835823@linuxfoundation.org>
References: <20210913131109.253835823@linuxfoundation.org>
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
index 89bb7e6dc7a4..9554c8348c02 100644
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



