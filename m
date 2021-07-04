Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4285B3BB059
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:08:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231231AbhGDXIS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:08:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:46686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230488AbhGDXIA (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:08:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6660A613F9;
        Sun,  4 Jul 2021 23:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625439924;
        bh=b+dbzik4gF/bptX3LTN5yD5r59X5tqhaXyxGi2QAB1k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T9IzHrxQ4AZYeGak7mjV3nz3Jkrfzl3+WnbAunzaQ9b7qsjwHOQmVV03H3mmDXuN6
         6gzHxzEz19PQbksLBQ4qRjMYJSrvcK5TRO2VDYKbdgTJ6C5x5OTRVWbMqd7plYwecT
         f8ZR/HcSfkuUBryozrkGFg7QEC/6RHo7bWzcyUWJXLQfSRPTAffW7wNzYVeCO1hmAJ
         hvESIcOud4axCX5KW5Fcz/dcStRkbUKsGNRKEm9rZJzDe5Wzk1Fiw5UuR8dMJtF4/T
         Mvjnlb+e5pluaMTaphHGV06XdZ4FKjYVfSRZh43Xw5z29NvZYdmw6HcoDrhsRoFXmu
         q41A7rN1TTgEw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Evgeny Novikov <novikov@ispras.ru>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 46/85] media: st-hva: Fix potential NULL pointer dereferences
Date:   Sun,  4 Jul 2021 19:03:41 -0400
Message-Id: <20210704230420.1488358-46-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704230420.1488358-1-sashal@kernel.org>
References: <20210704230420.1488358-1-sashal@kernel.org>
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
index f59811e27f51..6eeee5017fac 100644
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

