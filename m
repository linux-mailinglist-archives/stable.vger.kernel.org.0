Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 443AA2469F4
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 17:28:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729983AbgHQP2B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:28:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:40724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729977AbgHQP1y (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:27:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8C07F23B29;
        Mon, 17 Aug 2020 15:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678074;
        bh=C8r8mALl/7ZEMq5jWAreO2rJacfW0xTMtM7RPgVBCDI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KdF8tRhUZOARJBysnLA7oH5l1gLxqNX4fT204s8h2dDeN8sXYz+VakdEzxG5SrjZL
         yLxXWLQv5F5VTpGgp9iBeSmTWh7xplRkxDuWcWAaOvLNhO4EShlaUKnSzqOPnXE/TF
         C1DlhZLjWc5HNuWOSqqZHgqeWl0Ni/6BreqtvJ9k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 209/464] media: exynos4-is: Add missed check for pinctrl_lookup_state()
Date:   Mon, 17 Aug 2020 17:12:42 +0200
Message-Id: <20200817143843.826599488@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuhong Yuan <hslester96@gmail.com>

[ Upstream commit 18ffec750578f7447c288647d7282c7d12b1d969 ]

fimc_md_get_pinctrl() misses a check for pinctrl_lookup_state().
Add the missed check to fix it.

Fixes: 4163851f7b99 ("[media] s5p-fimc: Use pinctrl API for camera ports configuration]")
Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/exynos4-is/media-dev.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/platform/exynos4-is/media-dev.c b/drivers/media/platform/exynos4-is/media-dev.c
index 9aaf3b8060d50..9c31d950cddf7 100644
--- a/drivers/media/platform/exynos4-is/media-dev.c
+++ b/drivers/media/platform/exynos4-is/media-dev.c
@@ -1270,6 +1270,9 @@ static int fimc_md_get_pinctrl(struct fimc_md *fmd)
 
 	pctl->state_idle = pinctrl_lookup_state(pctl->pinctrl,
 					PINCTRL_STATE_IDLE);
+	if (IS_ERR(pctl->state_idle))
+		return PTR_ERR(pctl->state_idle);
+
 	return 0;
 }
 
-- 
2.25.1



