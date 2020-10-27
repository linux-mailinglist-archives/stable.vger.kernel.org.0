Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A70629AF7F
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:12:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1755306AbgJ0OJS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:09:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:58434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755298AbgJ0OJQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:09:16 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 004DB218AC;
        Tue, 27 Oct 2020 14:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603807755;
        bh=KaVf+ouLICQH5lgxzV3FEzx19YrarQcEmBofqWNc8Fs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sM2lDBcCYMvWC1+OopBICaRnszE/7xKg1WMPiKLqE97VODbbyjc/utK6YHBt8lGV6
         s6Rvs+ikoeGUDH4RouEXNM5gt0k6NxjXlPXQwhlJykpYBHHyvRE87E8N3ExQvfVGka
         USim/wcaheVlUshATIOfxha8n0PJw3glB+PDOtbU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 029/191] media: Revert "media: exynos4-is: Add missed check for pinctrl_lookup_state()"
Date:   Tue, 27 Oct 2020 14:48:04 +0100
Message-Id: <20201027134911.135083807@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027134909.701581493@linuxfoundation.org>
References: <20201027134909.701581493@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sylwester Nawrocki <s.nawrocki@samsung.com>

[ Upstream commit 00d21f325d58567d81d9172096692d0a9ea7f725 ]

The "idle" pinctrl state is optional as documented in the DT binding.
The change introduced by the commit being reverted makes that pinctrl state
mandatory and breaks initialization of the whole media driver, since the
"idle" state is not specified in any mainline dts.

This reverts commit 18ffec750578 ("media: exynos4-is: Add missed check for pinctrl_lookup_state()")
to fix the regression.

Fixes: 18ffec750578 ("media: exynos4-is: Add missed check for pinctrl_lookup_state()")
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/exynos4-is/media-dev.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/media-dev.c b/drivers/media/platform/exynos4-is/media-dev.c
index f772c9b92d9ba..d313f9078e714 100644
--- a/drivers/media/platform/exynos4-is/media-dev.c
+++ b/drivers/media/platform/exynos4-is/media-dev.c
@@ -1256,11 +1256,9 @@ static int fimc_md_get_pinctrl(struct fimc_md *fmd)
 	if (IS_ERR(pctl->state_default))
 		return PTR_ERR(pctl->state_default);
 
+	/* PINCTRL_STATE_IDLE is optional */
 	pctl->state_idle = pinctrl_lookup_state(pctl->pinctrl,
 					PINCTRL_STATE_IDLE);
-	if (IS_ERR(pctl->state_idle))
-		return PTR_ERR(pctl->state_idle);
-
 	return 0;
 }
 
-- 
2.25.1



