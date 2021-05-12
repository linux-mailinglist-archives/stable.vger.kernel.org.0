Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B29D237C967
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:47:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232823AbhELQS5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:18:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:33628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231756AbhELQIb (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:08:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8207C61D2E;
        Wed, 12 May 2021 15:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833970;
        bh=WDjFGuq1cWNi5L26WqICwsFtsg74FulEGGH77+spOkI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sK4PkcH0kcCzc3a30wtVvlq3sYS2f9ydlPbtz0A2CDshSSCz56zVouOglN8M5NW2P
         6Nb3vvm66HH7WHaEbFYUafvDVtbNKQ5SGncGOesuT6OIS8mT2TXDIa97dWapGDmluD
         2c/xLjgZyOCA7Z9PVYlsNfvLyX4bEMzykXOsz2aA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 358/601] drm: xlnx: zynqmp: fix a memset in zynqmp_dp_train()
Date:   Wed, 12 May 2021 16:47:15 +0200
Message-Id: <20210512144839.583327809@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 5842ab76bbfadb37eaea91e53c1efe34ae504e4a ]

The dp->train_set[] for this driver is only two characters, not four so
this memsets too much.  Fortunately, this ends up corrupting a struct
hole and not anything important.

Fixes: d76271d22694 ("drm: xlnx: DRM/KMS driver for Xilinx ZynqMP DisplayPort Subsystem")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Michal Simek <michal.simek@xilinx.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/YGLwCBMotnrKZu6P@mwanda
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xlnx/zynqmp_dp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xlnx/zynqmp_dp.c b/drivers/gpu/drm/xlnx/zynqmp_dp.c
index 99158ee67d02..59d1fb017da0 100644
--- a/drivers/gpu/drm/xlnx/zynqmp_dp.c
+++ b/drivers/gpu/drm/xlnx/zynqmp_dp.c
@@ -866,7 +866,7 @@ static int zynqmp_dp_train(struct zynqmp_dp *dp)
 		return ret;
 
 	zynqmp_dp_write(dp, ZYNQMP_DP_SCRAMBLING_DISABLE, 1);
-	memset(dp->train_set, 0, 4);
+	memset(dp->train_set, 0, sizeof(dp->train_set));
 	ret = zynqmp_dp_link_train_cr(dp);
 	if (ret)
 		return ret;
-- 
2.30.2



