Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92A3813FF7C
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:43:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731050AbgAPXZE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:25:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:54446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730302AbgAPXZD (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:25:03 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C14612072B;
        Thu, 16 Jan 2020 23:25:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579217103;
        bh=NSPwKSCXXk+sKxxvdvO/ts9c48CH8XGxM2OgPCbg3Cg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DTkzVWGAb4I9O3/ozu4jtRl6zh3CrkgDUMmB7DB/LLp8+rr7bRIX+hrRsRTiLivEk
         34QWp7JRaDeWz1/gt8FcYtZQZVJPOBEFGy8CyfiFYLlOmrF2Zqh+0Ro7qwh76jSZNL
         acZ7pJQ5GQPpzXwF2/NcgJEmdMoQ8pY2FPvuaqkw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Janusz Krzysztofik <jmkrzyszt@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Subject: [PATCH 5.4 149/203] media: ov6650: Fix default format not applied on device probe
Date:   Fri, 17 Jan 2020 00:17:46 +0100
Message-Id: <20200116231757.928202568@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231745.218684830@linuxfoundation.org>
References: <20200116231745.218684830@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Janusz Krzysztofik <jmkrzyszt@gmail.com>

commit 5439fa9263cb293e41168bc03711ec18c4f11cba upstream.

It is not clear what pixel format is actually configured in hardware on
reset.  MEDIA_BUS_FMT_YUYV8_2X8, assumed on device probe since the
driver was intiially submitted, is for sure not the one.

Fix it by explicitly applying a known, driver default frame format just
after initial device reset.

Fixes: 2f6e2404799a ("[media] SoC Camera: add driver for OV6650 sensor")
Signed-off-by: Janusz Krzysztofik <jmkrzyszt@gmail.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/i2c/ov6650.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/media/i2c/ov6650.c
+++ b/drivers/media/i2c/ov6650.c
@@ -877,6 +877,11 @@ static int ov6650_video_probe(struct v4l
 	ret = ov6650_reset(client);
 	if (!ret)
 		ret = ov6650_prog_dflt(client);
+	if (!ret) {
+		struct v4l2_mbus_framefmt mf = ov6650_def_fmt;
+
+		ret = ov6650_s_fmt(sd, &mf);
+	}
 	if (!ret)
 		ret = v4l2_ctrl_handler_setup(&priv->hdl);
 
@@ -1031,8 +1036,6 @@ static int ov6650_probe(struct i2c_clien
 	priv->rect.top	  = DEF_VSTRT << 1;
 	priv->rect.width  = W_CIF;
 	priv->rect.height = H_CIF;
-	priv->half_scale  = false;
-	priv->code	  = MEDIA_BUS_FMT_YUYV8_2X8;
 
 	/* Hardware default frame interval */
 	priv->tpf.numerator   = GET_CLKRC_DIV(DEF_CLKRC);


