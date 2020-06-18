Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A1841FE730
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:39:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728406AbgFRCjW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 22:39:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:42060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728529AbgFRBNG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:13:06 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E4B121924;
        Thu, 18 Jun 2020 01:13:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442786;
        bh=K65oyh5kbV+CJy45U4ctImhpPS1ivlTrRM/FOdW20Vs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k3Ulc+D70i51IWlWHnhCTaOvvX12WvTLtPUPSGSWblLrkhmRy1N5Enx8Fm5zDhC8+
         9Rt5AVfgyPfDBYZkfn5UifjW4hJHXBKdvqXh4AjcPMSxgycFHRJe5snzUmMyMKOUfH
         GG1GOBCkE1uCyyf8TG6Fpj0LOvxLleVGzEj9qZic=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bjorn Andersson <bjorn.andersson@linaro.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Rob Clark <robdclark@gmail.com>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.7 230/388] drm/msm: Fix undefined "rd_full" link error
Date:   Wed, 17 Jun 2020 21:05:27 -0400
Message-Id: <20200618010805.600873-230-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bjorn Andersson <bjorn.andersson@linaro.org>

[ Upstream commit 20aebe83698feb107d5a66b6cfd1d54459ccdfcf ]

rd_full should be defined outside the CONFIG_DEBUG_FS region, in order
to be able to link the msm driver even when CONFIG_DEBUG_FS is disabled.

Fixes: e515af8d4a6f ("drm/msm: devcoredump should dump MSM_SUBMIT_BO_DUMP buffers")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Reviewed-by: Rob Clark <robdclark@gmail.com>
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/msm_rd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/msm/msm_rd.c b/drivers/gpu/drm/msm/msm_rd.c
index 732f65df5c4f..fea30e7aa9e8 100644
--- a/drivers/gpu/drm/msm/msm_rd.c
+++ b/drivers/gpu/drm/msm/msm_rd.c
@@ -29,8 +29,6 @@
  * or shader programs (if not emitted inline in cmdstream).
  */
 
-#ifdef CONFIG_DEBUG_FS
-
 #include <linux/circ_buf.h>
 #include <linux/debugfs.h>
 #include <linux/kfifo.h>
@@ -47,6 +45,8 @@ bool rd_full = false;
 MODULE_PARM_DESC(rd_full, "If true, $debugfs/.../rd will snapshot all buffer contents");
 module_param_named(rd_full, rd_full, bool, 0600);
 
+#ifdef CONFIG_DEBUG_FS
+
 enum rd_sect_type {
 	RD_NONE,
 	RD_TEST,       /* ascii text */
-- 
2.25.1

