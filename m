Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8573E12C540
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 18:41:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729413AbfL2RfB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:35:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:38890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729107AbfL2RfB (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:35:01 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E116F20409;
        Sun, 29 Dec 2019 17:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577640900;
        bh=xmheIYouYHjzQysGkAZks8VAaejYmNwQTYRmOto9HuA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FnRW+TOo8UeEfS9liAI75hX1GqC6xj1fqBkBCmDR1T7jICUotUEC2NxcKOEflbqWA
         5Pv2fe0FDqlWnctcn4/TwPyzmNHpkrmpTr/mtpNUci8J4ZGTgfCNHrvctLGp0uqNPG
         Q29K8QuQCR4eoH5lQKoPU++Yxz4zMQ/VM42l4yaI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sam Bobroff <sbobroff@linux.ibm.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 186/219] drm/amdgpu: fix bad DMA from INTERRUPT_CNTL2
Date:   Sun, 29 Dec 2019 18:19:48 +0100
Message-Id: <20191229162537.495458963@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229162508.458551679@linuxfoundation.org>
References: <20191229162508.458551679@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sam Bobroff <sbobroff@linux.ibm.com>

[ Upstream commit 3d0e3ce52ce3eb4b9de3caf9c38dbb5a4d3e13c3 ]

The INTERRUPT_CNTL2 register expects a valid DMA address, but is
currently set with a GPU MC address.  This can cause problems on
systems that detect the resulting DMA read from an invalid address
(found on a Power8 guest).

Instead, use the DMA address of the dummy page because it will always
be safe.

Fixes: 27ae10641e9c ("drm/amdgpu: add interupt handler implementation for si v3")
Signed-off-by: Sam Bobroff <sbobroff@linux.ibm.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/si_ih.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/si_ih.c b/drivers/gpu/drm/amd/amdgpu/si_ih.c
index 60dad63098a2..e40a3fbc3e76 100644
--- a/drivers/gpu/drm/amd/amdgpu/si_ih.c
+++ b/drivers/gpu/drm/amd/amdgpu/si_ih.c
@@ -62,7 +62,8 @@ static int si_ih_irq_init(struct amdgpu_device *adev)
 	u64 wptr_off;
 
 	si_ih_disable_interrupts(adev);
-	WREG32(INTERRUPT_CNTL2, adev->irq.ih.gpu_addr >> 8);
+	/* set dummy read address to dummy page address */
+	WREG32(INTERRUPT_CNTL2, adev->dummy_page_addr >> 8);
 	interrupt_cntl = RREG32(INTERRUPT_CNTL);
 	interrupt_cntl &= ~IH_DUMMY_RD_OVERRIDE;
 	interrupt_cntl &= ~IH_REQ_NONSNOOP_EN;
-- 
2.20.1



