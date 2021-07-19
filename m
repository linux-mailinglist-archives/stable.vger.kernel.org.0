Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 560073CDEF9
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:50:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344924AbhGSPHH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:07:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:59982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345672AbhGSPEw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:04:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B67EF61006;
        Mon, 19 Jul 2021 15:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626709494;
        bh=hJ0q1YUEeTElbzGRnf2TEzf0g2dgesuOVIupLfKvsZ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zQzHLs7htac+Kem4MdA59ziNoKPc3SlQ80ziJ2K+b6XGlqxxf8I3ZMbc2cQ2m7J26
         nCVLy4UcTeGCUimsnCuoI3VtDCr3izJzoPk5djuKV2+X27rSYy/SrUv1x4ekPmbPKJ
         cK8u/+0tubPnyl+hG2uIQcE8h74ZYa1HFAVagyTM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 407/421] reset: bail if try_module_get() fails
Date:   Mon, 19 Jul 2021 16:53:38 +0200
Message-Id: <20210719145000.438939361@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144946.310399455@linuxfoundation.org>
References: <20210719144946.310399455@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Philipp Zabel <p.zabel@pengutronix.de>

[ Upstream commit 4fb26fb83f0def3d39c14e268bcd4003aae8fade ]

Abort instead of returning a new reset control for a reset controller
device that is going to have its module unloaded.

Reported-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Fixes: 61fc41317666 ("reset: Add reset controller API")
Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Link: https://lore.kernel.org/r/20210607082615.15160-1-p.zabel@pengutronix.de
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/reset/core.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/reset/core.c b/drivers/reset/core.c
index f7bf20493f23..ccb97f4e31c3 100644
--- a/drivers/reset/core.c
+++ b/drivers/reset/core.c
@@ -428,7 +428,10 @@ static struct reset_control *__reset_control_get_internal(
 	if (!rstc)
 		return ERR_PTR(-ENOMEM);
 
-	try_module_get(rcdev->owner);
+	if (!try_module_get(rcdev->owner)) {
+		kfree(rstc);
+		return ERR_PTR(-ENODEV);
+	}
 
 	rstc->rcdev = rcdev;
 	list_add(&rstc->list, &rcdev->reset_control_head);
-- 
2.30.2



