Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82BC520E810
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:12:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390528AbgF2WDO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 18:03:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:56906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726225AbgF2SfX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:35:23 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C438624759;
        Mon, 29 Jun 2020 15:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444075;
        bh=SGnq0RrVsgwdJiovhIBuLGHgftO74XJW57gEQCjVjL8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kJlFtfgGeiyZccxwvUGtxj77EszAxhaEbIcy6wBX+w3g7ZkjG9dRz4gdoFaeFU049
         Ash5UthyKsDpGXVwGQnps2HsNMI2dO9cS/gLNiyvEcAZRJ4DpQ/92OKYfBeVO0F7/S
         4EQtYo9YS6RavNXP1tPNDi+S0QH5eT2VGG2nXJG0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Denis Efremov <efremov@linux.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 184/265] drm/amd/display: Use kfree() to free rgb_user in calculate_user_regamma_ramp()
Date:   Mon, 29 Jun 2020 11:16:57 -0400
Message-Id: <20200629151818.2493727-185-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.7-rc1
X-KernelTest-Deadline: 2020-07-01T15:14+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Denis Efremov <efremov@linux.com>

[ Upstream commit 43a562774fceba867e8eebba977d7d42f8a2eac7 ]

Use kfree() instead of kvfree() to free rgb_user in
calculate_user_regamma_ramp() because the memory is allocated with
kcalloc().

Signed-off-by: Denis Efremov <efremov@linux.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/modules/color/color_gamma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/modules/color/color_gamma.c b/drivers/gpu/drm/amd/display/modules/color/color_gamma.c
index e89694eb90b4c..700f0039df7bd 100644
--- a/drivers/gpu/drm/amd/display/modules/color/color_gamma.c
+++ b/drivers/gpu/drm/amd/display/modules/color/color_gamma.c
@@ -1777,7 +1777,7 @@ bool calculate_user_regamma_ramp(struct dc_transfer_func *output_tf,
 
 	kfree(rgb_regamma);
 rgb_regamma_alloc_fail:
-	kvfree(rgb_user);
+	kfree(rgb_user);
 rgb_user_alloc_fail:
 	return ret;
 }
-- 
2.25.1

