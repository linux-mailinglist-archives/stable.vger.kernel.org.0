Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B26F03BB2A8
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:14:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233425AbhGDXQD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:16:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:50794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234226AbhGDXO5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:14:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 754CD61960;
        Sun,  4 Jul 2021 23:11:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625440303;
        bh=miupIieA8N3u5xFBc+Zyeff4poumuKA0p+ZcrLMKpU4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S4RINcr4FB03Azuy7lSOPr7L+3Jr9QJd+h/dLAI51iPErEacTh7eZVpUgQUQl8dc4
         B3mIJhwYEkoOz+WwvRtwRY71rdTrZAI0z7Me9iPkrzP87uLSY56pECEBKQrskcLGIU
         FbGGXp992kZwSHYL6jz/HPfPct867GMK1OLBTTou/+zpBamJnSYhSR//s3W7ue0vDq
         NZG+i9oLfz8YFBdW4OeGeyf1cggoGPE34/53bo908J0PBwkd8tmegNbRBJxMKcO2FE
         0Vd5fjmU1vpp3fcj6NejPXdapm1YIzVFMukvjXZ4N8b+80tSoZ1ABP10xb0A7pee+N
         kFhQILuIBo+xw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Evgeny Novikov <novikov@ispras.ru>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 15/25] media: st-hva: Fix potential NULL pointer dereferences
Date:   Sun,  4 Jul 2021 19:11:13 -0400
Message-Id: <20210704231123.1491517-15-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704231123.1491517-1-sashal@kernel.org>
References: <20210704231123.1491517-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Evgeny Novikov <novikov@ispras.ru>

[ Upstream commit b7fdd208687ba59ebfb09b2199596471c63b69e3 ]

When ctx_id >= HVA_MAX_INSTANCES in hva_hw_its_irq_thread() it tries to
access fields of ctx that is NULL at that point. The patch gets rid of
these accesses.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Evgeny Novikov <novikov@ispras.ru>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/sti/hva/hva-hw.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/platform/sti/hva/hva-hw.c b/drivers/media/platform/sti/hva/hva-hw.c
index 1185f6b6721e..3bb4d55c2058 100644
--- a/drivers/media/platform/sti/hva/hva-hw.c
+++ b/drivers/media/platform/sti/hva/hva-hw.c
@@ -130,8 +130,7 @@ static irqreturn_t hva_hw_its_irq_thread(int irq, void *arg)
 	ctx_id = (hva->sts_reg & 0xFF00) >> 8;
 	if (ctx_id >= HVA_MAX_INSTANCES) {
 		dev_err(dev, "%s     %s: bad context identifier: %d\n",
-			ctx->name, __func__, ctx_id);
-		ctx->hw_err = true;
+			HVA_PREFIX, __func__, ctx_id);
 		goto out;
 	}
 
-- 
2.30.2

