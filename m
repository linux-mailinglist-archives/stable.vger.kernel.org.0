Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FDCD45103F
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:42:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242141AbhKOSpK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:45:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:47398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237940AbhKOSmq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:42:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 62B84632F9;
        Mon, 15 Nov 2021 18:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999510;
        bh=XdHzq69UVsgqR64Yin1bH2sBYmYAy/ceHyhnLzd7Ng8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WrFa0mcdydFuuH7wqabZrHoJ7NH8W5/pFemcUT/4mT9Qrk589asBlur/Gmw+j4zfz
         kfV9SrBiR7k0VzlTi3HO8nJCsnlNC8iQpEIUxeIVvFiaLeMy3bGJwodKf3y4X/oaVR
         ZYSvkPP1JKzQjG7UHQop1hmym6Ptq81EwItkStG8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rob Clark <robdclark@gmail.com>,
        Sean Paul <sean@poorly.run>, David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>, linux-arm-msm@vger.kernel.org,
        dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org,
        Tim Gardner <tim.gardner@canonical.com>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 280/849] drm/msm: prevent NULL dereference in msm_gpu_crashstate_capture()
Date:   Mon, 15 Nov 2021 17:56:03 +0100
Message-Id: <20211115165429.743976506@linuxfoundation.org>
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

From: Tim Gardner <tim.gardner@canonical.com>

[ Upstream commit b220c154832c5cd0df34cbcbcc19d7135c16e823 ]

Coverity complains of a possible NULL dereference:

CID 120718 (#1 of 1): Dereference null return value (NULL_RETURNS)
23. dereference: Dereferencing a pointer that might be NULL state->bos when
    calling msm_gpu_crashstate_get_bo. [show details]
301                        msm_gpu_crashstate_get_bo(state, submit->bos[i].obj,
302                                submit->bos[i].iova, submit->bos[i].flags);

Fix this by employing the same state->bos NULL check as is used in the next
for loop.

Cc: Rob Clark <robdclark@gmail.com>
Cc: Sean Paul <sean@poorly.run>
Cc: David Airlie <airlied@linux.ie>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: linux-arm-msm@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org
Cc: freedreno@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20210929162554.14295-1-tim.gardner@canonical.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/msm_gpu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/msm_gpu.c b/drivers/gpu/drm/msm/msm_gpu.c
index 0ebf7bc6ad097..8236989828ba3 100644
--- a/drivers/gpu/drm/msm/msm_gpu.c
+++ b/drivers/gpu/drm/msm/msm_gpu.c
@@ -404,7 +404,7 @@ static void msm_gpu_crashstate_capture(struct msm_gpu *gpu,
 		state->bos = kcalloc(nr,
 			sizeof(struct msm_gpu_state_bo), GFP_KERNEL);
 
-		for (i = 0; i < submit->nr_bos; i++) {
+		for (i = 0; state->bos && i < submit->nr_bos; i++) {
 			if (should_dump(submit, i)) {
 				msm_gpu_crashstate_get_bo(state, submit->bos[i].obj,
 					submit->bos[i].iova, submit->bos[i].flags);
-- 
2.33.0



