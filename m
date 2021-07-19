Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A8E13CDA9F
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:18:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244218AbhGSOgi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:36:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:47358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243399AbhGSOfe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:35:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 33F0D61220;
        Mon, 19 Jul 2021 15:16:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626707769;
        bh=miupIieA8N3u5xFBc+Zyeff4poumuKA0p+ZcrLMKpU4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w6UuPROkEqL2BAn6wV8CxwmDuzq0CY+wRLRH4WlBB+ciKGlSZv/T0cNecnAUDEuDq
         EoG9gKYg60UQ/trz62Pg1Za7VHdKSkqo10dQxkUfHdH5LVEesCZsAinnLUrQc9L6E6
         R/o70pMHymrtdFTkF08JPmtfTzgdMXWCmj7dP9nQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evgeny Novikov <novikov@ispras.ru>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 050/315] media: st-hva: Fix potential NULL pointer dereferences
Date:   Mon, 19 Jul 2021 16:48:59 +0200
Message-Id: <20210719144944.506186256@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.861561397@linuxfoundation.org>
References: <20210719144942.861561397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



