Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F0B53A645A
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:23:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235970AbhFNLXx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:23:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:52108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235342AbhFNLVw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:21:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D5B9A61477;
        Mon, 14 Jun 2021 10:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667938;
        bh=CYeyHdrcUpwCtVzkiulcxNQDjieFU4hZICXGxgM987o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ELj9WGeEURkr/qUrdU68djf2Dwsb8H1UstwdL6zhqaaL/h5IkialP+V6kY+FprouT
         SewHWorvGGYnyWfvNhSVGn5R2bVfaJYqBcfX7WsuEmSapQSJHRqVzo9Vr52hsEu5lU
         F55qdEZVd+FvPW7dV3UBp6nLaXIOgrYtfoM/vBHk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jonathan Marek <jonathan@marek.ca>,
        Akhil P Oommen <akhilpo@codeaurora.org>,
        Rob Clark <robdclark@chromium.org>
Subject: [PATCH 5.12 132/173] drm/msm/a6xx: avoid shadow NULL reference in failure path
Date:   Mon, 14 Jun 2021 12:27:44 +0200
Message-Id: <20210614102702.561210060@linuxfoundation.org>
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

commit ce86c239e4d218ae6040bec18e6d19a58edb8b7c upstream.

If a6xx_hw_init() fails before creating the shadow_bo, the a6xx_pm_suspend
code referencing it will crash. Change the condition to one that avoids
this problem (note: creation of shadow_bo is behind this same condition)

Fixes: e8b0b994c3a5 ("drm/msm/a6xx: Clear shadow on suspend")
Signed-off-by: Jonathan Marek <jonathan@marek.ca>
Reviewed-by: Akhil P Oommen <akhilpo@codeaurora.org>
Link: https://lore.kernel.org/r/20210513171431.18632-6-jonathan@marek.ca
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
@@ -1284,7 +1284,7 @@ static int a6xx_pm_suspend(struct msm_gp
 	if (ret)
 		return ret;
 
-	if (adreno_gpu->base.hw_apriv || a6xx_gpu->has_whereami)
+	if (a6xx_gpu->shadow_bo)
 		for (i = 0; i < gpu->nr_rings; i++)
 			a6xx_gpu->shadow[i] = 0;
 


