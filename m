Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9340927C9F6
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:16:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732213AbgI2MPQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:15:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:54448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730084AbgI2Lh2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:37:28 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1CFAB2074A;
        Tue, 29 Sep 2020 11:33:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379210;
        bh=mqHT6RbFDr81GU1HO9Nq0bacZnanhKGb6BtrvhIrp9c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hoOfl3GFuDymSBhUeIX6BiLPwFycfOilz5lZtocVD4jSggJEY77trhtFetjib1v1m
         h0Btqx3JrUvmlGkK5xOFLeJlPXn5x1L3eXY73io/yN40qkK2Ch9rKj/hB0Ry9OitXX
         r2+t1WSwG2vUdjFXxRcwh4WgfMwTcDUvE+U5jZMU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Leo Li <sunpeng.li@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 021/388] drm/amd/display: Free gamma after calculating legacy transfer function
Date:   Tue, 29 Sep 2020 12:55:52 +0200
Message-Id: <20200929110011.510051783@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>

[ Upstream commit 0e3a7c2ec93b15f43a2653e52e9608484391aeaf ]

[Why]
We're leaking memory by not freeing the gamma used to calculate the
transfer function for legacy gamma.

[How]
Release the gamma after we're done with it.

Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Reviewed-by: Leo Li <sunpeng.li@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_color.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_color.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_color.c
index b43bb7f90e4e9..2233d293a707a 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_color.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_color.c
@@ -210,6 +210,8 @@ static int __set_legacy_tf(struct dc_transfer_func *func,
 	res = mod_color_calculate_regamma_params(func, gamma, true, has_rom,
 						 NULL);
 
+	dc_gamma_release(&gamma);
+
 	return res ? 0 : -ENOMEM;
 }
 
-- 
2.25.1



