Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77F2F3C4DD5
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:40:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240711AbhGLHPQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:15:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:46652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241035AbhGLHNq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:13:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E77C061166;
        Mon, 12 Jul 2021 07:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626073849;
        bh=wyMWFanJk4V0p8E7UCLTYW9/FtAYpGWdH2tr4Hp7hEM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bigi8iOc55Ob3VH81fAVqcvl920xGHGP2nIj97yF0ZmfiJM2aYApeAcMQoTgX8GhQ
         v+D3sFCk/RCvzlaR8jt9kU0t0BQiVtCaDvp+ZLto0bjszHt4yMu835duCECuXbVl0m
         ag6v2vaQIXtHv0bvYKcGER1BfNrefs0qy+na0b/g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Guenter Roeck <groeck@chromium.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 379/700] drm/rockchip: cdn-dp: fix sign extension on an int multiply for a u64 result
Date:   Mon, 12 Jul 2021 08:07:42 +0200
Message-Id: <20210712061016.649207788@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit ce0cb93a5adb283f577cd4661f511047b5e39028 ]

The variable bit_per_pix is a u8 and is promoted in the multiplication
to an int type and then sign extended to a u64. If the result of the
int multiplication is greater than 0x7fffffff then the upper 32 bits will
be set to 1 as a result of the sign extension. Avoid this by casting
tu_size_reg to u64 to avoid sign extension and also a potential overflow.

Fixes: 1a0f7ed3abe2 ("drm/rockchip: cdn-dp: add cdn DP support for rk3399")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Reviewed-by: Guenter Roeck <groeck@chromium.org>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20200915162049.36434-1-colin.king@canonical.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/rockchip/cdn-dp-reg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/rockchip/cdn-dp-reg.c b/drivers/gpu/drm/rockchip/cdn-dp-reg.c
index 9d2163ef4d6e..33fb4d05c506 100644
--- a/drivers/gpu/drm/rockchip/cdn-dp-reg.c
+++ b/drivers/gpu/drm/rockchip/cdn-dp-reg.c
@@ -658,7 +658,7 @@ int cdn_dp_config_video(struct cdn_dp_device *dp)
 	 */
 	do {
 		tu_size_reg += 2;
-		symbol = tu_size_reg * mode->clock * bit_per_pix;
+		symbol = (u64)tu_size_reg * mode->clock * bit_per_pix;
 		do_div(symbol, dp->max_lanes * link_rate * 8);
 		rem = do_div(symbol, 1000);
 		if (tu_size_reg > 64) {
-- 
2.30.2



