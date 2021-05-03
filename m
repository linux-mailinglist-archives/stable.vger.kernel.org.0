Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD43A371C3F
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:51:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233126AbhECQvu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:51:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:60834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234540AbhECQu0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:50:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 842ED6191A;
        Mon,  3 May 2021 16:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620060047;
        bh=6g2XKRRArM4saSLPY4VUkIIpd6tY+pCZaErkAo72feE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lK3M65GohWk7v79/N+RR4gYvtzX6G/GYLMnBeEC2AqmkpEcONJkPrU1ogcrsTff9j
         Vt5oPk0M/0qrwccjzhWsj3pt4g67zlkjPShuqEbLbE8Y+qc7YuFMgKw953Fl/mAhfa
         sGKdVw3Qq3j/JDYsKyk2aMAGWGfF0Vxh+CiDM1/88UOfq+UZ40JcGCkgjz96x3Uda4
         Cs9sGpFspXVdqVOMvP010J6XTvitJN/ru6xM2g8iPv46+TlnSKW+q3rYSG5Oc2dqgG
         K6LxFG7ONhnzJ2pHyiFNYyFNU1mfwvD/7BFUCEwv7iZxB4PQ4m68Ofs7NYne3PbdUC
         oOgOBXGxlrjyw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 43/57] media: platform: sti: Fix runtime PM imbalance in regs_show
Date:   Mon,  3 May 2021 12:39:27 -0400
Message-Id: <20210503163941.2853291-43-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503163941.2853291-1-sashal@kernel.org>
References: <20210503163941.2853291-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

[ Upstream commit 69306a947b3ae21e0d1cbfc9508f00fec86c7297 ]

pm_runtime_get_sync() will increase the runtime PM counter
even it returns an error. Thus a pairing decrement is needed
to prevent refcount leak. Fix this by replacing this API with
pm_runtime_resume_and_get(), which will not change the runtime
PM counter on error.

Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/sti/bdisp/bdisp-debug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/sti/bdisp/bdisp-debug.c b/drivers/media/platform/sti/bdisp/bdisp-debug.c
index 77ca7517fa3e..bae62af82643 100644
--- a/drivers/media/platform/sti/bdisp/bdisp-debug.c
+++ b/drivers/media/platform/sti/bdisp/bdisp-debug.c
@@ -480,7 +480,7 @@ static int regs_show(struct seq_file *s, void *data)
 	int ret;
 	unsigned int i;
 
-	ret = pm_runtime_get_sync(bdisp->dev);
+	ret = pm_runtime_resume_and_get(bdisp->dev);
 	if (ret < 0) {
 		seq_puts(s, "Cannot wake up IP\n");
 		return 0;
-- 
2.30.2

