Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88D0366D33
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 14:27:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728268AbfGLM1c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 08:27:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:40092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728629AbfGLM1b (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jul 2019 08:27:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 523E12166E;
        Fri, 12 Jul 2019 12:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562934450;
        bh=up/VqfVdtX7dNfyQg0SVx7gE5FZPPYce5pUzktaZStA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=onx5iBmuGJERniVNsJbQcZKC6mXdOfvwm0TC421D426kyo6WKm06rN3GJ2dzKGL11
         SZIQTRGlHIdMptSx3TbDXQc5/jwEJVlnThETg6W6nbkIH4YmKDaW3pqCgGMBz43/G/
         Z+dIORk72Fna4G7FItbg4D6y2PqLAU8OmwM7N7V4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Harsha Manjula Mallikarjun 
        <Harsha.ManjulaMallikarjun@in.bosch.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 058/138] gpu: ipu-v3: image-convert: Fix input bytesperline for packed formats
Date:   Fri, 12 Jul 2019 14:18:42 +0200
Message-Id: <20190712121630.897056625@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190712121628.731888964@linuxfoundation.org>
References: <20190712121628.731888964@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit bca4d70cf1b8f6478a711c448a3a1e47b794b162 ]

The input bytesperline calculation for packed pixel formats was
incorrect. The min/max clamping values must be multiplied by the
packed bits-per-pixel. This was causing corrupted converted images
when the input format was RGB4 (probably also other input packed
formats).

Fixes: d966e23d61a2c ("gpu: ipu-v3: image-convert: fix bytesperline
adjustment")

Reported-by: Harsha Manjula Mallikarjun <Harsha.ManjulaMallikarjun@in.bosch.com>
Suggested-by: Harsha Manjula Mallikarjun <Harsha.ManjulaMallikarjun@in.bosch.com>
Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/ipu-v3/ipu-image-convert.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/ipu-v3/ipu-image-convert.c b/drivers/gpu/ipu-v3/ipu-image-convert.c
index 0d971985f8c9..19d3b85e0e98 100644
--- a/drivers/gpu/ipu-v3/ipu-image-convert.c
+++ b/drivers/gpu/ipu-v3/ipu-image-convert.c
@@ -1942,7 +1942,9 @@ void ipu_image_convert_adjust(struct ipu_image *in, struct ipu_image *out,
 		clamp_align(in->pix.width, 2 << w_align_in, MAX_W,
 			    w_align_in) :
 		clamp_align((in->pix.width * infmt->bpp) >> 3,
-			    2 << w_align_in, MAX_W, w_align_in);
+			    ((2 << w_align_in) * infmt->bpp) >> 3,
+			    (MAX_W * infmt->bpp) >> 3,
+			    w_align_in);
 	in->pix.sizeimage = infmt->planar ?
 		(in->pix.height * in->pix.bytesperline * infmt->bpp) >> 3 :
 		in->pix.height * in->pix.bytesperline;
-- 
2.20.1



