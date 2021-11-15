Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21191450FEF
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:36:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239255AbhKOShx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:37:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:44046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238692AbhKOSfP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:35:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 738AC61ACE;
        Mon, 15 Nov 2021 18:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999338;
        bh=1WA+cCAp+hehJOLKhVUxKY83t9K1U3jwFGmAQl/F4oA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jkrAkh4bRbizEeqRK1RQ8y3/HtWOMCiMy6E8/Sz5lt9Hj29x/r3QPPFJI8C0D0tCx
         HovhhatFrhXiIGhcL8/SjXyUAgJIzW09HKm8zD9cLQwit2wsYDhJCkU5FxocSsilMQ
         eGAX4ndxfAoD3C2trCnqnLX1rzg3Ijtz7XS+Oc0Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mirela Rabulea <mirela.rabulea@nxp.com>,
        Laurentiu Palcu <laurentiu.palcu@nxp.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 262/849] media: imx-jpeg: Fix possible null pointer dereference
Date:   Mon, 15 Nov 2021 17:55:45 +0100
Message-Id: <20211115165429.110548303@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mirela Rabulea <mirela.rabulea@nxp.com>

[ Upstream commit 83f5f0633b156c636f5249d3c10f2a9423dd4c96 ]

Found by Coverity scan.

Signed-off-by: Mirela Rabulea <mirela.rabulea@nxp.com>
Reviewed-by: Laurentiu Palcu <laurentiu.palcu@nxp.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/imx-jpeg/mxc-jpeg.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/platform/imx-jpeg/mxc-jpeg.c b/drivers/media/platform/imx-jpeg/mxc-jpeg.c
index 755138063ee61..33e7604271cdf 100644
--- a/drivers/media/platform/imx-jpeg/mxc-jpeg.c
+++ b/drivers/media/platform/imx-jpeg/mxc-jpeg.c
@@ -575,6 +575,10 @@ static irqreturn_t mxc_jpeg_dec_irq(int irq, void *priv)
 
 	dst_buf = v4l2_m2m_next_dst_buf(ctx->fh.m2m_ctx);
 	src_buf = v4l2_m2m_next_src_buf(ctx->fh.m2m_ctx);
+	if (!dst_buf || !src_buf) {
+		dev_err(dev, "No source or destination buffer.\n");
+		goto job_unlock;
+	}
 	jpeg_src_buf = vb2_to_mxc_buf(&src_buf->vb2_buf);
 
 	if (dec_ret & SLOT_STATUS_ENC_CONFIG_ERR) {
-- 
2.33.0



