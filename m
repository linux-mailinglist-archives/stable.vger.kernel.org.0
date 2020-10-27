Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F53529B39E
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:56:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1752077AbgJ0Oxy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:53:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:45590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1763944AbgJ0Opl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:45:41 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 91D8E21D7B;
        Tue, 27 Oct 2020 14:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603809941;
        bh=7V9wtvwdCQLMZ8tHmSfN2E3T9IbfUcLtzn8OQH3qIUU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SaV2BkkBFbe4LLx3hcJtRVz3x3toqcFfTAXnj5WgJ+31m7guYnXrOYiop2whuxKx5
         CvRZVUL8fj2PVCI2Bx7gSucyfJ2Tn8LpDem8/Or/wZ5mZ+ZnAqcehRx2Yzg/OAphDa
         t1U6iWaniKClCrOzKrJGQPjTU2NCAhfe/bgvIgFQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhenzhong Duan <zhenzhong.duan@gmail.com>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 373/408] drm/msm/a6xx: fix a potential overflow issue
Date:   Tue, 27 Oct 2020 14:55:11 +0100
Message-Id: <20201027135512.303691610@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135455.027547757@linuxfoundation.org>
References: <20201027135455.027547757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhenzhong Duan <zhenzhong.duan@gmail.com>

[ Upstream commit 08d3ab4b46339bc6f97e83b54a3fb4f8bf8f4cd9 ]

It's allocating an array of a6xx_gpu_state_obj structure rathor than
its pointers.

This patch fix it.

Signed-off-by: Zhenzhong Duan <zhenzhong.duan@gmail.com>
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a6xx_gpu_state.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/adreno/a6xx_gpu_state.c b/drivers/gpu/drm/msm/adreno/a6xx_gpu_state.c
index 691c1a277d91b..dfcbb2b7cdda3 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gpu_state.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gpu_state.c
@@ -834,7 +834,7 @@ static void a6xx_get_indexed_registers(struct msm_gpu *gpu,
 	int i;
 
 	a6xx_state->indexed_regs = state_kcalloc(a6xx_state, count,
-		sizeof(a6xx_state->indexed_regs));
+		sizeof(*a6xx_state->indexed_regs));
 	if (!a6xx_state->indexed_regs)
 		return;
 
-- 
2.25.1



