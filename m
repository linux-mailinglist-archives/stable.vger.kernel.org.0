Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7ED926EACD
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:01:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726079AbgIRCBN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:01:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:45268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725886AbgIRCBM (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:01:12 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C83BF20853;
        Fri, 18 Sep 2020 02:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394472;
        bh=YJPAtgg8ivm3iVpE20/kFIelrzzAGemuhbNoSxU16ms=;
        h=From:To:Cc:Subject:Date:From;
        b=vqlSMF7HilJT/pNaff65vSD3vwNWGn5l7V22jvkl1n68NsRcHSkMbf/tVM+dK9z5q
         97tuFwn7JZRnNEz/DtW4ZQldPZ+Wmqa6QYSTaQrAG9wQudYSoiByWguAThWm9XzCNq
         aFb2Y0RNWKSS/MZFDYtFysb8wkW4z8AY7QsbZufU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Iago Toral Quiroga <itoral@igalia.com>,
        Eric Anholt <eric@anholt.net>, Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 001/330] drm/v3d: don't leak bin job if v3d_job_init fails.
Date:   Thu, 17 Sep 2020 21:55:41 -0400
Message-Id: <20200918020110.2063155-1-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Iago Toral Quiroga <itoral@igalia.com>

[ Upstream commit 0d352a3a8a1f26168d09f7073e61bb4b328e3bb9 ]

If the initialization of the job fails we need to kfree() it
before returning.

Signed-off-by: Iago Toral Quiroga <itoral@igalia.com>
Signed-off-by: Eric Anholt <eric@anholt.net>
Link: https://patchwork.freedesktop.org/patch/msgid/20190916071125.5255-1-itoral@igalia.com
Fixes: a783a09ee76d ("drm/v3d: Refactor job management.")
Reviewed-by: Eric Anholt <eric@anholt.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/v3d/v3d_gem.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/v3d/v3d_gem.c b/drivers/gpu/drm/v3d/v3d_gem.c
index 19c092d75266b..6316bf3646af5 100644
--- a/drivers/gpu/drm/v3d/v3d_gem.c
+++ b/drivers/gpu/drm/v3d/v3d_gem.c
@@ -565,6 +565,7 @@ v3d_submit_cl_ioctl(struct drm_device *dev, void *data,
 		ret = v3d_job_init(v3d, file_priv, &bin->base,
 				   v3d_job_free, args->in_sync_bcl);
 		if (ret) {
+			kfree(bin);
 			v3d_job_put(&render->base);
 			kfree(bin);
 			return ret;
-- 
2.25.1

