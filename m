Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A1843F54B6
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 02:55:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233892AbhHXA42 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Aug 2021 20:56:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:48618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234405AbhHXAze (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Aug 2021 20:55:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 766896141B;
        Tue, 24 Aug 2021 00:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629766487;
        bh=XFi6cA/Q/hPW4JHtHpkD+8ah60OgiCKtUl0ylHe1CM8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LMQzftsOdidQ/N7ygIF/Cj+gdxKpXWIJvLY0k2+K48xfsoDPk4a5sVgmKLl9ZR9mR
         UF3oLRMf4MIcdH96n0MvHpKFCsDilhps4n87xx6q5/qh5Bz/szfN3q0NY3p23DcvE5
         x+iJIG33BiN7y6mE/g9hRmZqCVe/PycxmeXJYqcuCz9MAc2TxeUcdwNE92N44TUrdG
         6uG5Xk8IDO7wCFOunS1B9XtMZVpsbCu0G9sXanFxQH0Dd6Izr/JQ+WnH/k2GTOlJyM
         V8lnpIjdoTBSV3TSpMYKZbxh68dhBLBlMXcuzwsf4y2ETRjMWpnWdX4En0qosBpQYL
         r1Mc8lY7dSn7w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kenneth Feng <kenneth.feng@amd.com>,
        Hawking Zhang <Hawking.Zhang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.10 11/18] Revert "drm/amd/pm: fix workload mismatch on vega10"
Date:   Mon, 23 Aug 2021 20:54:25 -0400
Message-Id: <20210824005432.631154-11-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824005432.631154-1-sashal@kernel.org>
References: <20210824005432.631154-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kenneth Feng <kenneth.feng@amd.com>

[ Upstream commit 2fd31689f9e44af949f60ff4f8aca013e628ab81 ]

This reverts commit 0979d43259e13846d86ba17e451e17fec185d240.
Revert this because it does not apply to all the cards.

Signed-off-by: Kenneth Feng <kenneth.feng@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c
index 132c269c7c89..ed4eafc744d3 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c
@@ -5159,7 +5159,7 @@ static int vega10_set_power_profile_mode(struct pp_hwmgr *hwmgr, long *input, ui
 
 out:
 	smum_send_msg_to_smc_with_parameter(hwmgr, PPSMC_MSG_SetWorkloadMask,
-						(!power_profile_mode) ? 0 : 1 << (power_profile_mode - 1),
+						1 << power_profile_mode,
 						NULL);
 	hwmgr->power_profile_mode = power_profile_mode;
 
-- 
2.30.2

