Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD3D52E3D04
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:11:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438935AbgL1OKD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:10:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:44542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438931AbgL1OKC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:10:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7BF0C207AB;
        Mon, 28 Dec 2020 14:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164562;
        bh=nKhsibxIgl5pMJc4yubbeYhDJ7KRHiUHEMiKE0rYd/I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XR0IAySADdfjg0aIDiBlz6LCkUIx+MiiZ8ReDVuQQ7uEupLYYrljvPR/Pm+RiIU8s
         Zq3NFRNQyb3QtYfhLbjFbF2UVYNryv1QcUMuozcsHAnb2GBJOQZ5dc4G2yDeqHpqJd
         DzDGcgKp+Nb+macbvJaubiKgGIgrJMmY8ayB/Zc4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Gomez <daniel@qtec.com>,
        Ricardo Ribalda <ribalda@kernel.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 219/717] media: imx214: Fix stop streaming
Date:   Mon, 28 Dec 2020 13:43:37 +0100
Message-Id: <20201228125031.470580878@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Gomez <daniel@qtec.com>

[ Upstream commit eeb76afbe8d91e112396c6281cd020725160f006 ]

Stop video streaming when requested.

When s_stream is called to stop the video streaming, if/else condition calls
start_streaming function instead of the one for stopping it.

Fixes: 436190596241 ("media: imx214: Add imx214 camera sensor driver")
Signed-off-by: Daniel Gomez <daniel@qtec.com>
Signed-off-by: Ricardo Ribalda <ribalda@kernel.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/imx214.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/imx214.c b/drivers/media/i2c/imx214.c
index 1ef5af9a8c8bc..cee1a4817af99 100644
--- a/drivers/media/i2c/imx214.c
+++ b/drivers/media/i2c/imx214.c
@@ -786,7 +786,7 @@ static int imx214_s_stream(struct v4l2_subdev *subdev, int enable)
 		if (ret < 0)
 			goto err_rpm_put;
 	} else {
-		ret = imx214_start_streaming(imx214);
+		ret = imx214_stop_streaming(imx214);
 		if (ret < 0)
 			goto err_rpm_put;
 		pm_runtime_put(imx214->dev);
-- 
2.27.0



