Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F2A7147B09
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 10:40:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730225AbgAXJkT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:40:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:37646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731041AbgAXJkR (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:40:17 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7016E2070A;
        Fri, 24 Jan 2020 09:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579858817;
        bh=nxf7MS6nUvRpKLClMp1RVbiVjakdhnmn7khBMRqNzVc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mnxMEzZsOM2wMn2jaivvqUKdgVIj1e5apQ0zZIC3j2bDJkcFkLlGi/DI3vUig7j2a
         79LLuPUQPUlLlX0Sfo9ABzWatTM/6+gv2V20fGEvQOZiEF1gcy2XE0BxWCRXd9sRx1
         ujsD1JHigxzYKngmq+rhpjWZdaG+GxnsBF8hmRYk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 064/102] drm/amdgpu/vi: silence an uninitialized variable warning
Date:   Fri, 24 Jan 2020 10:31:05 +0100
Message-Id: <20200124092816.044964945@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092806.004582306@linuxfoundation.org>
References: <20200124092806.004582306@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 4ff17a1df7d550257972a838220a8af4611c8f2c ]

Smatch complains that we need to initialized "*cap" otherwise it can
lead to an uninitialized variable bug in the caller.  This seems like a
reasonable warning and it doesn't hurt to silence it at least.

drivers/gpu/drm/amd/amdgpu/vi.c:767 vi_asic_reset_method() error: uninitialized symbol 'baco_reset'.

Fixes: 425db2553e43 ("drm/amdgpu: expose BACO interfaces to upper level from PP")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/powerplay/amd_powerplay.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/powerplay/amd_powerplay.c b/drivers/gpu/drm/amd/powerplay/amd_powerplay.c
index fa8ad7db2b3a1..d306cc7119976 100644
--- a/drivers/gpu/drm/amd/powerplay/amd_powerplay.c
+++ b/drivers/gpu/drm/amd/powerplay/amd_powerplay.c
@@ -1421,6 +1421,7 @@ static int pp_get_asic_baco_capability(void *handle, bool *cap)
 {
 	struct pp_hwmgr *hwmgr = handle;
 
+	*cap = false;
 	if (!hwmgr)
 		return -EINVAL;
 
-- 
2.20.1



