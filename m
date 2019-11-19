Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D33BE1014E9
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:38:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729061AbfKSFil (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:38:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:60716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729621AbfKSFik (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:38:40 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA180208C3;
        Tue, 19 Nov 2019 05:38:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141918;
        bh=tlbUosy2fq8Q/oWAJId8gRxFvS+jxOmsLcfyNhEtnSc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xHX+StIMKIHms4csQztj0Qg2r4e2YpE5gBm3GLTGhr3Zqi2y2c03gZ+KqCKKooOak
         6bZDE9TICfIpgrmOZO1YBRx1TQEksb7lx5q/okCs8ycwnB/TsfhPEV8+jnah1cmUEx
         73NMCJtpOc7noWWATai6OFjMnEa3j8aSitvdizVQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 326/422] media: imx: work around false-positive warning, again
Date:   Tue, 19 Nov 2019 06:18:43 +0100
Message-Id: <20191119051420.140254143@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 8d1a4817cce1b15b4909f0e324a4f5af5952da67 ]

A warning that I thought to be solved by a previous patch of mine
has resurfaced with gcc-8:

media/imx/imx-media-csi.c: In function 'csi_link_validate':
media/imx/imx-media-csi.c:1025:20: error: 'upstream_ep' may be used uninitialized in this function [-Werror=maybe-uninitialized]
media/imx/imx-media-csi.c:1026:24: error: 'upstream_ep.bus_type' may be used uninitialized in this function [-Werror=maybe-uninitialized]
media/imx/imx-media-csi.c:127:19: error: 'upstream_ep.bus.parallel.bus_width' may be used uninitialized in this function [-Werror=maybe-uninitialized]
media/imx/imx-media-csi.c: In function 'csi_enum_mbus_code':
media/imx/imx-media-csi.c:132:9: error: '*((void *)&upstream_ep+12)' may be used uninitialized in this function [-Werror=maybe-uninitialized]
media/imx/imx-media-csi.c:132:48: error: 'upstream_ep.bus.parallel.bus_width' may be used uninitialized in this function [-Werror=maybe-uninitialized]

I spent some more time digging in this time, and think I have a better
fix, bailing out of the function that either initializes or errors
out here, which simplifies the code enough for gcc to figure out
what is going on. The earlier partial workaround can be removed now,
as the new workaround is better.

Fixes: 890f27693f2a ("media: imx: work around false-positive warning")

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/imx/imx-media-csi.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
index d17ce1fb4ef51..0f8fdc347091b 100644
--- a/drivers/staging/media/imx/imx-media-csi.c
+++ b/drivers/staging/media/imx/imx-media-csi.c
@@ -166,6 +166,9 @@ static int csi_get_upstream_endpoint(struct csi_priv *priv,
 	struct v4l2_subdev *sd;
 	struct media_pad *pad;
 
+	if (!IS_ENABLED(CONFIG_OF))
+		return -ENXIO;
+
 	if (!priv->src_sd)
 		return -EPIPE;
 
@@ -1072,7 +1075,7 @@ static int csi_link_validate(struct v4l2_subdev *sd,
 			     struct v4l2_subdev_format *sink_fmt)
 {
 	struct csi_priv *priv = v4l2_get_subdevdata(sd);
-	struct v4l2_fwnode_endpoint upstream_ep = {};
+	struct v4l2_fwnode_endpoint upstream_ep;
 	bool is_csi2;
 	int ret;
 
-- 
2.20.1



