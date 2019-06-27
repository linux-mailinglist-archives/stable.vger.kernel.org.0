Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEDC75784F
	for <lists+stable@lfdr.de>; Thu, 27 Jun 2019 02:53:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727909AbfF0AeD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jun 2019 20:34:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:38026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727887AbfF0Ad7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Jun 2019 20:33:59 -0400
Received: from sasha-vm.mshome.net (unknown [107.242.116.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6DD5F217D8;
        Thu, 27 Jun 2019 00:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561595638;
        bh=Z2FQXOTKv+1PDnULnMt3wLBqjLRrQA1FAvv1gewbimQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ghrRlHI7YTakET364VtMGgPpNmNcvphOLevt5FchW3tyEnlm3KlZthQ0ZiUR1w3KB
         n83KXBU948tWCelgC1pF7gJCy3OD7mca6JyTvgmTKhQoNZtK4OmUUC7x7hrG/M5rx5
         TniBpqnUmKf4kkwf/V1npkmu5TX1DLUpSD/dsYNE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.1 63/95] gpu: ipu-v3: image-convert: Fix image downsize coefficients
Date:   Wed, 26 Jun 2019 20:29:48 -0400
Message-Id: <20190627003021.19867-63-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190627003021.19867-1-sashal@kernel.org>
References: <20190627003021.19867-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steve Longerbeam <slongerbeam@gmail.com>

[ Upstream commit 912bbf7e9ca422099935dd69d3ff0fd62db24882 ]

The output of the IC downsizer unit in both dimensions must be <= 1024
before being passed to the IC resizer unit. This was causing corrupted
images when:

input_dim > 1024, and
input_dim / 2 < output_dim < input_dim

Some broken examples were 1920x1080 -> 1024x768 and 1920x1080 ->
1280x1080.

Fixes: 70b9b6b3bcb21 ("gpu: ipu-v3: image-convert: calculate per-tile
resize coefficients")

Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/ipu-v3/ipu-image-convert.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/ipu-v3/ipu-image-convert.c b/drivers/gpu/ipu-v3/ipu-image-convert.c
index 19d3b85e0e98..e9803e2151f9 100644
--- a/drivers/gpu/ipu-v3/ipu-image-convert.c
+++ b/drivers/gpu/ipu-v3/ipu-image-convert.c
@@ -409,12 +409,14 @@ static int calc_image_resize_coefficients(struct ipu_image_convert_ctx *ctx,
 	if (WARN_ON(resized_width == 0 || resized_height == 0))
 		return -EINVAL;
 
-	while (downsized_width >= resized_width * 2) {
+	while (downsized_width > 1024 ||
+	       downsized_width >= resized_width * 2) {
 		downsized_width >>= 1;
 		downsize_coeff_h++;
 	}
 
-	while (downsized_height >= resized_height * 2) {
+	while (downsized_height > 1024 ||
+	       downsized_height >= resized_height * 2) {
 		downsized_height >>= 1;
 		downsize_coeff_v++;
 	}
-- 
2.20.1

