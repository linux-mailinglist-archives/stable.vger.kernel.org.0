Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFD533BB2D6
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:15:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbhGDXQc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:16:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:50590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232558AbhGDXNP (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:13:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 647BF6194A;
        Sun,  4 Jul 2021 23:08:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625440140;
        bh=ics9+4LFLEdVrg/TAATc/op/qasecKi+weli1DrdSsI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PKg0zNs35WyWBUJRYVSheb++WosJcLH9T03+ozJOP7U7jA7sO/Kb1RJAlsZk9IVYZ
         ZUO3OGg9FjUuOJ8Y2nVUHUdxWyHVbz6+KGc5vl8WRO0AUy4wflqGWKV8pdjqLI7Lmu
         hF3AQprsj+6UFbfDWObK0YF3JMW80Fj7cYb0ZjcuzXjxpzDO6OfI3DQXRR0TtvllDr
         9qKLnpdCuawI47gd8PYcN5y4cZyDcFEPbUJ8w9Mq2wlTsSOgU5MraY+MU3QhO5hbK3
         4DQNtYL5Ca59u9nSo1vTDwG8fsf34tStZlNIOB9BSXOP8M7U2vjRNU3pnbXaoSz4hm
         QR2kMuezbxHYg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Evgeny Novikov <novikov@ispras.ru>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 41/70] media: st-hva: Fix potential NULL pointer dereferences
Date:   Sun,  4 Jul 2021 19:07:34 -0400
Message-Id: <20210704230804.1490078-41-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704230804.1490078-1-sashal@kernel.org>
References: <20210704230804.1490078-1-sashal@kernel.org>
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
index 43f279e2a6a3..cf4c891bf619 100644
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

