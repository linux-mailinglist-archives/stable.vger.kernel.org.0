Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90C333A6458
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:23:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235871AbhFNLXu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:23:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:51958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235209AbhFNLVp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:21:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A608461996;
        Mon, 14 Jun 2021 10:52:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667933;
        bh=PyMAdgW7GLXLnWN7qNnA9ReK3odBD1pWhY9I1VIyoZQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d61ndjO8MouDTekyNQcJAONLNEvjw9m/0rpAg9W4XOkaGWl8z6gACTWlNtV1wvPWp
         EtWjuPZI8HyPDpXcy+7fAxRwmKy/55v3ThctUMyfMfrUrtUvaIYyCngOeyN6u3MTkf
         67RLFBiSthGX8I61demfcPKT4EfpkTQWwR1yw9ow=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jonathan Marek <jonathan@marek.ca>,
        Akhil P Oommen <akhilpo@codeaurora.org>,
        Rob Clark <robdclark@chromium.org>
Subject: [PATCH 5.12 130/173] drm/msm/a6xx: fix incorrectly set uavflagprd_inv field for A650
Date:   Mon, 14 Jun 2021 12:27:42 +0200
Message-Id: <20210614102702.497343449@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102658.137943264@linuxfoundation.org>
References: <20210614102658.137943264@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Marek <jonathan@marek.ca>

commit b4387eaf3821a4c4241ac3a556e13244eb1fdaa5 upstream.

Value was shifted in the wrong direction, resulting in the field always
being zero, which is incorrect for A650.

Fixes: d0bac4e9cd66 ("drm/msm/a6xx: set ubwc config for A640 and A650")
Signed-off-by: Jonathan Marek <jonathan@marek.ca>
Reviewed-by: Akhil P Oommen <akhilpo@codeaurora.org>
Link: https://lore.kernel.org/r/20210513171431.18632-4-jonathan@marek.ca
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
@@ -489,7 +489,7 @@ static void a6xx_set_ubwc_config(struct
 		rgb565_predicator << 11 | amsbc << 4 | lower_bit << 1);
 	gpu_write(gpu, REG_A6XX_TPL1_NC_MODE_CNTL, lower_bit << 1);
 	gpu_write(gpu, REG_A6XX_SP_NC_MODE_CNTL,
-		uavflagprd_inv >> 4 | lower_bit << 1);
+		uavflagprd_inv << 4 | lower_bit << 1);
 	gpu_write(gpu, REG_A6XX_UCHE_MODE_CNTL, lower_bit << 21);
 }
 


