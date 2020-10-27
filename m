Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAEA329BBAE
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:30:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1809592AbgJ0Q0l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 12:26:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:53662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1803050AbgJ0PwH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:52:07 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8FC442065C;
        Tue, 27 Oct 2020 15:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813927;
        bh=415yi4PlEZwq0e8liZdsfrLVKMR8mbuh+JjQSJGECVU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xiZhUy6bP+hbwf2MDImud4cOh52Mw8ADJ0se0arjaNw3Vqp3pZw7SurfpY16OQRvy
         w+UmbKHrA98tt/EapQWkNfXaIx/HBAnZ8aMeaTvrBusYM24iXzM2FFyo9zKK0i/SVK
         R1/PUO1xtx2ivx71inTqt6f3fFwzNgwPLyx/zKjM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhenzhong Duan <zhenzhong.duan@gmail.com>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 710/757] drm/msm/a6xx: fix a potential overflow issue
Date:   Tue, 27 Oct 2020 14:56:00 +0100
Message-Id: <20201027135523.804036360@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
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
index b12f5b4a1bea9..e9ede19193b0e 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gpu_state.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gpu_state.c
@@ -875,7 +875,7 @@ static void a6xx_get_indexed_registers(struct msm_gpu *gpu,
 	int i;
 
 	a6xx_state->indexed_regs = state_kcalloc(a6xx_state, count,
-		sizeof(a6xx_state->indexed_regs));
+		sizeof(*a6xx_state->indexed_regs));
 	if (!a6xx_state->indexed_regs)
 		return;
 
-- 
2.25.1



