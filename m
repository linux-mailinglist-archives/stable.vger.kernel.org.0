Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0806B2065F1
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:51:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393816AbgFWVfc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 17:35:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:51514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388252AbgFWUKU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:10:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C26B32073E;
        Tue, 23 Jun 2020 20:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943019;
        bh=JHWuGWGgG+yTFPUz5997dxPk+ppnHwY8nNNDkJLxbRE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zPN6H2YCyyPSEAv+l64DgQojT1mE3FsXiFO1fxL/TNYBRo3vucpLuftGtV+MXnnP0
         MKbWw2ORhh/+Ze45+0WAHrep27h3KgB6ZcMx3FtxYP9oK4OK+h+gWboqzJem9heBxB
         ejB9tFhFz3FqvOWDDOOIk7YvWVoPy4tkRsJlhpWM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Rob Clark <robdclark@gmail.com>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 227/477] drm/msm: Fix undefined "rd_full" link error
Date:   Tue, 23 Jun 2020 21:53:44 +0200
Message-Id: <20200623195418.310621346@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 732f65df5c4f4..fea30e7aa9e83 100644
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



