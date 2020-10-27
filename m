Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F57029C100
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:22:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1818021AbgJ0RQ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:16:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:56186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1781302AbgJ0Ozd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:55:33 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C0B7E2071A;
        Tue, 27 Oct 2020 14:55:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810533;
        bh=K3jEGwLrdgANAaMUzoUcu2fC9MxVd3UElz8G4lSMyPk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hp5UVEJSNqcvSh8EY3DYMtbpzlvx3cQ7tFiMVrV+rGSUsENlemjnXg4oSRJiJ5lZj
         i+RpGJ6yg8Zdl6OB7ZoEE6HU6dd3pK/tP/IKv0Ba6tdtN4ieYKOObbJWf2PKtaIs+j
         XEDFz1Qyixq0sJ6SYKx/X+3TJ3Xwzw1nm1wXIouk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 171/633] drm/amd/display: fix potential integer overflow when shifting 32 bit variable bl_pwm
Date:   Tue, 27 Oct 2020 14:48:34 +0100
Message-Id: <20201027135530.696278783@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit 1d5503331b12a76266049289747dfd94f1643fde ]

The 32 bit unsigned integer bl_pwm is being shifted using 32 bit arithmetic
and then being assigned to a 64 bit unsigned integer.  There is a potential
for a 32 bit overflow so cast bl_pwm to enforce a 64 bit shift operation
to avoid this.

Addresses-Coverity: ("unintentional integer overflow")
Fixes: 3ba01817365c ("drm/amd/display: Move panel_cntl specific register from abm to panel_cntl.")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dce/dce_panel_cntl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dce/dce_panel_cntl.c b/drivers/gpu/drm/amd/display/dc/dce/dce_panel_cntl.c
index ebff9b1e312e5..124c081a0f2ca 100644
--- a/drivers/gpu/drm/amd/display/dc/dce/dce_panel_cntl.c
+++ b/drivers/gpu/drm/amd/display/dc/dce/dce_panel_cntl.c
@@ -75,7 +75,7 @@ static unsigned int calculate_16_bit_backlight_from_pwm(struct dce_panel_cntl *d
 	else
 		bl_pwm &= 0xFFFF;
 
-	current_backlight = bl_pwm << (1 + bl_int_count);
+	current_backlight = (uint64_t)bl_pwm << (1 + bl_int_count);
 
 	if (bl_period == 0)
 		bl_period = 0xFFFF;
-- 
2.25.1



